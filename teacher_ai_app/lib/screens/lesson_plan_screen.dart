import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import '../widgets/voice_button.dart';
import '../services/teacher_ai_service.dart';
import '../models/teacher_data.dart';

class LessonPlanScreen extends StatefulWidget {
  @override
  _LessonPlanScreenState createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _voiceController = TextEditingController();
  
  String _selectedGrade = '5';
  String _selectedSubject = 'Mathematics';
  bool _isGenerating = false;
  bool _isRecording = false;
  LessonPlan? _generatedPlan;

  final List<String> _grades = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> _subjects = [
    'Mathematics', 'Science', 'English', 'Hindi', 'Social Studies', 'Computer Science'
  ];

  @override
  void dispose() {
    _topicController.dispose();
    _voiceController.dispose();
    super.dispose();
  }

  Future<void> _generateLessonPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    try {
      final plan = await TeacherAIService.generateLessonPlan(
        grade: _selectedGrade,
        subject: _selectedSubject,
        topic: _topicController.text.trim(),
        voiceInput: _voiceController.text.trim().isNotEmpty ? _voiceController.text.trim() : null,
      );

      setState(() {
        _generatedPlan = plan;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating lesson plan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startVoiceRecording() {
    setState(() => _isRecording = true);
    // TODO: Implement actual voice recording
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isRecording = false;
        _voiceController.text = 'Class 5 maths fractions padhana hai with examples and homework';
      });
    });
  }

  void _stopVoiceRecording() {
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Plan Generator'),
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
                        'Create Lesson Plan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
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
                      
                      SizedBox(height: 24),
                      
                      // Voice Input Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFF2563EB).withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.mic, color: Color(0xFF2563EB)),
                                SizedBox(width: 8),
                                Text(
                                  'Voice Input (Optional)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 12),
                            
                            if (_voiceController.text.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFFE5E7EB)),
                                ),
                                child: Text(_voiceController.text),
                              ),
                              SizedBox(height: 12),
                            ],
                            
                            VoiceButton(
                              onStartRecording: _startVoiceRecording,
                              onStopRecording: _stopVoiceRecording,
                              isRecording: _isRecording,
                              hintText: _isRecording 
                                  ? 'Recording... Tap to stop' 
                                  : 'Tap to describe your lesson',
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Generate Button
                      GradientButton(
                        text: _isGenerating ? 'Generating...' : 'Generate Lesson Plan',
                        onPressed: _isGenerating ? null : _generateLessonPlan,
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Generated Plan
            if (_generatedPlan != null) ...[
              SizedBox(height: 20),
              
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
                            'Generated Lesson Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Topic and Class Info
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF2563EB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.class_, color: Color(0xFF2563EB), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Class ${_generatedPlan!.grade} - ${_generatedPlan!.subject}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${_generatedPlan!.durationMinutes} mins',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Topic
                      Text(
                        _generatedPlan!.topic,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Objectives
                      Text(
                        'Learning Objectives',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      ..._generatedPlan!.objectives.map((objective) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check, color: Color(0xFF10B981), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                objective,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      
                      SizedBox(height: 16),
                      
                      // Activities
                      Text(
                        'Class Activities',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      ..._generatedPlan!.activities.map((activity) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              margin: EdgeInsets.only(top: 6),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                activity,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      
                      SizedBox(height: 16),
                      
                      // Homework
                      Text(
                        'Homework Assignment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.assignment, color: Color(0xFFF59E0B), size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _generatedPlan!.homework,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF92400E),
                                ),
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
                                // TODO: Save to favorites
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bookmark_border, size: 18),
                                  SizedBox(width: 8),
                                  Text('Save'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Share lesson plan
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.share, size: 18),
                                  SizedBox(width: 8),
                                  Text('Share'),
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
}