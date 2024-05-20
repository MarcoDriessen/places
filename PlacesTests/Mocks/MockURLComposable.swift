//
//  MockURLComposable.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation
@testable import Places

class MockURLComposable: URLComposable {
    private var components = URLComponents()
    
    func setScheme(_ scheme: String) -> Self {
        components.scheme = scheme
        return self
    }
    
    func setHost(_ host: String) -> Self {
        components.host = host
        return self
    }
    
    func setPath(_ path: String) -> Self {
        components.path = path
        return self
    }
    
    func addQueryItem(name: String, value: String?) -> Self {
        if components.queryItems == nil {
            components.queryItems = []
        }
        components.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    var url: URL? {
        return components.url
    }
}

