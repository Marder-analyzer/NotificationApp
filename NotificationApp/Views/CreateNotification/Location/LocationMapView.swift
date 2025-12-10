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

    @State private var isLocationSelected = false
    
    // MARK: - Main Body
    var body: some View {
        ZStack(alignment: .center) {
            mapLayer
            
            if isLocationSelected {
                selectedPinMarker
            } else {
                placeholderOverlay
            }
        }
        .frame(height: 250)
        .clipShape(.rect(cornerRadius: 20))
        .onTapGesture {
            if isLocationSelected { navigateToMap = true }
        }
        .navigationDestination(isPresented: $navigateToMap) {
            ChooseLocationView(region: $region, isLocationSelected: $isLocationSelected)
                .navigationBarHidden(true)
                .toolbar(.hidden, for: .tabBar)
        }
    }

    private var mapLayer: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
            .disabled(isLocationSelected)
            .onAppear {
                if !isLocationSelected { locationManager.requestLocation() }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if !isLocationSelected, let location = newLocation {
                    withAnimation {
                        region = MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                        )
                    }
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
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
            }
        }
    }
    
    private var selectedPinMarker: some View {
        Image(systemName: "mappin.fill")
            .font(.largeTitle)
            .foregroundColor(.red)
            .padding(.bottom, 20)
            .shadow(radius: 4)
    }
}

#Preview {
    LocationMapView(region: .constant(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
}
