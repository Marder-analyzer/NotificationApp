//
//  NotificationFollowButton.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 5.12.2025.
//

import SwiftUI

struct NotificationFollowButton: View {
    @ObservedObject var vm: FollowViewModel
    
    var body: some View {
        Button {
            Task {
                await vm.toggleFollow()
            }
        } label: {
            Image(systemName: vm.isFollowed ? "bookmark.fill" : "bookmark")
                .foregroundColor(vm.isFollowed ? .blue : .white)
                .font(.title3)
        }
        .disabled(vm.isLoading)
    }
}

//#Preview {
//    NotificationFollowButton(vm: FollowViewModel())
//}
