//
//  NotificationEvidenceView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI

struct NotificationEvidenceView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        Group {
            PhotoSelectionView(viewModel: viewModel)
            
            LocationSelectionView(viewModel: viewModel)
                .padding(.horizontal)
        }
        .sheet(isPresented: $viewModel.showCamera) {
            ImagePicker(image: $viewModel.selectedImage, sourceType: .camera)
        }
    }
}


#Preview {
    NotificationEvidenceView(viewModel: CreateNotificationViewModel())
}
