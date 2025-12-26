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
    @ObservedObject var vm: GenericViewModel
    let notification: NotificationItem
    @State private var isFollowed: Bool = false
    @State private var editedStatus: NotificationStatus
    @Environment(\.dismiss) var dismiss
    @StateObject private var followVM: FollowViewModel
    var profile: AuthUser
    
    private var hasChanges: Bool {
        editedStatus != notification.status
    }
    
    init(vm: GenericViewModel, notification: NotificationItem, profile: AuthUser) {
        self.vm = vm
        self.notification = notification
        _editedStatus = State(initialValue: notification.status)
        self.profile = profile
        
        let service = FollowService()
        _followVM = StateObject(
            wrappedValue: FollowViewModel(
                service: service,
                notificationId: notification.id,
                profile: profile
            )
        )
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
                        if profile.role == "admin"{
                            NotificationSaveChangesButton {
                                saveChanges()
                            }
                            .disabled(!hasChanges)
                            .opacity(hasChanges ? 1.0 : 0.4)
                        } else {
                            NotificationFollowButton(vm: followVM)
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
                                currentStatus: $editedStatus, profile: profile
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
        .task {
            await followVM.loadFollowStatus()
        }
    }
    
    private func saveChanges() {
        guard hasChanges else { return }
        
        var updatedNotification = notification
        updatedNotification.status = editedStatus

        vm.update(updatedNotification)
    }
}
