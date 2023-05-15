//
//  LocationService.swift
//  Weather
//
//  Created by Rohith Reddy Gurram on 5/14/23.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationDidUpdate(_ service: LocationService, location: CLLocation)
    func locationDidFail(withError error: WeatherError)
}

class LocationService: NSObject {
    var delegate: LocationServiceDelegate?
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
      locationManager.requestWhenInUseAuthorization()
      locationManager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.locationDidUpdate(self, location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationDidFail(withError: WeatherError.unableToFindLocation)
    }
}

