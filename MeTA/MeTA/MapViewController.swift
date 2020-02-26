//
//  MapViewController.swift
//  MeTA
//
//  Created by Kevin J. Zheng on 2/24/20.
//  Copyright © 2020 senior design. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var refreshPlaces: UIBarButtonItem!
    @IBAction func refreshPlaces(_ sender: Any) {
      fetchNearbyPlaces(coordinate: mapView.camera.target)
    }
    private let locationManager = CLLocationManager()
    
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
      let geocoder = GMSGeocoder()
        
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
          return
        }
          
        self.addressLabel.text = lines.joined(separator: "\n")
        let labelHeight = self.addressLabel.intrinsicContentSize.height
        self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                              bottom: labelHeight, right: 0)
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
      // 1
      mapView.clear()
      // 2
      dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
        places.forEach {
          // 3
          let marker = PlaceMarker(place: $0)
          // 4
          marker.map = self.mapView
        }
      }
    }

}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(coordinate: location.coordinate)
  }
}

extension MapViewController: TypesTableViewControllerDelegate {
  func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = controller.selectedTypes.sorted()
    dismiss(animated: true)
    fetchNearbyPlaces(coordinate: mapView.camera.target)
  }
}

extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocodeCoordinate(position.target)
  }
    
}


