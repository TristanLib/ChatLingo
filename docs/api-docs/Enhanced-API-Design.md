# ChatLingo 增强版API设计 - 必会专题 + AI功能

## 1. API概览更新

### 1.1 新增API模块
```
ChatLingo API v2.0
├── 认证模块 (/auth)
├── 用户管理 (/users)  
├── 必会专题 (/essentials) ← 新增
├── AI服务 (/ai) ← 新增
├── 学习进度 (/progress)
├── 社交功能 (/social)
├── 订阅支付 (/subscription)
└── 系统配置 (/system)
```

## 2. 必会专题API (/essentials)

### 2.1 获取必会分类
```http
GET /essentials/categories
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "category_id": "junior_high",
        "name": "初中必会",
        "description": "13-16岁初中生必备英语内容",
        "target_level": "A1-A2",
        "age_group": "13-16",
        "content_stats": {
          "vocabulary_count": 1500,
          "passages_count": 50,
          "dialogues_count": 30,
          "grammar_points": 100
        },
        "difficulty_color": "#4CAF50",
        "icon_url": "https://cdn.chatlingo.com/icons/junior_high.png",
        "estimated_duration_days": 90
      },
      {
        "category_id": "cet46",
        "name": "四六级必会",
        "description": "大学英语四六级考试必备内容",
        "target_level": "B1-B2", 
        "age_group": "18-25",
        "content_stats": {
          "vocabulary_count": 6000,
          "passages_count": 200,
          "dialogues_count": 150,
          "writing_templates": 50
        },
        "difficulty_color": "#2196F3",
        "icon_url": "https://cdn.chatlingo.com/icons/cet.png",
        "estimated_duration_days": 120,
        "is_popular": true
      }
    ]
  }
}
```

### 2.2 获取必会内容类型
```http
GET /essentials/categories/{category_id}/types
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "content_types": [
      {
        "type_id": "vocabulary",
        "name": "必背词汇",
        "description": "核心高频词汇",
        "icon": "📝",
        "total_count": 4500,
        "completed_count": 3024,
        "progress_percentage": 67,
        "estimated_time_per_item": 2,
        "difficulty_distribution": {
          "easy": 1500,
          "medium": 2000,
          "hard": 1000
        }
      },
      {
        "type_id": "passages",
        "name": "必背短文",
        "description": "精选阅读和听力短文",
        "icon": "📖",
        "total_count": 100,
        "completed_count": 67,
        "progress_percentage": 67,
        "estimated_time_per_item": 15,
        "subcategories": [
          "听力短文",
          "阅读理解",
          "完形填空"
        ]
      },
      {
        "type_id": "dialogues",
        "name": "必背对话",
        "description": "真实场景对话练习",
        "icon": "💬",
        "total_count": 200,
        "completed_count": 134,
        "progress_percentage": 67,
        "estimated_time_per_item": 10,
        "scenarios": [
          "校园生活",
          "日常交流", 
          "学术讨论"
        ]
      }
    ]
  }
}
```

### 2.3 获取具体必会内容
```http
GET /essentials/content?category=cet46&type=vocabulary&level=4&page=1&limit=20
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "content_items": [
      {
        "item_id": "vocab_accomplish_001",
        "word": "accomplish",
        "pronunciation": "/əˈkʌmplɪʃ/",
        "word_class": "verb",
        "definition": "完成，实现，达到",
        "difficulty_level": "4", // 四级词汇
        "frequency_rank": 1234,
        "essential_tags": ["四级核心", "高频动词"],
        "collocations": [
          {
            "phrase": "accomplish a task",
            "meaning": "完成任务",
            "example": "We need to accomplish this task by Friday."
          },
          {
            "phrase": "accomplish one's goal", 
            "meaning": "实现目标",
            "example": "Hard work will help you accomplish your goal."
          }
        ],
        "example_sentences": [
          {
            "sentence": "To accomplish this goal, we need to work together.",
            "translation": "要实现这个目标，我们需要合作。",
            "source": "CET4-2019",
            "audio_url": "https://cdn.chatlingo.com/audio/accomplish_001.mp3"
          }
        ],
        "memory_tips": "ac(加强) + com(一起) + plish(完成) = 一起完成",
        "related_words": ["achieve", "complete", "fulfill"],
        "image_url": "https://cdn.chatlingo.com/images/accomplish.jpg",
        "audio_url": "https://cdn.chatlingo.com/pronunciation/accomplish.mp3",
        "user_progress": {
          "mastery_level": 3,
          "last_reviewed": "2024-08-06T10:00:00Z",
          "review_count": 5,
          "is_mastered": false,
          "next_review_date": "2024-08-08"
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 225,
      "total_items": 4500,
      "items_per_page": 20
    },
    "study_statistics": {
      "today_target": 50,
      "today_completed": 32,
      "weekly_progress": 67,
      "estimated_completion": "2024-10-15"
    }
  }
}
```

