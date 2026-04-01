//
//  NotificationSubmitButtonView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct NotificationSubmitButtonView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        Button(action: {
            viewModel.submitNotification {
            }
        }) {
            Text("Bildirimi Oluştur")
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue.gradient)
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    NotificationSubmitButtonView(
        viewModel: CreateNotificationViewModel(
            genericVM: GenericViewModel()
        )
    )
}
