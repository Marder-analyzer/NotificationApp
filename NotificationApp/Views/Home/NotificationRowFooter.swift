//
//  NotificationRowFooter.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

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
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: "",
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: ""
    ))
    .padding()
}
