//
//  SettingsViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Combine

class SettingsViewModel: ObservableObject {
    let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}
