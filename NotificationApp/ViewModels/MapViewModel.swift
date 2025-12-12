//
//  MapViewModel.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 11.12.2025.
//
import Combine
import Foundation

@MainActor
class MapViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var isLoading = false
    
    func fetchNotifications() {
        isLoading = true
        let dataSource = NetworkDataSource<NotificationItem>()
        Task {
            do {
                let items = try await dataSource.fetch()
                self.notifications = items.filter { $0.locationCoordinate != nil }
                self.isLoading = false
            } catch {
                print("Map Data Error: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
}
