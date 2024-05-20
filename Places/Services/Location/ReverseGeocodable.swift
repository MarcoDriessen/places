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
  func getLocationName(coordinate: CLLocationCoordinate2D) async throws -> String
  func getCoordinates(name: String) async throws -> CLLocationCoordinate2D
}
