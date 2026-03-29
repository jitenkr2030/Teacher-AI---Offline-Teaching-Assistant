# Teacher AI Offline Assistant - Product Architecture

## 🎯 Executive Summary

Teacher AI is a mobile-first offline AI assistant built on the Cactus AI engine, designed specifically for school teachers in low-tech environments. The product leverages Cactus's on-device AI capabilities to provide teaching assistance without requiring internet connectivity.

## 🏗️ Technical Architecture

### Core AI Engine (Cactus Integration)

```
┌─────────────────────────────────────────────────────────────┐
│                    Teacher AI Mobile App                    │
│                     (Flutter/Dart)                         │
├─────────────────────────────────────────────────────────────┤
│                  Teacher AI Service Layer                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Lesson    │ │   Report    │ │   Homework  │           │
│  │  Planning   │ │   Cards     │ │  Checking   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Voice     │ │ Worksheet   │ │ Performance │           │
│  │ Assistant   │ │ Generator   │ │  Insights   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
├─────────────────────────────────────────────────────────────┤
│                    Cactus AI Engine                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │     LLM     │ │     STT     │ │   Vision    │           │
│  │ (Gemma/LFM) │ │ (Whisper)   │ │ (LFM2-VL)   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  Embeddings │ │     RAG     │ │     VAD     │           │
│  │  & Search   │ │   System    │ │ Detection   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
├─────────────────────────────────────────────────────────────┤
│                   Data & Storage                           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Student   │ │   Lesson    │ │  Model      │           │
│  │   Database  │ │   Plans     │ │  Weights    │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## 📱 Feature Mapping to Cactus Capabilities

### 1. 📝 Auto Lesson Plan Generator
**Cactus Integration:** LLM Completion + RAG
- **Input:** Teacher voice/text request ("Class 5 maths fractions padhana hai")
- **Processing:** 
  - STT for voice input (Whisper/Moonshine)
  - LLM generates structured lesson plan (Gemma/LFM)
  - RAG retrieves teaching examples from corpus
- **Output:** Topics, examples, homework, timing

### 2. 📊 Smart Report Card Comments
**Cactus Integration:** LLM Completion + Embeddings
- **Input:** Student marks and performance data
- **Processing:**
  - Embeddings analyze performance patterns
  - LLM generates personalized comments
- **Output:** "Needs improvement in problem solving", "Shows strong conceptual clarity"

### 3. 📸 Homework Checking (Game Changer)
**Cactus Integration:** Vision Model + LLM
- **Input:** Photo of student notebook
- **Processing:**
  - Vision model (LFM2-VL) analyzes handwritten answers
  - LLM evaluates correctness and provides feedback
- **Output:** Correct/incorrect detection, suggested marks, feedback

### 4. 🎤 Voice Teaching Assistant
**Cactus Integration:** STT + LLM + STT
- **Input:** Teacher voice question ("Photosynthesis simple explain karo")
- **Processing:**
  - STT transcribes teacher speech
  - LLM generates simple explanation
  - Text-to-speech for response (optional)
- **Output:** Simple explanations, examples for kids

### 5. 📚 Worksheet Generator
**Cactus Integration:** LLM Completion
- **Input:** Class, subject, topic
- **Processing:** LLM generates varied question types
- **Output:** MCQs, fill-in-blanks, short answers

### 6. 🧠 Student Performance Insights
**Cactus Integration:** Embeddings + RAG + LLM
- **Input:** Student marks, attendance data
- **Processing:**
  - Embeddings identify patterns and trends
  - RAG retrieves relevant teaching strategies
  - LLM generates insights and recommendations
- **Output:** Weak students identification, topic gaps, improvement suggestions

### 7. 📋 Voice Attendance
**Cactus Integration:** STT + VAD
- **Input:** Teacher speech ("Rahul present, Amit absent")
- **Processing:**
  - VAD detects speech segments
  - STT transcribes attendance calls
  - NLP extracts student names and status
- **Output:** Automated attendance record

## 🗄️ Data Models & Storage

### Core Data Models

```dart
class Teacher {
  String id;
  String name;
  String school;
  String subscriptionTier;
  DateTime subscriptionExpiry;
  List<Class> classes;
}

