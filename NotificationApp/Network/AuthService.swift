//
//  AuthService.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseAuth

final class AuthService {
	static let shared = AuthService()
	
	private init() {}
	
	func register(
		email: String,
		password: String
	) async throws -> User {
		let result = try await Auth.auth().createUser(withEmail: email, password: password)
		return result.user
	}
	
	func login(
		email: String,
		password: String
	) async throws -> User {
		let result = try await Auth.auth().signIn(withEmail: email, password: password)
		return result.user
	}
	
	func logout() throws {
		try Auth.auth().signOut()
	}
	
	var currentUser: User? {
		Auth.auth().currentUser
	}
	
	func observeAuthChanges(_ handler: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
		Auth.auth().addStateDidChangeListener { _, user in
			handler(user)
		}
	}
	
	func removeListener(_ handle: AuthStateDidChangeListenerHandle) {
		Auth.auth().removeStateDidChangeListener(handle)
	}
}
