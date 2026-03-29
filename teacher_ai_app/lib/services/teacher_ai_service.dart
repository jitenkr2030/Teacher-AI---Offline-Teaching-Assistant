import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/teacher_data.dart';

class TeacherAIService {
  static late SharedPreferences _prefs;
  static Teacher? _currentTeacher;
  
  // Mock Cactus AI integration - in real app, this would call the actual Cactus FFI
  static bool _isModelLoaded = false;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCurrentTeacher();
    await _initializeAIModels();
  }

  static Future<void> _loadCurrentTeacher() async {
    final teacherJson = _prefs.getString('current_teacher');
    if (teacherJson != null) {
      try {
        _currentTeacher = Teacher.fromJson(jsonDecode(teacherJson));
      } catch (e) {
        debugPrint('Error loading teacher data: $e');
        await _createDefaultTeacher();
      }
    } else {
      await _createDefaultTeacher();
    }
  }

  static Future<void> _createDefaultTeacher() async {
    _currentTeacher = Teacher(
      id: 'teacher_1',
      name: 'Demo Teacher',
      school: 'Demo School',
      subscriptionTier: 'free',
      subscriptionExpiry: DateTime.now().add(Duration(days: 30)),
      classes: [
        Class(
          id: 'class_1',
          name: 'Class 5 A',
          subject: 'Mathematics',
          grade: '5',
          students: [
            Student(
              id: 'student_1',
              name: 'Rahul Kumar',
              subjects: {'Mathematics': 85.0, 'Science': 78.0},
              attendance: [],
              homeworkSubmissions: [],
            ),
            Student(
              id: 'student_2',
              name: 'Priya Sharma',
              subjects: {'Mathematics': 92.0, 'Science': 88.0},
              attendance: [],
              homeworkSubmissions: [],
            ),
            Student(
              id: 'student_3',
              name: 'Amit Patel',
              subjects: {'Mathematics': 76.0, 'Science': 82.0},
              attendance: [],
              homeworkSubmissions: [],
            ),
          ],
          lessonPlans: [],
        ),
      ],
    );
    await _saveCurrentTeacher();
  }

  static Future<void> _saveCurrentTeacher() async {
    if (_currentTeacher != null) {
      await _prefs.setString('current_teacher', jsonEncode(_currentTeacher!.toJson()));
    }
  }

  static Future<void> _initializeAIModels() async {
    // Simulate model loading
    await Future.delayed(Duration(seconds: 2));
    _isModelLoaded = true;
    debugPrint('AI Models initialized successfully');
  }

  static Teacher? getCurrentTeacher() => _currentTeacher;

  static Future<Map<String, int>> getTeacherStats() async {
    // Return mock stats for demo
    return {
      'generatedPlans': 12,
      'checkedHomework': 45,
      'studentsCount': _currentTeacher?.classes.fold(0, (sum, c) => sum + c.students.length) ?? 0,
    };
  }

  static Future<LessonPlan> generateLessonPlan({
    required String grade,
    required String subject,
    required String topic,
    String? voiceInput,
  }) async {
    if (!_isModelLoaded) {
      throw Exception('AI models not loaded yet');
    }

    // Simulate AI processing
    await Future.delayed(Duration(seconds: 2));

    // Mock AI-generated lesson plan
    final lessonPlan = LessonPlan(
      id: 'lesson_${DateTime.now().millisecondsSinceEpoch}',
      topic: topic,
      grade: grade,
      subject: subject,
      objectives: [
        'Understand the concept of $topic',
        'Apply $topic in problem-solving',
        'Develop critical thinking skills',
      ],
      activities: [
        'Introduction with real-life examples (10 mins)',
        'Interactive demonstration (15 mins)',
        'Guided practice (10 mins)',
        'Independent work (10 mins)',
      ],
      homework: 'Complete exercise 3.1 from textbook, problems 1-10',
      durationMinutes: 45,
      created: DateTime.now(),
      voiceInput: voiceInput,
    );

    // Save to current teacher's data
    if (_currentTeacher != null) {
      final targetClass = _currentTeacher!.classes.firstWhere(
        (c) => c.grade == grade && c.subject == subject,
        orElse: () => _currentTeacher!.classes.first,
      );
      
      targetClass.lessonPlans.add(lessonPlan);
      await _saveCurrentTeacher();
    }

    return lessonPlan;
  }

  static Future<List<AnswerCheck>> checkHomework({
    required String imagePath,
    required List<String> questions,
    required List<String> correctAnswers,
  }) async {
    if (!_isModelLoaded) {
      throw Exception('AI models not loaded yet');
    }

    // Simulate AI vision processing
    await Future.delayed(Duration(seconds: 3));

    // Mock AI homework checking
    final answerChecks = <AnswerCheck>[];
    for (int i = 0; i < questions.length; i++) {
      final isCorrect = (i % 3) != 0; // Mock: every 3rd answer is wrong
      answerChecks.add(AnswerCheck(
        questionNumber: i + 1,
        studentAnswer: isCorrect ? correctAnswers[i] : 'Incorrect answer detected',
        correctAnswer: correctAnswers[i],
        isCorrect: isCorrect,
        marks: isCorrect ? 5.0 : 0.0,
        feedback: isCorrect 
            ? 'Correct! Well done.' 
            : 'Review this concept. See textbook page 45.',
      ));
    }

    return answerChecks;
  }

  static Future<String> processVoiceQuery(String query) async {
    if (!_isModelLoaded) {
      throw Exception('AI models not loaded yet');
    }

    // Simulate AI processing
    await Future.delayed(Duration(seconds: 1));

    // Mock AI responses based on common teaching queries
    final lowerQuery = query.toLowerCase();
    
    if (lowerQuery.contains('photosynthesis')) {
      return '''Photosynthesis is the process by which plants make their own food using sunlight, water, and carbon dioxide.

Simple explanation for students:
🌱 Plants are like tiny solar chefs!
☀️ They use sunlight as energy
💧 They drink water through their roots
🌬️ They breathe in carbon dioxide from air
🍃 They cook these ingredients to make glucose (sugar/food)
🌬️ They release oxygen for us to breathe!

You can explain it as: "Plants use sunlight to turn water and air into their food!"''';
    }
    
    if (lowerQuery.contains('fraction')) {
      return '''Fractions are parts of a whole number. Think of it like sharing a pizza!

For Class 5 students:
🍕 If you cut a pizza into 4 equal pieces, each piece is 1/4 (one-fourth)
🍕 If you eat 2 pieces, you've eaten 2/4 (two-fourths) which equals 1/2 (half)
🍕 The top number (numerator) shows how many parts you have
🍕 The bottom number (denominator) shows how many equal parts the whole is divided into

Try this activity: Give students chocolate bars and ask them to break them into equal parts!''';
    }
    
    if (lowerQuery.contains('gravity')) {
      return '''Gravity is the force that pulls everything toward the center of the Earth.

For young students:
🌍 Earth is like a giant magnet!
🪶 It pulls everything down - that's why apples fall from trees
🪶 It keeps us on the ground instead of floating away
🪶 It's why we can jump up but always come back down

Fun demonstration: Drop different objects (feather, ball, paper) and ask students why they all fall down!''';
    }
    
    return '''That's a great question! Here's a simple way to explain it:

For your students, try to:
1. Use real-life examples they can relate to
2. Keep explanations short and simple
3. Use visual aids or demonstrations
4. Ask questions to check understanding
5. Connect it to their daily experiences

Would you like me to create a more detailed explanation with examples and activities?''';
  }

  static Future<String> generateReportComments({
    required String studentName,
    required Map<String, double> subjects,
  }) async {
    if (!_isModelLoaded) {
      throw Exception('AI models not loaded yet');
    }

    await Future.delayed(Duration(seconds: 1));

    final average = subjects.values.reduce((a, b) => a + b) / subjects.length;
    final comments = <String>[];

    if (average >= 90) {
      comments.add('$studentName demonstrates exceptional academic performance across all subjects.');
      comments.add('Shows strong conceptual clarity and excellent problem-solving skills.');
    } else if (average >= 80) {
      comments.add('$studentName shows good academic performance and understanding of concepts.');
      comments.add('Demonstrates consistent effort and participation in class activities.');
    } else if (average >= 70) {
      comments.add('$studentName shows satisfactory progress and understanding of most concepts.');
      comments.add('Needs improvement in problem-solving and application of concepts.');
    } else {
      comments.add('$studentName requires additional support in core subjects.');
      comments.add('Should focus on strengthening fundamental concepts and regular practice.');
    }

    // Subject-specific comments
    subjects.forEach((subject, score) {
      if (score >= 85) {
        comments.add('Excellent performance in $subject.');
      } else if (score < 60) {
        comments.add('Needs significant improvement in $subject.');
      }
    });

    return comments.join(' ');
  }

  static Future<Worksheet> generateWorksheet({
    required String subject,
    required String grade,
    required String topic,
    required int questionCount,
    required QuestionType questionType,
  }) async {
    if (!_isModelLoaded) {
      throw Exception('AI models not loaded yet');
    }

    if (_currentTeacher?.subscriptionTier != 'pro') {
      throw Exception('Worksheet generator is available in Pro version only');
    }

    await Future.delayed(Duration(seconds: 2));

    final questions = <Question>[];
    for (int i = 1; i <= questionCount; i++) {
      questions.add(_generateMockQuestion(i, questionType, topic));
    }

    return Worksheet(
      id: 'worksheet_${DateTime.now().millisecondsSinceEpoch}',
      title: '$topic - Worksheet',
      subject: subject,
      grade: grade,
      topic: topic,
      questions: questions,
      created: DateTime.now(),
      totalMarks: questionCount * 5,
    );
  }

  static Question _generateMockQuestion(int number, QuestionType type, String topic) {
    switch (type) {
      case QuestionType.multipleChoice:
        return Question(
          number: number,
          text: 'What is the main concept of $topic?',
          type: type,
          options: [
            'Option A: Correct answer',
            'Option B: Wrong answer',
            'Option C: Another wrong answer',
            'Option D: Last wrong answer',
          ],
          correctAnswer: 'Option A: Correct answer',
          marks: 5,
        );
      case QuestionType.fillInBlanks:
        return Question(
          number: number,
          text: '$topic is important because it helps us understand ______.',
          type: type,
          correctAnswer: 'the world around us',
          marks: 5,
        );
      case QuestionType.shortAnswer:
        return Question(
          number: number,
          text: 'Explain the importance of $topic in our daily life.',
          type: type,
          correctAnswer: 'Student should explain practical applications',
          marks: 5,
        );
      case QuestionType.trueFalse:
        return Question(
          number: number,
          text: '$topic is essential for understanding complex problems.',
          type: type,
          correctAnswer: 'True',
          marks: 5,
        );
    }
  }

  static Future<List<AttendanceRecord>> takeVoiceAttendance({
    required String classId,
    required String voiceData,
  }) async {
    if (!_isModelLoaded) {
      throw Exception('AI models not loaded yet');
    }

    await Future.delayed(Duration(seconds: 2));

    // Mock voice processing - extract names and attendance status
    final records = <AttendanceRecord>[];
    final mockNames = ['Rahul', 'Priya', 'Amit', 'Anjali', 'Vikram'];
    
    for (final name in mockNames) {
      records.add(AttendanceRecord(
        studentId: 'student_${name.toLowerCase()}',
        date: DateTime.now(),
        isPresent: name != 'Vikram', // Mock: Vikram is absent
        method: AttendanceMethod.voice,
      ));
    }

    return records;
  }

  static Future<Map<String, dynamic>> getStudentInsights(String studentId) async {
    if (_currentTeacher?.subscriptionTier != 'pro') {
      throw Exception('Student insights available in Pro version only');
    }

    await Future.delayed(Duration(seconds: 1));

    // Mock AI-generated insights
    return {
      'strengths': ['Mathematics', 'Problem solving'],
      'weaknesses': ['Science concepts', 'Attention to detail'],
      'recommendations': [
        'Provide additional practice in Science',
        'Use visual aids for better concept understanding',
        'Encourage peer learning sessions'
      ],
      'performanceTrend': 'improving',
      'engagementLevel': 0.8,
    };
  }

  static Future<void> upgradeSubscription() async {
    // Mock subscription upgrade
    if (_currentTeacher != null) {
      _currentTeacher = Teacher(
        id: _currentTeacher!.id,
        name: _currentTeacher!.name,
        school: _currentTeacher!.school,
        subscriptionTier: 'pro',
        subscriptionExpiry: DateTime.now().add(Duration(days: 30)),
        classes: _currentTeacher!.classes,
      );
      await _saveCurrentTeacher();
    }
  }
}