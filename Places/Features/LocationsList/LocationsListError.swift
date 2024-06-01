//
//  LocationsListError.swift
//  Places
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation

extension LocationsListViewModel {
  enum LocationsListError: Error {
    case fetchError
    case urlError
  }
}
