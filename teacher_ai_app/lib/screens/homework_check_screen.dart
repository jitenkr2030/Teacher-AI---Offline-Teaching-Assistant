import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import '../services/teacher_ai_service.dart';

class HomeworkCheckScreen extends StatefulWidget {
  @override
  _HomeworkCheckScreenState createState() => _HomeworkCheckScreenState();
}

class _HomeworkCheckScreenState extends State<HomeworkCheckScreen> {
  bool _isProcessing = false;
  String? _selectedImagePath;
  List<AnswerCheck> _answerChecks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework Checker'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1F2937),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, size: 48, color: Color(0xFF10B981)),
                    SizedBox(height: 16),
                    Text(
                      'Take Photo of Homework',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Position the camera clearly over the student\'s work',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            text: '📷 Take Photo',
                            onPressed: _takePhoto,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _selectFromGallery,
                            child: Text('📁 Gallery'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            if (_selectedImagePath != null) ...[
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.image, color: Color(0xFF10B981)),
                          SizedBox(width: 8),
                          Text(
                            'Selected Image',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Image preview\n($_selectedImagePath)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF6B7280)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      GradientButton(
                        text: _isProcessing ? 'Analyzing...' : '🔍 Check Homework',
                        onPressed: _isProcessing ? null : _checkHomework,
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            if (_answerChecks.isNotEmpty) ...[
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF10B981)),
                          SizedBox(width: 8),
                          Text(
                            'Analysis Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ..._answerChecks.map((check) => _buildAnswerCheckCard(check)).toList(),
                      SizedBox(height: 16),
                      _buildSummaryCard(),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCheckCard(AnswerCheck check) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: check.isCorrect ? Color(0xFF10B981).withOpacity(0.1) : Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: check.isCorrect ? Color(0xFF10B981).withOpacity(0.3) : Color(0xFFEF4444).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                check.isCorrect ? Icons.check_circle : Icons.cancel,
                color: check.isCorrect ? Color(0xFF10B981) : Color(0xFFEF4444),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Question ${check.questionNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: check.isCorrect ? Color(0xFF10B981) : Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${check.marks.toInt()} marks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          if (check.studentAnswer.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Student Answer: ${check.studentAnswer}',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
          
          if (check.feedback.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              check.feedback,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalMarks = _answerChecks.fold(0.0, (sum, check) => sum + check.marks);
    final correctAnswers = _answerChecks.where((check) => check.isCorrect).length;
    final percentage = _answerChecks.isNotEmpty ? (correctAnswers / _answerChecks.length * 100) : 0.0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$totalMarks/${(_answerChecks.length * 5)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Accuracy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _takePhoto() async {
    // TODO: Implement camera functionality
    setState(() {
      _selectedImagePath = 'camera_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
  }

  void _selectFromGallery() async {
    // TODO: Implement gallery selection
    setState(() {
      _selectedImagePath = 'gallery_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
  }

  Future<void> _checkHomework() async {
    if (_selectedImagePath == null) return;

    setState(() => _isProcessing = true);

    try {
      final mockQuestions = [
        'What is 2 + 2?',
        'Solve: 5x = 25',
        'What is the square of 6?',
      ];
      
      final mockAnswers = ['4', 'x = 5', '36'];

      final answerChecks = await TeacherAIService.checkHomework(
        imagePath: _selectedImagePath!,
        questions: mockQuestions,
        correctAnswers: mockAnswers,
      );

      setState(() {
        _answerChecks = answerChecks;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking homework: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}