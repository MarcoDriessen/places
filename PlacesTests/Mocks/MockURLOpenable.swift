//
//  MockURLOpenable.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import UIKit
@testable import Places

class MockURLOpenable: URLOpenable {
  var openedURL: URL?
  
  func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
    openedURL = url
    completion?(true)
  }
}

