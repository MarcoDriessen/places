//
//  MockReverseGeocoable.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation
import CoreLocation
@testable import Places

class MockReverseGeocodable: ReverseGeocodable {
  
  var mockName: String?
  var mockCoordinate: CLLocationCoordinate2D?
  var error: Error?
  
  func getLocationName(coordinate: CLLocationCoordinate2D) async throws -> String {
    if let error = error {
      throw error
    }
    
    guard let name = mockName else {
      throw ReverseGeocodableError.unknownLocation
    }
    
    return name
  }
  
  func getCoordinates(name: String) async throws -> CLLocationCoordinate2D {
    if let error = error {
      throw error
    }
    
    guard let coordinate = mockCoordinate else {
      throw ReverseGeocodableError.unknownLocation
    }
    
    return coordinate
  }
}

