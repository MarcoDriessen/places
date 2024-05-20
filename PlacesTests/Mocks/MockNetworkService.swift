//
//  MockNetworkService.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation
@testable import Places

class MockNetworkService: NetworkService {
    var decoder = JSONDecoder()
    var urlSession = URLSession.shared
    
    var mockData: Data?
    var error: Error?

    func fetch<T: Decodable>(from url: URL) async throws -> T {
        if let error = error {
            throw error
        }
        
        guard let data = mockData else {
            throw NetworkError.noData
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