class Class {
  String id;
  String name;
  String subject;
  String grade;
  List<Student> students;
  List<LessonPlan> lessonPlans;
}

class Student {
  String id;
  String name;
  Map<String, double> subjects; // subject -> marks
  List<AttendanceRecord> attendance;
  List<HomeworkSubmission> homeworkSubmissions;
}

class LessonPlan {
  String id;
  String topic;
  String grade;
  String subject;
  List<String> objectives;
  List<String> activities;
  String homework;
  int durationMinutes;
  DateTime created;
}

class HomeworkSubmission {
  String id;
  String studentId;
  String assignmentId;
  String imagePath;
  double score;
  String feedback;
  DateTime submitted;
}
```

### Local Storage Strategy
- **SQLite** for structured data (students, classes, attendance)
- **File System** for model weights and images
- **Vector Index** for RAG corpus and embeddings

## 💰 Business Model Integration

### Subscription Tiers
1. **Free Tier**: 5 lesson plans/month, basic features
2. **Teacher Pro (₹99/month)**: Unlimited lesson plans, homework checking, voice features
3. **School Premium (₹999-₹4999/month)**: Multi-teacher, advanced analytics, admin dashboard

### In-App Purchases
- **Model Packs**: Specialized subject models (Mathematics, Science, Languages)
- **Feature Packs**: Advanced analytics, parent communication
- **Content Packs**: Premium lesson templates, worksheet libraries

## 🔧 Technical Implementation Details

### Model Selection Strategy
- **Primary LLM**: Gemma-3-270m-it (270M params, good balance of speed/quality)
- **Vision Model**: LFM2-VL-450M (efficient image understanding)
- **STT Model**: Moonshine-base (fast, accurate for English/Hindi)
- **Embeddings**: Nomic-embed-text-v2-moe (multilingual support)

### Performance Optimizations
- **Model Quantization**: INT4 for reduced memory usage
- **Lazy Loading**: Load models on-demand
- **Caching**: Cache frequent queries and results
- **Batch Processing**: Process multiple requests when possible

### Offline-First Architecture
- **Local Models**: All AI models run locally on device
- **Sync Strategy**: Optional cloud backup for data (not AI processing)
- **Update Mechanism**: Model updates via app store or secure downloads

## 🎯 User Experience Flow

### Teacher Onboarding
1. **Setup Profile**: Name, school, subjects, grades
2. **Model Download**: Download required AI models (one-time)
3. **Class Setup**: Add classes and student lists
4. **Tutorial**: Interactive walkthrough of features

### Daily Usage Flow
1. **Morning Prep**: Generate lesson plans for the day
2. **During Class**: Use voice assistant for explanations
3. **After Class**: Check homework via photos
4. **Evening**: Review student performance, plan next day

## 📊 Success Metrics

### Engagement Metrics
- Daily active users
- Features used per session
- Lesson plans generated
- Homework submissions checked

### Business Metrics
- Subscription conversion rate
- Monthly recurring revenue
- Customer lifetime value
- Churn rate

### Educational Impact
- Time saved per teacher (hours/week)
- Student performance improvement
- Teacher satisfaction scores

## 🚀 Development Roadmap

### Phase 1: MVP (4-6 weeks)
- Basic lesson plan generation
- Simple report card comments
- Voice assistant (Q&A)
- Teacher profile and classes

### Phase 2: Core Features (6-8 weeks)
- Homework checking with vision
- Worksheet generator
- Voice attendance
- Student performance insights

### Phase 3: Business Features (4-6 weeks)
- Subscription system
- Advanced analytics
- Multi-teacher support
- Cloud sync (optional)

### Phase 4: Scale & Optimize (Ongoing)
- Model optimizations
- New subject models
- Regional language support
- Advanced features

## 🔒 Privacy & Security

### Data Protection
- **Local Processing**: All AI processing happens on-device
- **No Student Data to Cloud**: Student information never leaves device
- **Encryption**: Local database encryption
- **Consent**: Clear consent for photo usage

### Compliance
- **COPPA**: Child privacy protection
- **GDPR**: Data protection standards
- **Local Regulations**: Indian education data policies

This architecture provides a comprehensive foundation for building Teacher AI as a real, scalable product that addresses the massive need for AI-powered teaching assistance in offline environments.