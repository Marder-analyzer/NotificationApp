//
//  ContentView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct HomeView<R: Repository>: View where R.Entity == NotificationItem {
    @StateObject private var vm: GenericViewModel<R>
    
    init(repository: R) {
        _vm = StateObject(wrappedValue: GenericViewModel(repository: repository))
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
                    CustomSearchBar(text: $vm.searchText)
                    
                    Button {
                        vm.sortOrder.toggle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(10)
                            .background(Color.hexConverter(hexString: "#1c2630"))
                            .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
                            .cornerRadius(12)
                    }
                    
                    FilterMenuView(viewModel: vm)
                }
                .padding(.horizontal)
                
                StatusFilterView(
                    selectedIndex: $vm.selectedStatusIndex,
                    options: statusOptions
                )
                
                NotificationRowView2(vm: vm)
                    .padding(.horizontal)
            }
            .onAppear {
                vm.loadNotifications()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationDestination(isPresented: $navigateToAddScreen) {
                CreateNotificationView(showBackButton: true)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview {
    let repo = RepositoryFactory().makeNotificationRepository()
    HomeView(repository: repo)
}
