//
//  Enums.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-22.
//

import CoreData

enum Tab {
    case tasks, people, businesses, settings
}

enum EditNameSheet: Identifiable {
    case create
    case edit(NSManagedObject)

    var id: String {
        switch self {
        case .create:
            return "create"
        case .edit(let obj):
            return obj.objectID.uriRepresentation().absoluteString
        }
    }
}

enum TaskStatus: String, CaseIterable {
    case open = "Open"
    case completed = "Completed"
}

