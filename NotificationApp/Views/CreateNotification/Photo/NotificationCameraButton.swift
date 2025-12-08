//
//  NotificationCameraButton.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct NotificationCameraButton: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        Button(action: {
            viewModel.showCamera = true
        }) {
            Image(systemName: "camera")
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
    NotificationCameraButton(viewModel: CreateNotificationViewModel())
}
