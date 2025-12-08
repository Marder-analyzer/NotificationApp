//
//  FirebaseSaveable.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

protocol FirebaseSaveable {
	var id: UUID { get }
	func toDictionary() -> [String: Any]
}
