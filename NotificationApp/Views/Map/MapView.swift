//
//  MapView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 11.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct MapView: View {

    @StateObject private var vm: GenericViewModel
    @StateObject private var locationManager = LocationManager()
    var profile: AuthUser
    
    @State private var cameraPosition: MapCameraPosition =
        .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 39.0, longitude: 35.0),
                span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
            )
        )
    @State private var currentRegion: MKCoordinateRegion?
    
    @State private var selectedNotificationID: String?
    
    var selectedNotification: NotificationItem? {
        vm.notificationModel.first { $0.id == selectedNotificationID }
    }
    
    init(repository: GenericViewModel, profile: AuthUser) {
        _vm = StateObject(wrappedValue: repository)
        self.profile = profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Map(position: $cameraPosition, selection: $selectedNotificationID) {
                UserAnnotation()
                
                ForEach(vm.notificationModel.filter { $0.locationCoordinate != nil }) { item in
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
                vm.loadNotifications()
                locationManager.requestLocation()
            }

            if selectedNotificationID == nil {
                controlsSection
                    .padding(.bottom, 20)
            }
            
            if let selected = selectedNotification {
                NotificationMapCardView(notification: selected, vm: vm, profile: profile) {
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
        guard let location = locationManager.userLocation else {
            locationManager.requestLocation()
            return
        }

        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )

        withAnimation(.easeInOut(duration: 0.6)) {
            cameraPosition = .region(region)
        }
    }

}

//#Preview {
//    let repo = RepositoryFactory().makeNotificationRepository()
//    let vm = GenericViewModel(repository: repo)
//    MapView(repository: <#_#>, profile: <#AuthUser?#>)
//}
