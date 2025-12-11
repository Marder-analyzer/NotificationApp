//
//  Network.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

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
    
    func uploadImage(data: Data, completion: @escaping (String?) -> Void) {
        let filename = UUID().uuidString + ".jpg"
        
        let storageRef = Storage.storage().reference().child("notification_images/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(data, metadata: metadata) { metadata, error in
            if let error = error {
                print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Download URL alınamadı: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(url?.absoluteString)
            }
        }
    }
}
