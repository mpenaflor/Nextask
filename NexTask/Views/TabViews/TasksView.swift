//
//  TasksView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-19.
//

import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel: TasksViewModel
    
    @Binding var selectedTab: Tab
    
    @State private var showDeleteAlert = false
    @State private var indexToDelete: IndexSet?
    
    @State var needsFullReload = false

    init(dataManager: DataManager, selectedTab: Binding<Tab>) {
        _viewModel = StateObject(wrappedValue: TasksViewModel(dataManager: dataManager))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.Tasks.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            TaskFormView(viewModel: viewModel)
                        } label: {
                            Image(systemName: SFSymbols.add)
                        }
                    }
                }
                .alert("Delete Task?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let indexSet = indexToDelete {
                            deleteItems(offsets: indexSet)
                            indexToDelete = nil
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {
                        indexToDelete = nil
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
        }
        .onAppear() {
            if needsFullReload {
                viewModel.loadAll()
                needsFullReload = false
            }
        }
        .onChange(of: selectedTab) { prevTab, _ in
            if prevTab == .tasks {
                needsFullReload = true
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.tasks.isEmpty {
            EmptyStateView(
                title: L10n.Tasks.emptyTitle,
                message: L10n.Tasks.emptyMessage,
                systemImage: SFSymbols.tasks
            )
        } else {
            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink {
                        TaskFormView(viewModel: viewModel, task: task)
                    } label: {
                        TaskRowView(viewModel: viewModel, task: task, showAssignee: true)
                    }
                }
                .onDelete { indexSet in
                    indexToDelete = indexSet
                    showDeleteAlert = true
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteTasks(offsets: offsets)
        }
    }
}
