//
//  Location.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 07/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate: class {
    func updateData()
}

class Location: NSObject {
    
    // MARK: - Variables
    
    weak var delegate: LocationDelegate?
    
    var placemark: CLPlacemark? {
        didSet {
            delegate?.updateData()
        }
    }
    
    var currentLocation: CLLocationCoordinate2D? {
        get {
            return self.locationManager.location?.coordinate
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    // MARK: - Methods

    func requestPermissions() {
    
        let status  = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled",
                                          message: "Please enable Location Services in Settings",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            let topController = UIApplication.topViewController()
            topController?.present(alert, animated: true, completion: nil)
        }
    }
}

extension Location: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (placemark != nil) { return }
        
        let geocoder = CLGeocoder()
        
        if let location = self.locationManager.location {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error{
                    print("Location manager error: \(error.localizedDescription)")
                    return
                }
                
                self.placemark = placemarks?.first
            }
        }else{
            print("Location manager error")
        }
    }
    
}

