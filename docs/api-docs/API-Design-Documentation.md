# ChatLingo API设计文档

## 1. API概览

### 1.1 基础信息
- **Base URL**: `https://api.chatlingo.com/v1`
- **认证方式**: JWT Bearer Token
- **数据格式**: JSON
- **字符编码**: UTF-8
- **API版本**: v1.0

### 1.2 通用响应格式
```json
{
  "success": true,
  "data": {},
  "message": "操作成功",
  "timestamp": "2024-08-06T14:30:00Z",
  "request_id": "req_1234567890"
}
```

### 1.3 错误响应格式
```json
{
  "success": false,
  "error": {
    "code": "INVALID_TOKEN",
    "message": "认证令牌无效",
    "details": "Token has expired"
  },
  "timestamp": "2024-08-06T14:30:00Z",
  "request_id": "req_1234567890"
}
```

### 1.4 HTTP状态码
- `200` - 请求成功
- `201` - 资源创建成功
- `400` - 请求参数错误
- `401` - 未授权
- `403` - 权限不足
- `404` - 资源不存在
- `429` - 请求频率限制
- `500` - 服务器内部错误

## 2. 认证API

### 2.1 用户注册
```http
POST /auth/register
Content-Type: application/json

{
  "username": "lisa_chen",
  "email": "lisa@example.com",
  "password": "SecurePass123!",
  "english_level": "A1",
  "learning_goals": ["business", "daily_conversation"]
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "user_id": "usr_1234567890",
    "username": "lisa_chen",
    "email": "lisa@example.com",
    "english_level": "A1",
    "subscription_type": "free",
    "created_at": "2024-08-06T14:30:00Z"
  },
  "message": "注册成功"
}
```

### 2.2 用户登录
```http
POST /auth/login
Content-Type: application/json

{
  "email": "lisa@example.com",
  "password": "SecurePass123!"
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400,
    "user": {
      "user_id": "usr_1234567890",
      "username": "lisa_chen",
      "email": "lisa@example.com",
      "english_level": "A1",
      "subscription_type": "free"
    }
  },
  "message": "登录成功"
}
```

### 2.3 社交登录 (Apple ID)
```http
POST /auth/apple
Content-Type: application/json

{
  "identity_token": "eyJraWQiOiJmaDZCcyIsImFsZyI6IlJTMjU2In0...",
  "authorization_code": "c1234567890",
  "user_info": {
    "email": "lisa@privaterelay.appleid.com",
    "first_name": "Lisa",
    "last_name": "Chen"
  }
}
```

### 2.4 刷新访问令牌
```http
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 2.5 注销登录
```http
POST /auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 3. 用户管理API

### 3.1 获取用户信息
```http
GET /users/profile
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "user_id": "usr_1234567890",
    "username": "lisa_chen",
    "email": "lisa@example.com",
    "avatar_url": "https://cdn.chatlingo.com/avatars/lisa_chen.jpg",
    "english_level": "B1",
    "subscription_type": "premium",
    "learning_streak": 15,
    "total_learning_time": 7200,
    "coins": 1250,
    "experience_points": 3450,
    "created_at": "2024-06-01T10:00:00Z",
    "last_active_at": "2024-08-06T14:25:00Z"
  }
}
```

### 3.2 更新用户信息
```http
PUT /users/profile
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "username": "lisa_updated",
  "english_level": "B2",
  "learning_goals": ["business", "travel"],
  "daily_goal_minutes": 30,
  "timezone": "Asia/Shanghai"
}
```

### 3.3 上传头像
```http
POST /users/avatar
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: multipart/form-data

[Binary image data]
```

### 3.4 获取学习统计
```http
GET /users/statistics
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "total_learning_time": 7200,
    "learning_streak": 15,
    "vocabulary_learned": 856,
    "lessons_completed": 124,
    "conversation_count": 78,
    "average_accuracy": 87.5,
    "weekly_stats": {
      "current_week_minutes": 180,
      "last_week_minutes": 165,
      "weekly_goal": 140
    },
    "module_distribution": {
      "conversation": 40,
      "vocabulary": 30,
      "listening": 20,
      "grammar": 10
    }
  }
}
```

## 4. 学习内容API

