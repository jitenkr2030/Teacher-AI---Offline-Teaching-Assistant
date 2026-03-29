import 'package:flutter/material.dart';
import '../widgets/voice_button.dart';
import '../widgets/gradient_button.dart';
import '../services/teacher_ai_service.dart';
import '../models/teacher_data.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _classController = TextEditingController();
  bool _isRecording = false;
  bool _isProcessing = false;
  List<AttendanceRecord> _attendanceRecords = [];
  String _selectedClass = 'Class 5 A';
  
  // Mock student data
  final List<Map<String, String>> _students = [
    {'id': 'student_1', 'name': 'Rahul Kumar'},
    {'id': 'student_2', 'name': 'Priya Sharma'},
    {'id': 'student_3', 'name': 'Amit Patel'},
    {'id': 'student_4', 'name': 'Anjali Singh'},
    {'id': 'student_5', 'name': 'Vikram Mehta'},
    {'id': 'student_6', 'name': 'Sneha Reddy'},
    {'id': 'student_7', 'name': 'Rohit Gupta'},
    {'id': 'student_8', 'name': 'Kavita Nair'},
  ];

  final List<String> _classes = [
    'Class 5 A', 'Class 5 B', 'Class 6 A', 'Class 6 B',
    'Class 7 A', 'Class 7 B', 'Class 8 A', 'Class 8 B',
  ];

  @override
  void dispose() {
    _classController.dispose();
    super.dispose();
  }

  void _startVoiceRecording() {
    setState(() => _isRecording = true);
    // TODO: Implement actual voice recording
  }

  void _stopVoiceRecording() async {
    setState(() => _isRecording = false);
    await _processVoiceAttendance();
  }

  Future<void> _processVoiceAttendance() async {
    setState(() => _isProcessing = true);

    try {
      // Mock voice data - in real app, this would be actual recorded audio
      final mockVoiceData = "Rahul present, Priya present, Amit absent, Anjali present, Vikram absent";
      
      final records = await TeacherAIService.takeVoiceAttendance(
        classId: _selectedClass,
        voiceData: mockVoiceData,
      );

      setState(() {
        _attendanceRecords = records;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing attendance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleAttendance(String studentId) {
    setState(() {
      final existingIndex = _attendanceRecords.indexWhere(
        (record) => record.studentId == studentId,
      );
      
      if (existingIndex != -1) {
        final record = _attendanceRecords[existingIndex];
        _attendanceRecords[existingIndex] = AttendanceRecord(
          studentId: studentId,
          date: DateTime.now(),
          isPresent: !record.isPresent,
          method: AttendanceMethod.manual,
        );
      } else {
        _attendanceRecords.add(AttendanceRecord(
          studentId: studentId,
          date: DateTime.now(),
          isPresent: true,
          method: AttendanceMethod.manual,
        ));
      }
    });
  }

  int get _presentCount => _attendanceRecords.where((r) => r.isPresent).length;
  int get _absentCount => _attendanceRecords.where((r) => !r.isPresent).length;
  int get _totalCount => _students.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Attendance'),
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
            // Class Selection
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Class',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
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
                    
                    SizedBox(height: 16),
                    
                    Text(
                      'Total Students: ${_students.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Voice Attendance Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.mic, color: Color(0xFFF59E0B), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Voice Attendance',
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
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF59E0B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'How to use:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1. Tap the microphone button\n2. Say student names with status\n3. Example: "Rahul present, Priya absent"\n4. AI will automatically mark attendance',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    VoiceButton(
                      onStartRecording: _startVoiceRecording,
                      onStopRecording: _stopVoiceRecording,
                      isRecording: _isRecording,
                      hintText: _isRecording 
                          ? 'Recording attendance... Tap to stop' 
                          : 'Tap to start voice attendance',
                    ),
                    
                    if (_isProcessing) ...[
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing voice data...',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Attendance Summary
            if (_attendanceRecords.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Attendance Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Present',
                              '$_presentCount',
                              Color(0xFF10B981),
                              Icons.check_circle,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Absent',
                              '$_absentCount',
                              Color(0xFFEF4444),
                              Icons.cancel,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Total',
                              '$_totalCount',
                              Color(0xFF6B7280),
                              Icons.people,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFF2563EB).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Color(0xFF2563EB), size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Attendance Rate: ${((_presentCount / _totalCount) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 16),
            
            // Student List with Manual Attendance
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Manual Attendance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Mark all as present
                              _attendanceRecords = _students.map((student) {
                                final existing = _attendanceRecords.firstWhere(
                                  (record) => record.studentId == student['id'],
                                  orElse: () => AttendanceRecord(
                                    studentId: student['id']!,
                                    date: DateTime.now(),
                                    isPresent: true,
                                    method: AttendanceMethod.manual,
                                  ),
                                );
                                return AttendanceRecord(
                                  studentId: student['id']!,
                                  date: DateTime.now(),
                                  isPresent: true,
                                  method: AttendanceMethod.manual,
                                );
                              }).toList();
                            });
                          },
                          child: Text('Mark All Present'),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    ..._students.map((student) {
                      final attendance = _attendanceRecords.firstWhere(
                        (record) => record.studentId == student['id'],
                        orElse: () => AttendanceRecord(
                          studentId: student['id']!,
                          date: DateTime.now(),
                          isPresent: false,
                          method: AttendanceMethod.manual,
                        ),
                      );
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: attendance.isPresent 
                                ? Color(0xFF10B981).withOpacity(0.1) 
                                : Color(0xFFEF4444).withOpacity(0.1),
                            child: Text(
                              student['name']![0],
                              style: TextStyle(
                                color: attendance.isPresent 
                                    ? Color(0xFF10B981) 
                                    : Color(0xFFEF4444),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            student['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          subtitle: Text(
                            attendance.isPresent ? 'Present' : 'Absent',
                            style: TextStyle(
                              color: attendance.isPresent 
                                  ? Color(0xFF10B981) 
                                  : Color(0xFFEF4444),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Switch(
                            value: attendance.isPresent,
                            onChanged: (value) => _toggleAttendance(student['id']!),
                            activeColor: Color(0xFF10B981),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Save Attendance Button
            if (_attendanceRecords.isNotEmpty) ...[
              GradientButton(
                text: '💾 Save Attendance',
                onPressed: () {
                  // TODO: Save attendance to database
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Attendance saved successfully!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                color: Color(0xFF10B981),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}