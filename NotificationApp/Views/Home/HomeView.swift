//
//  ContentView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
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
                    CustomSearchBar(text: $viewModel.searchText)
                    FilterMenuView(viewModel: viewModel)
                }
                .padding(.horizontal)
                
                StatusFilterView(
                    selectedIndex: $viewModel.selectedStatusIndex,
                    options: statusOptions
                )
                
                let repo = RepositoryFactory().makeNotificationRepository()
                NotificationRowView2(repository: repo)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationDestination(isPresented: $navigateToAddScreen) {
                CreateNotificationView(showBackButton: true)
                    .toolbar(.hidden, for: .tabBar)

                    
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
