//
//  PlacesTests.swift
//  PlacesTests
//
//  Created by Marco Driessen on 18/05/2024.
//

import XCTest
@testable import Places

final class NetworkServiceTests: XCTestCase {
  
  var sut: NetworkService!
  var urlSession: URLSession!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    urlSession = URLSession(configuration: configuration)
    
    self.sut = DefaultNetworkService(decoder: JSONDecoder(), urlSession: urlSession)
  }
  
  override func tearDownWithError() throws {
    self.sut = nil
    try super.tearDownWithError()
  }
  
  func test_fetch_success() async throws {
    let expectedData = """
        {
          "locations":
          [
            {
              "name": "Amsterdam",
              "lat": 52.3547498,
              "long": 4.8339215
            },
            {
              "name": "Mumbai",
              "lat": 19.0823998,
              "long": 72.8111468
            },
            {
              "name": "Copenhagen",
              "lat": 55.6713442,
              "long": 12.523785
            },
          ]
        }
        """.data(using: .utf8)!
    
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)!
      return (response, expectedData)
    }
    
    let url = URL(string: "https://example.com/locations")!
    let places: Places = try await sut.fetch(from: url)
    
    XCTAssertEqual(places.locations.first?.name, "Amsterdam")
    XCTAssertEqual(places.locations.first?.lat, 52.3547498)
    XCTAssertEqual(places.locations.first?.long, 4.8339215)
  }
  
  func test_fetch_statusCode_failure() async throws {
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: 404,
                                     httpVersion: nil,
                                     headerFields: nil)!
      
      return (response, Data())
    }
    
    let url = URL(string: "https://example.com/locations")!
    
    do {
      _ = try await sut.fetch(from: url) as Places
    } catch {
      XCTAssertEqual(error as? NetworkServiceError, NetworkServiceError.invalidResponse)
    }
  }
  
  func test_fetch_decodingError() async throws {
    let invalidData = "invalid data".data(using: .utf8)!
    
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)!
      return (response, invalidData)
    }
    
    let url = URL(string: "https://example.com/locations")!
    
    do {
      _ = try await sut.fetch(from: url) as Places
    } catch {
      XCTAssertEqual(error as? NetworkServiceError, NetworkServiceError.decodingError)
    }
  }
}
