//
//  ChooseLocationView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 10.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct ChooseLocationView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Binding var region: MKCoordinateRegion
    @Binding var isLocationSelected: Bool
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchViewModel = LocationSearchViewModel()
    
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    @State private var isGeocoding: Bool = false

    @State private var isPinLifted: Bool = false
    
    let configuration = LocationConfiguration()
    
    // MARK: - Main Body
    var body: some View {
        ZStack {
            mapLayer
            
            centerPin
            
            VStack(spacing: 0) {
                topControlArea
                
                Spacer()
                
                controlsSection
                
                confirmButton
            }
        }
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
            .onAppear { locationManager.requestLocation() }
    }
    
    private var centerPin: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin")
                .font(.system(size: 40))
                .bold()
                .foregroundColor(.red)
                .offset(y: isPinLifted ? -20 : 0)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            
            Image(systemName: "oval.fill")
                .font(.caption)
                .foregroundColor(.black.opacity(0.2))
                .scaleEffect(isPinLifted ? 0.6 : 1.0)
                .opacity(isPinLifted ? 0.5 : 1.0)
        }
        .padding(.bottom, 40)
    }
    
    private var topControlArea: some View {
        ZStack(alignment: .topLeading) {
            backButton
            searchSection
        }
        .padding(.top, 20)
        .padding(.horizontal)
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .tint(.white)
                .bold()
        }
        .frame(width: 55, height: 55)
        .background(Color.hexConverter(hexString: "#1e293b"))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private var searchSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.hexConverter(hexString: "#8e8e93"))
                
                TextFieldComp(title: nil,
                              placeholder: "Konum Ara",
                              text: $searchText,
                              configuration: configuration.chooseLocationConfiguration)
                .onCodeCompletion { text in
                    searchViewModel.searchQuery = text
                }
                .focused($isFocused)
                .accentColor(.white)
                
                if !searchText.isEmpty {
                    Button {
                        clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.hexConverter(hexString: "#1e293b"))
            .cornerRadius(12)
            .shadow(radius: 5)
            
            if isFocused && !searchViewModel.searchQuery.isEmpty && !searchViewModel.results.isEmpty {
                resultsList
            }
        }
        .padding(.leading, 65)
    }
    
    private var resultsList: some View {
        VStack(alignment: .leading) {
            ForEach(searchViewModel.results.prefix(5), id: \.self) { result in
                Button {
                    selectLocation(result)
                } label: {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .foregroundColor(.primary)
                            .font(.headline)
                        Text(result.subtitle)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
            }
        }
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private var controlsSection: some View {
        HStack(alignment: .bottom) {
            Spacer()
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    zoomButton(icon: "plus", action: zoomIn)
                    Divider().background(Color.white.opacity(0.5)).frame(width: 30)
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
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 40)
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
    
    private var confirmButton: some View {
        Button {
            isLocationSelected = true
            dismiss()
        } label: {
            Text("Bu Konumu Kullan")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(15)
                .padding(.horizontal, 60)
                .padding(.bottom, 5)
        }
    }
    
    private func clearSearch() {
        searchViewModel.searchQuery = ""
        searchViewModel.results = []
        searchText = ""
    }
    
    private func zoomIn() {
        withAnimation {
            region.span.latitudeDelta *= 0.5
            region.span.longitudeDelta *= 0.5
        }
    }
    
    private func zoomOut() {
        withAnimation {
            region.span.latitudeDelta *= 2.0
            region.span.longitudeDelta *= 2.0
        }
    }
    
    private func goToMyLocation() {
        if let location = locationManager.userLocation {
            isFocused = false
            moveToLocation(location)
            getAddressFromCoordinates(location)
        } else {
            locationManager.requestLocation()
        }
    }
    
    private func selectLocation(_ completion: MKLocalSearchCompletion) {
        searchViewModel.searchLocation(completion: completion) { coordinate in
            if let coordinate = coordinate {
                moveToLocation(coordinate)
                self.searchText = completion.title
                searchViewModel.results = []
                isFocused = false
            }
        }
    }
    
    private func moveToLocation(_ coordinate: CLLocationCoordinate2D) {
        withAnimation {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
    private func getAddressFromCoordinates(_ coordinate: CLLocationCoordinate2D) {
        isGeocoding = true
        withAnimation(.spring()) {
            isPinLifted = true
        }
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            defer {
                isGeocoding = false
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                    isPinLifted = false
                }
            }
            
            if let place = placemarks?.first {
                let name = place.name ?? ""
                let thoroughfare = place.thoroughfare ?? ""
                let locality = place.locality ?? ""
                
                DispatchQueue.main.async {
                    if !name.isEmpty {
                        self.searchText = name
                    } else {
                        self.searchText = "\(thoroughfare), \(locality)"
                    }
                }
            }
        }
    }
}

#Preview {
    ChooseLocationView(region: .constant(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9334, longitude: 32.8597),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )),
                       isLocationSelected: .constant(false))
}
