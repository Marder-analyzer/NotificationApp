//
//  GenericRepository.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

final class GenericRepository<Model: Codable & FirebaseSaveable, C: Cache>: Repository where C.Value == Model {
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
}
