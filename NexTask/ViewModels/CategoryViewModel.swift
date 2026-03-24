//
//  CategoryViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-22.
//

import Combine
import CoreData

class CategoryViewModel: ObservableObject {
    @Published var categories: [BusinessCategory] = []
    @Published var shouldReload: Bool = false
    
    let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.shouldReload = true
    }

    func loadCategories() {
        categories = dataManager.fetch(
            BusinessCategory.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
        )
        shouldReload = false
    }
    
    func deleteCategory(_ category: BusinessCategory) {
        dataManager.delete(category)
        shouldReload = true
    }
    
    func deleteCategories(offsets: IndexSet) {
        dataManager.delete(categories, at: offsets)
        shouldReload = true
    }
    
    func createCategory(name: String) {
        let context = dataManager.context
        let category = BusinessCategory(context: context)
        category.name = name
        do {
            try context.save()
            shouldReload = true
        } catch {
            print("Save error:", error)
        }
    }
    
    func save(category: BusinessCategory? = nil, name: String, completion: (AppError?) -> Void) {
        guard isNameValid(name, objectId: category?.objectID) else {
            completion(AppError(title: L10n.Error.validationErrorTitle, message: L10n.Error.nameAlreadyInUse))
            return
        }
        
        let context = dataManager.context
        var categoryObj = category
        if categoryObj == nil {
            categoryObj = BusinessCategory(context: context)
        }
        categoryObj?.name = name
        
        do {
            try context.save()
            shouldReload = true
        } catch {
            print("Save error:", error)
        }
        
        completion(nil)
    }
    
    private func isNameValid(_ name: String, objectId: NSManagedObjectID?) -> Bool {
        let nameExists = categories.first { category in
            let categoryName = category.name?.trimmingCharacters(in: .whitespacesAndNewlines)
            return categoryName == name && category.objectID != objectId
        } != nil
        
        return !nameExists
    }

}
