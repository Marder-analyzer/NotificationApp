//
//  GenericRepository.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

final class GenericRepository<Model: Codable & FirebaseSaveable & Identifiable, C: Cache>: Repository where C.Value == Model {
    typealias Entity = Model
    
    private let cache: C
    private let remote: NetworkDataSource<Entity>
    
    init(cache: C, remote: NetworkDataSource<Entity>) {
        self.cache = cache
        self.remote = remote
    }
    
    func fetch() async throws -> [Model] {
        let cached = await cache.get()
        if !cached.isEmpty {
            return cached
        }
        
        let items = try await remote.fetch()
        
        await cache.save(items)
        return items
    }
    
    func save(_ entity: Model) async throws {
        try await remote.save(entity)
        await cache.insert(entity)
    }
    
    func delete(_ entity: Model) async throws {
        try await remote.delete(entity)
        await cache.remove(entity.id)
    }
    
    func update(_ entity: Model) async throws {
        try await remote.update(entity)
        await cache.update(entity)
    }
}
