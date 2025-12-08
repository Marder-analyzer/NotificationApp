//
//  NotificationFollowButton.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI

struct NotificationFollowButton: View {
    @State private var isFollowed: Bool = false
    
    var body: some View {
        Button(action: toggleFollow) {
            Image(systemName: isFollowed ? "bookmark.fill" : "bookmark")
                .font(.system(size: 14))
                .scaleEffect(isFollowed ? 1.1 : 1.0)
                .animation(.spring(), value: isFollowed)
        }
    }
    
    private func toggleFollow() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation {
            isFollowed.toggle()
        }
        print("Takip durumu: \(isFollowed)")
    }
}

#Preview {
    NotificationFollowButton()
}
