//
//  TagFormView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-20.
//

import SwiftUI
import CoreData

struct TagFormView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: TagViewModel

    @State private var name = ""
    
    @State private var showAlert = false
    @State private var error: AppError?
    
    var tag: Tag?
    
    enum Field {
        case name
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(L10n.Tags.fieldName)) {
                    TextField("", text: $name)
                        .focused($focusedField, equals: .name)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(tag == nil ? L10n.Tags.addTag : L10n.Tags.tagDetails)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.General.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.General.save) {
                        saveTag()
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
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                name = tag?.name ?? ""
            }
            .alert(error?.title ?? "", isPresented: $showAlert) {
                Button(L10n.General.ok, role: .cancel) { }
            } message: {
                Text(error?.message ?? "")
            }
        }
    }
    
    private func deleteTag() {
        guard let tag else {
            return
        }
        
        viewModel.deleteTag(tag)
        dismiss()
    }
    
    private func saveTag() {
        viewModel.save(tag: tag, name: name, completion: { appError in
            if appError != nil {
                error = appError
                showAlert = true
            } else {
                dismiss()
            }
        })
    }
}
