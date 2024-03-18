//
//  LocationHelper.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import MapKit
import Dependencies

struct LocationRepository: DependencyKey {
    var fetchLocation: (String) async throws -> [Destination]
}

extension LocationRepository {
    static var liveValue: LocationRepository {
        return Self(
            fetchLocation: { query in
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
                    throw error
                }
            }
        )
    }
}


extension DependencyValues {
    var locationRepository: LocationRepository {
        get { self[LocationRepository.self] }
        set { self[LocationRepository.self] = newValue }
    }
}

