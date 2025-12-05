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
            center: coordinate,
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

#Preview {
    NotificationDetailView(notification: NotificationItem(
        type: .security,
        title: "Kütüphane Arkası Şüpheli Paket",
        description: "Kütüphane arka girişinde sahipsiz siyah bir çanta var, uzun süredir orada duruyor.",
        date: Date(),
        status: .open,
        userName: "Ahmet Yılmaz",
        address: "Merkezi Yemekhane Önü, Kampüs",
        coordinate: CLLocationCoordinate2D(latitude: 39.90,
                                           longitude: 41.27),
        imageUrls: [""]
    ))
}
