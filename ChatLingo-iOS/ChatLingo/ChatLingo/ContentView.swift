//
//  ContentView.swift
//  ChatLingo
//
//  Created by TristanLee on 2025/8/6.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.path) {
                EssentialHomeView()
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
            .tabItem {
                Image(systemName: TabType.essential.icon)
                Text(TabType.essential.title)
            }
            .tag(TabType.essential)
            
            NavigationStack(path: $coordinator.path) {
                AIFeaturesView()
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
            .tabItem {
                Image(systemName: TabType.ai.icon)
                Text(TabType.ai.title)
            }
            .tag(TabType.ai)
            
            NavigationStack(path: $coordinator.path) {
                LearningProgressView()
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
            .tabItem {
                Image(systemName: TabType.progress.icon)
                Text(TabType.progress.title)
            }
            .tag(TabType.progress)
            
            NavigationStack(path: $coordinator.path) {
                ProfileView()
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
            .tabItem {
                Image(systemName: TabType.profile.icon)
                Text(TabType.profile.title)
            }
            .tag(TabType.profile)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AppCoordinator())
}
