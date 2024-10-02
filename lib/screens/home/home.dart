import 'package:flutter/material.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/screens/upload/upload.dart';
import 'package:intellectiq/utils/standard_format.dart';

import '../../design/transitions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    // TODO: Implement loading courses from Sembast database
    // For now, we'll use dummy data
    setState(() {
      courses = [
        Course(id: '1', title: 'Introduction to Flutter'),
        Course(id: '2', title: 'Advanced Python Programming'),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return StdFormat(
      appBar: AppBar(
        title: const Text('My Courses', style: TextStyle(fontSize: AppFont.body, fontWeight: FontWeight.w500, color: AppTheme.textMainColor),),
        backgroundColor: AppTheme.ternaryAppColor,
      ),
      showKeyboard: true,
      widget: Container(
        child: courses.isEmpty
            ? const Center(
          child: Text(
            'No courses available.\nTap the + button to add a course.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppFont.body, color: AppTheme.textMainColor),
          ),
        )
            : ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                courses[index].title,
                style: const TextStyle(color: AppTheme.textMainColor),
              ),
              onTap: () {
                // TODO: Navigate to course detail screen
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(createRoute(const FileUploadScreen()));
        },
        backgroundColor: AppTheme.primaryAppColor,
        child: const Icon(Icons.add, color: AppTheme.mainAppColor,),
      ),
    );
  }
}

class Course {
  final String id;
  final String title;

  Course({required this.id, required this.title});
}
