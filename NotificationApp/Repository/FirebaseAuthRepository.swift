//
//  FirebaseAuthRepository.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthRepository: AuthRepository {
	var currentUser: AuthUser? {
		guard let user = Auth.auth().currentUser else { return nil }
		return AuthUser(id: user.uid, email: user.email)
	}
	
	func register(email: String, password: String) async throws -> AuthUser {
		let result = try await Auth.auth().createUser(withEmail: email, password: password)
		let user = result.user
		return AuthUser(id: user.uid, email: user.email)
	}
	
	func login(email: String, password: String) async throws -> AuthUser {
		let result = try await Auth.auth().signIn(withEmail: email, password: password)
		let user = result.user
		return AuthUser(id: user.uid, email: user.email)
	}
	
	func resetPassword(email: String, completion: @escaping (String?) -> Void) {
		Auth.auth().sendPasswordReset(withEmail: email) { error in
				 if let error = error {
					 completion(error.localizedDescription)
				 } else {
						completion(nil)
				 }
		 }
	}
	
	func logout() async throws {
		do {
			try Auth.auth().signOut()
		} catch {
			throw error
		}
	}
	
	//TODO
	func observeAuthChanges(_ handler: @escaping (AuthUser?) -> Void) {
		let a = Auth.auth().addStateDidChangeListener { _, user in
			let authUser: AuthUser?
			if let user {
				authUser = AuthUser(id: user.uid, email: user.email)
			} else {
				authUser = nil
			}
			handler(authUser)
		}
	}
	
	
}
