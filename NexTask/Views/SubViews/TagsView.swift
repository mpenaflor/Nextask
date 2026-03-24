//
//  TagsView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-20.
//

import SwiftUI
import CoreData

struct TagsView: View {
    @StateObject private var viewModel: TagViewModel
    
    @State private var editMode: EditMode = .inactive
    
    @State private var activeSheet: EditNameSheet?
    
    init(dataManager: DataManager) {
        _viewModel = StateObject(wrappedValue: TagViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.Tags.title)
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
                    
                    if !viewModel.tags.isEmpty {
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
                            TagFormView(viewModel: viewModel)

                        case .edit(let tag):
                            TagFormView(viewModel: viewModel, tag: tag as? Tag)
                    }
                }
                .onChange(of: viewModel.shouldReload, initial: true) { _, reload in
                    if reload {
                        viewModel.loadTags()
                    }
                }
                .onDisappear() {
                    editMode = .inactive
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.tags.isEmpty {
            EmptyStateView(
                title: L10n.Tags.emptyTitle,
                message: L10n.Tags.emptyMessage,
                systemImage: SFSymbols.tags
            )
        } else {
            List {
                ForEach(viewModel.tags) { tag in
                    Button {
                        activeSheet = .edit(tag)
                        editMode = .inactive
                    } label: {
                        Text(tag.name ?? "")
                    }
                }
                .onDelete(perform: deleteTags)
            }
        }
    }
    
    private func deleteTags(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteTags(offsets: offsets)
        }
    }
}

#Preview {
    TagsView(dataManager: .preview)
}
