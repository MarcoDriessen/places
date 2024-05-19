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
    // Given
    let urlComposable = DefaultURLComposable()
      .setScheme("wikipedia")
      .setHost("places")
      .setPath("")
    
    // Then
    XCTAssertEqual(urlComposable.url?.absoluteString, "wikipedia://places")
  }
  
  func test_with_queryItems() {
    // Given
    let wikipediaSearchUrlComposable = DefaultURLComposable()
      .setScheme("https")
      .setHost("en.wikipedia.org")
      .setPath("/Amsterdam")
    
    var urlComposable = DefaultURLComposable()
      .setScheme("wikipedia")
      .setHost("places")
      .setPath("")
    
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
    let wikipediaSearchUrlComposable = DefaultURLComposable()
      .setScheme("https")
      .setHost("en.wikipedia.org")
      .setPath("/Amsterdam")
    
    var urlComposable = DefaultURLComposable()
      .setScheme("wikipedia")
      .setHost("places")
      .setPath("")
    
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