### 4.1 获取课程列表
```http
GET /learning/lessons?level=B1&type=conversation&page=1&limit=20
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "lessons": [
      {
        "lesson_id": "lesson_1234",
        "title": "商务会议英语",
        "description": "学习如何在商务会议中有效沟通",
        "difficulty": "B1",
        "type": "conversation",
        "estimated_duration": 15,
        "tags": ["business", "meeting", "communication"],
        "thumbnail_url": "https://cdn.chatlingo.com/lessons/business_meeting.jpg",
        "is_premium": false,
        "created_at": "2024-08-01T10:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 156,
      "total_pages": 8
    }
  }
}
```

### 4.2 获取课程详情
```http
GET /learning/lessons/lesson_1234
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "lesson_id": "lesson_1234",
    "title": "商务会议英语",
    "description": "学习如何在商务会议中有效沟通",
    "difficulty": "B1",
    "type": "conversation",
    "estimated_duration": 15,
    "content": {
      "introduction": {
        "text": "在商务环境中...",
        "audio_url": "https://cdn.chatlingo.com/audio/intro_1234.mp3"
      },
      "vocabulary": [
        {
          "word": "agenda",
          "pronunciation": "/əˈdʒendə/",
          "meaning": "议程",
          "example": "Let's go through today's agenda."
        }
      ],
      "conversation_scenarios": [
        {
          "scenario_id": "scenario_001",
          "title": "开始会议",
          "context": "您是会议主持人，需要开始一个重要的项目讨论会议",
          "ai_prompts": ["Let's get started with today's meeting"]
        }
      ]
    },
    "prerequisites": ["lesson_1230", "lesson_1231"],
    "next_lessons": ["lesson_1235", "lesson_1236"]
  }
}
```

### 4.3 开始学习课程
```http
POST /learning/sessions
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "lesson_id": "lesson_1234",
  "session_type": "conversation"
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "session_id": "session_5678",
    "lesson_id": "lesson_1234",
    "user_id": "usr_1234567890",
    "session_type": "conversation",
    "status": "active",
    "started_at": "2024-08-06T14:30:00Z",
    "current_step": 0,
    "total_steps": 5
  }
}
```

### 4.4 提交学习进度
```http
POST /learning/progress
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "session_id": "session_5678",
  "lesson_id": "lesson_1234",
  "progress_percentage": 60,
  "current_step": 3,
  "answers": [
    {
      "question_id": "q_001",
      "user_answer": "I agree with your proposal",
      "is_correct": true,
      "score": 85
    }
  ],
  "time_spent": 300
}
```

## 5. AI对话API

### 5.1 开始AI对话
```http
POST /chat/conversations
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "topic": "business_meeting",
  "user_level": "B1",
  "conversation_type": "practice",
  "context": {
    "scenario": "You are in a business meeting discussing quarterly results",
    "user_role": "Project Manager"
  }
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "conversation_id": "conv_9876",
    "ai_response": {
      "text": "Hi there! I'm excited to discuss our quarterly results with you. How do you think our team performed this quarter?",
      "audio_url": "https://cdn.chatlingo.com/tts/response_9876_001.mp3",
      "suggestions": [
        "I think we did quite well overall",
        "There were some challenges, but also successes",
        "Let me share the key metrics with you"
      ]
    },
    "conversation_context": {
      "turn": 1,
      "topic": "business_meeting",
      "user_level": "B1"
    }
  }
}
```

### 5.2 发送消息
```http
POST /chat/conversations/conv_9876/messages
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "message_type": "text",
  "content": "I think we exceeded our sales targets by 15% this quarter",
  "audio_data": null
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "message_id": "msg_001",
    "user_message": {
      "text": "I think we exceeded our sales targets by 15% this quarter",
      "grammar_feedback": {
        "is_correct": true,
        "score": 92,
        "suggestions": []
      },
      "vocabulary_used": ["exceeded", "targets", "quarter"],
      "timestamp": "2024-08-06T14:32:00Z"
    },
    "ai_response": {
      "text": "That's fantastic! A 15% increase is really impressive. What do you think contributed most to this success?",
      "audio_url": "https://cdn.chatlingo.com/tts/response_9876_002.mp3",
      "teaching_points": [
        "Great use of 'exceeded' - this is more advanced than 'beat'",
        "Your sentence structure is perfect for business communication"
      ]
    }
  }
}
```

