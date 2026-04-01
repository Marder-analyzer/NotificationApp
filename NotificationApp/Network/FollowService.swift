//
//  FollowService.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 25.12.2025.
//

import Foundation
import FirebaseFirestore

protocol FollowServiceProtocol {
    func follow(userId: String, notificationId: String) async throws
    func unfollow(
        userId: String,
        notificationId: String
    ) async throws
    func isFollowed(
        userId: String,
        notificationId: String
    ) async throws -> Bool
}

final class FollowService: FollowServiceProtocol {

    private let db = Firestore.firestore()
    
    func follow(
        userId: String,
        notificationId: String
    ) async throws {
        
        let data: [String: Any] = [
            "notificationId": notificationId,
            "createdAt": Date()
        ]
        
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("followedNotifications")
            .document(notificationId)
            .setData(data)
    }
    
    func unfollow(userId: String, notificationId: String) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("followedNotifications")
            .document(notificationId)
            .delete()
    }
    
    func isFollowed(
        userId: String,
        notificationId: String
    ) async throws -> Bool {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("followedNotifications")
            .document(notificationId)
            .getDocument()

        return snapshot.exists
    }
}
