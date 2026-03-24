//
//  L10n.swift.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import Foundation

enum L10n {
    
    // MARK: - General
    enum General {
        static let save = NSLocalizedString("general.save", comment: "Save button")
        static let cancel = NSLocalizedString("general.cancel", comment: "Cancel button")
        static let delete = NSLocalizedString("general.delete", comment: "Delete button")
        static let edit = NSLocalizedString("general.edit", comment: "Edit button")
        static let done = NSLocalizedString("general.done", comment: "Done button")
        static let error = NSLocalizedString("general.error", comment: "Error title")
        static let ok = NSLocalizedString("general.ok", comment: "OK button")
        static let none = NSLocalizedString("general.none", comment: "None button")
        static let search = NSLocalizedString("general.search", comment: "Search button")
        static let noResults = NSLocalizedString("general.noResults", comment: "No results label")
    }
    
    // MARK: - Auth
    enum Auth {
        static let login = NSLocalizedString("auth.login", comment: "")
        static let signup = NSLocalizedString("auth.signup", comment: "")
        static let email = NSLocalizedString("auth.email", comment: "")
        static let password = NSLocalizedString("auth.password", comment: "")
        static let confirmPassword = NSLocalizedString("auth.confirmPassword", comment: "")
        static let loginLink = NSLocalizedString("auth.login.link", comment: "")
        static let registerErrorTitle = NSLocalizedString("auth.register.error.title", comment: "")
        static let loginErrorTitle = NSLocalizedString("auth.login.error.title", comment: "")
        static let loginGreeting = NSLocalizedString("auth.login.greeting", comment: "")
        static let registerGreeting = NSLocalizedString("auth.register.greeting", comment: "")
        static let registerLink = NSLocalizedString("auth.register.link", comment: "")
        
        static let logoutTitle = NSLocalizedString("auth.logout.title", comment: "")
        static let logoutAlertMessage = NSLocalizedString("auth.logout.warning.message", comment: "")
        
        static let profileSectionTitle = NSLocalizedString("auth.profile.section.title", comment: "")
    }
    
    // MARK: - Tasks
    enum Tasks {
        static let title = NSLocalizedString("tasks.title", comment: "Tasks screen title")
        static let emptyTitle = NSLocalizedString("tasks.empty.title", comment: "No tasks title")
        static let emptyMessage = NSLocalizedString("tasks.empty.message", comment: "No tasks message")
        
        static let untitled = NSLocalizedString("tasks.untitled", comment: "Title not set")
        
        static let addTask = NSLocalizedString("tasks.add", comment: "Add task")
        static let taskDetails = NSLocalizedString("tasks.details", comment: "Task details")
        
        static let formSectionInfo = NSLocalizedString("tasks.form.section.info", comment: "Task title field")
        static let formSectionAssignee = NSLocalizedString("tasks.form.section.assignee", comment: "Task title field")
        
        static let fieldTitle = NSLocalizedString("tasks.field.title", comment: "Task title field")
        static let fieldDescription = NSLocalizedString("tasks.field.description", comment: "Task description field")
        static let fieldStatus = NSLocalizedString("tasks.field.status", comment: "Task status field")
        static let fieldAssignee = NSLocalizedString("tasks.field.assignee", comment: "Task assignee field")
        
        static let assigneePickerTitle = NSLocalizedString("tasks.assignee.picker.title", comment: "Task assignee picker title")
        
        static let statusOpen = NSLocalizedString("tasks.status.open", comment: "Open status")
        static let statusCompleted = NSLocalizedString("tasks.status.completed", comment: "Completed status")
        
        static let buttonReopen = NSLocalizedString("tasks.status.button.reopen", comment: "Re-open task button title")
        static let buttonComplete = NSLocalizedString("tasks.status.button.complete", comment: "Complete task button title")
        
        static let assignedCount = NSLocalizedString("tasks.assigned.count", comment: "Assigned tasks count label")
    }
    
    // MARK: - People
    enum People {
        static let title = NSLocalizedString("people.title", comment: "People screen title")
        static let emptyTitle = NSLocalizedString("people.empty.title", comment: "No people found title")
        static let emptyMessage = NSLocalizedString("people.empty.message", comment: "No people found message")
        
        static let unknown = NSLocalizedString("people.unknown", comment: "Person name not set")
        
        static let add = NSLocalizedString("people.add", comment: "Add Person screen title")
        static let details = NSLocalizedString("people.details", comment: "Edit Person screen title")
        
        static let sectionName = NSLocalizedString("people.section.name", comment: "Section title for person's name")
        static let sectionContact = NSLocalizedString("people.section.contact", comment: "Section title for person's contact")
        static let sectionBusiness = NSLocalizedString("people.section.business", comment: "Section title for person's business")
        
