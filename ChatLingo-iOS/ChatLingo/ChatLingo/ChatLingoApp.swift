//
//  ChatLingoApp.swift
//  ChatLingo
//
//  Created by TristanLee on 2025/8/6.
//

import SwiftUI

@main
struct ChatLingoApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appCoordinator)
        }
    }
}
