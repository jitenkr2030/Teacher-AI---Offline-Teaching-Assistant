import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import '../services/teacher_ai_service.dart';

class StudentInsightsScreen extends StatefulWidget {
  @override
  _StudentInsightsScreenState createState() => _StudentInsightsScreenState();
}

class _StudentInsightsScreenState extends State<StudentInsightsScreen> {
  bool _isLoading = false;
  String? _selectedStudentId;
  Map<String, dynamic>? _insights;
  
  // Mock student data
  final List<Map<String, String>> _students = [
    {'id': 'student_1', 'name': 'Rahul Kumar'},
    {'id': 'student_2', 'name': 'Priya Sharma'},
    {'id': 'student_3', 'name': 'Amit Patel'},
    {'id': 'student_4', 'name': 'Anjali Singh'},
    {'id': 'student_5', 'name': 'Vikram Mehta'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Performance Insights'),
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
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Analytics',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'AI-powered student performance analysis',
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
            
            // Student Selection
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Student',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Student List
                    ..._students.map((student) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFEF4444).withOpacity(0.1),
                          child: Text(
                            student['name']![0],
                            style: TextStyle(
                              color: Color(0xFFEF4444),
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
                        subtitle: Text('Class 5 A'),
                        trailing: Icon(
                          _selectedStudentId == student['id'] 
                              ? Icons.check_circle 
                              : Icons.radio_button_unchecked,
                          color: _selectedStudentId == student['id'] 
                              ? Color(0xFF10B981) 
                              : Color(0xFF9CA3AF),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedStudentId = student['id'];
                          });
                          _loadStudentInsights(student['id']!);
                        },
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
            
            // Insights Display
            if (_insights != null) ...[
              SizedBox(height: 20),
              
              // Performance Overview
              _buildPerformanceOverview(),
              
              SizedBox(height: 16),
              
              // Strengths and Weaknesses
              _buildStrengthsWeaknesses(),
              
              SizedBox(height: 16),
              
              // Recommendations
              _buildRecommendations(),
              
              SizedBox(height: 16),
              
              // Progress Trend
              _buildProgressTrend(),
            ],
            
            // Empty State
            if (_selectedStudentId == null) ...[
              SizedBox(height: 40),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Color(0xFF9CA3AF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Select a Student',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Choose a student to view AI-powered performance insights',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildPerformanceOverview() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Color(0xFFEF4444)),
                SizedBox(width: 8),
                Text(
                  'Performance Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Engagement Level',
                    '${(_insights!['engagementLevel'] * 100).toInt()}%',
                    Color(0xFF10B981),
                    Icons.trending_up,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Performance Trend',
                    _insights!['performanceTrend'].toString().toUpperCase(),
                    _insights!['performanceTrend'] == 'improving' 
                        ? Color(0xFF10B981) 
                        : Color(0xFFEF4444),
                    _insights!['performanceTrend'] == 'improving' 
                        ? Icons.trending_up 
                        : Icons.trending_down,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, IconData icon) {
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
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsWeaknesses() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strengths & Weaknesses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Strengths
            Row(
              children: [
                Icon(Icons.star, color: Color(0xFF10B981), size: 20),
                SizedBox(width: 8),
                Text(
                  'Strengths',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            ...(_insights!['strengths'] as List<String>).map((strength) => Padding(
              padding: EdgeInsets.only(left: 28, bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      strength,
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
            
            // Weaknesses
            Row(
              children: [
                Icon(Icons.warning, color: Color(0xFFEF4444), size: 20),
                SizedBox(width: 8),
                Text(
                  'Areas for Improvement',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            ...(_insights!['weaknesses'] as List<String>).map((weakness) => Padding(
              padding: EdgeInsets.only(left: 28, bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      weakness,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFFF59E0B), size: 20),
                SizedBox(width: 8),
                Text(
                  'AI Recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            ...(_insights!['recommendations'] as List<String>).map((recommendation) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.tips_and_updates, color: Color(0xFFF59E0B), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTrend() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Color(0xFF8B5CF6), size: 20),
                SizedBox(width: 8),
                Text(
                  'Progress Trend (Last 6 Months)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Mock Progress Chart
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: CustomPaint(
                painter: ProgressChartPainter(),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'
                        ].map((month) => Text(
                          month,
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                          ),
                        )).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadStudentInsights(String studentId) async {
    setState(() => _isLoading = true);

    try {
      final insights = await TeacherAIService.getStudentInsights(studentId);
      setState(() {
        _insights = insights;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading insights: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ProgressChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF8B5CF6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Mock data points
    final points = [
      Offset(30, size.height - 30),
      Offset(80, size.height - 60),
      Offset(130, size.height - 40),
      Offset(180, size.height - 80),
      Offset(230, size.height - 50),
      Offset(280, size.height - 90),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 5, paint..color = Color(0xFF8B5CF6)..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}