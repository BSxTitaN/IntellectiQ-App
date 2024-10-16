import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/models/course.dart';
import 'package:intellectiq/utils/course_storage.dart';
import 'package:intellectiq/utils/standard_format.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final String courseId;
  final List<QuizQuestion> questions;

  const QuizPage({super.key, required this.courseId, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showResult = false;
  String? _selectedAnswer;
  bool _showCorrectAnswer = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showCorrectAnswer = true;
      if (answer == widget.questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < widget.questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = null;
          _showCorrectAnswer = false;
        });
      } else {
        _showFinalResult();
      }
    });
  }

  void _showFinalResult() {
    setState(() {
      _showResult = true;
    });
    _animationController.forward();
    _saveQuizScore();
  }

  Future<void> _saveQuizScore() async {
    final courseStorage = Provider.of<CourseStorage>(context, listen: false);
    await courseStorage.saveQuizScore(widget.courseId, _score, DateTime.now());
  }

  String _getResultMessage() {
    if (_score == widget.questions.length) {
      return "Congratulations! You scored an ace of $_score/${widget.questions.length}";
    } else if (_score >= widget.questions.length ~/ 2) {
      return "Bravo! You scored $_score/${widget.questions.length}";
    } else {
      return "Aww shucks! You scored a stinker of $_score/${widget.questions.length}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StdFormat(
      appBar: AppBar(
        title: SizedBox(
          height: 7,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.questions.length,
              backgroundColor: AppTheme.btnDisableColor,
              valueColor:
              const AlwaysStoppedAnimation<Color>(AppTheme.primaryAppColor),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textMainColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      widget: _showResult ? _buildResultScreen() : _buildQuestionScreen(),
    );
  }

  Widget _buildQuestionScreen() {
    final question = widget.questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.question,
          style: const TextStyle(
              fontSize: AppFont.subtitle1,
              color: AppTheme.textMainColor,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Bounceable(
              onTap: _showCorrectAnswer ? null : () => _checkAnswer(option),
              child: Container(
                decoration: BoxDecoration(
                  color: _getOptionColor(option),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
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
                          String.fromCharCode(65 + index), // 'A', 'B', 'C', 'D'
                          style: const TextStyle(
                              color: AppTheme.textMainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: AppFont.subtitle2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                            color: _getOptionTextColor(option),
                            fontSize: AppFont.body,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (_showCorrectAnswer)
                      Icon(
                        _getOptionIcon(option),
                        color: _getOptionColor(option),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _getOptionColor(String option) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == option
          ? AppTheme.primaryAppColor
          : AppTheme.cardColor;
    }
    if (option == widget.questions[_currentQuestionIndex].correctAnswer) {
      return const Color(0xff42FC4A);
    }
    if (option == _selectedAnswer) {
      return const Color(0xffFC4242);
    }
    return AppTheme.cardColor;
  }

  Color _getOptionTextColor(String option) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == option
          ? AppTheme.mainAppColor
          : AppTheme.textMainColor;
    }
    if (option == widget.questions[_currentQuestionIndex].correctAnswer) {
      return AppTheme.mainAppColor;
    }
    if (option == _selectedAnswer) {
      return AppTheme.mainAppColor;
    }
    return AppTheme.textMainColor;
  }

  IconData _getOptionIcon(String option) {
    if (option == widget.questions[_currentQuestionIndex].correctAnswer) {
      return Icons.check_circle;
    }
    if (option == _selectedAnswer) {
      return Icons.cancel;
    }
    return Icons.circle_outlined;
  }

  Widget _buildResultScreen() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getResultMessage(),
                  style: const TextStyle(
                      fontSize: AppFont.head4,
                      color: AppTheme.textMainColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _animation.value,
                        child: SvgPicture.asset(
                          'assets/CurvedLineQuiz.svg',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 64.0),
              child: Text(
                'Click anywhere to go back to the course',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: AppFont.body,
                    color: AppTheme.textMainColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}