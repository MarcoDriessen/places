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
      let networkService = DefaultNetworkService()
      let searchURLComposable = DefaultURLComposable()
      let deeplinkURLComposable = DefaultURLComposable()
      let urlOpenable = UIApplication.shared
      let reverseGeocodable = DefaultReverseGeocodable()
      
      let viewModel = LocationsListViewModel(
        networkService: networkService,
        searchURLComposable: searchURLComposable,
        deeplinkURLComposable: deeplinkURLComposable,
        urlOpenable: urlOpenable,
        reverseGeocodable: reverseGeocodable)
      
      LocationsListView(viewModel: viewModel)
    }
  }
}
