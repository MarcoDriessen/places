//
//  MockReverseGeocoable.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation
@testable import Places

class MockReverseGeocodable: ReverseGeocodable {
    var mockName: String?
    var error: Error?

    func reverseGeocode(latitude: Double, longitude: Double) async throws -> String {
        if let error = error {
            throw error
        }
        
        guard let name = mockName else {
            throw NetworkError.noData
        }
        
        return name
    }
}

