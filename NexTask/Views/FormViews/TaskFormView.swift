//
//  TaskFormView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-20.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TasksViewModel

    var task: TaskItem?
    
    // Form state
    @State private var title = ""
    @State private var desc = ""
    @State private var status: TaskStatus = .open
    @State private var selectedPerson: Employee?
    @State private var selectedBusiness: Business?
    @State private var showAssignmentPickerSheet = false
    
    // For Keyboard 'Done button
    private enum Field {
        case title, desc
    }
    @FocusState private var focusedField: Field?
    
    private var isFormValid: Bool {
        !title.isEmpty &&
        !desc.isEmpty &&
        (selectedPerson != nil || selectedBusiness != nil)
    }
    
    private var assignee: String {
        if let person = selectedPerson, let fullName = Utils.getDiplayName(person) {
            return fullName
        }
        
        return selectedBusiness?.name ?? L10n.Tasks.assigneePickerTitle
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.Tasks.formSectionInfo) {
                    TextField(L10n.Tasks.fieldTitle, text: $title)
                        .focused($focusedField, equals: .title)

                    TextField(L10n.Tasks.fieldDescription, text: $desc, axis: .vertical)
                        .lineLimit(3...6)
                        .focused($focusedField, equals: .desc)
                }

                Section(L10n.Tasks.formSectionAssignee) {
                    Button {
                        showAssignmentPickerSheet = true
                    } label: {
                        HStack {
                            Text(assignee)
                            Spacer()
                            if selectedPerson != nil {
                                Image(systemName:  SFSymbols.person)
                                    .foregroundStyle(.blue)
                            } else if (selectedBusiness != nil) {
                                Image(systemName:  SFSymbols.business)
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
                
                if task != nil {
                    Section {
                        Button(action: {
                            updateStatus()
                        }) {
                            Text(status == .completed ? L10n.Tasks.buttonReopen : L10n.Tasks.buttonComplete)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(status == .completed ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(task == nil ? L10n.Tasks.addTask : L10n.Tasks.taskDetails)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
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
                loadTask()
            }
            // Sheets
            .sheet(isPresented: $showAssignmentPickerSheet) {
                TaskAssignmentPickerSheet(people: viewModel.people,
                                          businesses: viewModel.businesses,
                                          selectedPerson: $selectedPerson,
                                          selectedBusiness: $selectedBusiness)
            }
        }
    }

    // MARK: - Load existing task
    private func loadTask() {
        guard let task else { return }

        title = task.title ?? ""
        desc = task.taskDescription ?? ""
        status = task.isCompleted ? .completed : .open
        selectedPerson = task.person
        selectedBusiness = task.business
    }

    // MARK: - Save / Update
    private func saveTask() {
        viewModel.save(task: task, title: title, description: desc, isCompleted: status == .completed, person: selectedPerson, business: selectedBusiness)
        dismiss()
    }
    
    private func updateStatus() {
        status = status == .completed ? .open : .completed
        saveTask()
    }
}