### 2.4 提交必会内容学习记录
```http
POST /essentials/progress
Authorization: Bearer {token}
Content-Type: application/json

{
  "item_id": "vocab_accomplish_001",
  "category": "cet46",
  "type": "vocabulary",
  "action": "studied", // studied, mastered, needs_review
  "time_spent": 120, // 秒
  "difficulty_rating": 3, // 1-5，用户感知难度
  "self_assessment": 4, // 1-5，自我评估掌握度
  "study_method": "flashcard", // flashcard, reading, listening
  "notes": "这个词我总是拼错最后一个字母"
}
```

### 2.5 获取必会学习统计
```http
GET /essentials/statistics?period=week
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "overall_progress": {
      "total_essentials": 6750,
      "completed_essentials": 3225,
      "completion_percentage": 48,
      "current_streak_days": 15,
      "total_study_time": 12600 // 秒
    },
    "by_category": [
      {
        "category": "cet46",
        "progress_percentage": 67,
        "details": {
          "vocabulary": { "completed": 3024, "total": 4500, "percentage": 67 },
          "passages": { "completed": 67, "total": 100, "percentage": 67 },
          "dialogues": { "completed": 134, "total": 200, "percentage": 67 }
        }
      }
    ],
    "weekly_trend": [
      { "date": "2024-08-01", "items_studied": 45, "time_minutes": 85 },
      { "date": "2024-08-02", "items_studied": 52, "time_minutes": 92 },
      { "date": "2024-08-03", "items_studied": 38, "time_minutes": 76 }
    ],
    "weak_areas": [
      {
        "area": "听力短文",
        "accuracy_rate": 65,
        "suggestion": "建议增加慢速听力练习"
      }
    ],
    "achievements": [
      {
        "badge_id": "vocab_master_100",
        "name": "词汇小王子",
        "description": "掌握100个必会词汇",
        "earned_date": "2024-08-05"
      }
    ]
  }
}
```

## 3. AI服务API (/ai)

### 3.1 AI对话 - 必会内容练习
```http
POST /ai/chat/essentials
Authorization: Bearer {token}
Content-Type: application/json

{
  "conversation_context": {
    "category": "cet46",
    "content_type": "vocabulary",
    "target_words": ["accomplish", "achieve", "complete"],
    "difficulty_level": "intermediate",
    "scenario": "academic_discussion"
  },
  "message": {
    "type": "text", // text, audio
    "content": "I want to accomplish my goals this semester",
    "audio_data": null // base64编码的音频数据
  },
  "conversation_id": "conv_12345" // 可选，继续已有对话
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "conversation_id": "conv_12345",
    "ai_response": {
      "text": "That's a great attitude! What specific goals do you want to accomplish? And have you thought about how to achieve them step by step?",
      "audio_url": "https://cdn.chatlingo.com/tts/response_12345.mp3",
      "audio_duration": 4.2
    },
    "language_feedback": {
      "grammar_check": {
        "is_correct": true,
        "score": 95,
        "corrections": []
      },
      "vocabulary_usage": {
        "used_essential_words": ["accomplish"],
        "suggested_alternatives": [
          {
            "original": "accomplish",
            "suggestion": "achieve", 
            "note": "Both are correct, 'achieve' is slightly more common in academic contexts"
          }
        ]
      },
      "fluency_score": 88,
      "pronunciation_feedback": null // 仅音频输入时提供
    },
    "learning_suggestions": [
      "Try using 'achieve' instead of 'accomplish' in formal contexts",
      "Consider adding more specific details about your goals"
    ],
    "next_prompts": [
      "What's the most important goal for you?",
      "How do you plan to measure your progress?",
      "What challenges might you face?"
    ],
    "essential_words_practiced": 1,
    "session_progress": {
      "target_words_used": 1,
      "target_words_remaining": 2,
      "conversation_score": 88
    }
  }
}
```

