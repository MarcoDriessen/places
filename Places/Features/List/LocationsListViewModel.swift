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
  private let searchURLComposable: URLComposable
  private let deeplinkURLComposable: URLComposable
  private let urlOpenable: URLOpenable
  private let reverseGeocodable: ReverseGeocodable
  
  init(networkService: NetworkService,
       searchURLComposable: URLComposable,
       deeplinkURLComposable: URLComposable,
       urlOpenable: URLOpenable,
       reverseGeocodable: ReverseGeocodable) {
    self.networkService = networkService
    self.searchURLComposable = searchURLComposable
    self.deeplinkURLComposable = deeplinkURLComposable
    self.urlOpenable = urlOpenable
    self.reverseGeocodable = reverseGeocodable
  }
  
  func fetchLocations() async {
    
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
  
  func didTap(location: LocationViewEntity) {
    guard let latitude = location.latitude, let longitude = location.longitude else {
      return
    }
    
    var searchUrl = searchURLComposable
      .setScheme("https")
      .setHost("en.wikipedia.org")

    searchUrl = searchUrl
      .addQueryItem(name: "latitude", value: String(latitude))
      .addQueryItem(name: "longitude", value: String(longitude))
    
    var deeplinkUrl = deeplinkURLComposable
      .setScheme("wikipedia")
      .setHost("places")
      .setPath("")
    
    guard let searchUrlString = searchUrl.url?.absoluteString else {
      viewState = .error(.urlError)
      return
    }
    
    deeplinkUrl = deeplinkUrl
      .addQueryItem(name: "WMFArticleURL", value: searchUrlString)
    
    guard let deeplinkUrl = deeplinkUrl.url else {
      viewState = .error(.urlError)
      return
    }
    
    urlOpenable.open(deeplinkUrl, options: [:], completionHandler: nil)
  }
  
  func addLocation(latitude: String, longitude: String) async {
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
      
      guard !locations.contains(where: { $0.name == name }) else {
        bottomSheetState = .idle
        return
      }
      let location = LocationViewEntity(name: name, latitude: latitude, longitude: longitude)
      locations.append(location)
      viewState = .success(locations)
      bottomSheetState = .idle
      showBottomSheet = false
    } catch {
      bottomSheetState = .error(.geocodeError)
    }
  }
  
  func addLocation(name: String) async {
    bottomSheetState = .loading
    
    do {
      let coordinate = try await reverseGeocodable.getCoordinates(name: name)
      let location = LocationViewEntity(name: name,
                                        latitude: coordinate.latitude,
                                        longitude: coordinate.longitude)
      guard !locations.contains(where: { $0.name == name }) else {
        bottomSheetState = .idle
        return
      }
      locations.append(location)
      viewState = .success(locations)
      bottomSheetState = .idle
      showBottomSheet = false
    } catch {
      bottomSheetState = .error(.geocodeError)
    }
    
    guard !locations.contains(where: { $0.name == name }) else {
      return
    }
    let location = LocationViewEntity(name: name, latitude: nil, longitude: nil)
    locations.append(location)
    viewState = .success(locations)
    bottomSheetState = .idle
    showBottomSheet = false
  }
  
  func didTapGeocodeErrorConfirm() {
    bottomSheetState = .idle
  }
  
  func didTapUrlErrorConfirm() {
    viewState = .success(locations)
  }
}
