//
//  NotificationGalleryButton.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct NotificationGalleryButton: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
            Image(systemName: "photo.on.rectangle")
                .tint(.gray)
                .font(.largeTitle)
                .frame(width: 90, height: 90)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

#Preview {
    NotificationGalleryButton(viewModel: CreateNotificationViewModel())
}
