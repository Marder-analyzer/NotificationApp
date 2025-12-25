//
//  NotificationDetailPhotosView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailPhotosView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    @State private var selectedImage: SelectedImage?
    
    var body: some View {
			if let images = notification.imageUrls, !images.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Eklenen Fotoğraflar")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 180)
                                .background(.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .onTapGesture {
                                    selectedImage = SelectedImage(imageName: imageName)
                                }
                        }
                    }
                }
                .contentMargins(.horizontal, 20, for: .scrollContent)
            }
            .fullScreenCover(item: $selectedImage) { item in
                FullScreenImageView(imageName: item.imageName)
            }
        }
    }
}
