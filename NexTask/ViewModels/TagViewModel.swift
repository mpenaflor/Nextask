//
//  TagViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Combine
import CoreData

class TagViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var shouldReload: Bool = false
    
    let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.shouldReload = true
    }

    func loadTags() {
        tags = dataManager.fetch(
            Tag.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
        )
        shouldReload = false
    }
    func deleteTag(_ tag: Tag) {
        dataManager.delete(tag)
        shouldReload = true
    }
    
    func deleteTags(offsets: IndexSet) {
        dataManager.delete(tags, at: offsets)
        shouldReload = true
    }
    
    func save(tag: Tag? = nil, name: String, completion: (AppError?) -> Void) {
        guard isNameValid(name, objectId: tag?.objectID) else {
            completion(AppError(title: L10n.Error.validationErrorTitle, message: L10n.Error.nameAlreadyInUse))
            return
        }

        var tagObj = tag
        let context = dataManager.context
        if tag == nil {
            tagObj = Tag(context: context)
        }
        tagObj?.name = name
        
        do {
            try context.save()
            shouldReload = true
        } catch {
            print("Save error:", error)
        }
        
        completion(nil)
    }
    
    private func isNameValid(_ name: String, objectId: NSManagedObjectID?) -> Bool {
        let nameExists = tags.first { tag in
            let tagName = tag.name?.trimmingCharacters(in: .whitespacesAndNewlines)
            return tagName == name && tag.objectID != objectId
        } != nil
        
        return !nameExists
    }

}
