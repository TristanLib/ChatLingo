//
//  LearningProgressViewModel.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation
import SwiftUI

@MainActor
class LearningProgressViewModel: ObservableObject {
    @Published var todayStudyTime: Int = 0
    @Published var weeklyStudyTime: Int = 0
    @Published var dailyGoal: Int = 30 // 30分钟目标
    @Published var weeklyProgress: Int = 0
    @Published var streakDays: Int = 0
    @Published var nextMilestone: Int = 30
    @Published var recentDays: [DayRecord] = []
    
    // 技能进展
    @Published var vocabularyLevel: String = ""
    @Published var vocabularyProgress: Double = 0.0
    @Published var grammarLevel: String = ""
    @Published var grammarProgress: Double = 0.0
    @Published var listeningLevel: String = ""
    @Published var listeningProgress: Double = 0.0
    @Published var speakingLevel: String = ""
    @Published var speakingProgress: Double = 0.0
    
    @Published var recentAchievements: [Achievement] = []
    @Published var isLoading = false
    
    init() {
        loadProgressData()
    }
    
    func refreshData() async {
        isLoading = true
        
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        loadProgressData()
        isLoading = false
    }
    
    private func loadProgressData() {
        loadStudyTime()
        loadStreakData()
        loadSkillProgress()
        loadAchievements()
    }
    
    private func loadStudyTime() {
        todayStudyTime = Int.random(in: 15...35)
        weeklyStudyTime = Int.random(in: 150...280)
        weeklyProgress = Int.random(in: 65...95)
    }
    
    private func loadStreakData() {
        streakDays = Int.random(in: 5...45)
        
        // 计算下一个里程碑
        let milestones = [7, 14, 30, 60, 100, 365]
        nextMilestone = milestones.first { $0 > streakDays } ?? 365
        
        // 生成最近7天的学习记录
        recentDays = (0..<7).map { dayOffset in
            DayRecord(
                date: Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date(),
                hasStudied: dayOffset < streakDays && Bool.random()
            )
        }.reversed()
    }
    
    private func loadSkillProgress() {
        vocabularyLevel = "中级"
        vocabularyProgress = 0.65
        
        grammarLevel = "初级"
        grammarProgress = 0.45
        
        listeningLevel = "中级"
        listeningProgress = 0.58
        
        speakingLevel = "初级"
        speakingProgress = 0.38
    }
    
    private func loadAchievements() {
        let allAchievements = [
            Achievement(
                id: UUID(),
                name: "首次对话",
                description: "完成第一次AI对话",
                emoji: "🎯",
                color: .blue,
                unlockedDate: Date()
            ),
            Achievement(
                id: UUID(),
                name: "词汇达人",
                description: "学习100个新词汇",
                emoji: "📚",
                color: .green,
                unlockedDate: Date()
            ),
            Achievement(
                id: UUID(),
                name: "连续学习",
                description: "连续学习7天",
                emoji: "🔥",
                color: .orange,
                unlockedDate: Date()
            ),
            Achievement(
                id: UUID(),
                name: "语音练习",
                description: "完成10次语音评分",
                emoji: "🎙️",
                color: .purple,
                unlockedDate: Date()
            ),
            Achievement(
                id: UUID(),
                name: "早起鸟",
                description: "早上8点前完成学习",
                emoji: "🌅",
                color: .yellow,
                unlockedDate: Date()
            )
        ]
        
        // 随机选择一些已解锁的成就
        recentAchievements = Array(allAchievements.shuffled().prefix(Int.random(in: 2...4)))
    }
}

struct DayRecord: Hashable {
    let date: Date
    let hasStudied: Bool
}

struct Achievement: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let emoji: String
    let color: Color
    let unlockedDate: Date
}