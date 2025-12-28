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
import FirebaseFirestore

@main
struct NotificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()
    private let notifListener = NotificationsCellListener.shared
    @State private var restartToken = UUID()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .id(restartToken)
                .environmentObject(appState)
                .task {
                    notifListener.start(appState: appState)
                }
                .onReceive(NotificationCenter.default.publisher(for: .restartApp)) { _ in
                    restartToken = UUID()
                }
        }
    }
}

extension Notification.Name {
    static let restartApp = Notification.Name("restartApp")
}

@MainActor
final class AppState: ObservableObject {
    @Published var activePopup: InAppNotification? = nil
    
    private var queue: [InAppNotification] = []
    private var isPresenting = false
    
    func enqueue(_ item: InAppNotification) {
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

final class NotificationsCellListener {
	static let shared = NotificationsCellListener()
	
	private var ref: DatabaseReference?
	private var addHandle: DatabaseHandle?
	private var changeHandle: DatabaseHandle?
	private var startAtMillis: Double = Date().timeIntervalSince1970 * 1000
	private let listenerStartedAt: TimeInterval = Date().timeIntervalSince1970
	private(set) var followedIds = Set<String>()
	
	private var isRefreshing = false
	
	func start(appState: AppState) {
			Task { [weak self] in
					guard let self else { return }

					await self.refreshFollowedIds()

					let ref = Database.database().reference()
					self.ref = ref

					let path = ref.child("notificationsCell")
				
				self.addHandle = path.observe(.childAdded, with: { [weak self] snap in
					guard let self else { return }
					self.handleSnapAdd(snap, appState: appState, event: "added")
				}, withCancel: { error in
					print("childAdded cancelled:", error.localizedDescription)
				})
				
					self.changeHandle = path.observe(.childChanged, with: { [weak self] snap in
							guard let self else { return }
							self.handleSnap(snap, appState: appState, event: "changed")
					}, withCancel: { error in
							print("childChanged cancelled:", error.localizedDescription)
					})
			}
	}

	@MainActor
		func refreshFollowedIds() async {
				guard !isRefreshing else { return }
				isRefreshing = true
				defer { isRefreshing = false }

				guard let email = Auth.auth().currentUser?.email, !email.isEmpty else {
						print("No current user email")
						followedIds = []
						return
				}

				do {
						let db = Firestore.firestore()

						let userSnap = try await db.collection("users")
								.whereField("email", isEqualTo: email)
								.limit(to: 1)
								.getDocuments()

						guard let userDoc = userSnap.documents.first else {
								print("No user found for email:", email)
								followedIds = []
								return
						}

						let followedSnap = try await db.collection("users")
								.document(userDoc.documentID)
								.collection("followedNotifications")
								.getDocuments()

						followedIds = Set(followedSnap.documents.map { $0.documentID })
						print("followedIds refreshed:", followedIds.count)

				} catch {
						print("refreshFollowedIds error:", error)
				}
		}
	
	private func handleSnap(_ snap: DataSnapshot, appState: AppState, event: String) {
					guard followedIds.contains(snap.key) else {
							return
					}

					guard let dict = snap.value as? [String: Any] else { return }

					let title = dict["title"] as? String ?? ""
					let description = dict["description"] as? String ?? "\(dict["description"] as? Int ?? 0)"
					let emergency = dict["emergency"] as? Bool ?? false
					print("notificationsCell \(event):", snap.key, dict)

					let item = InAppNotification(id: snap.key, title: title, description: description)
					Task { @MainActor in
						appState.enqueue(item)
					}
	}
	
	private func handleSnapAdd(_ snap: DataSnapshot, appState: AppState, event: String) {
			guard let dict = snap.value as? [String: Any] else { return }

			let title = dict["title"] as? String ?? ""
			let description = dict["description"] as? String
					?? "\(dict["description"] as? Int ?? 0)"
			let emergency = dict["isEmergency"] as? Bool ?? false

			if emergency {
					let item = InAppNotification(
							id: snap.key,
							title: title,
							description: description
					)

					Task { @MainActor in
							appState.enqueue(item)
					}
			}
	}


	func stop() {
		guard let ref else { return }
		let path = ref.child("notificationsCell")
		if let h = addHandle { path.removeObserver(withHandle: h) }
		if let h = changeHandle { path.removeObserver(withHandle: h) }
		addHandle = nil
		changeHandle = nil
		self.ref = nil
	}
}


struct InAppNotification: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
}
