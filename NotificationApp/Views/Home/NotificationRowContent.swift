//
//  NotificationRowContent.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationRowContent: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(notification.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    NotificationRowContent(notification: NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var.",
        date: Date(),
        status: .open
    ))
    .padding()
}
