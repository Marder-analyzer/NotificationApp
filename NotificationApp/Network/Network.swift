//
//  Network.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseDatabase

final class NetworkDataSource<Entity: Decodable & FirebaseSaveable> {
//	let url: URL
//	
//	init(url: URL) {
//		self.url = url
//	}
	
	func fetch() async throws -> [Entity] {
		let ref = Database.database().reference().child("notifications")
		
		return try await withCheckedThrowingContinuation { continuation in
			ref.observeSingleEvent(of: .value) { snapshot in
				guard let dict = snapshot.value as? [String: Any] else {
					continuation.resume(returning: [])
					return
				}
				
				do {
					let jsonData = try JSONSerialization.data(withJSONObject: dict)
					let decoded = try JSONDecoder().decode([String: Entity].self, from: jsonData)
					continuation.resume(returning: Array(decoded.values))
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}
	
	func save(_ item: Entity, completion: @escaping () -> ()) {
		let ref = Database.database().reference()
		
		let notificationRef = ref.child("notifications").child(item.id.uuidString)
		
		notificationRef.setValue(item.toDictionary()) { error, _ in
			if let error = error {
				print("Bildirim kaydedilirken hata: \(error.localizedDescription)")
			} else {
				completion()
			}
		}
	}
}
