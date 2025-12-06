//
//  NotificationDetailContentView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailContentView: View {
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text(notification.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(notification.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
    }
}

#Preview {
    NotificationDetailContentView(notification: NotificationItem(
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
