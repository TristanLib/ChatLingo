# ChatLingo Backend API

ChatLingo AI-powered English learning backend API server built with Node.js, TypeScript, and Express.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- PostgreSQL 15+
- npm or yarn

### Installation

```bash
# Clone the repository
cd ChatLingo-Backend

# Install dependencies
npm install

# Create environment file
cp .env.example .env
# Edit .env with your configuration

# Build the project
npm run build

# Start development server
npm run dev

# Or start production server
npm start
```

## 📊 Current Status (August 7, 2025)

### ✅ Completed Features

#### Core Infrastructure
- **Express.js Server**: TypeScript-based REST API server
- **Security**: Helmet.js, CORS, error handling middleware
- **Authentication**: JWT-based authentication system
- **Database**: Prisma ORM with PostgreSQL schema designed

#### API Endpoints

**Authentication (`/api/auth/`)**
- `POST /register` - User registration with validation
- `POST /login` - User login with JWT token generation
- `GET /profile` - Get user profile (protected)
- `PUT /profile` - Update user profile (protected)

**Essential Learning (`/api/essential/`)**
- `GET /categories` - Get all essential learning categories
- `GET /categories/:id` - Get specific category details
- `GET /categories/:categoryId/content` - Get category content with pagination
- `GET /content/:contentId` - Get specific content details

**System (`/api/`)**
- `GET /health` - API health check
- `GET /` - API information and available endpoints

### 🎯 Essential Learning Categories (Mock Data)

1. **🎒 初中必会** (Junior High) - A1-A2 - 1500 words
2. **🎓 高中必会** (Senior High) - A2-B1 - 3500 words  
3. **🏛️ 四级必会** (CET-4) - B1 - 4500 words
4. **💼 商务必会** (Business) - B1-B2 - 2500 words
5. **🎯 考研必会** (Postgraduate) - B2-C1 - 5500 words

### 🏗 Architecture

```
src/
├── controllers/         # Request handlers
│   ├── authController.ts
│   └── essentialController.ts
├── middlewares/         # Express middlewares
│   └── auth.ts         # JWT authentication
├── routes/             # API routes
│   ├── auth.ts
│   ├── essential.ts
│   └── index.ts
├── services/           # Business logic (placeholder)
├── types/              # TypeScript type definitions
│   └── index.ts
├── utils/              # Helper functions
│   └── response.ts     # Standardized API responses
└── index.ts           # Application entry point
```

### 🗄 Database Schema

**Prisma Schema** (`prisma/schema.prisma`)
- User management with subscriptions
- Essential learning content hierarchy
- Progress tracking system
- AI conversation and assessment models
- Learning analytics and behavior logging

Key tables:
- `users` - User accounts and profiles
- `essential_categories` - Learning categories
- `essential_contents` - Learning materials
- `user_content_progress` - Individual progress tracking
- `ai_conversations` - AI chat sessions
- `ai_assessments` - AI scoring records

## 🔧 Development

### Available Scripts

```bash
# Development
npm run dev          # Start development server with hot reload
npm run build        # Compile TypeScript to JavaScript
npm start           # Start production server

# Database
npm run db:generate  # Generate Prisma client
npm run db:push     # Push schema to database
npm run db:migrate  # Run database migrations
npm run db:reset    # Reset database
```

### Environment Variables

```env
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/chatlingo"

# Authentication
JWT_SECRET="your-jwt-secret"
JWT_EXPIRES_IN="7d"

# Server
PORT=3000
NODE_ENV="development"
CORS_ORIGIN="http://localhost:3001"

# AI Services (for future implementation)
OPENAI_API_KEY="your-openai-key"
AZURE_SPEECH_KEY="your-azure-key"
AZURE_SPEECH_REGION="eastus"
```

### Testing the API

```bash
# Health check
curl http://localhost:3000/api/health

# Get essential categories
curl http://localhost:3000/api/essential/categories

# Register new user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","username":"testuser","password":"password123"}'

# Login user
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@chatlingo.com","password":"password123"}'
```

## 🎯 Next Development Phases

### Phase 1: AI Integration (Priority: High)
- [ ] **OpenAI GPT-4 Integration**
  - AI conversation controller and routes
  - Context management for educational dialogues
  - Role-based AI personalities (teacher, friend, interviewer, business)
  
- [ ] **Azure Speech Services**
  - Speech-to-text for voice input
  - Text-to-speech for AI responses
  - Pronunciation scoring and feedback

### Phase 2: Database Integration (Priority: High)
- [ ] **Replace Mock Data**
  - Implement actual Prisma database queries
  - Populate essential learning content
  - User progress tracking implementation

- [ ] **Progress Analytics**
  - Learning behavior logging
  - Performance analytics endpoints
  - Personalized recommendations

### Phase 3: iOS Integration (Priority: Medium)
- [ ] **API Documentation**
  - OpenAPI/Swagger documentation
  - iOS client integration guide
  - Authentication flow for mobile

- [ ] **Real-time Features**
  - WebSocket support for live AI chat
  - Push notifications for learning reminders

### Phase 4: Production Deployment (Priority: Low)
- [ ] **Infrastructure**
  - Docker containerization
  - Database migration scripts
  - Environment-specific configurations

- [ ] **Monitoring & Analytics**
  - Error logging and monitoring
  - Performance metrics
  - User analytics

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication:

1. **Registration/Login**: Returns access and refresh tokens
2. **Protected Routes**: Require `Authorization: Bearer <token>` header
3. **Token Expiry**: Access tokens expire in 7 days (configurable)

**Demo User**: 
- Email: `demo@chatlingo.com`  
- Password: `password123`

## 📱 API Response Format

All API responses follow a consistent format:

```json
{
  "success": true|false,
  "data": <response_data>,
  "message": "Optional message",
  "error": "Error message if success=false"
}
```

**Paginated responses** include additional pagination metadata:

```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "totalPages": 10
  }
}
```

## 🚨 Known Limitations (Current MVP)

1. **Mock Data**: Using in-memory mock data instead of database
2. **No AI Integration**: Placeholder responses for AI features
3. **Basic Authentication**: No OAuth 2.0 or social login yet
4. **No File Upload**: Audio/image upload not implemented
5. **No Real-time**: WebSocket not implemented

## 🤝 Contributing

This is part of the ChatLingo project. See main project documentation for contribution guidelines.

## 📄 License

MIT License - see main project LICENSE file.

---

**Last Updated**: August 7, 2025  
**API Version**: 1.0.0  
**Status**: MVP Development Phase