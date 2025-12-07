//
//  FirebaseSaveable.swift
//  NotificationApp
//
//  Created by Uğur burak Güven on 6.12.2025.
//

import Foundation

protocol FirebaseSaveable {
	var id: UUID { get }
	func toDictionary() -> [String: Any]
}
