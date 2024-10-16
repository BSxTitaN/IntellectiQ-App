import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/utils/file_processor.dart';
import 'package:intellectiq/utils/gpt_service.dart';
import 'package:intellectiq/utils/course_storage.dart';
import 'package:intellectiq/screens/course/course_page.dart';
import 'package:intellectiq/utils/standard_format.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';

class LoadingPage extends StatefulWidget {
  final PlatformFile file;

  const LoadingPage({super.key, required this.file});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String _status = 'Processing file...';

  @override
  void initState() {
    super.initState();
    _processFileAndCreateCourse();
  }

  Future<void> _processFileAndCreateCourse() async {
    try {
      setState(() => _status = 'Extracting text from file...');
      final String extractedText = await FileProcessor.extractText(context, widget.file);

      setState(() => _status = 'Generating course content...');
      if (!mounted) return;
      final String courseJson = await GptService.generateCourse(context, extractedText);

      setState(() => _status = 'Storing course data...');
      if (!mounted) return;
      final courseStorage = Provider.of<CourseStorage>(context, listen: false);
      final course = Course.fromJson('', jsonDecode(courseJson));
      final String courseId = await courseStorage.storeCourse(course);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CoursePage(courseId: courseId),
        ),
      );
    } catch (e) {
      setState(() => _status = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StdFormat(
      widget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.primaryAppColor, backgroundColor: AppTheme.btnDisableColor, strokeAlign: 8,),
            const SizedBox(height: 24),
            Text(
              _status,
              style: const TextStyle(
                fontSize: AppFont.body,
                color: AppTheme.textMainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}