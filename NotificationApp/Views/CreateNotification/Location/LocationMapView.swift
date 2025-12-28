//
//  LocationMapView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct LocationMapView: View {
    @Binding var region: MKCoordinateRegion
    @State private var navigateToMap = false
    @StateObject private var locationManager = LocationManager()
    @Binding var isLocationSelected: Bool
    var onRegionChange: ((CLLocationCoordinate2D) -> Void)? = nil
    
    // MARK: - Main Body
    var body: some View {
        ZStack(alignment: .center) {
            mapLayer
            
            if !isLocationSelected  {
                placeholderOverlay
            }
        }
        .frame(height: 250)
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            Group {
                if isLocationSelected {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            navigateToMap = true
                        }
                }
            }
        )
        .navigationDestination(isPresented: $navigateToMap) {
            ChooseLocationView(region: $region, isLocationSelected: $isLocationSelected)
                .navigationBarHidden(true)
                .toolbar(.hidden, for: .tabBar)
                .onDisappear {
                    if isLocationSelected {
                        onRegionChange?(region.center)
                    }
                }
        }
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: isLocationSelected ? [MapPinItem(coordinate: region.center)] : []) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
        .disabled(false)
        .onChange(of: locationManager.userLocation) { newLocation in
            if !isLocationSelected, let location = newLocation {
                updateRegion(to: location)
            }
        }
    }
    
    private var placeholderOverlay: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.6)
                .overlay(Color.black.opacity(0.3))
            
            Button {
                navigateToMap = true
            } label: {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Konum Seç")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.blue.gradient)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
            }
        }
    }
    
    private func updateRegion(to coordinate: CLLocationCoordinate2D) {
        withAnimation {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
        onRegionChange?(coordinate)
    }
}

struct MapPinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

/*#Preview {
    LocationMapView(region: .constant(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
}
*/
