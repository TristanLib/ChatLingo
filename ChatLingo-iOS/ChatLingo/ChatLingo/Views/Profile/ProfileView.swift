//
//  ProfileView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileHeaderSection
                statsSection
                menuSection
            }
            .padding()
        }
        .navigationTitle("我的")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // 头像
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(viewModel.userName.prefix(1)).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text(viewModel.userName)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("学习等级：\(viewModel.currentLevel)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // 经验值进度条
                VStack(spacing: 4) {
                    HStack {
                        Text("经验值")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(viewModel.currentExp)/\(viewModel.nextLevelExp)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: Double(viewModel.currentExp) / Double(viewModel.nextLevelExp))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("学习统计")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "总学习时长",
                    value: viewModel.totalStudyHours,
                    unit: "小时",
                    icon: "clock.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "掌握词汇",
                    value: viewModel.masteredWords,
                    unit: "个",
                    icon: "book.fill",
                    color: .green
                )
                
                StatCard(
                    title: "AI对话",
                    value: viewModel.aiConversations,
                    unit: "次",
                    icon: "message.badge.filled.fill",
                    color: .purple
                )
            }
        }
    }
    
    private var menuSection: some View {
        VStack(spacing: 12) {
            MenuRow(
                icon: "person.crop.circle",
                title: "个人信息",
                subtitle: "编辑个人资料和学习偏好",
                color: .blue
            ) {
                coordinator.navigate(to: .profile)
            }
            
            MenuRow(
                icon: "chart.bar.doc.horizontal",
                title: "学习报告",
                subtitle: "详细的学习数据分析",
                color: .green
            ) {
                coordinator.navigate(to: .learningAnalytics)
            }
            
            MenuRow(
                icon: "gear",
                title: "设置",
                subtitle: "应用设置和偏好配置",
                color: .gray
            ) {
                coordinator.navigate(to: .settings)
            }
            
            MenuRow(
                icon: "questionmark.circle",
                title: "帮助与反馈",
                subtitle: "使用帮助和意见反馈",
                color: .orange
            ) {
                // TODO: 导航到帮助页面
            }
            
            MenuRow(
                icon: "info.circle",
                title: "关于ChatLingo",
                subtitle: "应用信息和版本说明",
                color: .indigo
            ) {
                // TODO: 导航到关于页面
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: Int
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MenuRow: View {
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
                        .lineLimit(1)
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

#Preview {
    NavigationView {
        ProfileView()
    }
    .environmentObject(AppCoordinator())
}