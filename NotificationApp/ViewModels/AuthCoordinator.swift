//
//  AuthCoordinator.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthCoordinator: ObservableObject {
	@Published var user: AuthUser?
	@Published var isLoading: Bool = false
	@Published var errorMessage: String?
	@Published var profileUser: AuthUser?
	
	private let repository: AuthRepository
	
	init(repository: AuthRepository) {
		self.repository = repository
		
		self.user = repository.currentUser
		
		repository.observeAuthChanges { [ weak self ] authUser in
			Task { @MainActor in
				self?.user = authUser
			}
		}
	}
	
	func login(email: String, password: String) async -> AuthUser? {
		guard !email.isEmpty, !password.isEmpty else {
			errorMessage = "Email ve şifre boş olamaz."
			return nil
		}
		
		isLoading = true
		errorMessage = nil
		
		do {
			self.user = try await repository.login(email: email, password: password)
			loadProfileUser()
			isLoading = false
			return user
		} catch {
			self.errorMessage = error.localizedDescription
		}
		
		isLoading = false
		
		return nil
	}
	
	func register(email: String, password: String, nameSurname: String, userType: String) async -> Bool {
		guard !email.isEmpty, !password.isEmpty else {
			errorMessage = "Email ve şifre boş olamaz."
			return false
		}
		
		isLoading = true
		errorMessage = nil
		
		do {
			self.user = try await repository.register(email: email, password: password, nameSurname: nameSurname, userType: userType)
			isLoading = false
			return true
		} catch {
			errorMessage = error.localizedDescription
			isLoading = false
			return false
		}
	}
	
	func resetPassword(email: String, completion: @escaping (String?) -> Void) {
		guard !email.isEmpty else {
			errorMessage = "Email boş olamaz."
			return
		}
		
		isLoading = true
		errorMessage = nil
		
		repository.resetPassword(email: email) { error in
			completion(error)
		}
		
		isLoading = false
	}
	
	func loadProfileUser() {
		repository.loadProfileUser { user in
			self.profileUser = user
		}
	}
	
	func logout() async {
		do {
			try await repository.logout()
			self.user = nil
		} catch {
			self.errorMessage = error.localizedDescription
		}
	}
}