### 5.3 语音消息处理
```http
POST /chat/conversations/conv_9876/voice
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: multipart/form-data

{
  "audio": [Binary audio data],
  "format": "m4a",
  "duration": 5.2
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "transcription": {
      "text": "I think we exceeded our sales targets by fifteen percent this quarter",
      "confidence": 0.94,
      "words": [
        {"word": "I", "start": 0.0, "end": 0.1, "confidence": 0.99},
        {"word": "think", "start": 0.2, "end": 0.4, "confidence": 0.95}
      ]
    },
    "pronunciation_feedback": {
      "overall_score": 88,
      "problematic_words": [
        {
          "word": "exceeded",
          "user_pronunciation": "/ɪkˈsiːd/",
          "correct_pronunciation": "/ɪkˈsiːdɪd/",
          "feedback": "记住过去式需要-ed结尾"
        }
      ]
    },
    "ai_response": {
      "text": "Excellent pronunciation! I could understand you perfectly. That's wonderful news about the sales targets!",
      "audio_url": "https://cdn.chatlingo.com/tts/response_9876_003.mp3"
    }
  }
}
```

### 5.4 获取对话历史
```http
GET /chat/conversations/conv_9876/history
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 6. 词汇学习API

### 6.1 获取词汇列表
```http
GET /vocabulary/words?level=B1&category=business&page=1&limit=50
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "words": [
      {
        "word_id": "word_1001",
        "word": "achievement",
        "pronunciation": "/əˈtʃiːvmənt/",
        "definition": "a thing done successfully with effort, skill, or courage",
        "chinese_meaning": "成就，成绩",
        "word_class": "noun",
        "difficulty_level": "B1",
        "frequency_rank": 2456,
        "examples": [
          {
            "sentence": "Winning the contract was a great achievement for our team.",
            "chinese_translation": "赢得这份合同对我们团队来说是一个巨大的成就。",
            "audio_url": "https://cdn.chatlingo.com/examples/achievement_001.mp3"
          }
        ],
        "image_url": "https://cdn.chatlingo.com/words/achievement.jpg",
        "audio_url": "https://cdn.chatlingo.com/pronunciation/achievement.mp3",
        "related_words": ["accomplish", "success", "attainment"],
        "tags": ["business", "success", "work"]
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 50,
      "total": 1250,
      "total_pages": 25
    }
  }
}
```

### 6.2 词汇学习记录
```http
POST /vocabulary/learning-record
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "word_id": "word_1001",
  "action": "learned",
  "proficiency_level": 3,
  "time_spent": 45,
  "practice_results": [
    {
      "exercise_type": "definition_match",
      "score": 100,
      "attempts": 1
    }
  ]
}
```

### 6.3 获取复习单词
```http
GET /vocabulary/review?count=20
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "review_words": [
      {
        "word_id": "word_1001",
        "word": "achievement",
        "last_reviewed": "2024-08-04T10:00:00Z",
        "review_count": 3,
        "mastery_level": 0.75,
        "due_for_review": true,
        "review_type": "spaced_repetition"
      }
    ],
    "total_due": 20,
    "estimated_time": 8
  }
}
```

## 7. 社交功能API

### 7.1 获取社区动态
```http
GET /social/feed?page=1&limit=20&type=all
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "posts": [
      {
        "post_id": "post_5001",
        "user": {
          "user_id": "usr_2345",
          "username": "alice_learner",
          "avatar_url": "https://cdn.chatlingo.com/avatars/alice.jpg",
          "level": "B2"
        },
        "content": {
          "text": "今天学会了10个新单词，连续打卡第30天！💪",
          "images": ["https://cdn.chatlingo.com/posts/screenshot_001.jpg"],
          "learning_stats": {
            "words_learned": 10,
            "streak_days": 30,
            "study_time": 25
          }
        },
        "engagement": {
          "likes": 128,
          "comments": 23,
          "shares": 15,
          "user_liked": false
        },
        "created_at": "2024-08-06T12:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 456
    }
  }
}
```

### 7.2 发布动态
```http
POST /social/posts
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "content": {
    "text": "分享一个口语练习技巧：每天对着镜子说英语10分钟，真的很有效！",
    "type": "tip"
  },
  "visibility": "public",
  "tags": ["speaking", "practice", "tip"]
}
```

### 7.3 获取排行榜
```http
GET /social/leaderboard?period=week&type=study_time
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "leaderboard": [
      {
        "rank": 1,
        "user": {
          "user_id": "usr_top1",
          "username": "superlearner",
          "avatar_url": "https://cdn.chatlingo.com/avatars/superlearner.jpg"
        },
        "study_time": 1680,
        "change": "+2"
      }
    ],
    "user_rank": {
      "rank": 15,
      "study_time": 720,
      "change": "-1"
    },
    "period": "week",
    "total_participants": 1542
  }
}
```

## 8. 订阅和支付API

### 8.1 获取订阅计划
```http
GET /subscription/plans
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "plans": [
      {
        "plan_id": "basic_monthly",
        "name": "基础会员",
        "price": 39.00,
        "currency": "CNY",
        "billing_period": "monthly",
        "features": [
          "无限学习时长",
          "基础课程内容",
          "社区互动功能"
        ],
        "apple_product_id": "com.chatlingo.basic.monthly"
      },
      {
        "plan_id": "premium_monthly",
        "name": "高级会员",
        "price": 79.00,
        "currency": "CNY",
        "billing_period": "monthly",
        "features": [
          "所有基础功能",
          "AI对话无限制",
          "专属外教服务",
          "高级课程内容",
          "学习数据分析"
        ],
        "apple_product_id": "com.chatlingo.premium.monthly",
        "is_popular": true
      }
    ]
  }
}
```

### 8.2 验证App Store购买
```http
POST /subscription/verify-purchase
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "receipt_data": "base64_encoded_receipt",
  "product_id": "com.chatlingo.premium.monthly",
  "transaction_id": "1000000123456789"
}
```

### 8.3 获取订阅状态
```http
GET /subscription/status
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "subscription": {
      "is_active": true,
      "plan_id": "premium_monthly",
      "plan_name": "高级会员",
      "start_date": "2024-07-06T14:30:00Z",
      "expiry_date": "2024-08-06T14:30:00Z",
      "auto_renewal": true,
      "days_remaining": 30
    }
  }
}
```

## 9. 通知API

### 9.1 注册推送令牌
```http
POST /notifications/register-token
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "device_token": "abc123def456ghi789jkl012mno345pqr678",
  "platform": "ios",
  "app_version": "1.0.0",
  "device_info": {
    "model": "iPhone14,2",
    "os_version": "17.0.1"
  }
}
```

### 9.2 获取通知设置
```http
GET /notifications/preferences
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 9.3 更新通知设置
```http
PUT /notifications/preferences
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "daily_reminder": true,
  "reminder_time": "19:00",
  "streak_reminders": true,
  "social_notifications": false,
  "learning_tips": true
}
```

