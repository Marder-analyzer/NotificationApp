//
//  NotificationAdminRowView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 12.12.2025.
//

import SwiftUI

struct NotificationAdminRowView: View {
    let notification: NotificationItem
    
    var onStatusChange: (NotificationStatus) -> Void
    var onDelete: () -> Void
    var onUpdateDescription: (String) -> Void
    
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerSection
            contentSection
            Divider().background(Color.white.opacity(0.5))
            footerSection
            statusSection
        }
        .padding()
        .background(Color.hexConverter(hexString: "#1c2630"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .alert("Bildirimi Sil", isPresented: $showDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Bu işlem geri alınamaz. Bildirim kalıcı olarak silinecektir.")
        }
        .sheet(isPresented: $showEditSheet) {
            AdminEditDescriptionView(description: notification.description) { newText in
                onUpdateDescription(newText)
            }
            .presentationDetents([.medium])
        }
    }
    
    var headerSection: some View {
        HStack(spacing: 8) {
            typeBadge
            Spacer()
            timeInfo
            optionsMenu
        }
    }
    
    var typeBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: notification.type.iconName)
                .font(.caption)
                .padding(6)
                .background(notification.type.color)
                .clipShape(Circle())
                .foregroundColor(.white)
            
            Text(notification.type.rawValue)
                .font(.subheadline)
                .bold()
                .foregroundColor(notification.type.color)
        }
    }
    
    var timeInfo: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
            Text(notification.timeAgo)
        }
        .font(.caption)
        .foregroundColor(.gray)
    }
    
    var optionsMenu: some View {
        Menu {
            Button {
                showEditSheet = true
            } label: {
                Label("Açıklamayı Düzenle", systemImage: "pencil")
            }
            
            Divider()
            
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Bildirimi Sil", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(notification.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(notification.description)
                .font(.subheadline)
                .foregroundColor(Color.hexConverter(hexString: "#9ca3af"))
                .lineLimit(3)
        }
    }
    
    var footerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "person.circle.fill")
                Text(notification.userName ?? "Anonim")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                Text(notification.address)
                    .lineLimit(1)
            }
        }
        .font(.caption)
        .foregroundColor(.white.opacity(0.8))
    }
    
    var statusSection: some View {
        HStack {
            Spacer()
            statusMenu
        }
    }
    
    var statusMenu: some View {
        Menu {
            ForEach(NotificationStatus.allCases, id: \.self) { status in
                Button {
                    onStatusChange(status)
                } label: {
                    if notification.status == status {
                        Label(status.rawValue, systemImage: "checkmark")
                    } else {
                        Text(status.rawValue)
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Circle()
                    .fill(notification.status.color)
                    .frame(width: 8, height: 8)
                
                Text(notification.status.rawValue)
                    .bold()
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
            }
            .font(.caption)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.white.opacity(0.1))
            .foregroundColor(notification.status.color)
            .cornerRadius(8)
        }
    }
}

#Preview {
    NotificationAdminRowView(
        notification: NotificationItem(
            type: .security,
            title: "Kütüphane Arkası Şüpheli Paket",
            description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
            date: "12.12.2025 14:30",
            status: .open,
            userName: "Ahmet Yılmaz",
            address: "Merkezi Yemekhane Önü, Kampüs",
            coordinate: "",
            imageUrls: []
        ),
        onStatusChange: { newStatus in
            print("Yeni durum: \(newStatus.rawValue)")
        },
        onDelete: {
            print("Silme butonuna basıldı")
        },
        onUpdateDescription: { newText in
            print("Yeni açıklama: \(newText)")
        }
    )
}
