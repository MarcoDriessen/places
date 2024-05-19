//
//  Place.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation
import CoreLocation

struct Location: Decodable {
  let name: String?
  let lat: CLLocationDegrees
  let long: CLLocationDegrees
}
