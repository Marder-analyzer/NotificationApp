//
//  PhotoSelectionView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct PhotoSelectionView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Fotoğraf Ekle")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Button {
                        PhotoManager.requestCameraPermission { granted in
                                if granted {
                                    viewModel.showCamera = true
                                } else {
                                    viewModel.cameraPermissionMessage = "Kamera erişimi olmadan fotoğraf çekemezsiniz."
                                    viewModel.showCameraPermissionAlert = true
                                }
                            }
                    } label: {
                        buttonStyle(icon: "camera")
                    }
                    
                    Button {
                        PhotoManager.requestPhotoLibraryPermission { granted in
                            if granted {
                                viewModel.showPicker = true
                            } else {
                                viewModel.cameraPermissionMessage = "Galeri erişimi olmadan fotoğraf seçemezsiniz."
                                viewModel.showCameraPermissionAlert = true
                            }
                        }
                    } label: {
                        buttonStyle(icon: "photo.on.rectangle")
                    }
                    .photosPicker(
                        isPresented: $viewModel.showPicker,
                        selection: $viewModel.selectedItems,
                        maxSelectionCount: 5,
                        matching: .images
                    )
                    .onChange(of: viewModel.selectedItems) { _ in
                        Task { await viewModel.convertPhotos() }
                    }
                    
                    ForEach(viewModel.selectedImages, id: \.self) { image in
                        selectedImageView(image)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.vertical, 5)
            }
            .contentMargins(.horizontal, 20, for: .scrollContent)
            .animation(.spring(), value: viewModel.selectedImages)
        }
        .alert("İzin Gerekli", isPresented: $viewModel.showCameraPermissionAlert) {
            Button("Ayarlar") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("İptal", role: .cancel) {}
        } message: {
            Text(viewModel.cameraPermissionMessage)
        }
    }
    
    private func buttonStyle(icon: String) -> some View {
        Image(systemName: icon)
            .foregroundStyle(.white.opacity(0.4))
            .font(.largeTitle)
            .frame(width: 90, height: 90)
            .background(Color.hexConverter(hexString: "#1c2630"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        .white.opacity(0.2),
                        style: StrokeStyle(lineWidth: 1, dash: [5, 5])
                    )
            )
    }
    
    private func selectedImageView(_ image: UIImage) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.2), lineWidth: 1))
            
            Button {
                withAnimation {
                    if let index = viewModel.selectedImages.firstIndex(of: image) {
                        viewModel.selectedImages.remove(at: index)
                    }
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.red)
                    .background(Circle().fill(.white))
            }
            .offset(x: 6, y: -6)
        }
    }
}

#Preview {
    PhotoSelectionView(viewModel: CreateNotificationViewModel())
}
