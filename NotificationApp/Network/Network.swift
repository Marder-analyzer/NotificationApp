//
//  Network.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

final class NetworkDataSource<Entity: Codable & FirebaseSaveable & Identifiable> {
    
    private let ref = Database.database().reference().child("notifications")
    
    // MARK: - FETCH
    func fetch() async throws -> [Entity] {
        return try await withCheckedThrowingContinuation { continuation in
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else {
                    continuation.resume(returning: [])
                    return
                }
                
                do {
                    var items: [Entity] = []
                    
                    for (key, value) in dict {
                        var itemData = value as! [String: Any]
                        itemData["id"] = key
                        
                        let data = try JSONSerialization.data(withJSONObject: itemData)
                        let item = try JSONDecoder().decode(Entity.self, from: data)
                        items.append(item)
                    }
                    
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - SAVE (Create)
    func save(_ item: Entity) async throws {
        let itemRef = ref.child(item.id)

        return try await withCheckedThrowingContinuation { continuation in
            itemRef.setValue(item.toDictionary()) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - UPDATE
    func update(_ item: Entity) async throws {
        let itemRef = ref.child(item.id)
        return try await withCheckedThrowingContinuation { continuation in
            itemRef.updateChildValues(item.toDictionary()) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - DELETE
    func delete(_ item: Entity) async throws {
        let itemRef = ref.child(item.id)
        
        return try await withCheckedThrowingContinuation { continuation in
            itemRef.removeValue { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - IMAGE UPLOAD
    func uploadImage(data: Data) async throws -> String? {
        let filename = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child("notification_images/\(filename)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await storageRef.putDataAsync(data, metadata: metadata)
        let url = try await storageRef.downloadURL()
        return url.absoluteString
    }
}
