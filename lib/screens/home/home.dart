import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/screens/settings/setting.dart';
import 'package:intellectiq/utils/standard_format.dart';
import 'package:intellectiq/utils/course_storage.dart';
import 'package:intellectiq/screens/course/course_page.dart';
import 'package:provider/provider.dart';

import '../../design/transitions.dart';
import '../../models/course.dart';
import 'components/course_card.dart';
import 'loading.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _pickFileAndCreateCourse(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'pptx', 'mp4'],
    );

    if (result != null) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoadingPage(file: result.files.first),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseStorage = Provider.of<CourseStorage>(context, listen: false);

    return StdFormat(
      appBar: AppBar(
        title: const Text(
          'IntellectiQ',
          style: TextStyle(
              fontSize: AppFont.body,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMainColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(createRoute(const SettingPage()));
              },
              icon: const Icon(Icons.settings, color: AppTheme.primaryAppColor))
        ],
        backgroundColor: Colors.transparent,
      ),
      showKeyboard: true,
      widget: StreamBuilder<List<Course>>(
        stream: courseStorage.getAllCoursesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final courses = snapshot.data ?? [];

          if (courses.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'You don\'t have any material created currently, click the "+" button to add some',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AppFont.body,
                        color: AppTheme.textMainColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                SvgPicture.asset("assets/HomeArrow.svg",
                    colorFilter: const ColorFilter.mode(
                        AppTheme.primaryAppColor, BlendMode.srcIn),
                    semanticsLabel: 'A red up arrow'),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Your courses',
                  style: TextStyle(
                    fontSize: AppFont.head4,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMainColor,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      title: courses[index].title,
                      index: index,
                      onTap: () {
                        Navigator.of(context).push(createRoute(
                            CoursePage(courseId: courses[index].id)));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickFileAndCreateCourse(context),
        backgroundColor: AppTheme.primaryAppColor,
        child: const Icon(
          Icons.add,
          color: AppTheme.mainAppColor,
        ),
      ),
    );
  }
}