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
	
	init(id: String, email: String?, fullName: String? = nil, role: String? = nil, department: String? = nil, photoURL: String? = nil) {
		self.id = id
		self.email = email
		self.fullName = fullName
		self.role = role
		self.department = department
		self.photoURL = photoURL
	}
}
