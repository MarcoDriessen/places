//
//  LocationsListViewModel.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation
import UIKit

@Observable
final class LocationsListViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case success([Location])
        case error(Error? = nil) // use domain error
    }
    
    private(set) var viewState: ViewState = .loading
    
    private let networkService: NetworkService
    private let urlComposable: URLComposable
    
    init(networkService: NetworkService,
         urlComposable: URLComposable) {
        self.networkService = networkService
        self.urlComposable = urlComposable
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
    
    func didTap(location: Location) {
        
        guard let name = location.name else {
            viewState = .error()
            return
        }
        
        let searchUrl = DefaultURLComposable()
            .setScheme("https")
            .setHost("en.wikipedia.org")
            .setPath("/\(name)")
        
        var deeplinkUrl = DefaultURLComposable()
            .setScheme("wikipedia")
            .setHost("places")
            .setPath("")
        
        guard let searchUrlString = searchUrl.url?.absoluteString else {
            viewState = .error()
            return
        }
        
        deeplinkUrl = deeplinkUrl
            .addQueryItem(name: "WMFArticleURL", value: searchUrlString)
        
        UIApplication.shared.open(deeplinkUrl.url!)
    }
}
