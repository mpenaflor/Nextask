//
//  MultiSelectSheet.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-22.
//

import SwiftUI

struct MultiSelectSheet: View {
    let title: String
    let items: [String]

    @Binding var selections: Set<String>
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @FocusState private var isSearching: Bool

    // MARK: - Filter + Sort
    var filteredItems: [String] {
        let base: [String] = {
            if searchText.isEmpty {
                return items
            } else {
                return items.filter {
                    $0.localizedCaseInsensitiveContains(searchText)
                }
            }
        }()

        return base.sorted()
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if filteredItems.isEmpty {
                        Text(L10n.General.noResults)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(filteredItems, id: \.self) { item in
                            row(item)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: L10n.General.search)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isSearching = true
                }
            }
            .focused($isSearching)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
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

private extension MultiSelectSheet {
    @ViewBuilder
    func row(_ item: String) -> some View {
        Button {
            toggle(item)
        } label: {
            HStack {
                Text(item)

                Spacer()

                if selections.contains(item) {
                    Image(systemName: SFSymbols.checkmark)
                        .foregroundStyle(.blue)
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

private extension MultiSelectSheet {

    func toggle(_ item: String) {
        withAnimation {
            if selections.contains(item) {
                selections.remove(item)
            } else {
                selections.insert(item)
            }
        }
    }

    func createNew() {
        let newItem = searchText.trimmingCharacters(in: .whitespaces)
        guard !newItem.isEmpty else { return }

        withAnimation {
            selections.insert(newItem)
        }

        searchText = ""
    }
}
