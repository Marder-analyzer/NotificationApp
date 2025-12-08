//
//  PhotoSelectionView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct PhotoSelectionView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Fotoğraf Ekle")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15) {
                NotificationCameraButton(viewModel: viewModel)
                NotificationGalleryButton(viewModel: viewModel)
            }
            .buttonStyle(PlainButtonStyle())
            
            NotificationImagePreview(viewModel: viewModel)
        }
        .padding(.vertical, 5)
        .onChange(of: viewModel.selectedItem) { _, _ in
            Task { await viewModel.convertPhoto() }
        }
    }
}

#Preview {
    PhotoSelectionView(viewModel: CreateNotificationViewModel())
}
