//
//  NotificationDetailView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    @State private var isFollowed: Bool = false
    @State private var editedStatus: NotificationStatus
    
    init(notification: NotificationItem) {
        self.notification = notification
        _editedStatus = State(initialValue: notification.status)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    NotificationDetailMapView(notification: notification)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        VStack(spacing: 10) {
                            NotificationDetailHeaderView(
                                notification: notification,
                                currentStatus: $editedStatus
                            )
                            
                            NotificationDetailContentView(notification: notification)
                            
                            NotificationDetailInfoView(notification: notification)
                        }
                        .padding(.horizontal)
                        
                        NotificationDetailPhotosView(notification: notification)
                    }
                }
                .padding(.bottom, 70)
            }
            
            NotificationSaveChangesButton(
                currentStatus: editedStatus,
                originalStatus: notification.status,
                onSave: {
                    print("Veritabanı güncelleniyor: \(editedStatus.rawValue)")
                }
            )
        }
        .scrollIndicators(.never)
        .navigationTitle("Bildirim Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NotificationFollowButton()
            }
        }
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
        coordinate: CLLocationCoordinate2D(latitude: 39.90,
                                           longitude: 41.27),
        imageUrls: ["", ""]
    ))
}
