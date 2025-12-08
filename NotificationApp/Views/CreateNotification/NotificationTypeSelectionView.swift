//
//  NotificationTypeSelectionView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct NotificationTypeSelectionView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bildirim Türü")
                .font(.title3)
                .bold()
                .foregroundStyle(.white.opacity(0.7))
            
            Picker(selection: $viewModel.selectedType) {
                ForEach(NotificationType.allCases, id: \.self) { type in
                    HStack {
                        Image(systemName: type.iconName)
                            .foregroundColor(type.color)
                        Text(type.rawValue)
                            .foregroundStyle(.white)
                    }
                    .tag(type)
                }
            } label: {
                Text("Tür Seçiniz")
                    .foregroundColor(.white)
            }
            .pickerStyle(NavigationLinkPickerStyle())
            .padding()
            .background(Color.hexConverter(hexString:"#1c2630"))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(.white.opacity(0.2), lineWidth: 1))
        }
    }
}

#Preview {
    NotificationTypeSelectionView(viewModel: CreateNotificationViewModel())
}
