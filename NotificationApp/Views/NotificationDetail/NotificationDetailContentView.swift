//
//  NotificationDetailContentView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailContentView: View {
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(notification.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(notification.description)
                .font(.body)
                .foregroundColor(Color.hexConverter(hexString: "#9ca3af"))
                .lineSpacing(4)
        }
    }
}
