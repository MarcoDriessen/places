//
//  DefaultReverseGeocodable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation
import CoreLocation

struct DefaultReverseGeocodable: ReverseGeocodable {

  private let geocoder: CLGeocoder
  
  init(geocoder: CLGeocoder = CLGeocoder()) {
    self.geocoder = geocoder
  }
  
  func getLocationName(coordinate: CLLocationCoordinate2D) async throws -> String {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let placemarks = try await geocoder.reverseGeocodeLocation(location)
    
    guard let placemark = placemarks.first, let name = placemark.locality else {
      throw ReverseGeocodableError.unknownLocation
    }
    
    return name
  }
  
  func getCoordinates(name: String) async throws -> CLLocationCoordinate2D {
    let placemarks = try await geocoder.geocodeAddressString(name)
    
    guard let placemark = placemarks.first, let location = placemark.location else {
      throw ReverseGeocodableError.unknownLocation
    }
    
    return location.coordinate
  }
}
