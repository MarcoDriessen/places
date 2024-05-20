//
//  WikipediaSearchURLComposer.swift
//  Places
//
//  Created by Marco Driessen on 20/05/2024.
//

import Foundation

struct LocationsListURL {
  
  static func searchURL(with latitude: String, longitude: String) -> URL? {
  
    var components = URLComponents()
    
    components.scheme = "https"
    components.host = "en.wikipedia.org"
    
    let queryItems = [
      URLQueryItem(name: "latitude", value: latitude),
      URLQueryItem(name: "longitude", value: longitude)
    ]
    
    components.queryItems = queryItems
    
    return components.url
  }
  
  static func deeplinkURL(with searchString: String) -> URL? {
  
    var components = URLComponents()
    
    components.scheme = "wikipedia"
    components.host = "places"
  
    components.queryItems = [URLQueryItem(name: "WMFArticleURL", value: searchString)]
    
    return components.url
  }
}
