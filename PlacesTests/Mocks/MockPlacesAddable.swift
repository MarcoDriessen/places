//
//  MockPlacesAddable.swift
//  PlacesTests
//
//  Created by Marco Driessen on 01/06/2024.
//

import Foundation
import CoreLocation
@testable import Places

final class MockLocationAddable: LocationAddable {
  
  private var addLocationCallCount: Int = 0
  var isAddLocationCalled: Bool {
    addLocationCallCount > 0
  }
  
  var addLocationName: String? = nil
  var addLocationLatitude: CLLocationDegrees? = nil
  var addLocationLongitude: CLLocationDegrees? = nil
  
  func addLocation(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    addLocationCallCount += 1
    addLocationName = name
    addLocationLatitude = latitude
    addLocationLongitude = longitude
  }
}
