import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'ai_util.dart';

class FileProcessor {
  static Future<String> extractText(BuildContext context, PlatformFile file) async {
    switch (file.extension?.toLowerCase()) {
      case 'pdf':
        return _extractPdfText(file);
      case 'doc':
        return _extractDocText(file);
      case 'docx':
        return _extractDocxText(file);
      case 'mp4':
        return _extractVideoTranscript(context, file);
      case 'ppt':
      case 'pptx':
        return _extractPlainText(file);
      default:
        throw Exception('Unsupported file type');
    }
  }

  static Future<String> _extractPdfText(PlatformFile file) async {
    final PdfDocument document = PdfDocument(inputBytes: File(file.path!).readAsBytesSync());
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();
    document.dispose();
    return text;
  }

  static Future<String> _extractDocText(PlatformFile file) async {
    final PdfDocument document = PdfDocument(inputBytes: File(file.path!).readAsBytesSync());
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();
    document.dispose();
    return text;
  }

  static Future<String> _extractDocxText(PlatformFile file) async {
    final bytes = await File(file.path!).readAsBytes();
    final String text = docxToText(bytes);
    return text;
  }

  static Future<String> _extractVideoTranscript(BuildContext context, PlatformFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final videoBytes = await File(file.path!).readAsBytes();
    final videoByteData = ByteData.view(videoBytes.buffer);

    final sampleVideoPath = path.join(appDir.path, 'sample_video.mp4');
    final videoFile = await File(sampleVideoPath).create();
    await videoFile.writeAsBytes(videoByteData.buffer.asUint8List());

    final sampleAudioPath = path.join(appDir.path, 'sample_audio.mp3');
    final audioFile = await videoFile.copy(sampleAudioPath);

    final apiKey = Provider.of<ApiKeyProvider>(context, listen: false).assemblyAiKey;
    if (apiKey.isEmpty) {
      throw Exception('AssemblyAI API key not set');
    }

    try {
      // Upload the audio file
      final uploadUrl = await _uploadFile(apiKey, audioFile.path);

      // Start transcription
      final transcriptId = await _startTranscription(apiKey, uploadUrl);

      // Poll for transcription result
      final transcriptText = await _pollTranscriptionResult(apiKey, transcriptId);

      await videoFile.delete();
      await audioFile.delete();

      return transcriptText;
    } catch (e) {
      await videoFile.delete();
      await audioFile.delete();
      throw Exception('Transcription failed: $e');
    }
  }

  static Future<String> _extractPlainText(PlatformFile file) async {
    return await File(file.path!).readAsString();
  }

  static Future<String> _uploadFile(String apiKey, String filePath) async {
    const uploadUrl = 'https://api.assemblyai.com/v2/upload';
    final file = File(filePath);
    final fileStream = file.openRead();

    final request = http.StreamedRequest('POST', Uri.parse(uploadUrl));
    request.headers['authorization'] = apiKey;
    request.contentLength = await file.length();
    fileStream.listen(
          (List<int> chunk) => request.sink.add(chunk),
      onDone: () => request.sink.close(),
      onError: (error) => throw Exception('File upload failed: $error'),
    );

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['upload_url'];
    } else {
      throw Exception('File upload failed with status: ${response.statusCode}');
    }
  }

  static Future<String> _startTranscription(String apiKey, String audioUrl) async {
    const transcriptUrl = 'https://api.assemblyai.com/v2/transcript';
    final response = await http.post(
      Uri.parse(transcriptUrl),
      headers: {
        'authorization': apiKey,
        'content-type': 'application/json',
      },
      body: json.encode({'audio_url': audioUrl}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['id'];
    } else {
      throw Exception('Transcription request failed with status: ${response.statusCode}');
    }
  }

  static Future<String> _pollTranscriptionResult(String apiKey, String transcriptId) async {
    final pollingEndpoint = 'https://api.assemblyai.com/v2/transcript/$transcriptId';
    while (true) {
      final response = await http.get(
        Uri.parse(pollingEndpoint),
        headers: {'authorization': apiKey},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'completed') {
          return responseData['text'];
        } else if (responseData['status'] == 'error') {
          throw Exception('Transcription failed: ${responseData['error']}');
        }
      } else {
        throw Exception('Polling failed with status: ${response.statusCode}');
      }

      await Future.delayed(const Duration(seconds: 3));
    }
  }
}