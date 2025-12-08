//
//  MainTabView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 8.12.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                NavigationStack {
                    HomeView()
                }
            }
            Tab("Map", systemImage: "map.fill", value: 1) {
                NavigationStack {
                    HomeView()
                }
            }
            Tab("Create", systemImage: "plus.circle.fill", value: 2) {
                NavigationStack {
                    CreateNotificationView()
                }
            }
            Tab("Profile", systemImage: "person.fill", value: 3) {
                NavigationStack {
                    HomeView()
                }
            }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
