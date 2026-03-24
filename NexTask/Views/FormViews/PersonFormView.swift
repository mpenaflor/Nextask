//
//  PersonFormView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-23.
//

import SwiftUI

struct PersonFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PeopleViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""

    @State private var selectedBusiness: Business?
    @State private var selectedTags: Set<String> = []

    @State private var showBusinessSheet = false
    @State private var showTagSheet = false
    
    @State private var emailTouched = false
    
    @State private var showAlert = false
    @State private var error: AppError?

    var person: Employee?

    enum Field {
        case firstName, lastName, email, phone
    }

    @FocusState private var focusedField: Field?
    
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        Utils.isValidEmail(email)
    }
    
    var body: some View {
        Form {
            Section(L10n.People.sectionName) {
                TextField(L10n.People.fieldFirstname, text: $firstName)
                    .focused($focusedField, equals: .firstName)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                TextField(L10n.People.fieldLastname, text: $lastName)
                    .focused($focusedField, equals: .lastName)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
            }
            
            Section(L10n.People.sectionContact) {
                VStack(alignment: .leading, spacing: 4) {
                    TextField(L10n.People.fieldEmail, text: $email)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: email) { _, _ in
                            emailTouched = true
                        }
                    
                    if emailTouched && !Utils.isValidEmail(email) && email.count > 0 {
                        Text(L10n.Error.invalidEmail)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                
                TextField(L10n.People.fieldPhone, text: $phone)
                    .focused($focusedField, equals: .phone)
                    .keyboardType(.phonePad)
                    .autocorrectionDisabled(true)
            }
            
            Section(L10n.People.sectionBusiness) {
                Button {
                    showBusinessSheet = true
                } label: {
                    HStack {
                        Text(selectedBusiness?.name ?? L10n.People.sheetTitleBusiness)
                        Spacer()
                        Image(systemName: SFSymbols.chevronRight)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section(L10n.Tags.title) {
                Button {
                    showTagSheet = true
                } label: {
                    HStack {
                        Text(selectedTags.isEmpty
                             ? L10n.People.sheetTitleTags
                             : String(format: L10n.People.selectedTagsCount, selectedTags.count))
                        Spacer()
                        Image(systemName: SFSymbols.chevronRight)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Preview chips
                if !selectedTags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(selectedTags), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            
            if let person, let tasks = viewModel.getSortedTasks(person: person), tasks.count > 0 {
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
                Text(person == nil ? L10n.People.add : L10n.People.details)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.General.save) {
                    save()
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
            load()
        }
        .alert(error?.title ?? "", isPresented: $showAlert) {
            Button(L10n.General.ok, role: .cancel) { }
        } message: {
            Text(error?.message ?? "")
        }
        
        // Sheets
        .sheet(isPresented: $showBusinessSheet) {
            if let businesses = viewModel.businesses {
                BusinessPickerSheet(
                    businesses: businesses,
                    selected: $selectedBusiness
                )
            }
        }

        .sheet(isPresented: $showTagSheet) {
            if let allTags = viewModel.tagNames {
                MultiSelectSheet(
                    title: L10n.People.sheetTitleTags,
                    items: allTags,
                    selections: $selectedTags
                )
            }
        }
    }
}

extension PersonFormView {

    private func load() {
        guard let person else { return }

        firstName = person.firstname ?? ""
        lastName = person.lastname ?? ""
        email = person.email ?? ""
        phone = person.phone ?? ""

        selectedBusiness = person.business

        selectedTags = Set(
            (person.tags as? Set<Tag>)?
                .compactMap(\.name) ?? []
        )
    }

    private func save() {
        let tags = viewModel.tags?.filter { tag in
            guard let name = tag.name else { return false }
            return selectedTags.contains(name)
        }
        
        viewModel.save(person: person, firstname: firstName, lastname: lastName, email: email, phone: phone, business: selectedBusiness, tags: tags, completion: { appError in
            if appError != nil {
                error = appError
                showAlert = true
            } else {
                dismiss()
            }
        })
    }
}


