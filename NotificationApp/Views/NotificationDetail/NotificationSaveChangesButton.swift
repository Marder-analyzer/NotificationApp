//
//  NotificationSaveChangesButton.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 5.12.2025.
//

import SwiftUI

struct NotificationSaveChangesButton: View {
    var currentStatus: NotificationStatus
    var originalStatus: NotificationStatus
    var onSave: () -> Void
    
    var body: some View {
        if currentStatus != originalStatus {
            VStack {
                Button(action: onSave) {
                    Text("Değişiklikleri Kaydet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            )
            .animation(.spring(), value: currentStatus)
        }
    }
}

#Preview {
    NotificationSaveChangesButton(currentStatus: .investigating, originalStatus: .investigating, onSave: { 
        print("status")
    })
}
