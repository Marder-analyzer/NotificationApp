//
//  NotificationDetailInfoRow.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI

struct NotificationDetailInfoRow: View {
    let icon: String?
    let text: String?
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundColor(Color.hexConverter(hexString: "#9ca3af"))
                    .font(.system(size: 16))
            }
            
            if let text {
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(Color.hexConverter(hexString: "#d1d5db"))
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NotificationDetailInfoRow(icon: "calendar",
                              text: "notification.date.toTurkishFormat")
}
