//
//  FirebaseSaveable.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

protocol FirebaseSaveable {
	var id: String { get }
	func toDictionary() -> [String: Any]
}
