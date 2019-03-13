//
//  MapViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 03.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    private var mapView: GMSMapView!
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var zoomLevel: Float = 17.0
    private var selectedPlace: CLLocationCoordinate2D?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setupMapView()
        setupWithPermission()
    }
    
    func savedLocation() -> (String, String) {
        return ("Lat: \(selectedPlace?.latitude ?? 0.0)", "Long: \(selectedPlace?.longitude ?? 0.0)")
    }
    
    private func setupMapView() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.296320,
                                              longitude: 1.067484,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.layer.cornerRadius = 10

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    
    private func addMarker(ToPosition position: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .princetonOrange)
        marker.map = mapView
        selectedPlace = position
    }
    
    private func setupWithPermission() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            // TODO: tell user to enable location tracking in phone settings
            print("location request denied")
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("location access authorized")
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        addMarker(ToPosition: coordinate)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        addMarker(ToPosition: location.coordinate)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .notDetermined:
            print("Location status not determined.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location status is OK.")
            mapView.isHidden = false
            mapView.animate(toZoom: zoomLevel)
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}
