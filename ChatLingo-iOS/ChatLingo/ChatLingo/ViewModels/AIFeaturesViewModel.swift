//
//  AIFeaturesViewModel.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import Foundation

@MainActor
class AIFeaturesViewModel: ObservableObject {
    @Published var todayConversations: Int = 0
    @Published var averageScore: Double = 0.0
    @Published var recommendations: Int = 0
    @Published var isLoading = false
    
    init() {
        loadAIStats()
    }
    
    private func loadAIStats() {
        // 模拟AI统计数据
        todayConversations = Int.random(in: 3...8)
        averageScore = Double.random(in: 75...95)
        recommendations = Int.random(in: 2...5)
    }
    
    func refreshStats() async {
        isLoading = true
        
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        loadAIStats()
        isLoading = false
    }
}