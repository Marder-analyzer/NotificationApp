//
//  FollowingNotificationsView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 13.12.2025.
//

import SwiftUI

struct FollowingNotificationsView<R: Repository>: View where R.Entity == NotificationItem {
    @StateObject private var vm: GenericViewModel<R>
    @StateObject var authCoordinator = AuthCoordinator()
    @State var profile: AuthUser?
    @State private var selectedSegment = 0
    
    init(repository: R) {
        _vm = StateObject(wrappedValue: GenericViewModel(repository: repository))
    }
    
    let configuration = HomeConfiguration()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                headerView
                
                searchBar
                
                ScrollView {
                    if vm.isLoading {
                        ProgressView().tint(.white).padding(.top, 50)
                    }
                    else if vm.followingFilteredNotifications.isEmpty {
                        emptyStateView
                    }
                    else {
                        LazyVStack(spacing: 16) {
                            ForEach(vm.followingFilteredNotifications) { item in
                                
                                NavigationLink {
                                    NotificationDetailView(
                                        vm: vm,
                                        notification: item,
                                        profile: profile ?? AuthUser(id: "", email: "")
                                     )
                                    .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    FollowingNotificationRow(notification: item) {
                                        vm.toggleFollow(for: item)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            vm.showOnlyFollowed = true
            vm.loadNotifications()
            authCoordinator.loadProfileUser { profile in
                self.profile = profile
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var headerView: some View {
        ZStack {
            Text("Takip Ettiklerim")
                .foregroundStyle(.white)
                .font(.title2)
                .bold()
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.white)
                        .bold()
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
            
            TextFieldComp(
                title: nil,
                placeholder: "Takip ettiklerinde ara...",
                configuration: configuration.homeConfiguration
            )
            .onCodeCompletion { text in
                vm.followingSearchText = text
            }
        }
        .padding(10)
        .background(Color.hexConverter(hexString: "#1c2630"))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("Henüz takip ettiğiniz bir bildirim yok.")
                .foregroundColor(.gray)
        }
        .padding(.top, 50)
    }
}

#Preview {
    let repo = RepositoryFactory().makeNotificationRepository()
    FollowingNotificationsView(repository: repo)
}
