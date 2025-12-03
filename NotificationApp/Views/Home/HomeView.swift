//
//  ContentView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Değişkenler
    @StateObject private var viewModel = HomeViewModel()
    
    let statusOptions = ["Tümü", "Açık", "İnceleniyor", "Çözüldü"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HomeHeaderView(onAddTapped: {
                    print("Yeni bildirim ekle tıklandı")
                })
                
                HStack(spacing: 12) {
                    
                    CustomSearchBar(text: $viewModel.searchText)
                    
                    FilterMenuView(viewModel: viewModel)
                }
                .padding(.horizontal)
                
                StatusFilterView(selectedIndex: $viewModel.selectedStatusIndex, options: statusOptions)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredNotifications) { item in
                            NotificationRowView(notification: item)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color(.systemGroupedBackground))
                .scrollIndicators(.never)
            }
            .navigationBarHidden(true)
            .background(Color.white)
        }
    }
}

#Preview {
    HomeView()
}
