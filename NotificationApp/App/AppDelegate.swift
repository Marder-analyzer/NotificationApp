//
//  AppDelegate.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
		func application(
				_ application: UIApplication,
				didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
		) -> Bool {
				FirebaseApp.configure()
				return true
		}
}
