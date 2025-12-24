//
//  AuthCoordinator.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseAuth
import Combine
import Firebase

@MainActor
final class AuthCoordinator: ObservableObject {
	@Published var user: AuthUser?
	@Published var isLoading: Bool = false
	@Published var errorMessage: String?
	@Published var profileUser: AuthUser?
	
	func register(email: String, password: String, nameSurname: String, userType: String) async -> AuthUser? {
		let result = try? await Auth.auth().createUser(withEmail: email, password: password)
		let user = result?.user
		
		try? await createProfileDocument(
			uid: user?.uid ?? "",
			email: user?.email ?? email,
			nameSurname: nameSurname,
			userType: userType
		)
		
		return AuthUser(id: user?.uid ?? "", email: user?.email)
	}
	
	func login(email: String, password: String) async -> AuthUser? {
		let result = try? await Auth.auth().signIn(withEmail: email, password: password)
		let user = result?.user
		return AuthUser(id: user?.uid ?? "", email: user?.email)
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
	
	private func createProfileDocument(uid: String, email: String, nameSurname: String, userType: String) async throws {
		let role = (userType == Role.admin) ? Role.admin : Role.user
		let db = Firestore.firestore()
		
		let data: [String: Any] = [
			"email": email,
			"role": role,
			"department": "—",
			"fullName": nameSurname,
			"photoURL": NSNull(),
			"createdAt": FieldValue.serverTimestamp()
		]
		
		try await db.collection("users").document(uid).setData(data, merge: true)
	}
	
	func loadProfileUser(completion: @escaping (AuthUser?) -> ()) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		Firestore.firestore()
			.collection("users")
			.document(uid)
			.getDocument { snapshot, _ in
				guard let data = snapshot?.data() else { return }
				
				DispatchQueue.main.async {
					completion( AuthUser(
						id: data["uid"] as? String ?? "",
						email: Auth.auth().currentUser?.email ?? "—",
						fullName: data["fullName"] as? String ?? "—",
						role: data["role"] as? String ?? "user",
						department: data["department"] as? String ?? "—",
						photoURL: data["photoURL"] as? String
					))
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
