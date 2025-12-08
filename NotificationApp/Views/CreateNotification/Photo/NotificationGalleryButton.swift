//
//  NotificationGalleryButton.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct NotificationGalleryButton: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
            Image(systemName: "photo.on.rectangle")
                .foregroundStyle(.white.opacity(0.4))
                .font(.largeTitle)
                .frame(width: 90, height: 90)
                .background(Color.hexConverter(hexString:"#1c2630"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            .white.opacity(0.2),
                            style: StrokeStyle(
                                lineWidth: 1,
                                dash: [5, 5]
                            )
                        )
                )
        }
    }
}

#Preview {
    NotificationGalleryButton(viewModel: CreateNotificationViewModel())
}
