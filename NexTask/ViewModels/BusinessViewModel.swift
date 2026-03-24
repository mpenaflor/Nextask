//
//  BusinessViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Combine
import CoreData

class BusinessViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    @Published var categories: [BusinessCategory] = []
    @Published var tags: [Tag] = []
    
    @Published var needsBusinessesRefresh: Bool = false

    let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        loadAll()
    }

    func loadAll() {
        self.loadBusinesses()
        self.loadCategories()
        self.loadTags()
    }
    
    func loadBusinesses() {
        businesses = dataManager.fetch(
            Business.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        )
        needsBusinessesRefresh = false
    }
    
    func loadCategories() {
        categories = dataManager.fetch(
            BusinessCategory.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        )
    }
    
    func loadTags() {
        tags = dataManager.fetch(
            Tag.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        )
    }
    
    func deleteBusinesses(offsets: IndexSet) {
        dataManager.delete(businesses, at: offsets)
        loadBusinesses()
    }
    
    func save(business: Business? = nil, name: String, email: String, categories: [BusinessCategory]? = nil, tags: [Tag]? = nil, completion: (AppError?) -> Void) {
        guard isNameValid(name, objectId: business?.objectID) else {
            completion(AppError(title: L10n.Error.validationErrorTitle, message: L10n.Error.nameAlreadyInUse))
            return
        }
        
        let context = dataManager.context
        var business = business
        if business == nil {
            business = Business(context: context)
        }
        business?.name = name
        business?.email = email
        if let categories {
            business?.categories = NSSet(array: categories)
        }
        if let tags {
            business?.tags = NSSet(array: tags)
        }

        do {
            try context.save()
            needsBusinessesRefresh = true
        } catch {
            print("Save error:", error)
        }
        
        completion(nil)
    }
    
    func getCategoryNames(business: Business) -> [String]? {
        guard let businessCategories = business.categories as? Set<NSManagedObject> else {
            return nil
        }
        
        return businessCategories.compactMap { $0.value(forKey: "name") as? String }.sorted()
    }
    
    func getTagNames(business: Business) -> [String]? {
        guard let tags = business.tags as? Set<NSManagedObject> else {
            return nil
        }
        
        return tags.compactMap { $0.value(forKey: "name") as? String }.sorted()
    }
    
    private func isNameValid(_ name: String, objectId: NSManagedObjectID?) -> Bool {
        let nameExists = businesses.first { business in
            let businessName = business.name?.trimmingCharacters(in: .whitespacesAndNewlines)
            return businessName == name && business.objectID != objectId
        } != nil
        
        return !nameExists
    }
    
    func getSortedTasks(business: Business) -> [TaskItem]? {
        guard let taskSet = business.tasks as? Set<TaskItem> else { return nil }

        return taskSet.sorted {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted // open (false) comes first
            } else {
                return $0.timestamp! > $1.timestamp! // newest first
            }
        }
    }
}
