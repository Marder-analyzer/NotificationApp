//
//  NotificationDetailContentView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailContentView: View {
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text(notification.title ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(notification.description ?? "")
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
    }
}
