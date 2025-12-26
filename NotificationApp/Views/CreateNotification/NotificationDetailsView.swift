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
                
                TextFieldComp(title: nil ,placeholder: "Rapor başlığını girin", configuration: configuration.createNotificationTitleConfiguration)
                    .onCodeCompletion { text in
                        viewModel.title = text
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Açıklama")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white.opacity(0.7))
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.hexConverter(hexString: "#1c2630"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    if viewModel.description.isEmpty {
                        Text("Olay hakkında detaylı bilgi verin")
                            .foregroundStyle(Color.hexConverter(hexString: "#8e8e93"))
                            .padding(.top, 18)
                            .padding(.leading, 15)
                    }
                    
                    TextEditor(text: $viewModel.description)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .foregroundStyle(.white)
                        .accentColor(.white)
                        .padding(10)
                }
                .frame(height: 150)
            }
        }
    }
}



#Preview {
    NotificationDetailsView(viewModel: CreateNotificationViewModel(genericVM: GenericViewModel()))
}