## 10. 错误码对照表

| 错误码 | HTTP状态 | 描述 |
|--------|---------|------|
| `AUTH_001` | 401 | 认证令牌无效 |
| `AUTH_002` | 401 | 认证令牌已过期 |
| `AUTH_003` | 403 | 权限不足 |
| `USER_001` | 400 | 用户名已存在 |
| `USER_002` | 400 | 邮箱已被注册 |
| `USER_003` | 404 | 用户不存在 |
| `LESSON_001` | 404 | 课程不存在 |
| `LESSON_002` | 403 | 课程需要会员权限 |
| `CHAT_001` | 429 | AI对话频率限制 |
| `CHAT_002` | 503 | AI服务暂时不可用 |
| `PAYMENT_001` | 400 | 购买验证失败 |
| `PAYMENT_002` | 409 | 订阅已存在 |
| `RATE_LIMIT` | 429 | 请求频率超限 |
| `SERVER_ERROR` | 500 | 服务器内部错误 |

## 11. 频率限制

| 端点类别 | 限制 | 时间窗口 |
|---------|------|---------|
| 认证API | 10次 | 1分钟 |
| 用户API | 100次 | 1分钟 |
| 学习API | 200次 | 1分钟 |
| AI对话API | 60次 | 1小时(免费) / 300次(会员) |
| 社交API | 150次 | 1分钟 |
| 上传API | 20次 | 1分钟 |

## 12. SDK示例 (Swift)

```swift
// ChatLingo API客户端
class ChatLingoAPI {
    private let baseURL = "https://api.chatlingo.com/v1"
    private var accessToken: String?
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(email: email, password: password)
        let response: APIResponse<LoginResponse> = try await post("/auth/login", body: request)
        
        if response.success {
            self.accessToken = response.data.accessToken
            return response.data
        } else {
            throw APIError.loginFailed(response.error?.message ?? "Unknown error")
        }
    }
    
    func startConversation(topic: String) async throws -> ConversationResponse {
        guard let token = accessToken else {
            throw APIError.notAuthenticated
        }
        
        let request = StartConversationRequest(topic: topic, userLevel: "B1")
        return try await post("/chat/conversations", body: request, token: token)
    }
}
```

---

**文档版本**: v1.0  
**最后更新**: 2024年8月6日  
**API版本**: v1.0  
**联系方式**: api-support@chatlingo.com