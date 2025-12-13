//
//  GenericViewModel.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//
import SwiftUI
import Combine

@MainActor
final class GenericViewModel<R: Repository>: ObservableObject where R.Entity: Identifiable, R.Entity: Equatable {
    @Published var notificationModel: [R.Entity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var followingSearchText: String = ""
    @Published var searchText: String = ""
    
    @Published var showOnlyMyDepartment: Bool = false
    
    @Published var showOnlyFollowed: Bool = false
    @Published var selectedStatusIndex: Int = 0
    @Published var selectedType: NotificationType? = nil
    @Published var sortOrder: SortOrder = .newest
    
    let currentUserRole = "Admin"
    let currentUserDepartment = NotificationType.health
    
    private let repository: R
    private var loadTask: Task<Void, Never>?
    
    init(repository: R) {
        self.repository = repository
    }
    
    func loadNotifications() {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            errorMessage = nil
            
            defer { isLoading = false }
            
            do {
                let notifications = try await repository.fetch()
                self.notificationModel = notifications
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error", error.localizedDescription)
            }
        }
    }
    
    func delete(_ item: R.Entity) {
        guard let index = notificationModel.firstIndex(where: { $0.id == item.id }) else {
            print("HATA: Silinecek öğe listede bulunamadı.")
            return
        }
        
        let removedItem = notificationModel.remove(at: index)
        
        Task {
            do {
                try await repository.delete(item)
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
    func update(_ item: R.Entity) {
        if let index = notificationModel.firstIndex(where: { $0.id == item.id }) {
            notificationModel[index] = item
        }
        
        Task {
            do {
                try await repository.update(item)
            } catch {
                print("Update Error:", error.localizedDescription)
                self.errorMessage = "Güncelleme başarısız oldu."
                loadNotifications()
            }
        }
    }
}

extension GenericViewModel where R.Entity == NotificationItem {
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
            let matchesSearch = query.isEmpty ||
            item.title.localizedCaseInsensitiveContains(query) ||
            item.description.localizedCaseInsensitiveContains(query)
            
            let matchesFollow = !filterByFollowed || item.isFollowed
            
            let matchesGlobalFilters: Bool
            if useGlobalFilters {
                let matchesType = selectedType == nil || item.type == selectedType
                let matchesDepartment = !showOnlyMyDepartment || (item.type == currentUserDepartment)
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
