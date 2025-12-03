//
//  NotificationRowHeaderView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationRowHeader: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    var body: some View {
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
            
            Text(formattedDate)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Yardımcılar
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd MMM HH:mm"
        return formatter.string(from: notification.date)
    }
}

#Preview {
    NotificationRowHeader(notification: NotificationItem(
        type: .health,
        title: "", description: "", date: Date(), status: .open
    ))
}
