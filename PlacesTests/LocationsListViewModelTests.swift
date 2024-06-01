//
//  LocationsListViewModelTests.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import XCTest
import CoreLocation
@testable import Places

final class LocationsListViewModelTests: XCTestCase {
  
  var viewModel: LocationsListViewModel!
  var mockNetworkService: MockNetworkService!
  var mockURLOpenable: MockURLOpenable!
  var mockReverseGeocodable: MockReverseGeocodable!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockNetworkService = MockNetworkService()
    mockURLOpenable = MockURLOpenable()
    mockReverseGeocodable = MockReverseGeocodable()
    
    viewModel = LocationsListViewModel(
      networkService: mockNetworkService,
      urlOpenable: mockURLOpenable,
      reverseGeocodable: mockReverseGeocodable
    )
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
    mockNetworkService = nil
    mockURLOpenable = nil
    mockReverseGeocodable = nil
    try super.tearDownWithError()
  }
  
  // MARK: - fetchLocations()
  
  func test_fetch_locations_success() {
    // Given
    let expectedData = """
    {
        "locations": [
            {"name": "Amsterdam", "lat": 52.3676, "long": 4.9041},
            {"name": "Rotterdam", "lat": 51.9225, "long": 4.47917}
        ]
    }
    """.data(using: .utf8)!
    let expectation = expectation(description: "Fetch locations success")
    mockNetworkService.mockData = expectedData
    
    // When
    viewModel.fetchLocations()
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .success(let locations) = self.viewModel.viewState {
        XCTAssertEqual(locations.count, 2)
        XCTAssertEqual(locations.first?.name, "Amsterdam")
        expectation.fulfill()
      } else {
        XCTFail()
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 0.1)
  }
  
  func test_fetch_locations_success_filters_empty_name() {
    // Given
    let expectedData = """
    {
        "locations": [
            {"lat": 52.3676, "long": 4.9041},
            {"name": "Rotterdam", "lat": 51.9225, "long": 4.47917}
        ]
    }
    """.data(using: .utf8)!
    let expectation = expectation(description: "Filter empty name")
    mockNetworkService.mockData = expectedData
    
    // When
    viewModel.fetchLocations()
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .success(let locations) = self.viewModel.viewState {
        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first?.name, "Rotterdam")
        expectation.fulfill()
      } else {
        XCTFail()
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 0.1)
  }
  
  func test_fetch_locations_error() {
    // Given
    mockNetworkService.error = NetworkServiceError.invalidResponse
    let expectation = expectation(description: "Fetch locations error")
    
    // When
    viewModel.fetchLocations()
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .error(let error) = self.viewModel.viewState {
        XCTAssertNotNil(error)
        expectation.fulfill()
      } else {
        XCTFail("Expected error state")
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 0.1)
  }
  
  // MARK: - addLocation(latitude:longitude:)
  
  func test_add_location_by_coordinate_success() {
    // Given
    mockReverseGeocodable.mockName = "Amsterdam"
    let expectation = expectation(description: "Location added")
    
    // When
    viewModel.addLocation(latitude: "52.3676", longitude: "4.9041")
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .success(let locations) = self.viewModel.viewState, case .idle = self.viewModel.bottomSheetState {
        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first?.name, "Amsterdam")
        expectation.fulfill()
      } else {
        XCTFail()
        expectation.fulfill()
      }
    }

    waitForExpectations(timeout: 1)
  }
  
  func test_add_location_by_coordinates_failure() {
    // Given
    mockReverseGeocodable.error = ReverseGeocodableError.unknownLocation
    let expectation = expectation(description: "Location error")
    
    // When
    viewModel.addLocation(latitude: "52.3676", longitude: "4.9041")
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .error(let error) = self.viewModel.bottomSheetState {
        XCTAssertNotNil(error)
        expectation.fulfill()
      } else {
        XCTFail("Expected error state")
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 1)
  }
  
  // MARK: - didTap(location:)
  
  func test_did_tap_location_success() {
    // Given
    mockURLOpenable.openedURL = URL(string: "https://example.com")
    let location = LocationsListViewModel.LocationViewEntity(name: "Amsterdam",
                                                             latitude: "52.3676",
                                                             longitude: "4.9041")
    
    // When
    viewModel.didTap(location: location)
    
    // Then
    XCTAssertNotNil(mockURLOpenable.openedURL)
    XCTAssertEqual(
      mockURLOpenable.openedURL?.absoluteString,
      "wikipedia://places?WMFArticleURL=https://en.wikipedia.org?latitude%3D52.3676%26longitude%3D4.9041")
  }
  
  func test_did_tap_location_error() {
    // Given
    let location = LocationsListViewModel.LocationViewEntity(name: nil,
                                                             latitude: "52.3676",
                                                             longitude: "4.9041")
    
    // When
    viewModel.didTap(location: location)
    
    // Then
    if case .success = viewModel.viewState {
      XCTFail()
    } else {
      XCTAssert(true)
    }
  }
  
  // MARK: - addLocation(name:)
  
  func test_add_location_by_name_success() {
    // Given
    mockReverseGeocodable.mockCoordinate = CLLocationCoordinate2D(latitude: 52.4, longitude: 4.9)
    let expectation = expectation(description: "Location added")
    
    // When
    viewModel.addLocation(name: "New Location")
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .success(let locations) = self.viewModel.viewState {
        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first?.name, "New Location")
        expectation.fulfill()
      } else {
        XCTFail("Expected success state with locations")
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func test_add_location_by_name_duplicate_does_not_add() {
    // Given
    let expectedData = """
    {
        "locations": [
            {"name": "Amsterdam", "lat": 52.3676, "long": 4.9041},
            {"name": "Rotterdam", "lat": 51.9225, "long": 4.47917}
        ]
    }
    """.data(using: .utf8)!
    mockNetworkService.mockData = expectedData
    let expectation = expectation(description: "Add Location duplicate does not add")
    
    // When
    viewModel.fetchLocations()
    viewModel.addLocation(name: "Amsterdam")
    
    // Then
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if case .success(let locations) = self.viewModel.viewState {
        XCTAssertNotEqual(locations.count, 3)
        XCTAssertEqual(locations.count, 2)
        XCTAssertEqual(locations.first?.name, "Amsterdam")
        expectation.fulfill()
      } else {
        XCTFail("Expected success state with locations")
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 0.1)
  }
  
  func test_did_tap_url_error_confirm() {
    // Given - When
    viewModel.didTapUrlErrorConfirm()
    
    // Then
    if case .success = viewModel.viewState {
      XCTAssert(true)
    } else {
      XCTFail()
    }
  }
  
  func test_did_tap_geocode_error_confirm() {
    // Given - When
    viewModel.didTapGeocodeErrorConfirm()
    
    // Then
    if case .idle = viewModel.bottomSheetState {
      XCTAssert(true)
    } else {
      XCTFail()
    }
  }
}
