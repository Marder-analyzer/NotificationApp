//
//  NotificationDetailPhotosView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 5.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailPhotosView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    @State private var selectedImage: SelectedImage?
    
    var body: some View {
        if !notification.imageUrls.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Eklenen Fotoğraflar")
                    .font(.title3)
                    .bold()
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(notification.imageUrls, id: \.self) { imageName in
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

#Preview {
    NotificationDetailPhotosView(notification: NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: Date(),
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: CLLocationCoordinate2D(latitude: 39.90,
                                           longitude: 41.27),
        imageUrls: ["", ""]
    ))
}
