//
//  AuthRepository.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

protocol AuthRepository {
	var currentUser: AuthUser? { get }
	
	func register(email: String, password: String) async throws -> AuthUser
	func login(email: String, password: String) async throws -> AuthUser
	func resetPassword(email: String, completion: @escaping (String?) -> Void)
	func logout() async throws
	
	func observeAuthChanges(_ handler: @escaping (AuthUser?) -> Void)
	
}
