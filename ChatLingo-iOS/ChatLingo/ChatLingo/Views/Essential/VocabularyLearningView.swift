//
//  VocabularyLearningView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct VocabularyLearningView: View {
    let vocabulary: [VocabularyItem]
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("词汇学习")
                .font(.title)
                .fontWeight(.bold)
            
            Text("共 \(vocabulary.count) 个词汇")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "book.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)
                
                Text("词汇学习功能")
                    .font(.headline)
                
                Text("这里将显示词汇卡片学习界面")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button("开始学习") {
                // TODO: 实现词汇学习逻辑
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("词汇学习")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        VocabularyLearningView(vocabulary: [])
    }
    .environmentObject(AppCoordinator())
}