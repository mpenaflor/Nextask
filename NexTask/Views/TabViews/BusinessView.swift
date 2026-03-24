//
//  BusinessView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-19.
//

import SwiftUI

struct BusinessView: View {
    
    @StateObject private var viewModel: BusinessViewModel
    
    @State private var selectedCategories: Set<String> = []
    
    @State private var editMode: EditMode = .inactive
    
    @Binding var selectedTab: Tab
    
    @State var needsFullReload = false
    
    var filteredBusinesses: [Business] {
        guard !selectedCategories.isEmpty else { return viewModel.businesses }

        return viewModel.businesses.filter { business in
            if let categoryNames = viewModel.getCategoryNames(business: business) {
                return !Set(categoryNames).isDisjoint(with: selectedCategories)
            }

            return false
        }
    }
    
    init(dataManager: DataManager, selectedTab: Binding<Tab>) {
        _viewModel = StateObject(wrappedValue: BusinessViewModel(dataManager: dataManager))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.Business.title)
                .environment(\.editMode, $editMode)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            BusinessFormView(viewModel: viewModel)
                        } label: {
                            Image(systemName: SFSymbols.add)
                        }
                    }
                    
                    if !viewModel.businesses.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                withAnimation {
                                    editMode = editMode.isEditing ? .inactive : .active
                                }
                            } label: {
                                Image(systemName: editMode == .inactive ? SFSymbols.edit : SFSymbols.checkmarkButton)
                                    .foregroundStyle(editMode == .inactive ? .primary : Color.blue)
                            }
                        }
                    }
                }
                .onAppear() {
                    if viewModel.needsBusinessesRefresh {
                        viewModel.loadBusinesses()
                    }
                    
                    if needsFullReload {
                        viewModel.loadAll()
                        needsFullReload = false
                    }
                }
                .onDisappear() {
                    editMode = .inactive
                }
                .onChange(of: selectedTab) { prevTab, tab in
                    if prevTab == .businesses {
                       needsFullReload = true
                    }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if filteredBusinesses.isEmpty {
            EmptyStateView(
                title: L10n.Business.emptyTitle,
                message: L10n.Business.emptyMessage,
                systemImage: SFSymbols.people
            )
        } else {
            List {
                ForEach(filteredBusinesses) { business in
                    NavigationLink {
                        BusinessFormView(viewModel: viewModel, business: business)
                    } label: {
                        BusinessRowView(
                            business: business,
                            categories: viewModel.getCategoryNames(business: business),
                            tags: viewModel.getTagNames(business: business),
                            onTagTap: { tag in
                                print(tag)
                            }
                        )
                    }
                }
                .onDelete(perform: deleteBusinesses)
            }
        }
    }
    
    private func deleteBusinesses(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteBusinesses(offsets: offsets)
        }
    }
}

#Preview {
    BusinessView(dataManager: .preview, selectedTab: .constant(.businesses))
}