        static let fieldFirstname = NSLocalizedString("people.field.firstname", comment: "Field name for person's first name")
        static let fieldLastname = NSLocalizedString("people.field.lastname", comment: "Field name for person's last name")
        static let fieldEmail = NSLocalizedString("people.field.email", comment: "Field name for person's email")
        static let fieldPhone = NSLocalizedString("people.field.phone", comment: "Field name for person's phone")
        
        static let sheetTitleBusiness = NSLocalizedString("people.sheet.title.business", comment: "Sheet title for Person business")
        static let sheetTitleTags = NSLocalizedString("people.sheet.title.tags", comment: "Sheet title for Person tags")
        
        static let selectedTagsCount = NSLocalizedString("people.tags.selected.count", comment: "Selected tag count label")
    }
    
    // MARK: - Business
    enum Business {
        static let title = NSLocalizedString("business.title", comment: "Business screen title")
        static let emptyTitle = NSLocalizedString("business.empty.title", comment: "No business found title")
        static let emptyMessage = NSLocalizedString("business.empty.message", comment: "No business found message")
        
        static let unknown = NSLocalizedString("business.unknown", comment: "Business name not set")
        
        static let add = NSLocalizedString("business.add", comment: "Add Business screen title")
        static let details = NSLocalizedString("business.details", comment: "Edit Business screen title")
        
        static let info = NSLocalizedString("business.info", comment: "Business Info section title")
        
        static let name = NSLocalizedString("business.field.name", comment: "Business name field title")
        static let email = NSLocalizedString("business.field.email", comment: "Business email field title")
        static let categories = NSLocalizedString("business.field.categories", comment: "Business categories field title")
        static let tags = NSLocalizedString("business.field.tags", comment: "Business tags field title")
        
        static let sheetTitleCategories = NSLocalizedString("business.sheet.title.categories", comment: "Sheet title for Business categories")
        static let sheetTitleTags = NSLocalizedString("business.sheet.title.tags", comment: "Sheet title for Business tags")
    }
    
    // MARK: - Settings
    enum Settings {
        static let title = NSLocalizedString("settings.title", comment: "Settings")
    }
    
    // MARK: - Tags
    enum Tags {
        static let title = NSLocalizedString("tags.title", comment: "Tags screen title")
        static let emptyTitle = NSLocalizedString("tags.empty.title", comment: "No tags title")
        static let emptyMessage = NSLocalizedString("tags.empty.message", comment: "No tags message")
        
        static let addTag = NSLocalizedString("tags.add", comment: "Add tag")
        static let tagDetails = NSLocalizedString("tags.details", comment: "Tag Details")
        
        static let fieldName = NSLocalizedString("tags.field.name", comment: "Tag name field")
        
        static let untitled = NSLocalizedString("tags.untitled", comment: "Tag name not set")
        
        static let deleteAlertTitle = NSLocalizedString("tags.delete.alert.title", comment: "Title in the delete confirmation alert")
    }
    
    // MARK: - Business Categories
    enum Categories {
        static let title = NSLocalizedString("categories.title", comment: "Categories screen title")
        static let emptyTitle = NSLocalizedString("categories.empty.title", comment: "No categories title")
        static let emptyMessage = NSLocalizedString("categories.empty.message", comment: "No categories message")
        
        static let addCategory = NSLocalizedString("categories.add", comment: "Add category")
        static let categoryDetails = NSLocalizedString("categories.details", comment: "Category details")
        
        static let fieldName = NSLocalizedString("categories.field.name", comment: "Category name field")
        
        static let untitled = NSLocalizedString("categories.untitled", comment: "Category name not set")
        
        static let categorylertTitle = NSLocalizedString("categories.delete.alert.title", comment: "Title in the delete confirmation alert")
    }
    
    // MARK: - Validation / Errors
    enum Error {
        static let requiredField = NSLocalizedString("error.required_field", comment: "Required field error")
        static let duplicateTag = NSLocalizedString("error.duplicate_tag", comment: "Duplicate tag error")
        static let duplicateCategory = NSLocalizedString("error.duplicate_category", comment: "Duplicate category error")
        
        static let saveFailed = NSLocalizedString("error.save_failed", comment: "Save failed error")
        
        static let invalidEmail = NSLocalizedString("error.validation.invalidEmail", comment: "Invalid email error message")
        
        static let validationErrorTitle = NSLocalizedString("error.validation.title", comment: "Invalid email error message")
        static let emailAlreadyInUse = NSLocalizedString("error.validation.email", comment: "Email already in use error message")
        static let nameAlreadyInUse = NSLocalizedString("error.validation.name", comment: "Name already in use error message")
    }
    
    // MARK: - Alerts
    enum Alert {
        static let deleteTitle = NSLocalizedString("alert.delete.title", comment: "Delete alert title")
        static let deleteMessage = NSLocalizedString("alert.delete.message", comment: "Delete alert message")
        
        static let discardTitle = NSLocalizedString("alert.discard.title", comment: "Discard changes title")
        static let discardMessage = NSLocalizedString("alert.discard.message", comment: "Discard changes message")
    }
}
