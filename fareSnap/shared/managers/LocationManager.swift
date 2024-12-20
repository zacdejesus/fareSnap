//
//  LocationManager.swift
//  fareSnap
//
//  Created by Alejandro De Jesus on 05/12/2024.
//
import Foundation
import Combine
import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    var userLocation: CLLocationCoordinate2D? { get }
    var userLocationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> { get }
    func requestPermission()
    func startUpdatingLocation()
}



class LocationManager: NSObject, LocationManagerProtocol, ObservableObject, CLLocationManagerDelegate {
    var userLocationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
        $userLocation.eraseToAnyPublisher()
    }
    
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }
}
