//
//  SearchViewModel.swift
//  Places
//
//  Created by Marco Driessen on 01/06/2024.
//

import Foundation
import CoreLocation

@Observable
final class SearchViewModel {
  
  enum GeocodeError: Error {
    case geocodeError
    case invalidFormat
  }
  
  enum ViewState {
    case idle
    case loading
    case error(GeocodeError)
  }
  
  private(set) var viewState: ViewState = .idle
  private let reverseGeocodable: ReverseGeocodable
  private weak var locationAddable: LocationAddable?
  
  init(reverseGeocodable: ReverseGeocodable,
       locationAddable: LocationAddable) {
    self.reverseGeocodable = reverseGeocodable
    self.locationAddable = locationAddable
  }
  
  func addLocation(latitude: String, longitude: String) {
    Task {
      viewState = .loading
      
      let formattedLatitude = latitude.replacingOccurrences(of: ",", with: ".")
      let formattedLongitude = longitude.replacingOccurrences(of: ",", with: ".")
      
      guard let latitude = Double(formattedLatitude), let longitude = Double(formattedLongitude) else {
        viewState = .error(.invalidFormat)
        return
      }
      
      do {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let name = try await reverseGeocodable.getLocationName(coordinate: coordinate)
        locationAddable?.addLocation(name: name, latitude: latitude, longitude: longitude)
        viewState = .idle
      } catch {
        viewState = .error(.geocodeError)
      }
    }
  }
  
  func addLocation(name: String) {
    Task {
      viewState = .loading
      
      do {
        let coordinate = try await reverseGeocodable.getCoordinates(name: name)
        locationAddable?.addLocation(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
        viewState = .idle
      } catch {
        viewState = .error(.geocodeError)
      }
    }
  }
  
  func didTapGeocodeErrorConfirm() {
    viewState = .idle
  }
}
