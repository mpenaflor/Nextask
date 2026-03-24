//
//  SettingsView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-19.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @ObservedObject var dataManager: DataManager
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    TagsView(dataManager: dataManager)
                } label: {
                    Text(L10n.Tags.title)
                }
                
                NavigationLink {
                    BusinessCategoriesView(dataManager: dataManager)
                } label: {
                    Text(L10n.Categories.title)
                }
                
                Section(L10n.Auth.profileSectionTitle) {
                    ProfileSectionView()
                }
                
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: SFSymbols.logout)
                        Text(L10n.Auth.logoutTitle)
                    }
                }
                
            }
            .navigationTitle(L10n.Settings.title)
            .alert(L10n.Auth.logoutTitle, isPresented: $showLogoutAlert) {
                Button(L10n.General.cancel, role: .cancel) {}
                
                Button(L10n.Auth.logoutTitle, role: .destructive) {
                    auth.logout()
                }
            } message: {
                Text(L10n.Auth.logoutAlertMessage)
            }
        }
    }
}

#Preview {
    SettingsView(dataManager: .preview)
}
