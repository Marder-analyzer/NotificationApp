//
//  NotificationDetailInfoView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 5.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailInfoView: View {
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            NotificationDetailInfoRow(icon: "calendar", color: .blue, text: notification.date?.toTurkishFormat)
            
					NotificationDetailInfoRow(icon: "person.fill", color: .purple, text: notification.userName)
            
					NotificationDetailInfoRow(icon: "mappin.and.ellipse", color: .red, text: notification.address)
        }
        .padding(.top, 10)
    }
}

#Preview {
    NotificationDetailView(notification: NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: Date(),
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: "",
        imageUrls: [""]
    ))
}
