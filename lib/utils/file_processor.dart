import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:assemblyai_flutter_sdk/assemblyai_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:path/path.dart' as path;

import 'ai_util.dart';

class FileProcessor {
  static Future<String> extractText(BuildContext context, PlatformFile file) async {
    switch (file.extension?.toLowerCase()) {
      case 'pdf':
        return _extractPdfText(file);
      case 'mp4':
        return _extractVideoTranscript(context, file);
      case 'doc':
      case 'docx':
      case 'ppt':
      case 'pptx':
        return _extractPlainText(file);
      default:
        throw Exception('Unsupported file type');
    }
  }

  static Future<String> _extractPdfText(PlatformFile file) async {
    String text = "";
    text = await ReadPdfText.getPDFtext(file.path!);
    return text;
  }

  static Future<String> _extractVideoTranscript(BuildContext context, PlatformFile file) async {
    {
      final appDir = await getApplicationDocumentsDirectory();
      final videoBytes = await File(file.path!).readAsBytes();
      final videoByteData = ByteData.view(videoBytes.buffer);

      final sampleVideoPath = path.join(appDir.path, 'sample_video.mp4');
      final videoFile = await File(sampleVideoPath).create();
      await videoFile.writeAsBytes(videoByteData.buffer.asUint8List());

      final sampleAudioPath = path.join(appDir.path, 'sample_audio.mp3');
      final audioFile = await videoFile.copy(sampleAudioPath);

      final apiKey = Provider.of<ApiKeyProvider>(context, listen: false)
          .assemblyAiKey;
      if (apiKey.isEmpty) {
        throw Exception('AssemblyAI API key not set');
      }

      final assemblyAi = AssemblyAI(apiKey);
      final transcript = await assemblyAi.submitTranscription({
        'audio_url': audioFile.path,
        'language_code': 'en_us',
        'punctuate': true,
      });

      await videoFile.delete();
      await audioFile.delete();

      return transcript.text ?? 'Transcription failed';
    }
  }

  static Future<String> _extractPlainText(PlatformFile file) async {
    return await File(file.path!).readAsString();
  }
}
