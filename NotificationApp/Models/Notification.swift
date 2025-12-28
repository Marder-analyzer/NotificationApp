//
//  NotificationItem.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import Foundation
import SwiftUI
import CoreLocation
internal import MapKit

// MARK: - Bildirim Türleri (Enum)
enum NotificationType: String, Codable, CaseIterable {
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
enum NotificationStatus: String, Codable, CaseIterable {
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
struct NotificationItem: Codable, Identifiable, Equatable, FirebaseSaveable {
    var id: String
	let type: NotificationType
	let title: String
	var description: String
	let date: String?
	var status: NotificationStatus
	let userName: String?
	let address: String
	let coordinate: String
	var isFollowed: Bool = false
	let isEmergency: Bool?
    
	init(id: String = UUID().uuidString, type: NotificationType, title: String, description: String, date: String?, status: NotificationStatus, userName: String?, address: String, coordinate: String, isFollowed: Bool = false, isEmergency: Bool? = nil) {
        self.id = id
		self.type = type
		self.title = title
		self.description = description
		self.date = date
		self.status = status
		self.userName = userName
		self.address = address
		self.coordinate = coordinate
        self.isFollowed = isFollowed
		self.isEmergency = isEmergency
	}
    
    static func == (lhs: NotificationItem, rhs: NotificationItem) -> Bool {
        return lhs.id == rhs.id && lhs.status == rhs.status && lhs.isFollowed == rhs.isFollowed
    }
    
    var locationCoordinate: CLLocationCoordinate2D? {
        let components = coordinate.split(separator: ",")
        guard components.count == 2,
              let lat = Double(components[0].trimmingCharacters(in: .whitespaces)),
              let lon = Double(components[1].trimmingCharacters(in: .whitespaces)) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    var dateObject: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.date(from: self.date ?? "")
    }
    
    var timeAgo: String {
        guard let dateObj = dateObject else { return date ?? "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.localizedString(for: dateObj, relativeTo: Date())
    }
}

extension NotificationItem {
	func toDictionary() -> [String: Any] {
		var dict: [String: Any] = [
			"id": id,
			"type": type.rawValue,
			"title": title,
			"description": description,
			"date": date,
			"status": status.rawValue,
			"userName": userName,
			"address": address,
			"coordinate": coordinate,
			"isFollowed" : isFollowed,
		]
		
		if let isEmergency {
			dict["isEmergency"] = isEmergency
		}
		return dict
	}
}
