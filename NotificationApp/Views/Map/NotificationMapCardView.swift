//
//  NotificationMapCardView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 11.12.2025.
//

import SwiftUI

struct NotificationMapCardView: View {
    let notification: NotificationItem
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: notification.type.iconName )
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(notification.type.color.gradient)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.type.rawValue)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(notification.type.color)
                        .textCase(.uppercase)
                    
                    Text(notification.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(notification.timeAgo)
                }
                .font(.caption)
                .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
                
                Spacer()
                
                NavigationLink(destination: NotificationDetailView(notification: notification)
                    .toolbar(.hidden, for: .tabBar)) {
                    HStack {
                        Text("Detayı Gör")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.blue.gradient)
                    .clipShape(Capsule())
                    .shadow(radius: 3)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .background(Color.hexConverter(hexString: "#1e293b"))
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    NotificationMapCardView(notification: NotificationItem(
        type: .technical,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: "",
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: "",
        imageUrls: [""]
    ), onClose: {
        
    })
}
