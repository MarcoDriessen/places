//
//  DefaultURLComposable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation

final class DefaultURLComposable: URLComposable {

    private var components: URLComponents
    
    init(scheme: String,
         host: String,
         path: String) {
        components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
    }
    
    func addQueryItem(name: String, value: String) -> Self {
        var queryItems = components.queryItems ?? []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        components.queryItems = queryItems
        return self
    }

    var url: URL? {
        components.url
    }
}
