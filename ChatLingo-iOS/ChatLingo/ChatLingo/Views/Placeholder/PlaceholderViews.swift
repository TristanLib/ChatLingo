//
//  PlaceholderViews.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

// MARK: - 占位符视图，用于导航系统

struct VoicePracticeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mic.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.orange)
            
            Text("语音练习")
                .font(.title)
                .fontWeight(.bold)
            
            Text("这里将实现语音识别和发音评分功能")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("开始录音") {
                // TODO: 实现录音功能
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("语音练习")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LearningAnalyticsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("学习分析")
                .font(.title)
                .fontWeight(.bold)
            
            Text("这里将显示详细的学习数据分析和AI生成的学习报告")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                AnalyticsCard(title: "本周学习时长", value: "125分钟", trend: "+15%")
                AnalyticsCard(title: "词汇掌握率", value: "78%", trend: "+8%")
                AnalyticsCard(title: "AI对话评分", value: "8.6", trend: "+0.5")
            }
        }
        .padding()
        .navigationTitle("学习分析")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let trend: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Text(trend)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .cornerRadius(6)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SettingsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var notificationsEnabled = true
    @State private var voiceFeedback = true
    @State private var dailyGoal = 30
    
    var body: some View {
        Form {
            Section("通知设置") {
                Toggle("学习提醒", isOn: $notificationsEnabled)
                Toggle("语音反馈", isOn: $voiceFeedback)
            }
            
            Section("学习目标") {
                Stepper("每日目标：\(dailyGoal)分钟", value: $dailyGoal, in: 10...120, step: 10)
            }
            
            Section("其他") {
                NavigationLink("数据与隐私") {
                    Text("数据与隐私设置")
                }
                
                NavigationLink("清除缓存") {
                    Text("缓存管理")
                }
            }
            
            Section {
                Button("退出登录") {
                    // TODO: 实现退出登录
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileDetailView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var userName = "ChatLingo用户"
    @State private var email = "user@example.com"
    @State private var learningGoal = "提升口语能力"
    
    var body: some View {
        Form {
            Section("基本信息") {
                TextField("用户名", text: $userName)
                TextField("邮箱", text: $email)
                    .keyboardType(.emailAddress)
            }
            
            Section("学习偏好") {
                TextField("学习目标", text: $learningGoal)
                
                Picker("学习时间偏好", selection: .constant("晚上")) {
                    Text("早上").tag("早上")
                    Text("中午").tag("中午")
                    Text("晚上").tag("晚上")
                }
            }
            
            Section("账户") {
                Button("保存更改") {
                    // TODO: 保存用户信息
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("个人信息")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("语音练习") {
    NavigationView {
        VoicePracticeView()
    }
    .environmentObject(AppCoordinator())
}

#Preview("学习分析") {
    NavigationView {
        LearningAnalyticsView()
    }
    .environmentObject(AppCoordinator())
}

#Preview("设置") {
    NavigationView {
        SettingsView()
    }
    .environmentObject(AppCoordinator())
}