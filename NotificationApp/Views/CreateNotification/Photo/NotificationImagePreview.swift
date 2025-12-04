//
//  NotificationImagePreview.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationImagePreview: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        if let image = viewModel.selectedImage {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                
                Button(action: { viewModel.selectedImage = nil }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Color.white.clipShape(Circle()))
                        .font(.title2)
                }
                .padding(5)
            }
            .listRowInsets(EdgeInsets())
            .padding(.vertical)
        }
    }
}

#Preview {
    NotificationImagePreview(viewModel: CreateNotificationViewModel())
}
