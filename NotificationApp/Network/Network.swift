//
//  Network.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation

final class NetworkDataSource<T: Decodable> {
	let url: URL
	
	init(url: URL) {
		self.url = url
	}
	
	func fetch() async throws -> [T] {
		let (data, _) = try await URLSession.shared.data(from: url)
		return try JSONDecoder().decode([T].self, from: data)
	}
}
