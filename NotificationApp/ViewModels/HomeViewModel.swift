//
//  HomeViewModel.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
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
				.sorted(by: { $0.date ?? .now > $1.date ?? .now })
    }
}

