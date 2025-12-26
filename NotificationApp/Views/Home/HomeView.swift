//
//  ContentView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @StateObject var vm: GenericViewModel
    let profile: AuthUser?
    @State private var searchText = ""
    @State private var showOnlyFollowed = false
    @State private var selectedStatusIndex = 0
    @State private var selectedType: NotificationType?
    @State private var showOnlyMyDepartment = false
    @State private var sortOrder: SortOrder = .newest
    
    var items: [NotificationItem] {
        vm.filteredNotifications(
            query: searchText,
            onlyFollowed: showOnlyFollowed,
            selectedType: selectedType,
            selectedStatusIndex: selectedStatusIndex,
            showOnlyMyDepartment: false,
            sortOrder: sortOrder
        )
    }
    
    init(repository: GenericViewModel, profile: AuthUser) {
        self.profile = profile
        _vm = StateObject(wrappedValue: repository)
    }
    
    @State private var navigateToAddScreen = false
    let statusOptions = ["Tümü", "Açık", "İnceleniyor", "Çözüldü"]
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HomeHeaderView(onAddTapped: {
                    navigateToAddScreen = true
                })
                
                HStack(spacing: 12) {
                    CustomSearchBar(text: $searchText)
                    
                    Button {
                        sortOrder.toggle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(10)
                            .background(Color.hexConverter(hexString: "#1c2630"))
                            .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
                            .cornerRadius(12)
                    }
                    if let profile {
                        FilterMenuView(
                            selectedType: $selectedType,
                            showOnlyFollowed: $showOnlyFollowed,
                            showOnlyMyDepartment: $showOnlyMyDepartment,
                            profile: profile
                        )
                    } else {
                        ProgressView()
                    }
                }
                .padding(.horizontal)
                
                StatusFilterView(
                    selectedIndex: $selectedStatusIndex,
                    options: statusOptions
                )
                
                if let profile {
                    NotificationRowView2(vm: vm, profile: profile, items: items)
                        .padding(.horizontal)
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                guard let profile else { return }
                vm.profile = profile
                vm.loadNotifications()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationDestination(isPresented: $navigateToAddScreen) {
                CreateNotificationView(genericVM: vm,
                                       showBackButton: true)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarHidden(true)
            }
        }

    }
}
