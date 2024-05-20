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
  
  func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> String {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let placemarks = try await geocoder.reverseGeocodeLocation(location)
    
    guard let placemark = placemarks.first, let name = placemark.locality else {
      throw ReverseGeocodableError.unknownLocation
    }
    
    return name
  }
}
