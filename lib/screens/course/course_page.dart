import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intellectiq/utils/course_storage.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/utils/standard_format.dart';

class CoursePage extends StatelessWidget {
  final String courseId;

  const CoursePage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final courseStorage = Provider.of<CourseStorage>(context, listen: false);

    return StdFormat(
      appBar: AppBar(
        title: const Text(
          'Course',
          style: TextStyle(
            fontSize: AppFont.body,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMainColor,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      widget: FutureBuilder<String?>(
        future: courseStorage.getCourse(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading course'));
          }
          final courseData = jsonDecode(snapshot.data!);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseData['title'],
                  style: const TextStyle(
                    fontSize: AppFont.head4,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMainColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  courseData['summary'],
                  style: const TextStyle(
                    fontSize: AppFont.body,
                    color: AppTheme.textMainColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Modules',
                  style: TextStyle(
                    fontSize: AppFont.head4,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMainColor,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courseData['modules'].length,
                  itemBuilder: (context, index) {
                    final module = courseData['modules'][index];
                    return ExpansionTile(
                      title: Text(
                        module['title'],
                        style: const TextStyle(
                          fontSize: AppFont.body,
                          color: AppTheme.textMainColor,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            module['description'],
                            style: const TextStyle(
                              fontSize: AppFont.body,
                              color: AppTheme.textMainColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quiz',
                  style: TextStyle(
                    fontSize: AppFont.head4,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMainColor,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courseData['quiz'].length,
                  itemBuilder: (context, index) {
                    final question = courseData['quiz'][index];
                    return ExpansionTile(
                      title: Text(
                        'Question ${index + 1}',
                        style: const TextStyle(
                          fontSize: AppFont.body,
                          color: AppTheme.textMainColor,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question['question'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFont.body,
                                  color: AppTheme.textMainColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...question['options'].map<Widget>((option) =>
                                  Text(
                                    '• $option',
                                    style: TextStyle(
                                      fontSize: AppFont.body,
                                      color: option == question['correctAnswer']
                                          ? AppTheme.primaryAppColor
                                          : AppTheme.textMainColor,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}