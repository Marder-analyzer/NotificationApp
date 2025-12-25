//
//  NotificationRowView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
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
        .background(Color.hexConverter(hexString:"#1c2630"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
}

struct NotificationRowView2<R: Repository>: View where R.Entity == NotificationItem {
    @ObservedObject var vm: GenericViewModel<R>
    var profile: AuthUser
    
    var body: some View {
        
        ScrollView {
            if vm.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(.top, 50)
            } else if vm.homeFilteredNotifications.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bell.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Gösterilecek bildirim bulunamadı.")
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(vm.homeFilteredNotifications) { item in
                        NavigationLink {
                            NotificationDetailView(
                                vm: vm,
                                notification: item,
                                profile: profile
                            )
                            .toolbar(.hidden, for: .tabBar)
                        } label: {
                            NotificationRowView(notification: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .scrollIndicators(.never)
        .background(Color.clear)
    }
}
