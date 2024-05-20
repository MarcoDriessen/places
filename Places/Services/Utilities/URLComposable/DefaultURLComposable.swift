//
//  DefaultURLComposable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation

final class DefaultURLComposable: URLComposable {

    private var components: URLComponents
    
    init() {
        self.components = URLComponents()
    }

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
