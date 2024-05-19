//
//  LocationsListViewModel.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation

@Observable
final class LocationsListViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case success([Location])
        case error(Error)
    }
    
    private(set) var viewState: ViewState = .loading
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchLocations() async {
        // Move url elsewhere
        do {
            let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
            let places: Places = try await networkService.fetch(from: url)
            viewState = .success(places.locations.filter { $0.name != nil })
        } catch {
            viewState = .error(error)
        }
    }
}
