//
//  FilterMenuView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct FilterMenuView<R: Repository>: View where R.Entity == NotificationItem {
    
    @ObservedObject var viewModel: GenericViewModel<R>
    var profile: AuthUser
    
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
            
            if profile.role == "admin",
               let department = profile.department {
                Toggle(isOn: $viewModel.showOnlyMyDepartment) {
                    Label("Yetki Alanım (\(department))", systemImage: NotificationType(rawValue:profile.department ?? "")?.iconName ?? "")
                }
            }
        } label: {
            Image(systemName: isFilterActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isFilterActive ? .white : Color.hexConverter(hexString: "#8e8e93"))
                .padding(10)
                .background(isFilterActive ? .blue : Color.hexConverter(hexString: "#1c2630"))
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
    let repo = RepositoryFactory().makeNotificationRepository()
    let viewModel = GenericViewModel(repository: repo)
    
    FilterMenuView(viewModel: viewModel, profile: AuthUser(id: "", email: ""))
}
