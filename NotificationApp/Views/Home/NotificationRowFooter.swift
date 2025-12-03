//
//  NotificationRowFooter.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationRowFooter: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(notification.status.rawValue)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(notification.status.color.opacity(0.2))
                .foregroundColor(notification.status.color)
                .cornerRadius(8)
        }
    }
}

#Preview {
    NotificationRowFooter(notification: NotificationItem(
        type: .technical,
        title: "", description: "", date: Date(), status: .investigating
    ))
    .padding()
}
