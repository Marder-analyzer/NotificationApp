//
//  NotificationDetailHeaderView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailHeaderView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    @Binding var currentStatus: NotificationStatus
    var profile: AuthUser
    
    var body: some View {
        HStack(spacing: 15) {
            
            StatusBadgeView(status: $currentStatus, profile: profile) 
            
            HStack(spacing: 6) {
                Image(systemName: notification.type.iconName )
                    .font(.headline)
                Text(notification.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
						.foregroundColor(notification.type.color)
						.background(notification.type.color.opacity(0.1))
            .clipShape(.rect(cornerRadius: 35))
            
            Spacer()
        }
    }
}

#Preview {
    let repo = RepositoryFactory().makeNotificationRepository()
    let vm = GenericViewModel(repository: repo)
    
    NotificationDetailView(vm: vm, notification: NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: "",
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: "",
        imageUrls: [""]
    ), profile: AuthUser(id: "", email: ""))
}
