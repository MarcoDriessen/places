//
//  LocationAddable.swift
//  Places
//
//  Created by Marco Driessen on 01/06/2024.
//

import Foundation
import CoreLocation

protocol LocationAddable: AnyObject {
  func addLocation(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}
