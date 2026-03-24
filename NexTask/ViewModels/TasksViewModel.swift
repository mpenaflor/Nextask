//
//  TasksViewModel.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Combine
import CoreData

class TasksViewModel: ObservableObject {
    let dataManager: DataManager
    
    @Published var tasks: [TaskItem] = []
    
    var businesses: [Business]?
    var people: [Employee]?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        loadAll()
    }
    
    func loadAll() {
        loadTasks()
        loadPeople()
        loadBusinesses()
    }
    
    func loadTasks() {
        let fetchedTasks = dataManager.fetch(
            TaskItem.self,
            sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.timestamp, ascending: false)]
        )
        
        tasks = fetchedTasks.sorted {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted // open (false) comes first
            } else {
                return $0.timestamp! > $1.timestamp! // newest first
            }
        }
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
    
    func deleteTasks(offsets: IndexSet) {
        dataManager.delete(tasks, at: offsets)
        loadTasks()
    }
    
    func save(task: TaskItem? = nil, title: String, description: String, isCompleted: Bool, person: Employee? = nil, business: Business? = nil) {
        
        let context = dataManager.context
        var taskObj = task
        if taskObj == nil {
            taskObj = TaskItem(context: context)
        }
        taskObj?.timestamp = Date()
        taskObj?.title = title
        taskObj?.taskDescription = description
        taskObj?.isCompleted = isCompleted

        // Clear both first
        taskObj?.person = person
        taskObj?.business = business

        do {
            try context.save()
            loadTasks()
        } catch {
            print("Error saving:", error)
        }
    }
}
