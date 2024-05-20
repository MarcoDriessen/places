//
//  ReverseGeocodable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation
import CoreLocation

enum ReverseGeocodableError: Error {
  case unknownLocation
}

protocol ReverseGeocodable {
  func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> String
}
