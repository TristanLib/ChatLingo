//
//  EssentialDetailViewModel.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation

@MainActor
class EssentialDetailViewModel: ObservableObject {
    @Published var category: EssentialCategory?
    @Published var recentActivity: [LearningActivity] = []
    @Published var sampleVocabulary: [VocabularyItem] = []
    @Published var isLoading = false
    
    func loadCategory(_ category: EssentialCategory) {
        self.category = category
        loadSampleVocabulary()
        loadRecentActivity()
    }
    
    private func loadSampleVocabulary() {
        // 创建一些示例词汇数据
        sampleVocabulary = [
            VocabularyItem(
                word: "essential",
                phonetic: "/ɪˈsenʃəl/",
                partOfSpeech: "adj.",
                chineseTranslation: "必要的，重要的",
                englishDefinition: "absolutely necessary; extremely important",
                exampleSentence: "Good communication skills are essential for this job.",
                exampleTranslation: "良好的沟通技巧对这份工作是必要的。",
                difficulty: .intermediate,
                frequency: 5,
                tags: ["CET4", "business", "important"]
            ),
            VocabularyItem(
                word: "comprehensive",
                phonetic: "/ˌkɒmprɪˈhensɪv/",
                partOfSpeech: "adj.",
                chineseTranslation: "全面的，综合的",
                englishDefinition: "complete and including everything that is necessary",
                exampleSentence: "The report provides a comprehensive analysis of the market.",
                exampleTranslation: "这份报告提供了对市场的全面分析。",
                difficulty: .upperIntermediate,
                frequency: 4,
                tags: ["CET4", "academic", "analysis"]
            ),
            VocabularyItem(
                word: "implement",
                phonetic: "/ˈɪmplɪment/",
                partOfSpeech: "v.",
                chineseTranslation: "实施，执行",
                englishDefinition: "to put a decision or plan into effect",
                exampleSentence: "The company plans to implement the new policy next month.",
                exampleTranslation: "公司计划下个月实施新政策。",
                difficulty: .intermediate,
                frequency: 4,
                tags: ["CET4", "business", "action"]
            )
        ]
    }
    
    private func loadRecentActivity() {
        // 这里可以从Core Data或API加载最近的学习活动
        recentActivity = []
    }
}

struct LearningActivity: Identifiable {
    let id = UUID()
    let type: String
    let content: String
    let timestamp: Date
    let score: Double?
}