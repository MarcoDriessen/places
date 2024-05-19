//
//  URLComposableTests.swift
//  PlacesTests
//
//  Created by Marco Driessen on 19/05/2024.
//

import XCTest
@testable import Places

class URLComposableTests: XCTestCase {

    func test_without_queryItems() {
        // Given - When
        let urlComposable = DefaultURLComposable(scheme: "wikipedia", host: "places", path: "")
        
        // Then
        XCTAssertEqual(urlComposable.url?.absoluteString, "wikipedia://places")
    }
    
    func test_with_queryItems() {
        // Given
        let wikipediaSearchUrlComposable = DefaultURLComposable(scheme: "https", host: "en.wikipedia.org", path: "/Amsterdam")
        let wikipediaUrlString = wikipediaSearchUrlComposable.url!.absoluteString
        var urlComposable = DefaultURLComposable(scheme: "wikipedia", host: "places", path: "")
        
        // When
        urlComposable = urlComposable
            .addQueryItem(name: "WMFArticleURL", value: wikipediaSearchUrlComposable.url!.absoluteString)
        
        // Then
        XCTAssertEqual(
            urlComposable.url?.absoluteString,
            "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/Amsterdam"
        )
    }
    
    func test_with_multiple_queryItems() {
        // Given
        let wikipediaSearchUrlComposable = DefaultURLComposable(scheme: "https", host: "en.wikipedia.org", path: "/Amsterdam")
        let wikipediaUrlString = wikipediaSearchUrlComposable.url!.absoluteString
        var urlComposable = DefaultURLComposable(scheme: "wikipedia", host: "places", path: "")
        
        // When
        urlComposable = urlComposable
            .addQueryItem(name: "WMFArticleURL", value: wikipediaSearchUrlComposable.url!.absoluteString)
            .addQueryItem(name: "anotherItem", value: "value")
        
        // Then
        XCTAssertEqual(
            urlComposable.url?.absoluteString,
            "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/Amsterdam&anotherItem=value"
        )
    }
}
