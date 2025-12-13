//
//  NotificationDetailView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailView<R: Repository>: View where R.Entity == NotificationItem {
    
    // MARK: - Değişkenler
    @ObservedObject var vm: GenericViewModel<R>
    let notification: NotificationItem
    @State private var isFollowed: Bool = false
    @State private var editedStatus: NotificationStatus
    @Environment(\.dismiss) var dismiss
    var userRole: String = "Admin"
    
    private var hasChanges: Bool {
        editedStatus != notification.status
    }
    
    init(vm: GenericViewModel<R>, notification: NotificationItem) {
        self.vm = vm
        self.notification = notification
        _editedStatus = State(initialValue: notification.status)
    }
    
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
                        if userRole == "Admin" {
                            NotificationSaveChangesButton {
                                saveChanges()
                            }
                            .disabled(!hasChanges)
                            .opacity(hasChanges ? 1.0 : 0.4)
                        } else {
                            NotificationFollowButton()
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
                                currentStatus: $editedStatus, userRole: userRole
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
    
    private func saveChanges() {
        guard hasChanges else { return }
        
        var updatedNotification = notification
        updatedNotification.status = editedStatus

        vm.update(updatedNotification)
    }
}

#Preview {
    let repo = RepositoryFactory().makeNotificationRepository()
    let vm = GenericViewModel(repository: repo)
    
    NotificationDetailView(vm: vm, notification:  NotificationItem(
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
}
