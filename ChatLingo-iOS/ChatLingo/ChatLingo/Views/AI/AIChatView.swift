//
//  AIChatView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct AIChatView: View {
    let role: AIRole?
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = AIChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 聊天头部信息
            chatHeaderView
            
            Divider()
            
            // 聊天消息列表
            chatMessagesView
            
            // 输入区域
            chatInputView
        }
        .navigationTitle(role?.displayName ?? "AI助手")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let role = role {
                viewModel.setAIRole(role)
            }
        }
    }
    
    private var chatHeaderView: some View {
        HStack(spacing: 12) {
            Image(systemName: role?.icon ?? "brain.head.profile")
                .font(.system(size: 24))
                .foregroundColor(role?.color ?? .blue)
                .frame(width: 40, height: 40)
                .background(role?.color.opacity(0.2) ?? Color.blue.opacity(0.2))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(role?.displayName ?? "AI助手")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(role?.description ?? "智能英语学习助手")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("设置") {
                // TODO: 打开聊天设置
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private var chatMessagesView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.messages.isEmpty {
                    // 空状态显示
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "message.badge.filled.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 8) {
                            Text("开始与AI对话")
                                .font(.headline)
                            
                            Text("发送消息开始你的英语学习之旅")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                    }
                }
            }
            .padding()
        }
    }
    
    private var chatInputView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                Button(action: {
                    // TODO: 语音输入
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                TextField("输入英语消息...", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("发送") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.isUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(DateFormatter.timeFormatter.string(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    NavigationView {
        AIChatView(role: .teacher)
    }
    .environmentObject(AppCoordinator())
}