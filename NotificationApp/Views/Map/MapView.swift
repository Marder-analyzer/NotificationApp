//
//  MapView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 11.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var locationManager = LocationManager() 
    

    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var currentRegion: MKCoordinateRegion?
    
    @State private var selectedNotificationID: UUID?
    
    var selectedNotification: NotificationItem? {
        viewModel.notifications.first { $0.id == selectedNotificationID }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Map(position: $cameraPosition, selection: $selectedNotificationID) {
                UserAnnotation()
                
                ForEach(viewModel.notifications) { item in
                    if let coordinate = item.locationCoordinate {
                        Marker(item.title, systemImage: item.type.iconName, coordinate: coordinate)
                            .tint(item.type.color)
                            .tag(item.id)
                    }
                }
            }
            .onMapCameraChange { context in
                self.currentRegion = context.region
            }
            .mapControls {
                MapCompass()
            }
            .onAppear {
                viewModel.fetchNotifications()
                locationManager.requestLocation()
            }

            if selectedNotificationID == nil {
                controlsSection
                    .padding(.bottom, 20)
            }
            
            if let selected = selectedNotification {
                NotificationMapCardView(notification: selected) {
                    withAnimation(.spring) {
                        selectedNotificationID = nil
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }
        }
    }

    private var controlsSection: some View {
        HStack(alignment: .bottom) {
            Spacer()
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    zoomButton(icon: "plus", action: zoomIn)
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                        .frame(width: 30)
                    
                    zoomButton(icon: "minus", action: zoomOut)
                }
                .background(Color.hexConverter(hexString: "#1e293b"))
                .cornerRadius(20)
                .shadow(radius: 6)
                
                Button(action: goToMyLocation) {
                    Image(systemName: "location.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(16)
                        .background(Color.blue.gradient)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                }
            }
            .padding(.trailing, 20)
        }
    }
    
    // MARK: - Yardımcı Görünümler & Fonksiyonlar
    private func zoomButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
        }
    }
    
    private func zoomIn() {
        guard var region = currentRegion else { return }
        withAnimation {
            region.span.latitudeDelta *= 0.5
            region.span.longitudeDelta *= 0.5
            cameraPosition = .region(region)
        }
    }
    
    private func zoomOut() {
        guard var region = currentRegion else { return }
        withAnimation {
            region.span.latitudeDelta *= 2.0
            region.span.longitudeDelta *= 2.0
            cameraPosition = .region(region)
        }
    }
    
    private func goToMyLocation() {
        withAnimation {
            cameraPosition = .userLocation(fallback: .automatic)
        }
    }
}

#Preview {
    MapView()
}
