//
//  DataManager.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Combine
import CoreData

class DataManager: ObservableObject {
    
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Save error:", error)
        }
    }
    
    func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)

        do {
            try context.save()
        } catch {
            print("Delete error:", error)
        }
    }
    
    func delete<T: NSManagedObject>(_ objects: [T], at offsets: IndexSet? = nil) {
        if let offsets = offsets, !offsets.isEmpty {
            offsets.map { objects[$0] }.forEach(context.delete)
        } else {
            objects.forEach { context.delete($0) }
        }

        do {
            try context.save()
        } catch {
            print("Delete error:", error)
        }
    }
    
    func fetch<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error:", error)
            return []
        }
    }
    
    func save() async throws {
        let context = self.context

        try await context.perform {
            if context.hasChanges {
                try context.save()
            }
        }
    }
}

extension DataManager {
    static var preview: DataManager {
        DataManager(
            context: PersistenceController.preview.container.viewContext
        )
    }
}
