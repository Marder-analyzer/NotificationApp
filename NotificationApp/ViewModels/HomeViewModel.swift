//
//  HomeViewModel.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import Foundation
import Combine
import _MapKit_SwiftUI

// MARK: - Ana Ekran ViewModel
class HomeViewModel: ObservableObject {
    
    // MARK: - Değişkenler
    @Published var notifications: [NotificationItem] = []
    
    @Published var searchText: String = ""
    @Published var selectedStatusIndex: Int = 0
    
    @Published var selectedType: NotificationType? = nil
    @Published var showOnlyFollowed: Bool = false
    @Published var showOnlyMyDepartment: Bool = false
    
    let currentUserRole = "Admin"
    let currentUserDepartment = NotificationType.health
    
    init() {
        fetchNotifications()
    }
    
    // MARK: - Sahte Veri(Şimdilik)
    func fetchNotifications() {
        let mockData = [
            NotificationItem(
                type: .security,
                title: "Kütüphane Arkası Şüpheli Paket",
                description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
                date: Date(),
                status: .open,
                userName: "Ahmet Yılmaz",
                address: "Merkezi Yemekhane Önü, Kampüs",
                coordinate: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
                imageUrls: [""]
            ),
            NotificationItem(
                type: .health,
                title: "Yemekhane Önü Baygınlık",
                description: "Bir öğrenci fenalaştı, acil müdahale gerekiyor.",
                date: Date().addingTimeInterval(-3600),
                status: .investigating,
                userName: "Ahmet Yılmaz",
                address: "Merkezi Yemekhane Önü, Kampüs",
                coordinate: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
                imageUrls: [""]
            ),
            NotificationItem(
                type: .technical,
                title: "Projeksiyon Arızası",
                description: "D-102 nolu sınıfta projeksiyon cihazı çalışmıyor.",
                date: Date().addingTimeInterval(-86400),
                status: .resolved,
                userName: "Ahmet Yılmaz",
                address: "Merkezi Yemekhane Önü, Kampüs",
                coordinate: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
                imageUrls: [""]
            )
        ]
        
        self.notifications = mockData.sorted(by: { $0.date > $1.date })
    }

    // MARK: - Gelişmiş Filtreleme Mantığı (Logic)
    var filteredNotifications: [NotificationItem] {
        
        return notifications.filter { item in
            let matchesSearch = searchText.isEmpty ||
            item.title.localizedCaseInsensitiveContains(searchText) ||
            item.description.localizedCaseInsensitiveContains(searchText)
            
            let matchesStatus: Bool
            switch selectedStatusIndex {
            case 0: matchesStatus = true
            case 1: matchesStatus = item.status == .open
            case 2: matchesStatus = item.status == .investigating
            case 3: matchesStatus = item.status == .resolved
            default: matchesStatus = true
            }
            
            let matchesType = (selectedType == nil) || (item.type == selectedType)
            
            let matchesFollowed = !showOnlyFollowed || (showOnlyFollowed == true )
            
            let matchesAdminScope = !showOnlyMyDepartment || (item.type == currentUserDepartment)
            
            return matchesSearch && matchesStatus && matchesType && matchesFollowed && matchesAdminScope
        }
        .sorted(by: { $0.date > $1.date })
    }
}

