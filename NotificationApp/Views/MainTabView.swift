//
//  MainTabView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 8.12.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection: Int = 0
    var userRole: String = "Admin"
    private let notificationRepo = RepositoryFactory().makeNotificationRepository()
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Anasayfa", systemImage: "house.fill", value: 0) {
                NavigationStack {
                    
                    HomeView(repository: notificationRepo)
                        .navigationBarHidden(true)
                }
            }
            Tab("Harita", systemImage: "map.fill", value: 1) {
                NavigationStack {
                    MapView(vm: GenericViewModel(repository: notificationRepo))
                        .navigationBarHidden(true)
                }
            }
            Tab("Oluştur", systemImage: "plus.circle.fill", value: 2) {
                NavigationStack {
                    CreateNotificationView()
                        .navigationBarHidden(true)
                }
            }
            Tab("Profil", systemImage: "person.fill", value: 3) {
                NavigationStack {
									ProfileView()
										.navigationBarHidden(true)
//                    FollowingNotificationsView(repository: notificationRepo)
//                        .navigationBarHidden(true)
                }
            }
            if userRole == "Admin" {
                Tab("Yönetici", systemImage: "shield.righthalf.filled", value: 4) {
                    NavigationStack {
                        AdminDashboardView(repository: notificationRepo)
                            .navigationBarHidden(true)
                    }
                }
            }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
