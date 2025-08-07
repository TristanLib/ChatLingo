//
//  EssentialHomeViewModel.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation
import Combine

@MainActor
class EssentialHomeViewModel: ObservableObject {
    @Published var essentialCategories: [EssentialCategory] = []
    @Published var todayVocabularyProgress: Int = 0
    @Published var todayVocabularyGoal: Int = 20
    @Published var weeklyProgress: Int = 0
    @Published var weeklyGoal: Int = 100
    @Published var streakDays: Int = 0
    @Published var recommendations: [LearningRecommendation] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    func refreshData() async {
        isLoading = true
        
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        loadData()
        isLoading = false
    }
    
    private func loadData() {
        loadEssentialCategories()
        loadProgressData()
        loadRecommendations()
    }
    
    private func loadEssentialCategories() {
        essentialCategories = [
            EssentialCategory(
                categoryKey: .juniorHigh,
                name: "junior_high",
                displayNameCN: "初中必会",
                displayNameEN: "Junior High Essentials",
                description: "初中英语必备词汇和表达",
                targetLevel: "A1-A2",
                ageGroup: "13-16岁",
                iconName: "book.fill",
                backgroundImageName: "junior_bg",
                totalVocabularyCount: 1500,
                totalPassagesCount: 50,
                totalDialoguesCount: 30,
                totalGrammarCount: 100,
                masteredVocabularyCount: 450,
                completedPassagesCount: 15,
                completedDialoguesCount: 8
            ),
            EssentialCategory(
                categoryKey: .seniorHigh,
                name: "senior_high",
                displayNameCN: "高中必会",
                displayNameEN: "Senior High Essentials",
                description: "高中英语核心词汇和语法",
                targetLevel: "A2-B1",
                ageGroup: "16-18岁",
                iconName: "graduationcap.fill",
                backgroundImageName: "senior_bg",
                totalVocabularyCount: 3500,
                totalPassagesCount: 100,
                totalDialoguesCount: 50,
                totalGrammarCount: 150,
                masteredVocabularyCount: 1200,
                completedPassagesCount: 30,
                completedDialoguesCount: 15
            ),
            EssentialCategory(
                categoryKey: .cet4,
                name: "cet4",
                displayNameCN: "四级必会",
                displayNameEN: "CET-4 Essentials",
                description: "大学英语四级必备内容",
                targetLevel: "B1",
                ageGroup: "18-25岁",
                iconName: "building.columns.fill",
                backgroundImageName: "cet4_bg",
                totalVocabularyCount: 4500,
                totalPassagesCount: 100,
                totalDialoguesCount: 200,
                totalGrammarCount: 120,
                masteredVocabularyCount: 2800,
                completedPassagesCount: 65,
                completedDialoguesCount: 120
            ),
            EssentialCategory(
                categoryKey: .business,
                name: "business",
                displayNameCN: "商务必会",
                displayNameEN: "Business Essentials",
                description: "职场商务英语必备",
                targetLevel: "B1-B2",
                ageGroup: "25-40岁",
                iconName: "briefcase.fill",
                backgroundImageName: "business_bg",
                totalVocabularyCount: 2500,
                totalPassagesCount: 80,
                totalDialoguesCount: 60,
                totalGrammarCount: 80,
                masteredVocabularyCount: 800,
                completedPassagesCount: 25,
                completedDialoguesCount: 20
            )
        ]
    }
    
    private func loadProgressData() {
        // 模拟真实的学习进度数据
        todayVocabularyProgress = Int.random(in: 8...18)
        todayVocabularyGoal = 20
        weeklyProgress = Int.random(in: 60...95)
        weeklyGoal = 100
        streakDays = Int.random(in: 5...25)
    }
    
    private func loadRecommendations() {
        recommendations = [
            LearningRecommendation(
                type: .vocabulary,
                title: "复习四级高频词汇",
                description: "根据你的学习进度，建议复习这些重要词汇",
                priority: .high,
                estimatedTime: 15,
                relatedContent: RecommendedContent(
                    contentId: "cet4_vocab_set_1",
                    contentType: "vocabulary",
                    metadata: ["category": "cet4", "difficulty": "intermediate"]
                ),
                reason: "你在四级词汇的掌握度为62%，需要加强练习",
                createdAt: Date(),
                expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Date())
            ),
            LearningRecommendation(
                type: .speaking,
                title: "AI对话练习",
                description: "与AI老师练习日常英语对话",
                priority: .medium,
                estimatedTime: 20,
                relatedContent: RecommendedContent(
                    contentId: "daily_conversation_1",
                    contentType: "dialogue",
                    metadata: ["scenario": "daily_life", "role": "teacher"]
                ),
                reason: "你的口语练习时间较少，建议增加对话练习",
                createdAt: Date(),
                expiresAt: Calendar.current.date(byAdding: .day, value: 2, to: Date())
            ),
            LearningRecommendation(
                type: .review,
                title: "复习昨日词汇",
                description: "巩固昨天学习的词汇",
                priority: .medium,
                estimatedTime: 10,
                relatedContent: RecommendedContent(
                    contentId: "yesterday_vocabulary",
                    contentType: "vocabulary",
                    metadata: ["date": "yesterday", "count": "15"]
                ),
                reason: "复习是巩固记忆的关键",
                createdAt: Date(),
                expiresAt: Calendar.current.date(byAdding: .hour, value: 12, to: Date())
            )
        ]
    }
    
    func updateVocabularyProgress(_ newProgress: Int) {
        todayVocabularyProgress = min(newProgress, todayVocabularyGoal)
        
        // 更新周进度
        if newProgress > todayVocabularyProgress {
            weeklyProgress = min(weeklyProgress + (newProgress - todayVocabularyProgress), weeklyGoal)
        }
    }
    
    func getCategoryProgress(for categoryType: EssentialCategoryType) -> Double {
        guard let category = essentialCategories.first(where: { $0.categoryKey == categoryType }) else {
            return 0.0
        }
        return category.progressPercentage
    }
}