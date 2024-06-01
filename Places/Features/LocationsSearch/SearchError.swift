//
//  SearchError.swift
//  Places
//
//  Created by Marco Driessen on 01/06/2024.
//

import Foundation

extension SearchViewModel {
  enum GeocodeError: Error {
    case geocodeError
    case invalidFormat
  }
}
