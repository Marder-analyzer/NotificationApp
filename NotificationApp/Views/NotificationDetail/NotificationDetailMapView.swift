//
//  NotificationDetailMapView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 4.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct NotificationDetailMapView: View {
    // MARK: - Değişkenler
    let notification: NotificationItem
    
    @State private var cameraPosition: MapCameraPosition
    
    private var markerCoordinate: CLLocationCoordinate2D
    
    init(notification: NotificationItem) {
        self.notification = notification
        
        let components = notification.coordinate.split(separator: ",")
        
        var parsedCoordinate = CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27)
        
        if components.count == 2,
           let lat = Double(components[0].trimmingCharacters(in: .whitespaces)),
           let lon = Double(components[1].trimmingCharacters(in: .whitespaces)) {
            parsedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        self.markerCoordinate = parsedCoordinate
        
        let region = MKCoordinateRegion(
            center: parsedCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            Marker(notification.title, coordinate: markerCoordinate)
                .tint(.red)
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 20))
        .padding()
        .onAppear {
            let region = MKCoordinateRegion(
                center: markerCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
            cameraPosition = .region(region)
        }
    }
}
