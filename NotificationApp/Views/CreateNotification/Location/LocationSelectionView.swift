//
//  LocationSelectionView.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 3.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI

struct LocationSelectionView: View {
    @ObservedObject var viewModel: CreateNotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Konum")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LocationMapView(
                region: $viewModel.region,
                onRegionChange: { coordinate in
                    Task {
                        await viewModel.getAddressFromLatLon(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                    }
                }
            )
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    LocationSelectionView(viewModel: CreateNotificationViewModel())
}
