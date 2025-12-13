//
//  InMemoryActor.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

actor InMemoryActor<T: Identifiable>: Cache {
    typealias Value = T
    
    private var storage: [T] = []
    
    func save(_ value: [T]) {
        storage = value
    }
    
    func get() -> [T] {
        storage
    }
    
    func insert(_ value: T) {
        if let index = storage.firstIndex(where: { $0.id == value.id }) {
            storage[index] = value
        } else {
            storage.append(value)
        }
    }
    
    func remove(_ id: T.ID) {
        storage.removeAll { $0.id == id }
    }
    
    func update(_ value: T) {
        if let index = storage.firstIndex(where: { $0.id == value.id }) {
            storage[index] = value
        }
    }
}