### 3.2 AI语音评分
```http
POST /ai/speech/score
Authorization: Bearer {token}
Content-Type: multipart/form-data

{
  "audio": [Binary audio data],
  "target_text": "To accomplish this goal, we need to work together.",
  "content_context": {
    "category": "cet46", 
    "type": "vocabulary",
    "difficulty": "intermediate"
  },
  "evaluation_criteria": ["pronunciation", "fluency", "intonation", "pace"]
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "overall_score": 87,
    "detailed_scores": {
      "pronunciation": {
        "score": 90,
        "details": [
          {
            "word": "accomplish",
            "expected": "/əˈkʌmplɪʃ/",
            "detected": "/əˈkʌmplɪʃ/",
            "accuracy": 95,
            "feedback": "Excellent pronunciation!"
          },
          {
            "word": "together", 
            "expected": "/təˈɡeðər/",
            "detected": "/təˈɡɛðər/",
            "accuracy": 82,
            "feedback": "The vowel sound in the second syllable could be improved"
          }
        ]
      },
      "fluency": {
        "score": 85,
        "speaking_rate": 145, // 每分钟单词数
        "pause_analysis": {
          "appropriate_pauses": 2,
          "inappropriate_pauses": 1,
          "total_pause_time": 1.2
        }
      },
      "intonation": {
        "score": 88,
        "feedback": "Good rising intonation for emphasis on 'together'"
      },
      "pace": {
        "score": 85,
        "feedback": "Speaking pace is appropriate, consider slight acceleration"
      }
    },
    "improvement_suggestions": [
      {
        "area": "pronunciation",
        "suggestion": "Practice the 'th' sound in 'together'",
        "exercise_recommendation": "tongue_twister_th_sounds"
      }
    ],
    "comparison": {
      "vs_native_speaker": 87,
      "vs_your_average": 92,
      "vs_peer_level": 85
    },
    "essential_content_mastery": {
      "word_pronunciation_scores": [
        { "word": "accomplish", "score": 95 },
        { "word": "goal", "score": 88 },
        { "word": "together", "score": 82 }
      ],
      "sentence_fluency": 85
    }
  }
}
```

### 3.3 AI写作批改
```http
POST /ai/writing/correct
Authorization: Bearer {token}
Content-Type: application/json

{
  "writing_content": "The chart show that more student choose to study abroad in recent years. This trend have several reason.",
  "writing_type": "chart_description", // 图表描述
  "content_context": {
    "category": "cet46",
    "target_level": "intermediate",
    "word_limit": 150
  },
  "evaluation_focus": ["grammar", "vocabulary", "structure", "coherence"]
}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "overall_score": 72,
    "corrected_text": "The chart shows that more students choose to study abroad in recent years. This trend has several reasons.",
    "detailed_corrections": [
      {
        "error_type": "grammar",
        "original": "chart show",
        "corrected": "chart shows", 
        "explanation": "主语'chart'是单数，动词应用第三人称单数形式'shows'",
        "rule": "subject_verb_agreement",
        "severity": "major"
      },
      {
        "error_type": "grammar",
        "original": "more student",
        "corrected": "more students",
        "explanation": "'more'后面应接复数名词",
        "rule": "noun_number",
        "severity": "major"
      },
      {
        "error_type": "grammar",
        "original": "trend have",
        "corrected": "trend has",
        "explanation": "主语'trend'是单数，动词应用'has'",
        "rule": "subject_verb_agreement", 
        "severity": "major"
      }
    ],
    "vocabulary_suggestions": [
      {
        "context": "chart description",
        "suggestions": [
          {
            "phrase": "The chart shows",
            "alternatives": ["The chart illustrates", "The chart demonstrates", "As shown in the chart"],
            "formality_level": "academic"
          }
        ]
      }
    ],
    "structure_feedback": {
      "score": 75,
      "strengths": ["清晰的开头", "逻辑连接词使用恰当"],
      "improvements": ["可以增加更具体的数据描述", "结论部分可以更完整"]
    },
    "essential_patterns_used": [
      {
        "pattern": "The chart shows that...",
        "category": "chart_description",
        "usage_score": 8
      }
    ],
    "recommended_templates": [
      {
        "template_id": "cet_chart_intro",
        "title": "图表作文开头必背模板",
        "content": "As is clearly shown in the chart, ...",
        "usage_context": "描述图表趋势"
      }
    ],
    "improvement_plan": {
      "focus_areas": ["主谓一致", "名词单复数"],
      "recommended_exercises": [
        "subject_verb_agreement_practice",
        "noun_forms_drill"
      ],
      "estimated_improvement_time": "2-3 weeks"
    }
  }
}
```

