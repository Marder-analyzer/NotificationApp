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
    
    var body: some View {
        ZStack(alignment: .center) {
            Map(coordinateRegion: $region)
                .disabled(true)
                .overlay(
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundColor(.red)
                        .shadow(radius: 2)
                        .padding(.bottom, 20)
                )

            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.6)
                .overlay(Color.black.opacity(0.3))
            
            Button(action: {
                print("Konum seçme moduna girildi")
            }) {
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
        .frame(height: 250)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    LocationMapView(region: .constant(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.90, longitude: 41.27),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
}
