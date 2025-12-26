//
//  AdminDashboardView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 12.12.2025.
//

import SwiftUI

struct AdminDashboardView: View {
		@StateObject private var vm: GenericViewModel
    var profile: AuthUser
    @State private var selectedSegment = 0
    
    init(repository: GenericViewModel, profile: AuthUser) {
        _vm = StateObject(wrappedValue: repository)
        self.profile = profile
    }
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                headerTitle
                
                StatusFilterView(
                    selectedIndex: $selectedSegment,
                    options: ["Bildirimler", "Kullanıcılar"]
                )
                
                if selectedSegment == 0 {
                    notificationsList
                } else {
                    usersListView
                }
                
                if selectedSegment == 0 {
                    emergencyButton
                }
            }
            .onTapGesture {
                hideKeyboard()
            }

        }
        .onAppear {
            vm.loadNotifications()
        }
    }
    
    private var headerTitle: some View {
        Text("Yönetici Paneli")
            .foregroundStyle(.white)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
    }
    
    private var notificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if vm.isLoading {
                } else if vm.notificationModel.isEmpty {
                } else {
                    ForEach(vm.notificationModel) { item in
                        NavigationLink {
                            NotificationDetailView(
                                vm: vm,
                                notification: item,
                                profile: profile ?? AuthUser(id: "", email: "")
                            )
                            .toolbar(.hidden, for: .tabBar)
                        } label: {
                            NotificationAdminRowView(
                                notification: item,
                                onStatusChange: { newStatus in
                                    updateStatus(for: item, status: newStatus)
                                },
                                onDelete: {
                                    deleteNotification(item)
                                },
                                onUpdateDescription: { newDescription in
                                    updateDescription(for: item, newDescription: newDescription)
                                }
                            )
                        }
                        .buttonStyle(.plain)
                        
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var usersListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(1...5, id: \.self) { i in
                    userRow(index: i)
                }
            }
            .padding(.top, 10)
        }
    }
    
    private func userRow(index: Int) -> some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Kullanıcı Adı \(index)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("kullanici\(index)@email.com")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(index == 1 ? "Admin" : "User")
                .font(.caption2)
                .bold()
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(index == 1 ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .padding()
        .background(Color.hexConverter(hexString: "#1c2630"))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var emergencyButton: some View {
        NavigationLink(destination: CreateEmergencyNotificationView()
            .toolbar(.hidden, for: .tabBar)) {
                HStack(spacing: 10) {
                    Image(systemName: "megaphone.fill")
                        .font(.title3)
                    
                    Text("ACİL DURUM BİLDİRİMİ GÖNDER")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .background(
                LinearGradient(colors: [Color.hexConverter(hexString: "#13181f").opacity(0), Color.hexConverter(hexString: "#13181f")], startPoint: .top, endPoint: .bottom)
                    .frame(height: 100)
                    .offset(y: 20)
            )
    }
    
    private func updateStatus(for item: NotificationItem, status: NotificationStatus) {
        var updatedItem = item
        updatedItem.status = status
        vm.update(updatedItem)
    }
    
    private func deleteNotification(_ item: NotificationItem) {
        vm.delete(item)
    }

    private func updateDescription(for item: NotificationItem, newDescription: String) {
        var updatedItem = item
        updatedItem.description = newDescription
        
        vm.update(updatedItem)
    }
}
