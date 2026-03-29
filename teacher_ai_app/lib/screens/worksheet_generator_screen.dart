import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import '../services/teacher_ai_service.dart';
import '../models/teacher_data.dart';

class WorksheetGeneratorScreen extends StatefulWidget {
  @override
  _WorksheetGeneratorScreenState createState() => _WorksheetGeneratorScreenState();
}

class _WorksheetGeneratorScreenState extends State<WorksheetGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _titleController = TextEditingController();
  
  String _selectedGrade = '5';
  String _selectedSubject = 'Mathematics';
  String _selectedQuestionType = 'multipleChoice';
  int _questionCount = 10;
  bool _isGenerating = false;
  Worksheet? _generatedWorksheet;

  final List<String> _grades = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> _subjects = [
    'Mathematics', 'Science', 'English', 'Hindi', 'Social Studies', 'Computer Science'
  ];

  @override
  void dispose() {
    _topicController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _generateWorksheet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    try {
      final worksheet = await TeacherAIService.generateWorksheet(
        subject: _selectedSubject,
        grade: _selectedGrade,
        topic: _topicController.text.trim(),
        questionCount: _questionCount,
        questionType: _getQuestionType(),
      );

      setState(() {
        _generatedWorksheet = worksheet;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating worksheet: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  QuestionType _getQuestionType() {
    switch (_selectedQuestionType) {
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'fillInBlanks':
        return QuestionType.fillInBlanks;
      case 'shortAnswer':
        return QuestionType.shortAnswer;
      case 'trueFalse':
        return QuestionType.trueFalse;
      default:
        return QuestionType.multipleChoice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worksheet Generator'),
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
            // Pro Feature Banner
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pro Feature',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Generate unlimited worksheets with AI',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ),
            
            // Input Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Worksheet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Worksheet Title
                      Text(
                        'Worksheet Title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Fractions Practice Worksheet',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a worksheet title';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Grade Selection
                      Text(
                        'Grade',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedGrade,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _grades.map((grade) {
                          return DropdownMenuItem(
                            value: grade,
                            child: Text('Class $grade'),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedGrade = value!),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Subject Selection
                      Text(
                        'Subject',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _subjects.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedSubject = value!),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Topic Input
                      Text(
                        'Topic',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _topicController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Fractions, Photosynthesis, Grammar',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a topic';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Question Type Selection
                      Text(
                        'Question Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedQuestionType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem(value: 'multipleChoice', child: Text('Multiple Choice')),
                          DropdownMenuItem(value: 'fillInBlanks', child: Text('Fill in the Blanks')),
                          DropdownMenuItem(value: 'shortAnswer', child: Text('Short Answer')),
                          DropdownMenuItem(value: 'trueFalse', child: Text('True/False')),
                        ],
                        onChanged: (value) => setState(() => _selectedQuestionType = value!),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Question Count
                      Text(
                        'Number of Questions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _questionCount.toDouble(),
                              min: 5,
                              max: 30,
                              divisions: 25,
                              label: '$_questionCount questions',
                              onChanged: (value) {
                                setState(() {
                                  _questionCount = value.round();
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFD1D5DB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '$_questionCount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Generate Button
                      GradientButton(
                        text: _isGenerating ? 'Generating...' : '🎯 Generate Worksheet',
                        onPressed: _isGenerating ? null : _generateWorksheet,
                        color: Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Generated Worksheet
            if (_generatedWorksheet != null) ...[
              SizedBox(height: 20),
              
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.quiz, color: Color(0xFF8B5CF6)),
                          SizedBox(width: 8),
                          Text(
                            'Generated Worksheet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Worksheet Info
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF8B5CF6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _generatedWorksheet!.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B5CF6),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Class ${_generatedWorksheet!.grade} - ${_generatedWorksheet!.subject}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Topic: ${_generatedWorksheet!.topic}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Questions
                      Text(
                        'Questions (${_generatedWorksheet!.questions.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      ..._generatedWorksheet!.questions.map((question) => _buildQuestionCard(question)).toList(),
                      
                      SizedBox(height: 16),
                      
                      // Worksheet Summary
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
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
                                    'Total Marks',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${_generatedWorksheet!.totalMarks}',
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
                                    'Questions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${_generatedWorksheet!.questions.length}',
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
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Export to PDF
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf, size: 18),
                                  SizedBox(width: 8),
                                  Text('Export PDF'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Save worksheet
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, size: 18),
                                  SizedBox(width: 8),
                                  Text('Save'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildQuestionCard(Question question) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${question.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${question.marks} marks',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          
          if (question.options != null) ...[
            SizedBox(height: 12),
            ...question.options!.map((option) => Padding(
              padding: EdgeInsets.only(left: 36, bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.radio_button_unchecked, size: 16, color: Color(0xFF9CA3AF)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }
}