### 3.4 AI个性化学习建议
```http
GET /ai/recommendations?category=cet46&timeframe=week
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "personalized_plan": {
      "user_analysis": {
        "current_level": "B1+",
        "learning_style": "visual_auditory", 
        "peak_learning_hours": ["09:00-11:00", "19:00-21:00"],
        "weak_areas": ["听力对话", "写作表达"],
        "strong_areas": ["词汇记忆", "阅读理解"]
      },
      "daily_recommendations": [
        {
          "date": "2024-08-07",
          "priority_tasks": [
            {
              "task_type": "vocabulary_review",
              "content": "复习昨日学习的20个词汇",
              "estimated_time": 10,
              "ai_reason": "基于遗忘曲线，这些词汇需要及时复习"
            },
            {
              "task_type": "listening_dialogue",
              "content": "练习校园生活场景对话5组",
              "estimated_time": 15,
              "ai_reason": "您的听力对话正确率需要提升"
            },
            {
              "task_type": "ai_conversation",
              "content": "与AI进行必会话题讨论",
              "estimated_time": 20,
              "ai_reason": "提升口语表达和词汇应用能力"
            }
          ],
          "optional_tasks": [
            {
              "task_type": "passage_reading",
              "content": "阅读环保主题必背短文",
              "estimated_time": 12,
              "ai_reason": "扩展词汇量，巩固阅读技能"
            }
          ]
        }
      ],
      "weekly_focus": {
        "theme": "听力对话突破周",
        "goals": [
          "提升听力对话正确率至80%",
          "掌握50个对话场景必会表达",
          "完成10次AI对话练习"
        ],
        "success_metrics": [
          { "metric": "listening_accuracy", "target": 80, "current": 65 },
          { "metric": "dialogue_expressions", "target": 50, "current": 32 }
        ]
      }
    },
    "adaptive_suggestions": [
      {
        "trigger": "consecutive_mistakes",
        "suggestion": "检测到您在同类语法错误上反复出现问题，建议专项练习主谓一致规则",
        "recommended_action": "grammar_focused_drill",
        "priority": "high"
      },
      {
        "trigger": "learning_efficiency_drop", 
        "suggestion": "最近学习效率有所下降，建议调整学习时间至您的高效时段",
        "recommended_action": "schedule_optimization",
        "priority": "medium"
      }
    ],
    "motivation_elements": {
      "current_streak": 15,
      "next_milestone": {
        "type": "vocabulary_mastery",
        "target": 3500,
        "current": 3024,
        "remaining": 476,
        "estimated_days": 12
      },
      "peer_comparison": {
        "your_rank": "top 25%",
        "average_progress": 45,
        "your_progress": 67
      }
    }
  }
}
```

