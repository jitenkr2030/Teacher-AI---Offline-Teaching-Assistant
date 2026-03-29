import 'package:flutter/material.dart';
import '../widgets/voice_button.dart';
import '../services/teacher_ai_service.dart';

class VoiceAssistantScreen extends StatefulWidget {
  @override
  _VoiceAssistantScreenState createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final _controller = TextEditingController();
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _response;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processQuery(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final response = await TeacherAIService.processVoiceQuery(query);
      setState(() {
        _response = response;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startRecording() {
    setState(() => _isRecording = true);
    // TODO: Implement voice recording
  }

  void _stopRecording() async {
    setState(() => _isRecording = false);
    // Mock voice input
    final mockQuery = 'Explain photosynthesis in simple terms';
    _controller.text = mockQuery;
    await _processQuery(mockQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Assistant'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1F2937),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.mic, size: 48, color: Color(0xFF8B5CF6)),
                    SizedBox(height: 16),
                    Text(
                      'Ask Me Anything',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Get instant answers to your teaching questions',
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

            SizedBox(height: 20),

            // Voice Input
            VoiceButton(
              onStartRecording: _startRecording,
              onStopRecording: _stopRecording,
              isRecording: _isRecording,
              hintText: _isRecording ? 'Listening...' : 'Tap to ask a question',
            ),

            SizedBox(height: 20),

            // Text Input
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Or type your question:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'e.g., Explain fractions simply',
                        suffixIcon: IconButton(
                          onPressed: _isProcessing ? null : () => _processQuery(_controller.text),
                          icon: _isProcessing 
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(Icons.send, color: Color(0xFF8B5CF6)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // Response
            if (_response != null) ...[
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.psychology, color: Color(0xFF8B5CF6)),
                          SizedBox(width: 8),
                          Text(
                            'AI Response',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        _response!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4B5563),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Quick Questions
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Questions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Explain photosynthesis',
                        'What are fractions?',
                        'How to teach grammar?',
                        'Science experiments',
                        'Math shortcuts',
                      ].map((question) => ActionChip(
                        label: Text(question),
                        onPressed: () {
                          _controller.text = question;
                          _processQuery(question);
                        },
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}