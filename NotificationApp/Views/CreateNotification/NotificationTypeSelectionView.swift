//
//  NotificationTypeSelectionView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationTypeSelectionView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bildirim Türü")
                .font(.title3)
                .bold()
            
            Picker("Tür Seçiniz", selection: $viewModel.selectedType) {
                ForEach(NotificationType.allCases, id: \.self) { type in
                    HStack {
                        Image(systemName: type.iconName)
                            .foregroundColor(type.color)
                        Text(type.rawValue)
                    }
                    .tag(type)
                }
            }
            .pickerStyle(NavigationLinkPickerStyle())
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1))
        }
    }
}

#Preview {
    NotificationTypeSelectionView(viewModel: CreateNotificationViewModel())
}
