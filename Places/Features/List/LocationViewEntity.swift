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
    let latitude: String?
    let longitude: String?
  }
}

extension Location {
  var toLocationViewEntity: LocationsListViewModel.LocationViewEntity {
    LocationsListViewModel.LocationViewEntity(
      name: name,
      latitude: String(lat),
      longitude: String(long))
  }
}
