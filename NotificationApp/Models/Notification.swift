//
//  NotificationItem.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import Foundation
import SwiftUI
import CoreLocation

// MARK: - Bildirim Türleri (Enum)
enum NotificationType: String, CaseIterable {
    case security = "Güvenlik"
    case health = "Sağlık"
    case technical = "Teknik Arıza"
    case lostFound = "Kayıp/Buluntu"
    case environmental = "Çevre"

    var iconName: String {
        switch self {
        case .security: return "shield.fill"
        case .health: return "staroflife.fill"
        case .technical: return "wrench.and.screwdriver.fill"
        case .lostFound: return "magnifyingglass"
        case .environmental: return "leaf.fill"
        }
    }

    var color: Color {
        switch self {
        case .security: return .red
        case .health: return .blue
        case .technical: return .orange
        case .lostFound: return .purple
        case .environmental: return .green
        }
    }
}

// MARK: - Bildirim Durumları (Enum)
enum NotificationStatus: String, CaseIterable {
    case open = "Açık"
    case investigating = "İnceleniyor"
    case resolved = "Çözüldü"
    
    var color: Color {
        switch self {
        case .open: return .red
        case .investigating: return .yellow
        case .resolved: return .green
        }
    }
}

// MARK: - Bildirim Veri Modeli (Model)
struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let description: String
    let date: Date
    let status: NotificationStatus
    let userName: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let imageUrls: [String]
}

struct SelectedImage: Identifiable {
    let id = UUID()
    let imageName: String
}
