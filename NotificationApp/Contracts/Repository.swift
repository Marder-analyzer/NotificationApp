//
//  Repository.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

protocol Repository {
    associatedtype Entity: Identifiable
    func fetch() async throws -> [Entity]
    func save(_ entity: Entity) async throws
    func delete(_ entity: Entity) async throws
    func update(_ entity: Entity) async throws
}

protocol Cache {
    associatedtype Value: Identifiable
    
    func get() async -> [Value]
    func save(_ values: [Value]) async
    func insert(_ value: Value) async
    func remove(_ id: Value.ID) async       
    func update(_ value: Value) async
}
