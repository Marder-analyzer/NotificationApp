//
//  FollowingNotificationRow.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 13.12.2025.
//

import SwiftUI

struct FollowingNotificationRow: View {
    let notification: NotificationItem
    var onUnfollow: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            iconView
            
            contentView
            
            unfollowButton
        }
        .padding()
        .background(Color.hexConverter(hexString: "#1c2630"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
        
    private var iconView: some View {
        Image(systemName: notification.type.iconName)
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(notification.type.color)
            .clipShape(Circle())
            .shadow(color: notification.type.color.opacity(0.3), radius: 3, x: 0, y: 2)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(notification.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(notification.description)
                .font(.subheadline)
                .foregroundColor(Color.hexConverter(hexString: "#9ca3af"))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            footerInfo
        }
    }
    
    private var footerInfo: some View {
        HStack(spacing: 10) {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                Text(notification.timeAgo)
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            Spacer()
            
            Text(notification.status.rawValue)
                .font(.caption2)
                .bold()
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(notification.status.color.opacity(0.15))
                .foregroundColor(notification.status.color)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(notification.status.color.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var unfollowButton: some View {
        Button(action: onUnfollow) {
            VStack(spacing: 4) {
                Image(systemName: "bookmark.fill")
                    .font(.title3)
            }
            .foregroundColor(.blue)
            .frame(width: 40, height: 40)
            .shadow(color: .blue.opacity(0.3), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FollowingNotificationRow(notification:  NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: "",
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: ""
    ), onUnfollow: {
        print("unfollow")
    })
}
