import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import '../services/teacher_ai_service.dart';
import '../models/teacher_data.dart';

class ReportCardScreen extends StatefulWidget {
  @override
  _ReportCardScreenState createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedClass = 'Class 5 A';
  bool _isGenerating = false;
  String? _generatedComment;
  
  // Mock student marks
  final Map<String, double> _subjects = {
    'Mathematics': 85.0,
    'Science': 78.0,
    'English': 92.0,
    'Hindi': 88.0,
    'Social Studies': 76.0,
  };

  final List<String> _classes = [
    'Class 5 A', 'Class 5 B', 'Class 6 A', 'Class 6 B',
    'Class 7 A', 'Class 7 B', 'Class 8 A', 'Class 8 B',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _generateComments() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    try {
      final comment = await TeacherAIService.generateReportComments(
        studentName: _nameController.text.trim(),
        subjects: _subjects,
      );

      setState(() {
        _generatedComment = comment;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating comments: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateSubjectMark(String subject, double mark) {
    setState(() {
      _subjects[subject] = mark;
    });
  }

  double _calculateAverage() {
    if (_subjects.isEmpty) return 0.0;
    return _subjects.values.reduce((a, b) => a + b) / _subjects.length;
  }

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final average = _calculateAverage();
    final grade = _getGrade(average);

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Report Cards'),
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
            // Student Information Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Student Name
                      Text(
                        'Student Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter student name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter student name';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Class Selection
                      Text(
                        'Class',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedClass,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _classes.map((className) {
                          return DropdownMenuItem(
                            value: className,
                            child: Text(className),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedClass = value!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Subject Marks Input
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Subject Marks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getGradeColor(grade).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getGradeColor(grade).withOpacity(0.3)),
                          ),
                          child: Text(
                            'Average: $average% (Grade: $grade)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getGradeColor(grade),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Subject Mark Inputs
                    ..._subjects.entries.map((entry) {
                      final subject = entry.key;
                      final mark = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                subject,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                initialValue: mark.toStringAsFixed(0),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  suffixText: '%',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final newMark = double.tryParse(value) ?? 0.0;
                                  _updateSubjectMark(subject, newMark.clamp(0.0, 100.0));
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getMarkColor(mark),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Generate Button
            GradientButton(
              text: _isGenerating ? 'Generating Comments...' : '📝 Generate Report Comments',
              onPressed: _isGenerating ? null : _generateComments,
              color: Color(0xFF10B981),
            ),
            
            // Generated Comments
            if (_generatedComment != null) ...[
              SizedBox(height: 20),
              
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_stories, color: Color(0xFF10B981)),
                          SizedBox(width: 8),
                          Text(
                            'AI-Generated Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF10B981).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFF10B981).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student: ${_nameController.text}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _generatedComment!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF374151),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Copy to clipboard
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.copy, size: 18),
                                  SizedBox(width: 8),
                                  Text('Copy'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Save to student record
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

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Color(0xFF10B981);
      case 'B+':
      case 'B':
        return Color(0xFF2563EB);
      case 'C':
        return Color(0xFFF59E0B);
      default:
        return Color(0xFFEF4444);
    }
  }

  Color _getMarkColor(double mark) {
    if (mark >= 80) return Color(0xFF10B981);
    if (mark >= 60) return Color(0xFF2563EB);
    if (mark >= 40) return Color(0xFFF59E0B);
    return Color(0xFFEF4444);
  }
}