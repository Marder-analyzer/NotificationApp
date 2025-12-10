//
//  NotificationDetailView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    @State private var isFollowed: Bool = false
    @State private var editedStatus: NotificationStatus = .open
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .tint(.white)
                                .bold()
                        }
                        
                        Spacer()
                        
                        Text("Bildirim Detayı")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        NotificationSaveChangesButton {
                            print("a")
                        }

                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(.white.opacity(0.2))
                    
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
            }
            .scrollIndicators(.never)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    NotificationDetailView(notification:  NotificationItem(
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
