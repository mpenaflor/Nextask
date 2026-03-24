//
//  PeopleView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-19.
//

import SwiftUI
import CoreData

struct PeopleView: View {
    @StateObject private var viewModel: PeopleViewModel
    
    @State private var editMode: EditMode = .inactive
    
    @Binding var selectedTab: Tab
    
    @State var needsFullReload = false

    init(dataManager: DataManager, selectedTab: Binding<Tab>) {
        _viewModel = StateObject(wrappedValue: PeopleViewModel(dataManager: dataManager))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.People.title)
                .environment(\.editMode, $editMode)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            PersonFormView(viewModel: viewModel)
                        } label: {
                            Image(systemName: SFSymbols.add)
                        }
                    }
                    
                    if !viewModel.people.isEmpty {
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
                    if needsFullReload {
                        viewModel.loadAll()
                        needsFullReload = false
                    }
                }
                .onDisappear() {
                    editMode = .inactive
                }
        }
        .onChange(of: selectedTab) { prevTab, _ in
            if prevTab == .people {
               needsFullReload = true
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.people.isEmpty {
            EmptyStateView(
                title: L10n.People.emptyTitle,
                message: L10n.People.emptyMessage,
                systemImage: SFSymbols.people
            )
        } else {
            List {
                ForEach(viewModel.people) { person in
                    NavigationLink {
                        PersonFormView(viewModel: viewModel, person: person)
                    } label: {
                        PersonRowView(viewModel: viewModel, person: person)
                    }
                }
                .onDelete(perform: deletePeople)
            }
        }
    }
    
    private func deletePeople(offsets: IndexSet) {
        withAnimation {
            viewModel.deletePeople(offsets: offsets)
        }
    }
}

#Preview {
    PeopleView(dataManager: .preview, selectedTab: .constant(.people))
}
