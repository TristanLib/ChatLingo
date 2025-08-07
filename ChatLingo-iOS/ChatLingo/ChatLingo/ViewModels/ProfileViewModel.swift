//
//  ProfileViewModel.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userName: String = "ChatLingo用户"
    @Published var currentLevel: String = "中级学习者"
    @Published var currentExp: Int = 750
    @Published var nextLevelExp: Int = 1000
    @Published var totalStudyHours: Int = 0
    @Published var masteredWords: Int = 0
    @Published var aiConversations: Int = 0
    @Published var isLoading = false
    
    init() {
        loadUserData()
        loadStats()
    }
    
    private func loadUserData() {
        // 这里可以从UserDefaults、Keychain或服务器加载用户数据
        userName = "学习者" // 默认用户名
        currentLevel = "中级学习者 (B1)"
        currentExp = Int.random(in: 600...950)
        nextLevelExp = 1000
    }
    
    private func loadStats() {
        // 模拟统计数据
        totalStudyHours = Int.random(in: 25...80)
        masteredWords = Int.random(in: 800...2500)
        aiConversations = Int.random(in: 15...60)
    }
    
    func refreshUserData() async {
        isLoading = true
        
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        loadUserData()
        loadStats()
        isLoading = false
    }
    
    func updateUserName(_ newName: String) {
        userName = newName.isEmpty ? "ChatLingo用户" : newName
        // TODO: 保存到持久化存储
    }
    
    var levelProgress: Double {
        return Double(currentExp) / Double(nextLevelExp)
    }
}