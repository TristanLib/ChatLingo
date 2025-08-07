//
//  AIFeaturesView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct AIFeaturesView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = AIFeaturesViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                aiRolesSection
                featuresSection
                quickActionsSection
            }
            .padding()
        }
        .navigationTitle("AI助手")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI智能助手")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("GPT-4驱动的个性化英语学习伙伴")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
            }
            
            HStack(spacing: 16) {
                StatBadge(
                    icon: "message.badge.filled.fill",
                    title: "今日对话",
                    value: "\(viewModel.todayConversations)",
                    color: .green
                )
                
                StatBadge(
                    icon: "mic.badge.plus",
                    title: "语音评分",
                    value: "\(Int(viewModel.averageScore))分",
                    color: .orange
                )
                
                StatBadge(
                    icon: "lightbulb.led",
                    title: "AI建议",
                    value: "\(viewModel.recommendations)",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var aiRolesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("选择AI角色")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(AIRole.allCases, id: \.self) { role in
                    AIRoleCard(role: role) {
                        coordinator.navigate(to: .aiChat(role))
                    }
                }
            }
        }
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI功能")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                FeatureRow(
                    icon: "message.badge.filled.fill",
                    title: "智能对话",
                    subtitle: "与AI进行自然英语对话，实时纠错和指导",
                    color: .green,
                    isNew: false
                ) {
                    coordinator.navigate(to: .aiChat(nil))
                }
                
                FeatureRow(
                    icon: "mic.badge.plus",
                    title: "语音评分",
                    subtitle: "专业的发音评测，多维度分析语音质量",
                    color: .orange,
                    isNew: false
                ) {
                    coordinator.navigate(to: .voicePractice)
                }
                
                FeatureRow(
                    icon: "lightbulb.led",
                    title: "学习建议",
                    subtitle: "基于学习数据的个性化推荐和改进建议",
                    color: .purple,
                    isNew: true
                ) {
                    // TODO: 导航到学习建议页面
                }
                
                FeatureRow(
                    icon: "chart.bar.doc.horizontal",
                    title: "智能分析",
                    subtitle: "深度分析学习行为，生成专业学习报告",
                    color: .blue,
                    isNew: true
                ) {
                    coordinator.navigate(to: .learningAnalytics)
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("快速开始")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                QuickActionButton(
                    icon: "play.fill",
                    title: "开始AI对话",
                    subtitle: "立即与AI助手练习英语",
                    color: .green
                ) {
                    coordinator.navigate(to: .aiChat(.friend))
                }
                
                QuickActionButton(
                    icon: "waveform",
                    title: "语音练习",
                    subtitle: "录制语音获取发音反馈",
                    color: .orange
                ) {
                    coordinator.navigate(to: .voicePractice)
                }
            }
        }
    }
}

struct StatBadge: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct AIRoleCard: View {
    let role: AIRole
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: role.icon)
                    .font(.system(size: 28))
                    .foregroundColor(role.color)
                
                VStack(spacing: 4) {
                    Text(role.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(role.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let isNew: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if isNew {
                            Text("NEW")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(color)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(color)
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
        AIFeaturesView()
    }
    .environmentObject(AppCoordinator())
}