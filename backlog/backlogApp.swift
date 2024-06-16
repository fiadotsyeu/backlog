//
//  backlogApp.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 03.05.2024.
//

import SwiftUI
import SwiftData

@main
struct backlogApp: App {
    let notificationManager = NotificationManager.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Tag.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if DEBUG
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    #endif
                    notificationManager.requestNotificationPermission()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
