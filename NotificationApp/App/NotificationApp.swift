//
//  NotificationApp.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import FirebaseCore

@main
struct NotificationApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	@StateObject private var authCoordinator: AuthCoordinator
	
	init() {
		let repo = FirebaseAuthRepository()
		_authCoordinator = StateObject(wrappedValue: AuthCoordinator(repository: repo))
	}
	
	var body: some Scene {
		WindowGroup {
			LoginContainerView()
				.environmentObject(authCoordinator)
			
		}
	}
}
