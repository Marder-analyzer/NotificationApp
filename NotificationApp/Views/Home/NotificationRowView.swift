//
//  NotificationRowView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationRowView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            NotificationRowHeader(notification: notification)
            
            Divider()
            
            NotificationRowContent(notification: notification)
            
            NotificationRowFooter(notification: notification)
            
        }
        .padding()
        .background(Color.hexConverter(hexString:"#1c2630"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
}

struct NotificationRowView2<R: Repository>: View where R.Entity == NotificationItem {
	@StateObject private var vm: GenericViewModel<R>
	
	init(repository: R) {
		_vm = StateObject(wrappedValue: GenericViewModel(repository: repository))
	}
	
	var body: some View {
		NavigationView {
			ScrollView {
				if vm.isLoading {
					
				} else {
					LazyVStack(spacing: 16) {
						ForEach(vm.notificationModel) { item in
							NavigationLink(destination: NotificationDetailView(notification: item)) {
								NotificationRowView(notification: item)
							}
							.buttonStyle(PlainButtonStyle())
							.padding(.horizontal)
						}
					}
					.padding(.top, 10)
				}
			}
			.scrollIndicators(.never)
            .background(Color.hexConverter(hexString: "#13181f"))
		}
		.task {
			vm.loadNotifications()
		}
	}
}
