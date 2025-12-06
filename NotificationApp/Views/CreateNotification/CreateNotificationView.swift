//
//  CreateNotificationView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct CreateNotificationView: View {
    // MARK: - Değişkenler
    @StateObject private var viewModel = CreateNotificationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                NotificationDetailsView(viewModel: viewModel)
                
                NotificationTypeSelectionView(viewModel: viewModel)
                
                NotificationEvidenceView(viewModel: viewModel)
                
                NotificationSubmitButtonView(viewModel: viewModel)
            }
            .padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Yeni Bildirim Oluştur")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Başarılı", isPresented: $viewModel.showAlert) {
            Button("Tamam") { dismiss() }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    CreateNotificationView()
}
