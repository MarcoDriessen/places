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
  
  var locationsList: LocationsListView {
    let networkService = DefaultNetworkService()
    let urlOpenable = UIApplication.shared
    let reverseGeocodable = DefaultReverseGeocodable()
        
    let searchViewModel = SearchViewModel(
      reverseGeocodable: reverseGeocodable
    )
    
    let viewModel = LocationsListViewModel(
      networkService: networkService,
      urlOpenable: urlOpenable,
      searchViewModel: searchViewModel
    )
    
    searchViewModel.locationAddable = viewModel
    
    return LocationsListView(
      viewModel: viewModel
    )
  }
}
