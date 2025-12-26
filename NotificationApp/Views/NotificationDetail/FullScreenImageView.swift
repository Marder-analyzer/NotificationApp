//
//  FullScreenImageView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageName: String
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            ZStack {

                Color.black.opacity(0.2).ignoresSafeArea()
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                                .shadow(radius: 5)
                        }
                    }
                    Spacer()
                }
            }
        }
}

#Preview {
    FullScreenImageView(imageName: "")
}
