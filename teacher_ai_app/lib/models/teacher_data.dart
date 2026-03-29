class Teacher {
  final String id;
  final String name;
  final String school;
  final String subscriptionTier;
  final DateTime subscriptionExpiry;
  final List<Class> classes;

  Teacher({
    required this.id,
    required this.name,
    required this.school,
    required this.subscriptionTier,
    required this.subscriptionExpiry,
    required this.classes,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      school: json['school'] ?? '',
      subscriptionTier: json['subscriptionTier'] ?? 'free',
      subscriptionExpiry: DateTime.parse(json['subscriptionExpiry'] ?? DateTime.now().toIso8601String()),
      classes: (json['classes'] as List<dynamic>?)
              ?.map((c) => Class.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'school': school,
      'subscriptionTier': subscriptionTier,
      'subscriptionExpiry': subscriptionExpiry.toIso8601String(),
      'classes': classes.map((c) => c.toJson()).toList(),
    };
  }

  bool get isPro => subscriptionTier == 'pro' && subscriptionExpiry.isAfter(DateTime.now());
}

class Class {
  final String id;
  final String name;
  final String subject;
  final String grade;
  final List<Student> students;
  final List<LessonPlan> lessonPlans;

  Class({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.students,
    required this.lessonPlans,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      students: (json['students'] as List<dynamic>?)
              ?.map((s) => Student.fromJson(s))
              .toList() ??
          [],
      lessonPlans: (json['lessonPlans'] as List<dynamic>?)
                  ?.map((l) => LessonPlan.fromJson(l))
                  .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'grade': grade,
      'students': students.map((s) => s.toJson()).toList(),
      'lessonPlans': lessonPlans.map((l) => l.toJson()).toList(),
    };
  }
}

class Student {
  final String id;
  final String name;
  final Map<String, double> subjects;
  final List<AttendanceRecord> attendance;
  final List<HomeworkSubmission> homeworkSubmissions;

  Student({
    required this.id,
    required this.name,
    required this.subjects,
    required this.attendance,
    required this.homeworkSubmissions,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subjects: Map<String, double>.from(json['subjects'] ?? {}),
      attendance: (json['attendance'] as List<dynamic>?)
              ?.map((a) => AttendanceRecord.fromJson(a))
              .toList() ??
          [],
      homeworkSubmissions: (json['homeworkSubmissions'] as List<dynamic>?)
                  ?.map((h) => HomeworkSubmission.fromJson(h))
                  .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects,
      'attendance': attendance.map((a) => a.toJson()).toList(),
      'homeworkSubmissions': homeworkSubmissions.map((h) => h.toJson()).toList(),
    };
  }

  double getAverageScore() {
    if (subjects.isEmpty) return 0.0;
    return subjects.values.reduce((a, b) => a + b) / subjects.length;
  }
}

class LessonPlan {
  final String id;
  final String topic;
  final String grade;
  final String subject;
  final List<String> objectives;
  final List<String> activities;
  final String homework;
  final int durationMinutes;
  final DateTime created;
  final String? voiceInput;

  LessonPlan({
    required this.id,
    required this.topic,
    required this.grade,
    required this.subject,
    required this.objectives,
    required this.activities,
    required this.homework,
    required this.durationMinutes,
    required this.created,
    this.voiceInput,
  });

  factory LessonPlan.fromJson(Map<String, dynamic> json) {
    return LessonPlan(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      grade: json['grade'] ?? '',
      subject: json['subject'] ?? '',
      objectives: List<String>.from(json['objectives'] ?? []),
      activities: List<String>.from(json['activities'] ?? []),
      homework: json['homework'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 45,
      created: DateTime.parse(json['created'] ?? DateTime.now().toIso8601String()),
      voiceInput: json['voiceInput'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'grade': grade,
      'subject': subject,
      'objectives': objectives,
      'activities': activities,
      'homework': homework,
      'durationMinutes': durationMinutes,
      'created': created.toIso8601String(),
      'voiceInput': voiceInput,
    };
  }
}

class HomeworkSubmission {
  final String id;
  final String studentId;
  final String assignmentId;
  final String imagePath;
  final double score;
  final String feedback;
  final DateTime submitted;
  final List<AnswerCheck> answerChecks;

  HomeworkSubmission({
    required this.id,
    required this.studentId,
    required this.assignmentId,
    required this.imagePath,
    required this.score,
    required this.feedback,
    required this.submitted,
    required this.answerChecks,
  });

  factory HomeworkSubmission.fromJson(Map<String, dynamic> json) {
    return HomeworkSubmission(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      assignmentId: json['assignmentId'] ?? '',
      imagePath: json['imagePath'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      feedback: json['feedback'] ?? '',
      submitted: DateTime.parse(json['submitted'] ?? DateTime.now().toIso8601String()),
      answerChecks: (json['answerChecks'] as List<dynamic>?)
                  ?.map((a) => AnswerCheck.fromJson(a))
                  .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'assignmentId': assignmentId,
      'imagePath': imagePath,
      'score': score,
      'feedback': feedback,
      'submitted': submitted.toIso8601String(),
      'answerChecks': answerChecks.map((a) => a.toJson()).toList(),
    };
  }
}

class AnswerCheck {
  final int questionNumber;
  final String studentAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final double marks;
  final String feedback;

  AnswerCheck({
    required this.questionNumber,
    required this.studentAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.marks,
    required this.feedback,
  });

  factory AnswerCheck.fromJson(Map<String, dynamic> json) {
    return AnswerCheck(
      questionNumber: json['questionNumber'] ?? 0,
      studentAnswer: json['studentAnswer'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      marks: (json['marks'] ?? 0).toDouble(),
      feedback: json['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'studentAnswer': studentAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
      'marks': marks,
      'feedback': feedback,
    };
  }
}

class AttendanceRecord {
  final String studentId;
  final DateTime date;
  final bool isPresent;
  final AttendanceMethod method;

  AttendanceRecord({
    required this.studentId,
    required this.date,
    required this.isPresent,
    required this.method,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      studentId: json['studentId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isPresent: json['isPresent'] ?? false,
      method: AttendanceMethod.values.firstWhere(
        (m) => m.toString() == json['method'],
        orElse: () => AttendanceMethod.manual,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'method': method.toString(),
    };
  }
}

enum AttendanceMethod { manual, voice, ai }

class Worksheet {
  final String id;
  final String title;
  final String subject;
  final String grade;
  final String topic;
  final List<Question> questions;
  final DateTime created;
  final int totalMarks;

  Worksheet({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.topic,
    required this.questions,
    required this.created,
    required this.totalMarks,
  });

  factory Worksheet.fromJson(Map<String, dynamic> json) {
    return Worksheet(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      topic: json['topic'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
                  ?.map((q) => Question.fromJson(q))
                  .toList() ??
          [],
      created: DateTime.parse(json['created'] ?? DateTime.now().toIso8601String()),
      totalMarks: json['totalMarks'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'grade': grade,
      'topic': topic,
      'questions': questions.map((q) => q.toJson()).toList(),
      'created': created.toIso8601String(),
      'totalMarks': totalMarks,
    };
  }
}

class Question {
  final int number;
  final String text;
  final QuestionType type;
  final List<String>? options;
  final String? correctAnswer;
  final int marks;

  Question({
    required this.number,
    required this.text,
    required this.type,
    this.options,
    this.correctAnswer,
    required this.marks,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      type: QuestionType.values.firstWhere(
        (t) => t.toString() == json['type'],
        orElse: () => QuestionType.shortAnswer,
      ),
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correctAnswer'],
      marks: json['marks'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'type': type.toString(),
      'options': options,
      'correctAnswer': correctAnswer,
      'marks': marks,
    };
  }
}

enum QuestionType { multipleChoice, fillInBlanks, shortAnswer, trueFalse }