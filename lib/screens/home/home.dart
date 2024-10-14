import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/screens/settings/setting.dart';
import 'package:intellectiq/utils/standard_format.dart';

import '../../design/transitions.dart';
import 'components/course_card.dart';

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
        title: const Text(
          'IntellectiQ',
          style: TextStyle(
              fontSize: AppFont.body,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMainColor),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(createRoute(const SettingPage()));
          }, icon: const Icon(Icons.settings, color: AppTheme.primaryAppColor))
        ],
        backgroundColor: Colors.transparent,
      ),
      showKeyboard: true,
      widget: courses.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'You don’t have any material created currently, click the “+” button to add some',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AppFont.body,
                        color: AppTheme.textMainColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SvgPicture.asset("assets/HomeArrow.svg",
                    colorFilter: const ColorFilter.mode(
                        AppTheme.primaryAppColor, BlendMode.srcIn),
                    semanticsLabel: 'A red up arrow'),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length + 1, // +1 for the title
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Your courses',
                            style: TextStyle(
                              fontSize: AppFont.head4,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMainColor,
                            ),
                          ),
                        );
                      }
                      return CourseCard(
                        title: courses[index - 1].title,
                        index: index - 1,
                        onTap: () {
                          // TODO: Navigate to course detail screen
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: AppTheme.primaryAppColor,
        child: const Icon(
          Icons.add,
          color: AppTheme.mainAppColor,
        ),
      ),
    );
  }
}

class Course {
  final String id;
  final String title;

  Course({required this.id, required this.title});
}
