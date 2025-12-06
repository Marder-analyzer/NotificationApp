//
//  NotificationRowHeaderView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationRowHeader: View {
	// MARK: - Değişkenler
	let notification: NotificationItem
	
	var body: some View {
		header()
	}
	
	@ViewBuilder
	func header() -> some View {
		HStack {
			HStack(spacing: 6) {
				Image(systemName: notification.type.iconName)
					.foregroundColor(notification.type.color)
				
				Text(notification.type.rawValue)
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(notification.type.color)
			}
			
			Spacer()
			
			Text(notification.date.toTurkishFormat)
				.font(.caption)
				.foregroundColor(.gray)
		}
	}
}

#Preview {
	NotificationRowHeader(notification: NotificationItem(
		type: .security,
		title: "Kütüphane Arkası Şüpheli Paket",
		description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
		date: Date(),
		status: .open,
		userName: "Ahmet Yılmaz",
		address: "Merkezi Yemekhane Önü, Kampüs",
		coordinate: CLLocationCoordinate2D(latitude: 39.90,
																			 longitude: 41.27),
		imageUrls: [""]
	))
}
