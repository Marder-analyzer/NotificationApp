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

enum Role {
    static let admin = "admin"
    static let user  = "user"
}

@MainActor
final class AuthCoordinator: ObservableObject {
	@Published var user: AuthUser?
	@Published var isLoading: Bool = false
	@Published var errorMessage: String?
	@Published var profileUser: AuthUser?
	
	func register(email: String, password: String, nameSurname: String, userType: String, department: String) async -> AuthUser? {
		let result = try? await Auth.auth().createUser(withEmail: email, password: password)
		let user = result?.user
		
		try? await createProfileDocument(
			uid: user?.uid ?? "",
			email: user?.email ?? email,
			nameSurname: nameSurname,
			userType: userType,
            department: department
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
	
    private func createProfileDocument(uid: String, email: String, nameSurname: String, userType: String, department: String) async throws {
		let role = (userType == Role.admin) ? Role.admin : Role.user
		let db = Firestore.firestore()
		
		let data: [String: Any] = [
            "uid": uid,
			"email": email,
			"role": role,
			"department": department,
			"fullName": nameSurname,
			"photoURL": NSNull(),
			"createdAt": FieldValue.serverTimestamp()
		]
		
		try await db.collection("users").document(uid).setData(data, merge: true)
	}
	
	func loadProfileUser(completion: @escaping (AuthUser?) -> ()) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		let db = Firestore.firestore()
		let userRef = db.collection("users").document(uid)
		let followedRef = userRef.collection("followedNotifications")
		
		var userData: [String: Any] = [:]
		var followedIds: [String] = []
		
		let group = DispatchGroup()
		
		group.enter()
		userRef.getDocument { snapshot, error in
			defer { group.leave() }
			guard let data = snapshot?.data(), error == nil else { return }
			userData = data
		}
		
		group.enter()
		followedRef.getDocuments { snapshot, error in
			defer { group.leave() }
			guard let docs = snapshot?.documents, error == nil else { return }
			
			followedIds = docs.compactMap { doc in
				if let id = doc.data()["notificationId"] as? String {
					return id
				}
				return doc.documentID
			}
		}
		
		group.notify(queue: .main) {
			let user = AuthUser(
				id: userData["uid"] as? String ?? uid,
				email: Auth.auth().currentUser?.email ?? "—",
				fullName: userData["fullName"] as? String ?? "—",
				role: userData["role"] as? String ?? "user",
				department: userData["department"] as? String,
				photoURL: userData["photoURL"] as? String,
				collection: followedIds
			)
			completion(user)
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

	}
	
}


