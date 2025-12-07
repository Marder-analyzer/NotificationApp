//
//  NotificationDetailMapView.swift
//  NotificationApp
//
//  Created by Rumeysa Tokur on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailMapView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    @State private var cameraPosition: MapCameraPosition
    
    init(notification: NotificationItem) {
        self.notification = notification
        
        let coordinate = notification.coordinate
        
        let region = MKCoordinateRegion(
					center: CLLocationCoordinate2D(latitude: 1, longitude: 1),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
					Marker(notification.title, coordinate: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27))
							.tint(.red)
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 20))
        .padding()
    }
}
