//
//  MainTabView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 8.12.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection: Int = 0
    @StateObject var authCoordinator = AuthCoordinator()
    @State private var profile: AuthUser? = nil
    private let notificationRepo = RepositoryFactory().makeNotificationRepository()
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Anasayfa", systemImage: "house.fill", value: 0) {
                if let profile {
                        HomeView(repository: notificationRepo, profile: profile)
                            .navigationBarHidden(true)
                } else {
                    ZStack {
                        Color.hexConverter(hexString: "#13181f")
                            .ignoresSafeArea()
                        ProgressView()
                    }
                }
            }
            Tab("Harita", systemImage: "map.fill", value: 1) {
                if let profile {
                    MapView(repository: notificationRepo, profile: profile)
                        .navigationBarHidden(true)
                } else {
                    ZStack {
                        Color.hexConverter(hexString: "#13181f")
                            .ignoresSafeArea()
                        ProgressView()
                    }
                }

            }
            Tab("Oluştur", systemImage: "plus.circle.fill", value: 2) {
                CreateNotificationView()
                    .navigationBarHidden(true)
            }
            Tab("Profil", systemImage: "person.fill", value: 3) {
                    ProfileView()
                        .navigationBarHidden(true)
            }
            if let profile = profile, profile.role == "admin" {
                Tab("Yönetici", systemImage: "shield.righthalf.filled", value: 4) {
                    AdminDashboardView(repository: notificationRepo, profile: profile )
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            authCoordinator.loadProfileUser { profile in
                self.profile = profile
            }
        }
        .tint(.blue)
    }
}

//#Preview {
//    MainTabView()
//}
