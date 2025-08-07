//
//  EssentialHomeView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct EssentialHomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = EssentialHomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                categoriesSection
                progressSection
                recommendedSection
            }
            .padding()
        }
        .navigationTitle("必会专题")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.refreshData()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ChatLingo 2.0")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("必会专题学习系统")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("查看全部") {
                    coordinator.navigate(to: .essentialCategories)
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            Text("继续你的英语学习之旅，掌握必备知识点")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("学习分类")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(viewModel.essentialCategories) { category in
                    EssentialCategoryCard(category: category) {
                        coordinator.navigate(to: .essentialDetail(category))
                    }
                }
            }
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("学习进度")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ProgressBar(
                    title: "今日词汇",
                    current: viewModel.todayVocabularyProgress,
                    total: viewModel.todayVocabularyGoal,
                    color: .blue
                )
                
                ProgressBar(
                    title: "本周目标",
                    current: viewModel.weeklyProgress,
                    total: viewModel.weeklyGoal,
                    color: .green
                )
                
                ProgressBar(
                    title: "连续学习",
                    current: viewModel.streakDays,
                    total: 30, // 30天目标
                    color: .orange
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("AI推荐")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.blue)
            }
            
            if viewModel.recommendations.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "lightbulb")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                    
                    Text("暂无推荐内容")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 80)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.recommendations) { recommendation in
                            RecommendationCard(recommendation: recommendation)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

struct EssentialCategoryCard: View {
    let category: EssentialCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(category.categoryKey.emoji)
                        .font(.system(size: 28))
                    
                    Spacer()
                    
                    Text("\(Int(category.progressPercentage * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(category.categoryKey.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayNameCN)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(category.targetLevel)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(category.totalVocabularyCount)个词汇")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                ProgressView(value: category.progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: category.categoryKey.color))
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProgressBar: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    
    private var progress: Double {
        return total > 0 ? min(Double(current) / Double(total), 1.0) : 0.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(current)/\(total)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}

struct RecommendationCard: View {
    let recommendation: LearningRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: recommendation.type.icon)
                    .foregroundColor(recommendation.priority.color)
                
                Spacer()
                
                Text("\(recommendation.estimatedTime)分钟")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(recommendation.priority.color.opacity(0.2))
                    .foregroundColor(recommendation.priority.color)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(recommendation.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(width: 180, height: 120)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        EssentialHomeView()
    }
    .environmentObject(AppCoordinator())
}