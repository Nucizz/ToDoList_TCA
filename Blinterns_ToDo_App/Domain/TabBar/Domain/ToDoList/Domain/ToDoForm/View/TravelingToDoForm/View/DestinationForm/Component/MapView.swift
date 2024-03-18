//
//  MapView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var isMarked: Bool
    @Binding var latitude: Double?
    @Binding var longitude: Double?
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

struct MapView_Previews: PreviewProvider {
    @State static var latitude: Double? = nil
    @State static var longitude: Double? = nil
    @State static var isMarked: Bool = false
    
    static var previews: some View {
        MapView(isMarked: $isMarked, latitude: $latitude, longitude: $longitude)
    }
}
