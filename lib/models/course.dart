class Course {
  final String id;
  final String title;
  final String summary;
  final List<Module> modules;
  final List<QuizQuestion> quiz;

  Course({
    required this.id,
    required this.title,
    required this.summary,
    required this.modules,
    required this.quiz,
  });

  factory Course.fromJson(String id, Map<String, dynamic> json) {
    return Course(
      id: id,
      title: json['title'],
      summary: json['summary'],
      modules: (json['modules'] as List).map((m) => Module.fromJson(m)).toList(),
      quiz: (json['quiz'] as List).map((q) => QuizQuestion.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'modules': modules.map((m) => m.toJson()).toList(),
    'quiz': quiz.map((q) => q.toJson()).toList(),
  };
}

class Module {
  final String title;
  final String description;

  Module({required this.title, required this.description});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
  };
}