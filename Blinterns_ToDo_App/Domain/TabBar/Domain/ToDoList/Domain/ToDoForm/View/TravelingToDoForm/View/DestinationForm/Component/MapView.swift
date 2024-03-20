//
//  MapView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    var isMarked: Bool
    var latitude: Double?
    var longitude: Double?
    let locationManager = CLLocationManager()
    
    var body: some View {
        Map(coordinateRegion: .constant(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ),
            showsUserLocation: true,
            userTrackingMode: .constant(isMarked ? .none : .follow),
            annotationItems: isMarked ? [MapAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0))] : []) { item in
                MapMarker(coordinate: item.coordinate, tint: .red)
            }
            .onAppear {
                requestLocationPermission()
            }
    }
    
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension MapView {
    struct MapAnnotationItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}

#Preview {
    MapView(isMarked: false, latitude: nil, longitude: nil)
}
