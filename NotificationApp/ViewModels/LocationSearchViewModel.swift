//
//  LocationSearchViewModel.swift
//  NotificationApp
//
//  Created by Mehmet Can Arslan on 10.12.2025.
//

import SwiftUI
import _MapKit_SwiftUI
import Combine

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = "" {
        didSet {
            completer.queryFragment = searchQuery
        }
    }
    @Published var results: [MKLocalSearchCompletion] = []
    
    private let completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .pointOfInterest
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Arama hatası: \(error.localizedDescription)")
    }
    
    func searchLocation(completion: MKLocalSearchCompletion, handler: @escaping (CLLocationCoordinate2D?) -> Void) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response, let item = response.mapItems.first else {
                handler(nil)
                return
            }
            handler(item.placemark.coordinate)
        }
    }
}
