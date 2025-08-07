//
//  EssentialCategoriesView.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI

struct EssentialCategoriesView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = EssentialHomeViewModel()
    
    var body: some View {
        List(viewModel.essentialCategories) { category in
            CategoryListRow(category: category) {
                coordinator.navigate(to: .essentialDetail(category))
            }
        }
        .navigationTitle("必会分类")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CategoryListRow: View {
    let category: EssentialCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // 分类图标
                Text(category.categoryKey.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayNameCN)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(category.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(category.targetLevel)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(category.categoryKey.color.opacity(0.2))
                            .foregroundColor(category.categoryKey.color)
                            .cornerRadius(4)
                        
                        Text(category.ageGroup)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(category.progressPercentage * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(category.categoryKey.color)
                    
                    Text("\(category.masteredVocabularyCount)/\(category.totalVocabularyCount)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    ProgressView(value: category.progressPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: category.categoryKey.color))
                        .frame(width: 60)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        EssentialCategoriesView()
    }
    .environmentObject(AppCoordinator())
}