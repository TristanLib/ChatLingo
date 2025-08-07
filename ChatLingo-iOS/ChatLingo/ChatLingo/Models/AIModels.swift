//
//  AIModels.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation
import SwiftUI

// MARK: - AI Chat Models

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    let messageType: ChatMessageType
    
    // AI specific properties
    var aiRole: AIRole?
    var relatedVocabulary: [String]?
    var grammarCorrections: [GrammarCorrection]?
    var pronunciationFeedback: PronunciationFeedback?
}

enum ChatMessageType: String, CaseIterable, Codable {
    case text = "text"
    case audio = "audio"
    case correction = "correction"
    case vocabulary = "vocabulary"
    case grammar = "grammar"
    case system = "system"
}

enum AIRole: String, CaseIterable, Codable {
    case teacher = "teacher"
    case friend = "friend"
    case interviewer = "interviewer"
    case colleague = "colleague"
    case customer = "customer"
    case tourist = "tourist"
    
    var displayName: String {
        switch self {
        case .teacher: return "老师"
        case .friend: return "朋友"
        case .interviewer: return "面试官"
        case .colleague: return "同事"
        case .customer: return "客户"
        case .tourist: return "游客"
        }
    }
    
    var description: String {
        switch self {
        case .teacher: return "耐心教学，纠正错误"
        case .friend: return "轻松聊天，日常对话"
        case .interviewer: return "模拟面试，职场英语"
        case .colleague: return "工作交流，商务沟通"
        case .customer: return "客服场景，服务对话"
        case .tourist: return "旅行场景，实用英语"
        }
    }
    
    var icon: String {
        switch self {
        case .teacher: return "person.crop.circle.badge.checkmark"
        case .friend: return "person.2.fill"
        case .interviewer: return "person.crop.circle.badge.plus"
        case .colleague: return "briefcase.fill"
        case .customer: return "person.crop.circle.badge.questionmark"
        case .tourist: return "airplane"
        }
    }
    
    var color: Color {
        switch self {
        case .teacher: return .blue
        case .friend: return .green
        case .interviewer: return .purple
        case .colleague: return .indigo
        case .customer: return .orange
        case .tourist: return .cyan
        }
    }
}

// MARK: - AI Feedback Models

struct GrammarCorrection: Identifiable, Codable {
    let id = UUID()
    let originalText: String
    let correctedText: String
    let errorType: GrammarErrorType
    let explanation: String
    let suggestion: String
    let confidence: Double // 0.0 - 1.0
}

enum GrammarErrorType: String, CaseIterable, Codable {
    case tense = "tense"
    case subjectVerb = "subject_verb"
    case articleUsage = "article_usage"
    case preposition = "preposition"
    case wordOrder = "word_order"
    case vocabulary = "vocabulary"
    case punctuation = "punctuation"
    
    var displayName: String {
        switch self {
        case .tense: return "时态错误"
        case .subjectVerb: return "主谓一致"
        case .articleUsage: return "冠词使用"
        case .preposition: return "介词错误"
        case .wordOrder: return "语序错误"
        case .vocabulary: return "词汇选择"
        case .punctuation: return "标点符号"
        }
    }
}

struct PronunciationFeedback: Identifiable, Codable {
    let id = UUID()
    let overallScore: Double // 0.0 - 100.0
    let fluencyScore: Double
    let accuracyScore: Double
    let completenessScore: Double
    let prosodyScore: Double
    
    let wordLevelScores: [WordPronunciationScore]
    let suggestions: [PronunciationSuggestion]
    let audioURL: String? // 用户录音文件URL
}

struct WordPronunciationScore: Identifiable, Codable {
    let id = UUID()
    let word: String
    let accuracyScore: Double
    let phonemes: [PhonemeScore]
    let isCorrect: Bool
}

struct PhonemeScore: Identifiable, Codable {
    let id = UUID()
    let phoneme: String
    let accuracy: Double
    let feedback: String?
}

struct PronunciationSuggestion: Identifiable, Codable {
    let id = UUID()
    let type: PronunciationIssueType
    let description: String
    let practiceAdvice: String
}

