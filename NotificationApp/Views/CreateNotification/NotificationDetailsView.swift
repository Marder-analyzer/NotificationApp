//
//  NotificationDetailsView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct NotificationDetailsView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    let configuration = LocationConfiguration()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Başlık")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white.opacity(0.7))
                
                TextFieldComp(title: nil, placeholder: "Rapor başlığını girin", text: $viewModel.title, configuration: configuration.createNotificationTitleConfiguration)
                    .onCodeCompletion { text in
                        viewModel.title = text
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Açıklama")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white.opacity(0.7))
                
                TextFieldComp(title: nil,
                              placeholder: "Olay hakkında detaylı bilgi verin",
                              text: $viewModel.description,
                              configuration: configuration.descriptionConfiguration)
                .onCodeCompletion { text in viewModel.description = text }
            }
        }
    }
}



#Preview {
    NotificationDetailsView(viewModel: CreateNotificationViewModel())
}
