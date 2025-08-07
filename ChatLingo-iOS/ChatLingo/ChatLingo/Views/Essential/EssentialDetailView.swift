//
//  EssentialDetailView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct EssentialDetailView: View {
    let category: EssentialCategory
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = EssentialDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                statsSection
                contentTypesSection
                recentActivitySection
            }
            .padding()
        }
        .navigationTitle(category.displayNameCN)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadCategory(category)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text(category.categoryKey.emoji)
                    .font(.system(size: 48))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayNameCN)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(category.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Label(category.targetLevel, systemImage: "target")
                        Label(category.ageGroup, systemImage: "person.2")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // 总体进度
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("总体进度")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(category.progressPercentage * 100))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(category.categoryKey.color)
                }
                
                ProgressView(value: category.progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: category.categoryKey.color))
                    .scaleEffect(y: 2)
            }
        }
        .padding()
        .background(category.categoryKey.color.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            EssentialStatCard(
                title: "词汇",
                current: category.masteredVocabularyCount,
                total: category.totalVocabularyCount,
                icon: "book.fill",
                color: .blue
            )
            
            EssentialStatCard(
                title: "短文",
                current: category.completedPassagesCount,
                total: category.totalPassagesCount,
                icon: "doc.text.fill",
                color: .green
            )
            
            EssentialStatCard(
                title: "对话",
                current: category.completedDialoguesCount,
                total: category.totalDialoguesCount,
                icon: "bubble.left.and.bubble.right.fill",
                color: .orange
            )
        }
    }
    
    private var contentTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("学习内容")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ContentTypeRow(
                    icon: "book.fill",
                    title: "必背词汇",
                    subtitle: "高频核心词汇，配例句和记忆技巧",
                    progress: Double(category.masteredVocabularyCount) / Double(category.totalVocabularyCount),
                    color: .blue
                ) {
                    coordinator.navigate(to: .vocabularyLearning(viewModel.sampleVocabulary))
                }
                
                ContentTypeRow(
                    icon: "doc.text.fill",
                    title: "必背短文",
                    subtitle: "精选阅读材料，提升理解能力",
                    progress: Double(category.completedPassagesCount) / Double(category.totalPassagesCount),
                    color: .green
                ) {
                    // TODO: 导航到短文学习
                }
                
                ContentTypeRow(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "必背对话",
                    subtitle: "真实场景对话，AI角色扮演",
                    progress: Double(category.completedDialoguesCount) / Double(category.totalDialoguesCount),
                    color: .orange
                ) {
                    coordinator.navigate(to: .aiChat(.teacher))
                }
                
                ContentTypeRow(
                    icon: "textformat.abc",
                    title: "必会语法",
                    subtitle: "核心语法点，系统学习",
                    progress: 0.6, // 示例进度
                    color: .purple
                ) {
                    // TODO: 导航到语法学习
                }
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("最近学习")
                .font(.title2)
                .fontWeight(.semibold)
            
            if viewModel.recentActivity.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                    
                    Text("还没有学习记录")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("开始学习来查看进度")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(height: 100)
            } else {
                // TODO: 显示最近的学习活动
                Text("最近学习活动列表")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct EssentialStatCard: View {
    let title: String
    let current: Int
    let total: Int
    let icon: String
    let color: Color
    
    private var percentage: Double {
        return total > 0 ? Double(current) / Double(total) : 0.0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(current)/\(total)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(Int(percentage * 100))%")
                    .font(.caption2)
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ContentTypeRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let progress: Double
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: color))
                }
                
                VStack {
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        EssentialDetailView(category: EssentialCategory(
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
        ))
    }
    .environmentObject(AppCoordinator())
}