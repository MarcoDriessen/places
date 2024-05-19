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
            let viewModel = LocationsListViewModel(networkService: networkService)
            LocationsListView(viewModel: viewModel)
        }
    }
}
