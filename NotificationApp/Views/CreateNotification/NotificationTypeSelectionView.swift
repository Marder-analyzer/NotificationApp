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
            
            Menu {
                Picker("Tür Seçiniz", selection: $viewModel.selectedType) {
                    ForEach(NotificationType.allCases, id: \.self) { type in
                        Label(type.rawValue, systemImage: type.iconName)
                            .tag(type)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: viewModel.selectedType.iconName)
                        .foregroundColor(viewModel.selectedType.color)
                        .font(.title3)
                    
                    Text(viewModel.selectedType.rawValue)
                        .foregroundStyle(.white)
                        .bold()
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.caption)
                }
                .padding()
                .background(Color.hexConverter(hexString: "#1c2630"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
            }
            
        }
    }
}

#Preview {
    NotificationTypeSelectionView(viewModel: CreateNotificationViewModel())
}
