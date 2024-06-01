//
//  LocationsListViewModel.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation
import UIKit
import CoreLocation

@Observable
final class LocationsListViewModel {
  
  enum ViewState {
    case loading
    case success([LocationViewEntity])
    case error(LocationsListError)
  }
  
  enum BottomSheetState {
    case idle
    case loading
    case error(GeocodeError)
  }
  
  private(set) var viewState: ViewState = .loading
  private(set) var bottomSheetState: BottomSheetState = .idle
  
  var showBottomSheet: Bool = false
  private var locations: [LocationViewEntity] = []
  
  private let networkService: NetworkService
  private let urlOpenable: URLOpenable
  private let reverseGeocodable: ReverseGeocodable
  
  init(networkService: NetworkService,
       urlOpenable: URLOpenable,
       reverseGeocodable: ReverseGeocodable) {
    self.networkService = networkService
    self.urlOpenable = urlOpenable
    self.reverseGeocodable = reverseGeocodable
  }
  
  func fetchLocations() {
    Task {
      guard let url = URL(string: Constants.locationsURLString) else {
        return
      }
      
      do {
        let places: Places = try await networkService.fetch(from: url)
        locations = places.locations
          .filter { $0.name != nil }
          .map { $0.toLocationViewEntity }
        viewState = .success(locations)
      } catch {
        viewState = .error(.fetchError)
      }
    }
  }
  
  func didTap(location: LocationViewEntity) {
    guard let latitude = location.latitude, let longitude = location.longitude else {
      return
    }
    
    let searchURL = LocationsListURL.searchURL(with: latitude, longitude: longitude)
    guard let searchURLString = searchURL?.absoluteString else {
      viewState = .error(.urlError)
      return
    }
    
    let deeplinkURL = LocationsListURL.deeplinkURL(with: searchURLString)
    
    guard let deeplinkURL = deeplinkURL else {
      viewState = .error(.urlError)
      return
    }
    
    urlOpenable.open(deeplinkURL, options: [:], completionHandler: nil)
  }
  
  func addLocation(latitude: String, longitude: String) {
    Task {
      bottomSheetState = .loading
      
      let formattedLatitude = latitude.replacingOccurrences(of: ",", with: ".")
      let formattedLongitude = longitude.replacingOccurrences(of: ",", with: ".")
      
      guard let latitude = Double(formattedLatitude), let longitude = Double(formattedLongitude) else {
        bottomSheetState = .error(.invalidFormat)
        return
      }
      
      do {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let name = try await reverseGeocodable.getLocationName(coordinate: coordinate)
        addLocation(name: name, latitude: latitude, longitude: longitude)
      } catch {
        bottomSheetState = .error(.geocodeError)
      }
    }
  }
  
  func addLocation(name: String) {
    Task {
      bottomSheetState = .loading
      
      do {
        let coordinate = try await reverseGeocodable.getCoordinates(name: name)
        addLocation(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
      } catch {
        bottomSheetState = .error(.geocodeError)
      }
    }
  }
  
  func didTapGeocodeErrorConfirm() {
    bottomSheetState = .idle
  }
  
  func didTapUrlErrorConfirm() {
    viewState = .success(locations)
  }
}

// MARK: - Private
extension LocationsListViewModel {
  fileprivate func addLocation(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    guard !locations.contains(where: { $0.name == name }) else {
      bottomSheetState = .idle
      return
    }
    let location = LocationViewEntity(name: name, latitude: String(latitude), longitude: String(longitude))
    locations.append(location)
    viewState = .success(locations)
    bottomSheetState = .idle
    showBottomSheet = false
  }
}
