//
//  NotificationDetailInfoRow.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 5.12.2025.
//

import SwiftUI

struct NotificationDetailInfoRow: View {
    let icon: String?
    let color: Color?
    let text: String?
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
							if let color {
								Circle()
								.fill(color.opacity(0.1))
										.frame(width: 36, height: 36)
							}
							if let icon {
								Image(systemName: icon)
										.foregroundColor(color)
										.font(.system(size: 16))
							}
            }
					if let text {
						Text(text)
								.font(.subheadline)
								.foregroundColor(.primary)
								.lineLimit(2)
					}
            
            
            Spacer()
        }
    }
}

#Preview {
    NotificationDetailInfoRow(icon: "calendar",
                              color: .blue,
                              text: "notification.date.toTurkishFormat")
}
