//
//  AppCoordinator.swift
//  ChatLingo
//
//  Created by ChatLingo Team on 2025/8/6.
//

import SwiftUI
import Foundation

class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: TabType = .essential
    
    func navigate(to destination: NavigationDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func navigateToRoot() {
        path = NavigationPath()
    }
    
    func selectTab(_ tab: TabType) {
        selectedTab = tab
        // 切换标签时清空导航栈
        navigateToRoot()
    }
    
    @ViewBuilder
    func view(for destination: NavigationDestination) -> some View {
        switch destination {
        case .essentialCategories:
            EssentialCategoriesView()
        case .essentialDetail(let category):
            EssentialDetailView(category: category)
        case .vocabularyLearning(let vocabulary):
            VocabularyLearningView(vocabulary: vocabulary)
        case .aiChat(let role):
            AIChatView(role: role)
        case .voicePractice:
            VoicePracticeView()
        case .learningAnalytics:
            LearningAnalyticsView()
        case .settings:
            SettingsView()
        case .profile:
            ProfileDetailView()
        }
    }
}

enum TabType: CaseIterable {
    case essential, ai, progress, profile
    
    var title: String {
        switch self {
        case .essential: return "必会"
        case .ai: return "AI助手"
        case .progress: return "进度"
        case .profile: return "我的"
        }
    }
    
    var icon: String {
        switch self {
        case .essential: return "book.fill"
        case .ai: return "brain.head.profile"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        }
    }
}

enum NavigationDestination: Hashable {
    case essentialCategories
    case essentialDetail(EssentialCategory)
    case vocabularyLearning([VocabularyItem])
    case aiChat(AIRole?)
    case voicePractice
    case learningAnalytics
    case settings
    case profile
}