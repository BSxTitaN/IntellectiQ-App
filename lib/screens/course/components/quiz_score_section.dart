import 'package:flutter/material.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/utils/course_storage.dart';

class QuizScoresSection extends StatelessWidget {
  final String courseId;
  final int quizLength;
  final CourseStorage courseStorage;

  const QuizScoresSection({
    super.key,
    required this.courseId,
    required this.quizLength,
    required this.courseStorage,
  });

  Color _getScoreColor(int index, int totalScores) {
    if (index < 3) return const Color(0xff42FC4A);
    if (index >= totalScores - 3) return const Color(0xffFC4242);
    return AppTheme.primaryAppColor;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Scores',
          style: TextStyle(
            fontSize: AppFont.head4,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMainColor,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<QuizScore>>(
          stream: courseStorage.getQuizScoresStream(courseId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text(
                'Error loading quiz scores',
                style: TextStyle(
                  fontSize: AppFont.body,
                  color: AppTheme.textMainColor,
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text(
                'No quiz scores available',
                style: TextStyle(
                  fontSize: AppFont.body,
                  color: AppTheme.textMainColor,
                ),
              );
            }

            final scores = snapshot.data!;
            scores.sort((a, b) {
              int scoreComp = b.score.compareTo(a.score);
              if (scoreComp != 0) return scoreComp;
              return b.date.compareTo(a.date);
            });

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.mainAppColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: AppFont.subtitle2,
                                color: AppTheme.primaryAppColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(score.date),
                                style: const TextStyle(
                                  fontSize: AppFont.body,
                                  color: AppTheme.textMainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(score.date),
                                style: const TextStyle(
                                  fontSize: AppFont.caption,
                                  color: AppTheme.textSecColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${score.score}/$quizLength',
                          style: TextStyle(
                            fontSize: AppFont.subtitle1,
                            color: _getScoreColor(index, scores.length),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
