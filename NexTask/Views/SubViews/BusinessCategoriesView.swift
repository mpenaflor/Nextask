//
//  BusinessCategoriesView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-20.
//

import SwiftUI
import CoreData

struct BusinessCategoriesView: View {
    @StateObject private var viewModel: CategoryViewModel
    
    @State private var editMode: EditMode = .inactive
    
    @State private var activeSheet: EditNameSheet?
    
    init(dataManager: DataManager) {
        _viewModel = StateObject(wrappedValue: CategoryViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.Categories.title)
                .environment(\.editMode, $editMode)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            activeSheet = .create
                            editMode = .inactive
                        } label: {
                            Image(systemName: SFSymbols.add)
                        }
                    }
                    
                    if !viewModel.categories.isEmpty {
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
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                        case .create:
                            BusinessCategoryFormView(viewModel: viewModel)

                        case .edit(let category):
                            BusinessCategoryFormView(viewModel: viewModel, category: category as? BusinessCategory)
                        }
                }
                .onChange(of: viewModel.shouldReload, initial: true) { _, reload in
                    if reload {
                        viewModel.loadCategories()
                    }
                }
                .onDisappear() {
                    editMode = .inactive
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.categories.isEmpty {
            EmptyStateView(
                title: L10n.Categories.emptyTitle,
                message: L10n.Categories.emptyMessage,
                systemImage: SFSymbols.categories
            )
        } else {
            List {
                ForEach(viewModel.categories) { category in
                    Button {
                        activeSheet = .edit(category)
                        editMode = .inactive
                    } label: {
                        Text(category.name ?? "")
                    }
                }
                .onDelete(perform: deleteCategories)
            }
        }
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteCategories(offsets: offsets)
        }
    }
}

#Preview {
    BusinessCategoriesView(dataManager: .preview)
}
