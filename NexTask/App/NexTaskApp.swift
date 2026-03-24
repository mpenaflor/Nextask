//
//  NexTaskApp.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-19.
//

import SwiftUI
import CoreData
import FirebaseCore

@main
struct NexTaskApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var dataManager: DataManager
    
    init() {
        let context = persistenceController.container.viewContext
        _dataManager = StateObject(wrappedValue: DataManager(context: context))
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: dataManager)
                .environmentObject(authViewModel)
        }
    }
}
