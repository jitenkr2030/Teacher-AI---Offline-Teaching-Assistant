import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import '../widgets/gradient_button.dart';
import '../services/teacher_ai_service.dart';
import '../models/teacher_data.dart';
import 'lesson_plan_screen.dart';
import 'homework_check_screen.dart';
import 'voice_assistant_screen.dart';
import 'report_card_screen.dart';
import 'worksheet_generator_screen.dart';
import 'student_insights_screen.dart';
import 'attendance_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Teacher? _teacher;
  bool _isLoading = true;
  int _generatedPlansCount = 0;
  int _checkedHomeworkCount = 0;
  int _studentsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    try {
      final teacher = await TeacherAIService.getCurrentTeacher();
      final stats = await TeacherAIService.getTeacherStats();
      
      setState(() {
        _teacher = teacher;
        _generatedPlansCount = stats['generatedPlans'] ?? 0;
        _checkedHomeworkCount = stats['checkedHomework'] ?? 0;
        _studentsCount = stats['studentsCount'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error or create default teacher
      _teacher = Teacher(
        id: 'default',
        name: 'Teacher',
        school: 'Demo School',
        subscriptionTier: 'free',
        subscriptionExpiry: DateTime.now().add(Duration(days: 30)),
        classes: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  _teacher?.name ?? 'Teacher',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showSubscriptionDialog,
            icon: Stack(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: _teacher?.subscriptionTier == 'pro'
                      ? Color(0xFFF59E0B)
                      : Color(0xFF6B7280),
                ),
                if (_teacher?.subscriptionTier != 'pro')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
            ],
          ),
          IconButton(
            onPressed: _showProfileMenu,
            icon: Icon(
              Icons.account_circle,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
      
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTeacherData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats
                    _buildQuickStats(),
                    
                    // Quick Actions
                    _buildQuickActions(),
                    
                    // AI Features
                    _buildAIFeatures(),
                    
                    // Recent Activity
                    _buildRecentActivity(),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Your Impact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: '$_generatedPlansCount',
                  label: 'Lesson Plans',
                  icon: Icons.description,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _StatItem(
                  value: '$_checkedHomeworkCount',
                  label: 'Homework Checked',
                  icon: Icons.check_circle,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _StatItem(
                  value: '$_studentsCount',
                  label: 'Students',
                  icon: Icons.people,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  title: 'Voice\nAssistant',
                  icon: Icons.mic,
                  color: Color(0xFF8B5CF6),
                  onTap: () => _navigateTo(VoiceAssistantScreen()),
                  subtitle: 'Ask anything',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  title: 'Check\nHomework',
                  icon: Icons.camera_alt,
                  color: Color(0xFF10B981),
                  onTap: () => _navigateTo(HomeworkCheckScreen()),
                  subtitle: 'Photo check',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  title: 'Take\nAttendance',
                  icon: Icons.how_to_reg,
                  color: Color(0xFFF59E0B),
                  onTap: () => _navigateTo(AttendanceScreen()),
                  subtitle: 'Voice enabled',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeatures() {
    final isPro = _teacher?.subscriptionTier == 'pro';
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Teaching Tools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          
          SizedBox(height: 16),
          
          FeatureCard(
            title: 'Lesson Plan Generator',
            description: 'Create comprehensive lesson plans in seconds with voice input',
            icon: Icons.auto_stories,
            color: Color(0xFF2563EB),
            onTap: () => _navigateTo(LessonPlanScreen()),
          ),
          
          FeatureCard(
            title: 'Smart Report Cards',
            description: 'Generate personalized comments based on student performance',
            icon: Icons.analytics,
            color: Color(0xFF10B981),
            onTap: () => _navigateTo(ReportCardScreen()),
          ),
          
          FeatureCard(
            title: 'Worksheet Generator',
            description: 'Create MCQs, fill-in-blanks, and short answer questions',
            icon: Icons.quiz,
            color: Color(0xFF8B5CF6),
            onTap: () => _navigateTo(WorksheetGeneratorScreen()),
            isLocked: !isPro,
            lockReason: 'Upgrade to Pro to generate unlimited worksheets',
          ),
          
          FeatureCard(
            title: 'Student Performance Insights',
            description: 'AI-powered analysis of student progress and improvement areas',
            icon: Icons.trending_up,
            color: Color(0xFFEF4444),
            onTap: () => _navigateTo(StudentInsightsScreen()),
            isLocked: !isPro,
            lockReason: 'Advanced analytics available in Pro version',
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          
          SizedBox(height: 16),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                _ActivityItem(
                  icon: Icons.description,
                  title: 'Generated lesson plan',
                  subtitle: 'Class 5 - Fractions',
                  time: '2 hours ago',
                  color: Color(0xFF2563EB),
                ),
                Divider(height: 20, color: Color(0xFFF3F4F6)),
                _ActivityItem(
                  icon: Icons.check_circle,
                  title: 'Checked homework',
                  subtitle: '15 assignments reviewed',
                  time: '5 hours ago',
                  color: Color(0xFF10B981),
                ),
                Divider(height: 20, color: Color(0xFFF3F4F6)),
                _ActivityItem(
                  icon: Icons.mic,
                  title: 'Voice assistant used',
                  subtitle: 'Asked about photosynthesis',
                  time: '1 day ago',
                  color: Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to Pro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get unlimited access to all features:'),
            SizedBox(height: 12),
            ...[
              '✓ Unlimited lesson plans',
              '✓ Advanced homework checking',
              '✓ Worksheet generator',
              '✓ Student performance insights',
              '✓ Priority support',
            ].map((feature) => Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                feature,
                style: TextStyle(fontSize: 14),
              ),
            )).toList(),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFF59E0B), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Only ₹99/month',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later'),
          ),
          GradientButton(
            text: 'Upgrade Now',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement subscription flow
            },
            color: Color(0xFF2563EB),
            width: 120,
          ),
        ],
      ),
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _teacher?.name ?? 'Teacher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        _teacher?.school ?? 'Demo School',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (_teacher?.subscriptionTier == 'pro'
                                  ? Color(0xFF10B981)
                                  : Color(0xFF6B7280))
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _teacher?.subscriptionTier?.toUpperCase() ?? 'FREE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _teacher?.subscriptionTier == 'pro'
                                ? Color(0xFF10B981)
                                : Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            Divider(color: Color(0xFFE5E7EB)),
            
            SizedBox(height: 16),
            
            ...[
              ('Settings', Icons.settings),
              ('Help & Support', Icons.help_outline),
              ('Privacy Policy', Icons.privacy_tip_outlined),
              ('About', Icons.info_outline),
            ].map((item) => ListTile(
              leading: Icon(item.$2, color: Color(0xFF6B7280)),
              title: Text(item.$1),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement navigation
              },
            )).toList(),
            
            SizedBox(height: 16),
            
            GradientButton(
              text: 'Sign Out',
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement sign out
              },
              color: Color(0xFFEF4444),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}