//
//  ContentView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    @ObservedObject var dataManager: DataManager
    
    @State private var selectedTab: Tab = .tasks
    
    var body: some View {
        Group {
            if auth.isLoggedIn {
                TabView(selection: $selectedTab){
                    TasksView(dataManager: dataManager, selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: SFSymbols.tasks)
                            Text(L10n.Tasks.title)
                        }
                        .tag(Tab.tasks)

                    PeopleView(dataManager: dataManager, selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: SFSymbols.people)
                            Text(L10n.People.title)
                        }
                        .tag(Tab.people)
                    
                    BusinessView(dataManager: dataManager, selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: SFSymbols.business)
                            Text(L10n.Business.title)
                        }
                        .tag(Tab.businesses)

                    SettingsView(dataManager: dataManager)
                        .tabItem {
                            Image(systemName: SFSymbols.settings)
                            Text(L10n.Settings.title)
                        }
                        .tag(Tab.settings)
                }
            } else {
                LoginView()
            }
        }
        .onChange(of: auth.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                selectedTab = .tasks
            }
        }
    }
}

#Preview {
    //ContentView(dataManager: .preview)
}
