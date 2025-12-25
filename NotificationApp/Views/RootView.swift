//
//  RootView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 25.12.2025.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    var body: some View {
        NavigationStack {
            if let user = Auth.auth().currentUser {
                MainTabView()
                    .navigationBarHidden(true)
            } else {
                LoginContainerView()
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    RootView()
}
