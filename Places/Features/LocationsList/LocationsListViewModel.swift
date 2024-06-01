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
  
  enum ViewState: Equatable {
    case loading
    case success([LocationViewEntity])
    case error(LocationsListError)
  }
  
  private(set) var viewState: ViewState = .loading
  
  var showBottomSheet: Bool = false
  private var locations: [LocationViewEntity] = []
  
  private let networkService: NetworkService
  private let urlOpenable: URLOpenable
  
  init(networkService: NetworkService,
       urlOpenable: URLOpenable) {
    self.networkService = networkService
    self.urlOpenable = urlOpenable
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
    
    guard urlOpenable.canOpenURL(deeplinkURL) else {
      viewState = .error(.openURLError)
      return
    }
    
    urlOpenable.open(deeplinkURL, options: [:], completionHandler: nil)
  }

  func didTapUrlErrorConfirm() {
    viewState = .success(locations)
  }
}

extension LocationsListViewModel: LocationAddable {
  internal func addLocation(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    guard !locations.contains(where: { $0.name == name }) else {
      return
    }
    let location = LocationViewEntity(name: name, latitude: String(latitude), longitude: String(longitude))
    locations.append(location)
    viewState = .success(locations)
    showBottomSheet = false
  }
}
