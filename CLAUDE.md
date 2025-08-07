# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ChatLingo is an AI-powered English learning iOS application focused on the "必会" (Essential/Must-Know) learning concept. The project is currently in the design and specification phase, with comprehensive documentation but no actual code implementation yet.

### Core Concept: 必会 (Essential) Learning System
- **必背词汇** (Essential vocabulary) categorized by learning stage
- **必背短文** (Essential passages) for reading comprehension  
- **必背对话** (Essential dialogues) with AI role-playing
- **必会写作** (Essential writing) templates and expressions
- **必会听力** (Essential listening) with adaptive speed training

### Learning Categories
- 🎒 初中必会 (Junior High): A1-A2, ages 13-16
- 🎓 高中必会 (Senior High): A2-B1, ages 16-18  
- 🏛️ 四六级必会 (CET-4/6): B1-B2, ages 18-25
- 🎯 考研必会 (Postgraduate): B2-C1, ages 22-28
- 💼 商务必会 (Business): Professional English, ages 25-40

## Project Structure

The project uses a documentation-first approach with organized folder structure:

```
docs/
├── specifications/     # Feature specs and project requirements
├── architecture/      # Technical architecture and AI design
├── ui-design/         # Interface wireframes and user experience
├── api-docs/          # RESTful API specifications
├── database/          # PostgreSQL schema designs
└── prototypes/        # Interactive HTML prototypes
```

## Architecture Overview

### Target Technology Stack
- **Frontend**: Swift 5.7+ / SwiftUI + UIKit, MVVM + Coordinator pattern
- **Backend**: Node.js + TypeScript / Express.js microservices
- **Database**: PostgreSQL 15+ with vector extensions for AI
- **AI Services**: OpenAI GPT-4 API + Azure Speech Services
- **Deployment**: Docker + Kubernetes

### Key Technical Components
1. **Essential Content System**: Categorized learning materials with difficulty levels
2. **AI Dialogue Engine**: GPT-4 powered conversational practice
3. **Voice Scoring System**: Multi-dimensional pronunciation analysis
4. **Personalized Recommendation**: ML-driven learning path optimization
5. **Progress Analytics**: Detailed learning statistics and insights

## Development Workflow

Since this is currently a specification-only project:

### Working with Documentation
- **Enhanced versions** are the current active specifications (Enhanced-*.md)
- **Original versions** serve as baseline reference documents
- Always update both README.md links when moving or renaming files
- Interactive prototypes in docs/prototypes/ demonstrate all key features

### Database Schema Management
- Use `Enhanced-Database-Schema.sql` as the primary schema reference
- Schema includes vector extension support for AI embeddings
- Essential content categorization with enum types for consistency

### API Development Reference  
- Follow RESTful patterns defined in `docs/api-docs/Enhanced-API-Design.md`
- AI-specific endpoints for dialogue, scoring, and recommendations
- Authentication via JWT + OAuth 2.0

## Key Implementation Notes

### Essential Learning System Architecture
- Content organized by `essential_category` enum (junior_high, senior_high, cet4, etc.)
- Progress tracking with `mastery_level` states (unknown → learning → familiar → mastered → expert)
- Personalized learning paths based on user category and proficiency

### AI Integration Requirements
- GPT-4 integration for contextual dialogue based on essential content
- Azure Speech Services for pronunciation scoring and feedback
- Vector search using PostgreSQL extensions for content recommendations
- Real-time feedback system for grammar, vocabulary, and pronunciation

### Mobile-First Design Principles
- SwiftUI for modern interface components
- UIKit for complex interactions requiring fine control
- Core Data + CloudKit for offline-first data architecture
- AVFoundation + Speech Framework for audio processing

## Content Management

### Essential Content Structure
Each learning category contains:
- **Vocabulary**: High-frequency core words with usage examples
- **Passages**: Selected reading materials from authentic sources
- **Dialogues**: Real-world conversation scenarios  
- **Grammar**: Essential grammar points for the level
- **Templates**: Writing frameworks and common expressions

### AI-Enhanced Features
- **Situational Practice**: AI creates dialogue scenarios using essential content
- **Real-time Correction**: Grammar, vocabulary, and pronunciation feedback
- **Personalized Roles**: AI adapts as teacher, friend, interviewer, etc.
- **Learning Guidance**: Smart prompting to use target vocabulary and patterns

## Business Context

This is a commercial English learning application targeting Chinese speakers with:
- Subscription-based revenue model (¥39-79/month)
- Freemium features with AI dialogue premium tier
- Target users: students (CET exams), professionals (business English), test takers (IELTS/TOEFL)
- Projected 80K+ paid users by year 2 with ¥58M revenue target

## Current Project Status

**Phase**: iOS Frontend Complete ✅
**Status**: Core iOS application implemented with SwiftUI/MVVM architecture
**Completed**: Essential learning system, AI chat interface, progress tracking, user profiles
**Next Steps**: Backend API development and AI service integration
**Priority**: Connect real data APIs and implement actual AI dialogue functionality

## iOS Implementation Details

### ✅ Completed iOS Components (August 2025)
The iOS application is now fully functional with the following architecture:

#### Core Architecture
- **Framework**: SwiftUI + MVVM + Coordinator Pattern
- **Navigation**: NavigationStack with custom AppCoordinator
- **Data**: Core Data integration (user's existing project base)
- **State Management**: ObservableObject with @Published properties

#### Implemented File Structure
```
ChatLingo-iOS/ChatLingo/ChatLingo/
├── Models/
│   ├── EssentialModels.swift      # Core learning content models
│   └── AIModels.swift             # AI functionality models
├── ViewModels/
│   ├── EssentialHomeViewModel.swift    # Home page business logic
│   └── EssentialDetailViewModel.swift  # Detail page logic
├── Views/
│   ├── Essential/
│   │   ├── EssentialHomeView.swift     # Category selection interface
│   │   ├── EssentialDetailView.swift   # Learning content details
│   │   └── VocabularyLearningView.swift # Word learning interface
│   ├── AI/
│   │   ├── AIFeaturesView.swift        # AI assistant overview
│   │   └── AIChatView.swift            # AI dialogue interface
│   ├── Progress/
│   │   └── ProgressView.swift          # Learning analytics
│   └── Profile/
│       └── ProfileView.swift           # User settings
├── Navigation/
│   └── AppCoordinator.swift            # Central navigation controller
├── ContentView.swift                   # Main tab navigation
└── ChatLingoApp.swift                  # App entry point
```

#### Key Features Implemented
1. **Essential Learning Categories** (5 categories)
   - 🎒 初中必会, 🎓 高中必会, 🏛️ 四级必会, 💼 商务必会, 🎯 考研必会
   - Progress tracking with mastery levels
   - Content type breakdown (vocabulary, passages, dialogues, grammar)

2. **AI Assistant System** (4 AI roles)
   - 👨‍🏫 AI Teacher, 👥 AI Friend, 💼 AI Interviewer, 🤝 AI Business Partner
   - Role-based conversation interfaces
   - Simulated AI responses (ready for API integration)

3. **Progress Analytics**
   - Learning statistics and progress visualization
   - Daily/weekly goal tracking
   - Achievement system foundation

4. **User Profile Management**
   - Settings and preferences
   - Learning history overview
   - Account management interface

### Technical Notes for Future Development
- All UI components are complete and tested in Xcode
- Data models support Codable for API integration
- Coordinator pattern enables clean navigation flow
- Architecture ready for backend API integration
- AI chat interface prepared for OpenAI GPT-4 integration