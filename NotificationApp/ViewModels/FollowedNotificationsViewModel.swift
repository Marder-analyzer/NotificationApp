//
//  FollowedNotificationsViewModel.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 25.12.2025.
//

import Combine
import Foundation

@MainActor
final class FollowedNotificationsViewModel<R: Repository>: ObservableObject
where R.Entity == NotificationItem {

    @Published var notifications: [NotificationItem] = []

    private let followService: FollowServiceProtocol
    private let repository: R
    private let userId: String

    init(
        followService: FollowServiceProtocol,
        repository: R,
        userId: String
    ) {
        self.followService = followService
        self.repository = repository
        self.userId = userId
    }

}