### 3.5 AI智能复习提醒
```http
GET /ai/review/schedule
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "success": true,
  "data": {
    "immediate_reviews": [
      {
        "item_id": "vocab_accomplish_001",
        "item_type": "vocabulary",
        "item_content": "accomplish",
        "last_studied": "2024-08-04T10:00:00Z",
        "mastery_level": 2,
        "forgetting_probability": 0.7,
        "urgency": "high",
        "estimated_review_time": 3,
        "review_method": "flashcard"
      }
    ],
    "scheduled_reviews": [
      {
        "scheduled_time": "2024-08-07T09:00:00Z",
        "items_count": 15,
        "total_estimated_time": 12,
        "review_types": ["vocabulary", "dialogue"],
        "ai_optimization": "安排在您的学习高效时段"
      }
    ],
    "smart_reminders": [
      {
        "reminder_time": "2024-08-07T08:45:00Z", 
        "message": "您有15个必会词汇需要复习，预计12分钟",
        "notification_type": "gentle"
      }
    ],
    "study_pattern_insights": {
      "optimal_review_interval": "2-3天",
      "best_review_time": "09:00-10:00",
      "recommended_batch_size": 20,
      "retention_rate_trend": "improving"
    }
  }
}
```

## 4. API性能优化

### 4.1 缓存策略
```javascript
// Redis缓存键设计
const cacheKeys = {
  essentials: {
    categories: 'essentials:categories',
    content: (category, type, page) => `essentials:${category}:${type}:${page}`,
    userProgress: (userId, category) => `progress:${userId}:${category}`
  },
  ai: {
    chatContext: (conversationId) => `ai:chat:${conversationId}`,
    userProfile: (userId) => `ai:profile:${userId}`,
    recommendations: (userId) => `ai:rec:${userId}`
  }
};

// 缓存TTL设置
const cacheTTL = {
  essentialCategories: 86400, // 24小时
  essentialContent: 3600,     // 1小时
  userProgress: 1800,         // 30分钟
  aiRecommendations: 7200,    // 2小时
  chatContext: 1800          // 30分钟
};
```

### 4.2 API限流策略
```javascript
// 不同功能的限流配置
const rateLimits = {
  essentials: {
    content: '100/hour',      // 内容获取
    progress: '500/hour'      // 进度提交
  },
  ai: {
    chat: '60/hour',          // AI对话
    speechScore: '30/hour',   // 语音评分
    writingCorrect: '20/hour', // 写作批改
    recommendations: '10/hour' // 个性化推荐
  }
};
```

### 4.3 数据预处理
```javascript
// 必会内容预处理服务
class EssentialsPreprocessor {
  async preprocessContent(content) {
    return {
      ...content,
      searchableText: this.generateSearchableText(content),
      difficultyScore: this.calculateDifficultyScore(content),
      relatedItems: await this.findRelatedItems(content),
      learningPath: this.generateLearningPath(content)
    };
  }
}
```

## 5. API安全增强

### 5.1 AI服务安全
```javascript
// AI请求安全验证
const aiSecurityMiddleware = async (req, res, next) => {
  // 检查用户订阅状态
  const subscription = await getUserSubscription(req.user.id);
  if (!subscription.ai_features_enabled) {
    return res.status(403).json({
      error: 'AI features require premium subscription'
    });
  }
  
  // 检查AI服务配额
  const usage = await getAIUsage(req.user.id, 'today');
  const limit = subscription.ai_daily_limit;
  if (usage >= limit) {
    return res.status(429).json({
      error: 'AI service daily limit exceeded'
    });
  }
  
  next();
};
```

### 5.2 必会内容版权保护
```javascript
// 内容访问权限验证
const essentialsAccessControl = async (req, res, next) => {
  const { category, type } = req.params;
  const userLevel = await getUserLevel(req.user.id);
  
  // 检查内容访问权限
  const accessRules = await getAccessRules(category, type);
  if (!checkAccess(userLevel, accessRules)) {
    return res.status(403).json({
      error: 'Insufficient level for this content'
    });
  }
  
  next();
};
```

---

这套增强版API设计完全支持"必会"专题学习和AI智能功能，为ChatLingo提供了强大的后端服务能力！

**文档版本**: v2.0  
**最后更新**: 2024年8月6日