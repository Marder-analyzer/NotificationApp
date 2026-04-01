//
//  GenericViewModel.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//
import SwiftUI
import Combine
import Firebase

final class GenericViewModel: ObservableObject {
    @Published var notificationModel: [NotificationItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let ref = Database.database().reference().child("notifications")
	private let rootRef = Database.database().reference()
	private var notificationsCellRef: DatabaseReference { rootRef.child("notificationsCell") }

    
    @Published var profile: AuthUser?
    
    private var loadTask: Task<Void, Never>?
    
    func loadNotifications() {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            errorMessage = nil
            
            defer { isLoading = false }
            
            do {
                let notifications = try await fetch()
                self.notificationModel = notifications
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error", error.localizedDescription)
            }
        }
    }
    
    func delete(_ item: NotificationItem) {
        guard let index = notificationModel.firstIndex(where: { $0.id == item.id }) else {
            print("HATA: Silinecek öğe listede bulunamadı.")
            return
        }
        
        let removedItem = notificationModel.remove(at: index)
        
        Task {
            do {
                try await delete(item)
            } catch {
                print("Delete Error:", error.localizedDescription)
                self.errorMessage = "Silme işlemi başarısız oldu."
                
                await MainActor.run {
                    if index <= self.notificationModel.count {
                        self.notificationModel.insert(removedItem, at: index)
                    } else {
                        self.notificationModel.append(removedItem)
                    }
                }
            }
        }
    }
    
    // MARK: - UPDATE (Güncelleme)
    func update(_ item: NotificationItem) {
        if let index = notificationModel.firstIndex(where: { $0.id == item.id }) {
            notificationModel[index] = item
        }
        
        Task {
            do {
                try await update(item)
							Task {
								await NotificationsCellListener.shared.refreshFollowedIds()
							}
					
            } catch {
                print("Update Error:", error.localizedDescription)
                self.errorMessage = "Güncelleme başarısız oldu."
                loadNotifications()
            }
        }
    }
    
    
    
    // MARK: - FETCH
    func fetch() async throws -> [NotificationItem] {
        return try await withCheckedThrowingContinuation { continuation in
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else {
                    continuation.resume(returning: [])
                    return
                }
                
                do {
                    var items: [NotificationItem] = []
                    
                    for (key, value) in dict {
                        var itemData = value as! [String: Any]
                        itemData["id"] = key
                        
                        let data = try JSONSerialization.data(withJSONObject: itemData)
                        let item = try JSONDecoder().decode(NotificationItem.self, from: data)
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
	func save(_ item: NotificationItem) async throws {
			let itemRef = ref.child(item.id)

			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
					itemRef.setValue(item.toDictionary()) { error, _ in
							if let error = error {
									continuation.resume(throwing: error)
							} else {
									continuation.resume()
							}
					}
			}

			guard let rootRef = ref.parent else {
					throw NSError(
							domain: "RealtimeDatabase",
							code: -1,
							userInfo: [NSLocalizedDescriptionKey: "Root reference not found (ref.parent is nil)"]
					)
			}

			let cellRef = rootRef.child("notificationsCell").child(item.id)
			var cellPayload: [String: Any] = [
					"title": item.title,
					"description": item.description
			]
		
		if let emergency = item.isEmergency {
			cellPayload["isEmergency"] = emergency
		}

			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
					cellRef.setValue(cellPayload) { error, _ in
							if let error = error {
									continuation.resume(throwing: error)
							} else {
									continuation.resume()
							}
					}
			}
	}

    
    // MARK: - UPDATE
	func update(_ item: NotificationItem) async throws {
			let itemRef = ref.child(item.id)

			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
					itemRef.updateChildValues(item.toDictionary()) { error, _ in
							if let error = error {
									continuation.resume(throwing: error)
							} else {
									continuation.resume()
							}
					}
			}

			guard let rootRef = ref.parent else {
					throw NSError(
							domain: "RealtimeDatabase",
							code: -1,
							userInfo: [NSLocalizedDescriptionKey: "Root reference not found (ref.parent is nil)"]
					)
			}

			let cellRef = rootRef.child("notificationsCell").child(item.id)

			var cellPayload: [String: Any] = [
					"title": item.title,
					"description": item.description
			]

			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
					cellRef.updateChildValues(cellPayload) { error, _ in
							if let error = error {
									continuation.resume(throwing: error)
							} else {
									continuation.resume()
							}
					}
			}
	}
    
    // MARK: - DELETE
    func delete(_ item: NotificationItem) async throws {
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
        return nil
    }
}

extension GenericViewModel {

    func filteredNotifications(
        query: String,
        onlyFollowed: Bool,
        selectedType: NotificationType?,
        selectedStatusIndex: Int,
        showOnlyMyDepartment: Bool,
        sortOrder: SortOrder
    ) -> [NotificationItem] {
        let filtered = notificationModel.filter { item in

            if onlyFollowed {
                guard profile?.collection?.contains(item.id) == true  else {
                    return false
                }
            }

            let matchesSearch =
                query.isEmpty ||
                item.title.localizedCaseInsensitiveContains(query) ||
                item.description.localizedCaseInsensitiveContains(query)

            let matchesType =
                selectedType == nil || item.type == selectedType

            let department = profile?.department ?? ""
            let matchesDepartment = !showOnlyMyDepartment ||
            item.type.rawValue == department

            let matchesStatus: Bool
            switch selectedStatusIndex {
            case 1: matchesStatus = item.status == .open
            case 2: matchesStatus = item.status == .investigating
            case 3: matchesStatus = item.status == .resolved
            default: matchesStatus = true
            }

            return matchesSearch &&
                   matchesType &&
                   matchesDepartment &&
                   matchesStatus
        }

        return filtered.sorted {
            guard let l = $0.dateObject, let r = $1.dateObject else { return false }
            return sortOrder == .newest ? l > r : l < r
        }
    }
    
    func toggleFollow(for item: NotificationItem) {
        var newItem = item
        newItem.isFollowed.toggle()
        
        update(newItem)
    }
}

enum SortOrder {
    case newest
    case oldest
    
    mutating func toggle() {
        self = (self == .newest) ? .oldest : .newest
    }
    
}
