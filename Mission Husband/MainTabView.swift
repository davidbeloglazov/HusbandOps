//
//  MainTabView.swift
//  Mission Husband
//
//  Main tab navigation for the app
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Home / Daily Mission
                DailyMissionView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "target.fill" : "target")
                        Text("Mission")
                    }

                // Learning
                LearningView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                        Text("Learning")
                    }

                // Community
                CommunityView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "network.fill" : "network")
                        Text("Network")
                    }

                // Profile
                ProfileView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                        Text("Profile")
                    }
            }
            .tint(AppTheme.accent)
        }
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .accentColor(AppTheme.accent)
    }
}

#Preview {
    MainTabView()
}
