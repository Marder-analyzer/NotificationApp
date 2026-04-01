//
//  FollowViewModel.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 25.12.2025.
//

import Combine
import Foundation

@MainActor
final class FollowViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var isFollowed = false

    private let service: FollowServiceProtocol
    private var userId: String
    private let notificationId: String

    init(
        service: FollowServiceProtocol,
        notificationId: String,
        profile: AuthUser
    ) {
        self.service = service
        self.notificationId = notificationId
        self.userId = profile.id
    }
    
    func toggleFollow() async {

        isLoading = true
        defer { isLoading = false }

        do {
            if isFollowed {
                try await service.unfollow(userId: userId, notificationId: notificationId)
							Task {
								await NotificationsCellListener.shared.refreshFollowedIds()
							}
                isFollowed = false
            } else {
                try await service.follow(userId: userId, notificationId: notificationId)
							Task {
								await NotificationsCellListener.shared.refreshFollowedIds()
							}
                isFollowed = true
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadFollowStatus() async {
        do {
            isFollowed = try await service.isFollowed(
                userId: userId,
                notificationId: notificationId
            )
        } catch {
            print("Follow status error:", error.localizedDescription)
        }
    }
}
