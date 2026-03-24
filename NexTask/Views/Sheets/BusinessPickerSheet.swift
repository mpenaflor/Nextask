//
//  BusinessPickerSheet.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-23.
//

import SwiftUI

struct BusinessPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let businesses: [Business]
    
    @Binding var selected: Business?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(L10n.General.none) {
                        selected = nil
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                }
                
                Section(L10n.Business.title) {
                    ForEach(businesses, id: \.objectID) { business in
                        Button {
                            selected = business
                            dismiss()
                        } label: {
                            HStack {
                                Text(business.name ?? "")

                                Spacer()

                                if selected == business {
                                    Image(systemName: SFSymbols.checkmark)
                                        .foregroundStyle(.blue)
                                }
                            }
                            
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.People.sheetTitleBusiness)
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
