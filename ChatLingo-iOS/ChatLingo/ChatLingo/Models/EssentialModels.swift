//
//  EssentialModels.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation
import SwiftUI

// MARK: - Essential Category Models

struct EssentialCategory: Identifiable, Hashable {
    let id = UUID()
    let categoryKey: EssentialCategoryType
    let name: String
    let displayNameCN: String
    let displayNameEN: String
    let description: String
    let targetLevel: String // A1-A2, B1-B2, C1-C2
    let ageGroup: String // 13-16, 18-25, etc.
    let iconName: String
    let backgroundImageName: String?
    
    // 计算属性，根据categoryKey返回对应颜色
    var difficultyColor: Color {
        return categoryKey.color
    }
    
    // Content statistics
    let totalVocabularyCount: Int
    let totalPassagesCount: Int
    let totalDialoguesCount: Int
    let totalGrammarCount: Int
    
    // Progress tracking
    var masteredVocabularyCount: Int = 0
    var completedPassagesCount: Int = 0
    var completedDialoguesCount: Int = 0
    
    var progressPercentage: Double {
        let totalItems = totalVocabularyCount + totalPassagesCount + totalDialoguesCount
        let completedItems = masteredVocabularyCount + completedPassagesCount + completedDialoguesCount
        return totalItems > 0 ? Double(completedItems) / Double(totalItems) : 0.0
    }
}

enum EssentialCategoryType: String, CaseIterable, Codable {
    case juniorHigh = "junior_high"
    case seniorHigh = "senior_high"
    case cet4 = "cet4"
    case cet6 = "cet6"
    case postgraduate = "postgraduate"
    case dailyLife = "daily_life"
    case business = "business"
    case travel = "travel"
    case academic = "academic"
    case ielts = "ielts"
    case toefl = "toefl"
    
    var displayName: String {
        switch self {
        case .juniorHigh: return "初中必会"
        case .seniorHigh: return "高中必会"
        case .cet4: return "四级必会"
        case .cet6: return "六级必会"
        case .postgraduate: return "考研必会"
        case .dailyLife: return "日常必会"
        case .business: return "商务必会"
        case .travel: return "旅行必会"
        case .academic: return "学术必会"
        case .ielts: return "雅思必会"
        case .toefl: return "托福必会"
        }
    }
    
    var emoji: String {
        switch self {
        case .juniorHigh: return "🎒"
        case .seniorHigh: return "🎓"
        case .cet4, .cet6: return "🏛️"
        case .postgraduate: return "🎯"
        case .dailyLife: return "🏠"
        case .business: return "💼"
        case .travel: return "✈️"
        case .academic: return "📚"
        case .ielts, .toefl: return "🌍"
        }
    }
    
    var color: Color {
        switch self {
        case .juniorHigh: return .green
        case .seniorHigh: return .blue
        case .cet4: return .orange
        case .cet6: return .red
        case .postgraduate: return .purple
        case .business: return .indigo
        case .dailyLife: return .cyan
        case .travel: return .mint
        case .academic: return .brown
        case .ielts, .toefl: return .teal
        }
    }
}

// MARK: - Essential Content Models

struct VocabularyItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let word: String
    let phonetic: String
    let partOfSpeech: String
    let chineseTranslation: String
    let englishDefinition: String
    let exampleSentence: String
    let exampleTranslation: String
    let difficulty: ContentDifficulty
    let frequency: Int // 词频等级 1-5
    let tags: [String]
    
    // Learning progress
    var masteryLevel: MasteryLevel = .unknown
    var lastReviewDate: Date?
    var nextReviewDate: Date?
    var reviewCount: Int = 0
    var correctAnswers: Int = 0
    
    var accuracy: Double {
        return reviewCount > 0 ? Double(correctAnswers) / Double(reviewCount) : 0.0
    }
}

struct PassageItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let chineseTranslation: String?
    let audioURL: String?
    let difficulty: ContentDifficulty
    let category: EssentialCategoryType
    let wordCount: Int
    let estimatedReadingTime: Int // minutes
    let keyVocabulary: [String]
    let comprehensionQuestions: [ComprehensionQuestion]
    
    // Learning progress
    var isCompleted: Bool = false
    var readingTime: TimeInterval?
    var comprehensionScore: Double?
    var lastAccessDate: Date?
}

struct DialogueItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let scenario: String // 场景描述
    let participants: [String] // 参与者角色
    let difficulty: ContentDifficulty
    let category: EssentialCategoryType
    let audioURL: String?
    let transcripts: [DialogueLine]
    let keyPhrases: [String]
    let culturalNotes: String?
    
    // AI practice
    var aiPracticeAvailable: Bool = true
    var practiceCount: Int = 0
    var averageScore: Double?
}

struct DialogueLine: Identifiable, Codable, Hashable {
    let id = UUID()
    let speaker: String
    let content: String
    let translation: String
    let audioURL: String?
    let startTime: TimeInterval?
    let endTime: TimeInterval?
}

struct ComprehensionQuestion: Identifiable, Codable, Hashable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

// MARK: - Learning Progress Models

enum MasteryLevel: String, CaseIterable, Codable {
    case unknown = "unknown"
    case learning = "learning"
    case familiar = "familiar"
    case mastered = "mastered"
    case expert = "expert"
    
    var displayName: String {
        switch self {
        case .unknown: return "未学习"
        case .learning: return "学习中"
        case .familiar: return "熟悉"
        case .mastered: return "掌握"
        case .expert: return "精通"
        }
    }
    
    var color: Color {
        switch self {
        case .unknown: return .gray
        case .learning: return .orange
        case .familiar: return .yellow
        case .mastered: return .green
        case .expert: return .blue
        }
    }
    
    var progress: Double {
        switch self {
        case .unknown: return 0.0
        case .learning: return 0.25
        case .familiar: return 0.5
        case .mastered: return 0.75
        case .expert: return 1.0
        }
    }
}

enum ContentDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case elementary = "elementary"
    case intermediate = "intermediate"
    case upperIntermediate = "upper_intermediate"
    case advanced = "advanced"
    
    var displayName: String {
        switch self {
        case .beginner: return "入门"
        case .elementary: return "初级"
        case .intermediate: return "中级"
        case .upperIntermediate: return "中高级"
        case .advanced: return "高级"
        }
    }
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .elementary: return .blue
        case .intermediate: return .orange
        case .upperIntermediate: return .red
        case .advanced: return .purple
        }
    }
}