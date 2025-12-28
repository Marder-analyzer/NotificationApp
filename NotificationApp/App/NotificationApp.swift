//
//  NotificationApp.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import Foundation
import Combine
import FirebaseDatabase

@main
struct NotificationApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	@StateObject private var appState = AppState()
	private let notifListener = NotificationsCallListener()
	
	var body: some Scene {
		WindowGroup {
			RootView()
				.environmentObject(appState)
				.task {
					notifListener.start(appState: appState)
				}
		}
	}
}

@MainActor
final class AppState: ObservableObject {
	@Published var activePopup: InAppNotification? = nil

	// İstersen sıraya almak için:
	private var queue: [InAppNotification] = []
	private var isPresenting = false

	func enqueue(_ item: InAppNotification) {
		// Aynı id tekrar gelirse gösterme (opsiyonel)
		if activePopup?.id == item.id { return }
		if queue.contains(where: { $0.id == item.id }) { return }

		queue.append(item)
		presentNextIfNeeded()
	}

	func dismissPopup() {
		activePopup = nil
		isPresenting = false
		presentNextIfNeeded()
	}

	private func presentNextIfNeeded() {
		guard !isPresenting else { return }
		guard activePopup == nil else { return }
		guard !queue.isEmpty else { return }

		isPresenting = true
		activePopup = queue.removeFirst()
	}
}

final class NotificationsCallListener {
	private var ref: DatabaseReference?
	private var handle: DatabaseHandle?

	private var startAtMillis: Double = Date().timeIntervalSince1970 * 1000

	func start(appState: AppState) {
		let ref = Database.database().reference()
		self.ref = ref

		let path = ref
			.child("notificationsCell")

		let query = path
			.queryOrdered(byChild: "createdAt")
			.queryStarting(afterValue: startAtMillis)

		handle = query.observe(.childAdded, with: { snap in
			guard
				let dict = snap.value as? [String: Any],
				let title = dict["title"] as? String,
				let description = dict["description"] as? String
			else { return }
	
			let item = InAppNotification(id: snap.key, title: title, description: description)
			Task { @MainActor in appState.enqueue(item) }

		}, withCancel: { error in
			print("❌ observe cancelled:", error.localizedDescription)
		})
	}

	func stop() {
		guard let ref, let handle else { return }
		ref.removeObserver(withHandle: handle)
		self.handle = nil
		self.ref = nil
	}
}

struct InAppNotification: Identifiable, Equatable {
	let id: String
	let title: String
	let description: String
}
