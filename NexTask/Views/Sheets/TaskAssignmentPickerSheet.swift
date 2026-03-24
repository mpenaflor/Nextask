//
//  TaskAssignmentPickerSheet.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import SwiftUI

struct TaskAssignmentPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let people: [Employee]?
    let businesses: [Business]?
    
    @Binding var selectedPerson: Employee?
    @Binding var selectedBusiness: Business?

    var body: some View {
        NavigationStack {
            List {
                if let people {
                    Section(L10n.People.title) {
                        ForEach(people, id: \.objectID) { person in
                            Button {
                                selectedPerson = person
                                selectedBusiness = nil
                                dismiss()
                            } label: {
                                HStack {
                                    Text(Utils.getDiplayName(person) ?? L10n.People.unknown)

                                    Spacer()

                                    if selectedPerson == person {
                                        Image(systemName: SFSymbols.checkmark)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
                
                if let businesses {
                    Section(L10n.Business.title) {
                        ForEach(businesses, id: \.objectID) { business in
                            Button {
                                selectedBusiness = business
                                selectedPerson = nil
                                dismiss()
                            } label: {
                                HStack {
                                    Text(business.name ?? "")

                                    Spacer()

                                    if selectedBusiness == business {
                                        Image(systemName: SFSymbols.checkmark)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.Tasks.fieldAssignee)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.General.cancel) { dismiss() }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.General.done) { dismiss() }
                }
            }
        }
    }
}
