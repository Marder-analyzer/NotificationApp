//
//  NotificationRowHeaderView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
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
			HStack(spacing: 10) {
				Image(systemName: notification.type.iconName )
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(6)
                    .background(notification.type.color)
                    .clipShape(Circle())
				
				Text(notification.type.rawValue )
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(notification.type.color)
			}
			
			Spacer()
			
			Text(notification.date ?? "")
				.font(.caption)
				.foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
		}
	}
}
