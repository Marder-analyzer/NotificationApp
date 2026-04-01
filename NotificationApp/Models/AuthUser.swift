//
//  AuthUser.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

struct AuthUser: Identifiable, Equatable {
	let id: String
	let email: String?
	let fullName: String?
	let role: String?
	let department: String?
	let photoURL: String?
	let collection: [String]?
	
	init(id: String, email: String?, fullName: String? = nil, role: String? = nil, department: String? = nil, photoURL: String? = nil, collection: [String]? = nil) {
		self.id = id
		self.email = email
		self.fullName = fullName
		self.role = role
		self.department = department
		self.photoURL = photoURL
		self.collection = collection
	}
}
