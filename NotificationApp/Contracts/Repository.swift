//
//  Repository.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

protocol Repository {
	associatedtype Entity
	func fetch() async throws -> [Entity]
}

protocol Cache {
	associatedtype Value
	func save(_ value: [Value]) async
	func get() async -> [Value]
}
