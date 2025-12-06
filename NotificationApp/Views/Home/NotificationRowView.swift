//
//  NotificationRowView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationRowView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            NotificationRowHeader(notification: notification)
            
            Divider()
            
            NotificationRowContent(notification: notification)
            
            NotificationRowFooter(notification: notification)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
}

#Preview {
    NotificationRowView(notification: NotificationItem(
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
