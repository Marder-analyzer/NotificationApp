//
//  RepositoryFactory.swift
//  NotificationApp
//
//  Created by Uğur burak Güven on 6.12.2025.
//

import Foundation

struct RepositoryFactory {
	
	typealias GenericRepositoryImpl = GenericRepository<NotificationItem, InMemoryActor<NotificationItem>>
	
	func makeNotificationRepository() -> GenericRepositoryImpl {
		
		let network = NetworkDataSource<NotificationItem>()
		let cache = InMemoryActor<NotificationItem>()
		return GenericRepository<NotificationItem, InMemoryActor<NotificationItem>>(cache: cache, remote: network)
	}
}
