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
    @Published var followingSearchText: String = ""
    @Published var searchText: String = ""
    
    @Published var showOnlyMyDepartment: Bool = false
    
    @Published var showOnlyFollowed: Bool = false
    @Published var selectedStatusIndex: Int = 0
    @Published var selectedType: NotificationType? = nil
    @Published var sortOrder: SortOrder = .newest
		private let ref = Database.database().reference().child("notifications")

//    let currentUserDepartment = profile?.department
    @Published var profile: AuthUser?

//    let currentUserRole = profile?.role
    
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
	func update(_ item: NotificationItem) async throws {
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
    var homeFilteredNotifications: [NotificationItem] {
        return applyFilter(
            items: notificationModel,
            query: searchText, 
            filterByFollowed: showOnlyFollowed,
            useGlobalFilters: true
        )
    }
    
    var followingFilteredNotifications: [NotificationItem] {
        return applyFilter(
            items: notificationModel,
            query: followingSearchText,
            filterByFollowed: true,
            useGlobalFilters: false
        )
    }
    
	private func applyFilter(items: [NotificationItem], query: String, filterByFollowed: Bool, useGlobalFilters: Bool) -> [NotificationItem] {
        
        let filtered = items.filter { item in
					if filterByFollowed {
						guard let contain = self.profile?.collection?.first(where: { $0 == item.id }) else { return false }
						
					}
					
            let matchesSearch = query.isEmpty ||
            item.title.localizedCaseInsensitiveContains(query) ||
            item.description.localizedCaseInsensitiveContains(query)
            
            let matchesFollow = !filterByFollowed || item.isFollowed
            
            let matchesGlobalFilters: Bool
            if useGlobalFilters {
                let matchesType = selectedType == nil || item.type == selectedType
                let matchesDepartment = !showOnlyMyDepartment || (item.type == NotificationType(rawValue: profile?.department ?? ""))
                let matchesStatus: Bool
                switch selectedStatusIndex {
                case 1: matchesStatus = (item.status == .open)
                case 2: matchesStatus = (item.status == .investigating)
                case 3: matchesStatus = (item.status == .resolved)
                default: matchesStatus = true
                }
                matchesGlobalFilters = matchesType && matchesDepartment && matchesStatus
            } else {
                matchesGlobalFilters = true
            }
            
            return matchesSearch && matchesFollow && matchesGlobalFilters
        }
        
        return filtered.sorted { lhs, rhs in
            guard let lDate = lhs.dateObject,
                  let rDate = rhs.dateObject else { return false }
            
            switch sortOrder {
            case .newest:
                return lDate > rDate
            case .oldest:
                return lDate < rDate
            }
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
