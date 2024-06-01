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
  
  func addLocation(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    addLocationCallCount += 1
  }
}