enum PronunciationIssueType: String, CaseIterable, Codable {
    case vowelSound = "vowel_sound"
    case consonantSound = "consonant_sound"
    case stressPattern = "stress_pattern"
    case intonation = "intonation"
    case rhythm = "rhythm"
    case linking = "linking"
    
    var displayName: String {
        switch self {
        case .vowelSound: return "元音发音"
        case .consonantSound: return "辅音发音"
        case .stressPattern: return "重音模式"
        case .intonation: return "语调"
        case .rhythm: return "节奏"
        case .linking: return "连读"
        }
    }
}

// MARK: - AI Recommendation Models

struct LearningRecommendation: Identifiable, Codable {
    let id = UUID()
    let type: RecommendationType
    let title: String
    let description: String
    let priority: RecommendationPriority
    let estimatedTime: Int // minutes
    let relatedContent: RecommendedContent
    let reason: String
    let createdAt: Date
    let expiresAt: Date?
}

enum RecommendationType: String, CaseIterable, Codable {
    case vocabulary = "vocabulary"
    case grammar = "grammar"
    case listening = "listening"
    case speaking = "speaking"
    case reading = "reading"
    case writing = "writing"
    case review = "review"
    
    var displayName: String {
        switch self {
        case .vocabulary: return "词汇学习"
        case .grammar: return "语法练习"
        case .listening: return "听力训练"
        case .speaking: return "口语练习"
        case .reading: return "阅读理解"
        case .writing: return "写作练习"
        case .review: return "复习巩固"
        }
    }
    
    var icon: String {
        switch self {
        case .vocabulary: return "book.fill"
        case .grammar: return "textformat.abc"
        case .listening: return "ear.fill"
        case .speaking: return "mic.fill"
        case .reading: return "doc.text.fill"
        case .writing: return "pencil"
        case .review: return "arrow.clockwise"
        }
    }
}

enum RecommendationPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
    
    var displayName: String {
        switch self {
        case .low: return "低优先级"
        case .medium: return "中等优先级"
        case .high: return "高优先级"
        case .urgent: return "紧急"
        }
    }
}

struct RecommendedContent: Codable {
    let contentId: String
    let contentType: String // "vocabulary", "passage", "dialogue"
    let metadata: [String: String]
}

// MARK: - Learning Analytics Models

struct LearningAnalytics: Codable {
    let userId: String
    let timeFrame: AnalyticsTimeFrame
    let generatedAt: Date
    
    // Overall metrics
    let totalStudyTime: TimeInterval
    let averageSessionLength: TimeInterval
    let streakDays: Int
    let completionRate: Double
    
    // Skills breakdown
    let vocabularyProgress: SkillProgress
    let grammarProgress: SkillProgress
    let listeningProgress: SkillProgress
    let speakingProgress: SkillProgress
    let readingProgress: SkillProgress
}

struct SkillProgress: Codable {
    let currentLevel: ContentDifficulty
    let masteredItems: Int
    let totalItems: Int
    let averageScore: Double
    let recentImprovement: Double // percentage change
    
    var completionPercentage: Double {
        return totalItems > 0 ? Double(masteredItems) / Double(totalItems) : 0.0
    }
}

enum AnalyticsTimeFrame: String, CaseIterable, Codable {
    case week = "week"
    case month = "month"
    case quarter = "quarter"
    case year = "year"
    
    var displayName: String {
        switch self {
        case .week: return "本周"
        case .month: return "本月"
        case .quarter: return "本季度"
        case .year: return "本年"
        }
    }
}

enum ProgressTrend: String, CaseIterable, Codable {
    case improving = "improving"
    case stable = "stable"
    case declining = "declining"
    
    var displayName: String {
        switch self {
        case .improving: return "进步中"
        case .stable: return "稳定"
        case .declining: return "需要加强"
        }
    }
    
    var color: Color {
        switch self {
        case .improving: return .green
        case .stable: return .blue
        case .declining: return .red
        }
    }
}