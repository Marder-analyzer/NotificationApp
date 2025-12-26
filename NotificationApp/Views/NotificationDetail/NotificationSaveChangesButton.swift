//
//  NotificationSaveChangesButton.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI

struct NotificationSaveChangesButton: View {

    var onSave: () -> Void
    
    var body: some View {
        Button(action: onSave) {
            Image(systemName: "checkmark")
                .bold()
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NotificationSaveChangesButton(onSave: {
        print("status")
    })
}
