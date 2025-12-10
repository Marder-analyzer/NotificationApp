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
                
                TextFieldComp(title: nil, placeholder: "Rapor başlığını girin", configuration: configuration.createNotificationTitleConfiguration)
                    .onCodeCompletion { text in
                        viewModel.title = text
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Açıklama")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white.opacity(0.7))
                
                TextField("Olay hakkında detaylı bilgi verin", text: $viewModel.description, axis: .vertical)
                    .foregroundStyle(.white)
                    .lineLimit(4...10)
                    .padding()
                    .background(Color.hexConverter(hexString:"#1c2630"))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.2), lineWidth: 1))
                    .accentColor(.white)
                    .onAppear {
                        UITextField.appearance().attributedPlaceholder = NSAttributedString(
                            string: "Olay hakkında detaylı bilgi verin",
                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(Color.hexConverter(hexString: "#8e8e93"))]
                        )
                    }
            }
        }
    }
}



#Preview {
    NotificationDetailsView(viewModel: CreateNotificationViewModel())
}
