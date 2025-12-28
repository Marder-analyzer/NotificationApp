//
//  CreateEmergencyNotificationView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 12.12.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct CreateEmergencyNotificationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: CreateNotificationViewModel
    
    let configuration = LocationConfiguration()
    @State private var showConfirmationAlert = false
    
    init(genericVM: GenericViewModel) {
        _viewModel = StateObject(
            wrappedValue: CreateNotificationViewModel(genericVM: genericVM)
        )
    }
    
    var body: some View {
        ZStack {
            Color.hexConverter(hexString: "#13181f")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerView
                    
                    Divider()
                        .background(.white.opacity(0.2))
                    
                    formContent
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .navigationBarHidden(true)
        .onTapGesture { hideKeyboard() }
        .alert("Acil Durum Yayını", isPresented: $showConfirmationAlert, actions: alertActions, message: alertMessage)
        .alert("Bilgi", isPresented: $viewModel.showAlert) { Button("Tamam") { } } message: { Text(viewModel.alertMessage) }
    }
    
    private var headerView: some View {
        ZStack {
            Text("Acil Durum Bildirimi Oluştur")
                .foregroundStyle(.red)
                .font(.title2)
                .bold()
            
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .tint(.white)
                        .bold()
                }
                Spacer()
            }
        }
    }
    
    private var formContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
            descriptionSection
            
            LocationSelectionView(viewModel: viewModel)
                .padding(.top, 10)
            
            submitButton
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Başlık")
            TextFieldComp(
                title: nil,
                placeholder: "Rapor başlığını girin",
                configuration: configuration.createNotificationTitleConfiguration
            )
            .onCodeCompletion { viewModel.title = $0 }
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Açıklama")
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.hexConverter(hexString: "#1c2630"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.2), lineWidth: 1))
                
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
    
    private func buttonStyle(icon: String) -> some View {
        Image(systemName: icon)
            .font(.title2)
            .frame(width: 80, height: 80)
            .foregroundStyle(.white.opacity(0.8))
            .background(Color.hexConverter(hexString: "#1c2630"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.white.opacity(0.3))
            )
    }
    
    private var submitButton: some View {
        Button {
            if viewModel.isValid {
                showConfirmationAlert = true
            } else {
                viewModel.alertMessage = "Lütfen başlık ve açıklama alanlarını doldurunuz."
                viewModel.showAlert = true
            }
        } label: {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView().tint(.white)
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("ACİL DURUM YAYINLA")
                }
            }
            .font(.headline)
            .bold()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(15)
            .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 20)
        .disabled(viewModel.isSubmitting)
        .opacity(viewModel.isSubmitting ? 0.7 : 1)
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.white.opacity(0.8))
    }
    
    @ViewBuilder
    private func alertActions() -> some View {
        Button("İptal", role: .cancel) { }
        Button("YAYINLA", role: .destructive) {
            viewModel.selectedType = .security
            viewModel.submitNotification { dismiss() }
        }
    }
    
    private func alertMessage() -> some View {
        Text("Bu bildirim tüm kullanıcılara acil durum uyarısı olarak gönderilecektir. Onaylıyor musunuz?")
    }
}

#Preview {
    CreateEmergencyNotificationView(genericVM: GenericViewModel())
}
