import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';
import 'package:intellectiq/utils/course_storage.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/utils/standard_format.dart';
import 'package:intellectiq/models/course.dart';

import '../quizes/quiz_page.dart';
import 'components/quiz_score_section.dart';

class CoursePage extends StatefulWidget {
  final String courseId;

  const CoursePage({super.key, required this.courseId});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    ));

    // Start the animation after a short delay to ensure the widget is built
    Future.delayed(Duration.zero, () {
      _animationController!.forward();
    });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

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
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.primaryAppColor),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      widget: FutureBuilder<Course?>(
        future: courseStorage.getCourse(widget.courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
                child: Text(
              'Error loading course',
              style: TextStyle(
                fontSize: AppFont.body,
                color: AppTheme.textMainColor,
              ),
            ));
          }
          final course = snapshot.data!;
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: AppFont.head4,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMainColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      course.summary,
                      style: const TextStyle(
                        fontSize: AppFont.body,
                        color: AppTheme.textMainColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Modules',
                      style: TextStyle(
                        fontSize: AppFont.subtitle1,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMainColor,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: course.modules.length,
                      itemBuilder: (context, index) {
                        final module = course.modules[index];
                        return ExpansionTile(
                          shape: const Border(),
                          iconColor: AppTheme.primaryAppColor,
                          collapsedIconColor: AppTheme.ternaryAppColor,
                          title: Text(
                            "${index + 1}. ${module.title}",
                            style: const TextStyle(
                              fontSize: AppFont.body,
                              color: AppTheme.textMainColor,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                module.description,
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
                    const SizedBox(height: 32),
                    QuizScoresSection(
                      courseId: widget.courseId,
                      quizLength: course.quiz.length,
                      courseStorage: courseStorage,
                    ),
                    const SizedBox(height: 64),
                  ],
                ),
              ),
              SlideTransition(
                position: _offsetAnimation!,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Bounceable(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            courseId: widget.courseId,
                            questions: course.quiz,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAppColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 47,
                                height: 47,
                                decoration: BoxDecoration(
                                  color: AppTheme.mainAppColor,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Center(
                                  child: Text(
                                    '!',
                                    style: TextStyle(
                                      fontSize: AppFont.subtitle2,
                                      color: AppTheme.primaryAppColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  "Quiz Available!",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppFont.subtitle2,
                                    color: AppTheme.mainAppColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
