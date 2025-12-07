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
				Image(systemName: notification.type?.iconName ?? "")
					.foregroundColor(notification.type?.color)
				
				Text(notification.type?.rawValue ?? "")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(notification.type?.color)
			}
			
			Spacer()
			
			Text(notification.date?.toTurkishFormat ?? "")
				.font(.caption)
				.foregroundColor(.gray)
		}
	}
}
