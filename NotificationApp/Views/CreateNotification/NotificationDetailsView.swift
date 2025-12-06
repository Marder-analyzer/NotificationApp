//
//  NotificationDetailsView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationDetailsView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Başlık")
                    .font(.title3)
                    .bold()
                
                TextField("Rapor başlığını girin", text: $viewModel.title)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1))
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Açıklama")
                    .font(.title3)
                    .bold()
                
                TextField("Olay hakkında detaylı bilgi verin", text: $viewModel.description, axis: .vertical)
                    .lineLimit(4...10)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1))
                    
            }
        }
    }
}

#Preview {
    NotificationDetailsView(viewModel: CreateNotificationViewModel())
}
