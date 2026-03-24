//
//  BusinessFormView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-22.
//

import SwiftUI
import CoreData

struct BusinessFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BusinessViewModel
    
    @State private var businessName = ""
    @State private var email = ""

    @State private var selectedCategories: Set<String> = []
    @State private var selectedTags: Set<String> = []

    @State private var showCategorySheet = false
    @State private var showTagSheet = false
        
    @State private var emailTouched = false
    
    @State private var showAlert = false
    @State private var error: AppError?
    
    var business: Business?
    
    enum Field {
        case name, email
    }

    @FocusState private var focusedField: Field?
    
    private var isFormValid: Bool {
        !businessName.trimmingCharacters(in: .whitespaces).isEmpty &&
        Utils.isValidEmail(email)
    }
    
    private var categoryNames: [String] {
        viewModel.categories
            .compactMap(\.name)
            .sorted()
    }
    
    private var tagNames: [String] {
        viewModel.tags
            .compactMap(\.name)
            .sorted()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(L10n.Business.info)) {
                    TextField(L10n.Business.name, text: $businessName)
                        .focused($focusedField, equals: .name)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)

                    VStack(alignment: .leading, spacing: 4) {
                        TextField(L10n.Business.email, text: $email)
                            .focused($focusedField, equals: .email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .onChange(of: email) { _, _ in
                                emailTouched = true
                            }

                        if emailTouched && !Utils.isValidEmail(email) && email.count != 0 {
                            Text(L10n.Error.invalidEmail)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }

                // MARK: - Categories
                Section {
                    Button {
                        showCategorySheet = true
                    } label: {
                        HStack {
                            Text(L10n.Business.categories)
                            Spacer()
                            Text(summary(selectedCategories))
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: - Tags
                Section {
                    Button {
                        showTagSheet = true
                    } label: {
                        HStack {
                            Text(L10n.Business.tags)
                            Spacer()
                            Text(summary(selectedTags))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // MARK: - Tasks
                if let business, let tasks = viewModel.getSortedTasks(business: business), tasks.count > 0 {
                    let taskViewModel = TasksViewModel(dataManager: viewModel.dataManager)
                    Section(L10n.Tasks.title) {
                        ForEach(tasks) { task in
                            TaskRowView(viewModel: taskViewModel, task: task, showAssignee: false)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(business == nil ? L10n.Business.add : L10n.Business.details)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.General.save) {
                        handleSave()
                    }
                    .disabled(!isFormValid)
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.General.done) {
                        withAnimation {
                            focusedField = nil
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                if let business {
                    businessName = business.name ?? ""
                    email = business.email ?? ""
                    
                    if let businessCategories = business.categories as? Set<NSManagedObject>  {
                        selectedCategories = Set(
                            businessCategories.compactMap { $0.value(forKey: "name") as? String }
                        )
                    }
                    
                    if let businessTags = business.tags as? Set<NSManagedObject>  {
                        selectedTags = Set(
                            businessTags.compactMap { $0.value(forKey: "name") as? String }
                        )
                    }
                }
                viewModel.loadCategories()
                viewModel.loadTags()
            }
            .alert(error?.title ?? "", isPresented: $showAlert) {
                Button(L10n.General.ok, role: .cancel) { }
            } message: {
                Text(error?.message ?? "")
            }

            // Sheets
            .sheet(isPresented: $showCategorySheet) {
                MultiSelectSheet(
                    title: L10n.Business.sheetTitleCategories,
                    items: categoryNames,
                    selections: $selectedCategories
                )
            }

            .sheet(isPresented: $showTagSheet) {
                MultiSelectSheet(
                    title: L10n.Business.sheetTitleTags,
                    items: tagNames,
                    selections: $selectedTags
                )
            }
        }
    }
    
    private func summary(_ set: Set<String>) -> String {
        if set.isEmpty { return "None" }
        if set.count <= 2 { return set.joined(separator: ", ") }
        return "\(set.count) selected"
    }
    
    private func handleSave() {
        let businessCategories = viewModel.categories.filter { category in
            guard let name = category.name else { return false }
            return selectedCategories.contains(name)
        }
        
        let businessTags = viewModel.tags.filter { tag in
            guard let name = tag.name else { return false }
            return selectedTags.contains(name)
        }
        
        viewModel.save(business: business, name: businessName, email: email, categories: businessCategories, tags: businessTags, completion: { appError in
            if appError != nil {
                error = appError
                showAlert = true
            } else {
                dismiss()
            }
        })
    }
}


