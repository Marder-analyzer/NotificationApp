//
//  NotificationRowContent.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationRowContent: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.title ?? "")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(notification.description ?? "")
                .font(.subheadline)
                .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    NotificationRowContent(notification: NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: "",
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: "",
        imageUrls: [""]
    ))
    .padding()
}
