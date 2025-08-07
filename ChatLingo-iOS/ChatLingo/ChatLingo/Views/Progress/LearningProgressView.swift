//
//  LearningProgressView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct LearningProgressView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = LearningProgressViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                overviewSection
                streakSection
                skillsSection
                achievementsSection
            }
            .padding()
        }
        .navigationTitle("学习进度")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("分析") {
                    coordinator.navigate(to: .learningAnalytics)
                }
            }
        }
        .refreshable {
            await viewModel.refreshData()
        }
    }
    
    private var overviewSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("本周概览")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(viewModel.weeklyStudyTime)分钟")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            HStack(spacing: 16) {
                ProgressCard(
                    title: "今日学习",
                    value: "\(viewModel.todayStudyTime)",
                    unit: "分钟",
                    progress: Double(viewModel.todayStudyTime) / Double(viewModel.dailyGoal),
                    color: .green,
                    icon: "clock.fill"
                )
                
                ProgressCard(
                    title: "本周目标",
                    value: "\(viewModel.weeklyProgress)",
                    unit: "%",
                    progress: Double(viewModel.weeklyProgress) / 100.0,
                    color: .blue,
                    icon: "target"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("连续学习")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(viewModel.streakDays)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("天")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    
                    Text("连续学习记录")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("再坚持 \(viewModel.nextMilestone - viewModel.streakDays) 天达成 \(viewModel.nextMilestone) 天里程碑！")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    ForEach(viewModel.recentDays, id: \.self) { day in
                        Circle()
                            .fill(day.hasStudied ? Color.orange : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("技能进展")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                SkillProgressRow(
                    skill: "词汇",
                    level: viewModel.vocabularyLevel,
                    progress: viewModel.vocabularyProgress,
                    color: .blue
                )
                
                SkillProgressRow(
                    skill: "语法",
                    level: viewModel.grammarLevel,
                    progress: viewModel.grammarProgress,
                    color: .green
                )
                
                SkillProgressRow(
                    skill: "听力",
                    level: viewModel.listeningLevel,
                    progress: viewModel.listeningProgress,
                    color: .orange
                )
                
                SkillProgressRow(
                    skill: "口语",
                    level: viewModel.speakingLevel,
                    progress: viewModel.speakingProgress,
                    color: .purple
                )
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("最近成就")
                .font(.title2)
                .fontWeight(.semibold)
            
            if viewModel.recentAchievements.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                    
                    Text("继续学习解锁成就")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 80)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    ForEach(viewModel.recentAchievements, id: \.id) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
            }
        }
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let unit: String
    let progress: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                HStack(alignment: .bottom, spacing: 2) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: min(progress, 1.0))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SkillProgressRow: View {
    let skill: String
    let level: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(skill)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(level)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .foregroundColor(color)
                    .cornerRadius(6)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Text(achievement.emoji)
                .font(.system(size: 28))
            
            Text(achievement.name)
                .font(.caption2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 80, height: 80)
        .background(achievement.color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        LearningProgressView()
    }
    .environmentObject(AppCoordinator())
}