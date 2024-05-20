//
//  PlacesApp.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import SwiftUI

@main
struct PlacesApp: App {
  var body: some Scene {
    WindowGroup {
      locationsList
    }
  }
  
  @ViewBuilder
  var locationsList: LocationsListView {
    let networkService = DefaultNetworkService()
    let urlOpenable = UIApplication.shared
    let reverseGeocodable = DefaultReverseGeocodable()
    
    let viewModel = LocationsListViewModel(
      networkService: networkService,
      urlOpenable: urlOpenable,
      reverseGeocodable: reverseGeocodable)
    
    LocationsListView(viewModel: viewModel)
  }
}
