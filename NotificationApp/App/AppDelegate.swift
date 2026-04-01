//
//  AppDelegate.swift
//  NotificationApp
//
//  Created by Safiyenur Ozer on 6.12.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject,
									 UIApplicationDelegate,
									 UNUserNotificationCenterDelegate,
									 MessagingDelegate {
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		
		FirebaseApp.configure()
		
		UNUserNotificationCenter.current().delegate = self
		Messaging.messaging().delegate = self
		
		requestNotificationPermission(application)
		
		Messaging.messaging().token { token, error in
			if let error = error {
				print("FCM token error:", error)
			} else {
				print("FCM token (manual):", token ?? "nil")
			}
		}
		return true
	}
}

private extension AppDelegate {
	
	func requestNotificationPermission(_ application: UIApplication) {
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		
		UNUserNotificationCenter.current()
			.requestAuthorization(options: options) { granted, error in
				if granted {
					DispatchQueue.main.async {
						application.registerForRemoteNotifications()
					}
				} else {
					print("Notification permission denied")
				}
			}
	}
}

extension AppDelegate {
	
	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		Messaging.messaging().apnsToken = deviceToken
	}
	
	func application(
		_ application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: Error
	) {
		print("Failed to register for remote notifications:", error)
	}
}

extension AppDelegate {

	func messaging(
		_ messaging: Messaging,
		didReceiveRegistrationToken fcmToken: String?
	) {
		guard let token = fcmToken else { return }

		print("FCM Token:", token)
	}
}

extension AppDelegate {

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([.banner, .sound, .badge])
	}
}

extension AppDelegate {

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {

		let userInfo = response.notification.request.content.userInfo
		print("Notification tapped:", userInfo)

		completionHandler()
	}
}
