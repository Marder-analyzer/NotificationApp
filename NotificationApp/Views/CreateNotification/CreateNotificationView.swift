//
//  CreateNotificationView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct CreateNotificationView: View {
    // MARK: - Değişkenler
    @StateObject private var viewModel: CreateNotificationViewModel
    @Environment(\.dismiss) var dismiss
    var showBackButton: Bool = false
    
    init(
        genericVM: GenericViewModel,
        showBackButton: Bool = false
    ) {
        _viewModel = StateObject(
            wrappedValue: CreateNotificationViewModel(genericVM: genericVM)
        )
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 24) {
                        headerView
                        
                        Divider()
                            .background(.white.opacity(0.2))
                        
                        NotificationDetailsView(viewModel: viewModel)
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Bildirim Türü")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white.opacity(0.7))
                            
                            NotificationTypeSelectionView(selectedType: $viewModel.selectedType)
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                    LocationSelectionView(viewModel: viewModel)
                        .padding(.horizontal)
                        .padding(.vertical, 24)
                    
                    NotificationSubmitButtonView(viewModel: viewModel)
                        .padding(.horizontal)
                }
            }
            .scrollIndicators(.never)
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
    
    private var headerView: some View {
        ZStack {
            Text("Yeni Bildirim Oluştur")
                .foregroundStyle(.white)
                .font(.title2)
                .bold()
            
            HStack {
                if showBackButton {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .tint(.white)
                            .bold()
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    CreateNotificationView(
        genericVM: GenericViewModel(),
        showBackButton: false
    )
}
