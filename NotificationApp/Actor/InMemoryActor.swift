//
//  InMemoryActor.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

actor InMemoryActor<T>: Cache {
	typealias Value = T
	
	private var storage: [T] = []
	
	func save(_ value: [T]) async {
		storage = value
	}
	
	func get() async -> [T] {
		storage
	}
}
