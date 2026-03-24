//
//  PeopleViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Combine
import CoreData

class PeopleViewModel: ObservableObject {
    @Published var people: [Employee] = []

    var businesses: [Business]?
    var tags: [Tag]?
    
    let dataManager: DataManager
    
    var tagNames: [String]? {
        let tagNames = tags?.compactMap { $0.value(forKey: "name") as? String }.sorted()
        return tagNames
    }

    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        loadAll()
    }

    func loadAll() {
        loadPeople()
        loadBusinesses()
        loadTags()
    }
    
    func loadPeople() {
        people = dataManager.fetch(
            Employee.self,
            sortDescriptors: [NSSortDescriptor(key: "firstname", ascending: true)],
        )
    }
    
    func loadBusinesses() {
        businesses = dataManager.fetch(
            Business.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        )
    }
    
    func loadTags() {
        tags = dataManager.fetch(
            Tag.self,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        )
    }
    
    func deletePeople(offsets: IndexSet) {
        dataManager.delete(people, at: offsets)
        loadPeople()
    }
    
    func save(person: Employee? = nil, firstname: String, lastname: String, email: String, phone: String, business: Business? = nil, tags: [Tag]? = nil, completion: (AppError?) -> Void) {
        
        let fullname = "\(firstname) \(lastname)".trimmingCharacters(in: .whitespacesAndNewlines)
        guard isNameValid(fullname, objectId: person?.objectID) else {
            completion(AppError(title: L10n.Error.validationErrorTitle, message: L10n.Error.nameAlreadyInUse))
            return
        }
        
        guard isEmailValid(email, objectId: person?.objectID) else {
            completion(AppError(title: L10n.Error.validationErrorTitle, message: L10n.Error.emailAlreadyInUse))
            return
        }
        
        let context = dataManager.context
        var person = person
        if person == nil {
            person = Employee(context: context)
        }
        person?.firstname = firstname
        person?.lastname = lastname
        person?.email = email
        person?.phone = phone
        
        person?.business = business
        person?.tags = tags != nil ? NSSet(array: tags!) : nil

        do {
            try context.save()
            loadPeople()
        } catch {
            print("Save error:", error)
        }
        
        completion(nil)
    }
    
    func getTagNames(person: Employee) -> [String]? {
        guard let tags = person.tags as? Set<NSManagedObject> else {
            return nil
        }
        
        return tags.compactMap { $0.value(forKey: "name") as? String }.sorted()
    }
    
    private func isNameValid(_ name: String, objectId: NSManagedObjectID?) -> Bool {
        let nameExists = people.first { person in
            let personFullname = "\(person.firstname ?? "") \(person.lastname ?? "")".trimmingCharacters(in: .whitespacesAndNewlines)
            return personFullname == name && person.objectID != objectId
        } != nil
        
        return !nameExists
    }
    
    private func isEmailValid(_ email: String, objectId: NSManagedObjectID?) -> Bool {
        let emailExists = people.first { person in
            let personEmail = person.email
            return personEmail == email && person.objectID != objectId
        } != nil
        
        return !emailExists
    }
    
    func getSortedTasks(person: Employee) -> [TaskItem]? {
        guard let taskSet = person.tasks as? Set<TaskItem> else { return nil }

        return taskSet.sorted {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted // open (false) comes first
            } else {
                return $0.timestamp! > $1.timestamp! // newest first
            }
        }
    }
}
