//
//  LocationHelper.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import MapKit

class LocationRepository: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    func fetchLocations(query: String) async -> [Destination] {
        do {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query.lowercased()

            let response = try await MKLocalSearch(request: request).start()

            return response.mapItems.compactMap { item in
                let placemark = item.placemark
                return Destination(
                    name: item.name ?? "",
                    address: placemark.title ?? "",
                    longitude: placemark.coordinate.longitude,
                    latitude: placemark.coordinate.latitude
                )
            }
        } catch {
            return []
        }
        
    }
    
}
