//
//  UserLocationHelper.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 12-03-2024.
//

import Foundation
import CoreLocation

struct UserLocationHelper {
    
    let locationManager = CLLocationManager()
    
    func getCoordinates() -> (latitude: Double, longitude: Double)? {
        guard getAuthorization() else {
            return nil
        }
        
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                return
            }
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if let result: CLLocationCoordinate2D = locationManager.location?.coordinate {
            locationManager.stopUpdatingLocation()
            return (result.latitude, result.longitude)
        }
        
        return nil
    }
    
    func onCoordinatesReturned() {
        locationManager.stopUpdatingLocation()
    }
    
    private func getAuthorization() -> Bool {
        let status = locationManager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        } else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return getAuthorization()
        } else {
            return false
        }
    }
    
}
