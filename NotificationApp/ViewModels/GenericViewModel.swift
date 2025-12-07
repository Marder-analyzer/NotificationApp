//
//  GenericViewModel.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//
import SwiftUI
import Combine

@MainActor
final class GenericViewModel<R: Repository>: ObservableObject {
	@Published var notificationModel: [R.Entity] = []
	@Published var isLoading: Bool = false
	
	private let repository: R
	private var loadTask: Task<Void, Never>?
	
	init(repository: R) {
		self.repository = repository
	}
	
	func loadNotifications() {
		loadTask?.cancel()
		
		loadTask = Task {
			isLoading = true
			
			defer { isLoading = false }
			
			do {
				let notifications = try await repository.fetch()
				self.notificationModel = notifications
			} catch {
				print("Error", error.localizedDescription)
			}
		}
	}
}
