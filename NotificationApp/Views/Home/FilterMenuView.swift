//
//  FilterMenuView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct FilterMenuView: View {
    // MARK: - Değişkenler
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Menu {
            Picker("Bildirim Türü", selection: $viewModel.selectedType) {
                Text("Tüm Türler").tag(Optional<NotificationType>.none)
                ForEach(NotificationType.allCases, id: \.self) { type in
                    Label(type.rawValue, systemImage: type.iconName)
                        .tag(Optional(type))
                }
            }
            
            Divider()
            
            Toggle(isOn: $viewModel.showOnlyFollowed) {
                Label("Sadece Takip Ettiklerim", systemImage: "heart.fill")
            }
            
            if viewModel.currentUserRole == "Admin" {
                Toggle(isOn: $viewModel.showOnlyMyDepartment) {
                    Label("Yetki Alanım (\(viewModel.currentUserDepartment.rawValue))", systemImage: "building.shield.fill")
                }
            }
            
        } label: {
            Image(systemName: isFilterActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isFilterActive ? .blue : .gray)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
    
    private var isFilterActive: Bool {
        return viewModel.selectedType != nil ||
        viewModel.showOnlyFollowed ||
        viewModel.showOnlyMyDepartment
    }
}

#Preview {
    FilterMenuView(viewModel: HomeViewModel())
}
