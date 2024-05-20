//
//  LocationViewEntity.swift
//  Places
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation

extension LocationsListViewModel {
  struct LocationViewEntity: Equatable, Identifiable {
    var id = UUID()
    let name: String?
    let latitude: Double?
    let longitude: Double?
  }
}

extension Location {
  var toLocationViewEntity: LocationsListViewModel.LocationViewEntity {
    LocationsListViewModel.LocationViewEntity(
      name: name,
      latitude: lat,
      longitude: long)
  }
}
