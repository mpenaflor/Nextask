//
//  BusinessCategoryFormView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-20.
//

import SwiftUI
import CoreData

struct BusinessCategoryFormView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: CategoryViewModel

    @State private var name = ""
    
    @State private var showAlert = false
    @State private var error: AppError?
    
    var category: BusinessCategory?
    
    var tag: Tag?
    
    enum Field {
        case name
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(L10n.Categories.fieldName)) {
                    TextField("", text: $name)
                        .focused($focusedField, equals: .name)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(category == nil ? L10n.Categories.addCategory : L10n.Categories.categoryDetails)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.General.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.General.save) {
                        saveCategory()
                    }
                    .disabled(name.isEmpty)
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
            .onAppear {
                name = category?.name ?? ""
            }
            .alert(error?.title ?? "", isPresented: $showAlert) {
                Button(L10n.General.ok, role: .cancel) { }
            } message: {
                Text(error?.message ?? "")
            }
        }
    }
    
    private func deleteCategory() {
        guard let category else {
            return
        }
        
        viewModel.deleteCategory(category)
        dismiss()
    }
    
    private func saveCategory() {
        viewModel.save(category: category, name: name, completion: { appError in
            if appError != nil {
                error = appError
                showAlert = true
            } else {
                dismiss()
            }
        })
    }
}
