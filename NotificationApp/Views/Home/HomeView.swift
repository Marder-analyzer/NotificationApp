//
//  ContentView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct HomeView: View {
		@StateObject private var viewModel = HomeViewModel()
		@State private var navigateToAddScreen = false
		let statusOptions = ["Tümü", "Açık", "İnceleniyor", "Çözüldü"]

		var body: some View {
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

						ScrollView {
								LazyVStack(spacing: 16) {
										ForEach(viewModel.filteredNotifications) { item in
												NavigationLink(destination: NotificationDetailView(notification: item)) {
														NotificationRowView(notification: item)
												}
												.buttonStyle(PlainButtonStyle())
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
				.navigationDestination(isPresented: $navigateToAddScreen) {
						CreateNotificationView()
				}
				.onTapGesture {
						hideKeyboard()
				}
		}
}


#Preview {
    HomeView()
}
