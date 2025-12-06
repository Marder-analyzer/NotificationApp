//
//  NotificationAppApp.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 3.12.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct NotificationAppApp: App {
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
