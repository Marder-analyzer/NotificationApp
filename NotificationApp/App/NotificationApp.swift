//
//  NotificationApp.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct NotificationApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	var body: some Scene {
        WindowGroup {
            RootView()
        }
	}
}
