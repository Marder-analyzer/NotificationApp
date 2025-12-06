//
//  NotificationCameraButton.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI

struct NotificationCameraButton: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        Button(action: {
            viewModel.showCamera = true
        }) {
            Image(systemName: "camera.fill")
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
    NotificationCameraButton(viewModel: CreateNotificationViewModel())
}
