//
//  LocationsListViewModelTests.swift
//  PlacesTests
//
//  Created by Marco Driessen on 20/05/2024.
//

import XCTest
@testable import Places

final class LocationsListViewModelTests: XCTestCase {
  
  var viewModel: LocationsListViewModel!
  var mockNetworkService: MockNetworkService!
  var mockURLComposable: MockURLComposable!
  var mockURLOpenable: MockURLOpenable!
  var mockReverseGeocodable: MockReverseGeocodable!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockNetworkService = MockNetworkService()
    mockURLComposable = MockURLComposable()
    mockURLOpenable = MockURLOpenable()
    mockReverseGeocodable = MockReverseGeocodable()
    
    viewModel = LocationsListViewModel(
      networkService: mockNetworkService,
      urlComposable: mockURLComposable,
      urlOpenable: mockURLOpenable,
      reverseGeocodable: mockReverseGeocodable
    )
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
    mockNetworkService = nil
    mockURLComposable = nil
    mockURLOpenable = nil
    mockReverseGeocodable = nil
    try super.tearDownWithError()
  }
  
  // MARK: - fetchLocations()
  
  func test_fetch_locations_success() async {
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
    
    // When
    await viewModel.fetchLocations()
    
    // Then
    if case .success(let locations) = viewModel.viewState {
      XCTAssertEqual(locations.count, 2)
      XCTAssertEqual(locations.first?.name, "Amsterdam")
    } else {
      XCTFail()
    }
    
  }
  
  func test_fetch_locations_success_filters_empty_name() async {
    // Given
    let expectedData = """
    {
        "locations": [
            {"lat": 52.3676, "long": 4.9041},
            {"name": "Rotterdam", "lat": 51.9225, "long": 4.47917}
        ]
    }
    """.data(using: .utf8)!
    
    mockNetworkService.mockData = expectedData
    
    // When
    await viewModel.fetchLocations()
    
    // Then
    if case .success(let locations) = viewModel.viewState {
      XCTAssertEqual(locations.count, 1)
      XCTAssertEqual(locations.first?.name, "Rotterdam")
    } else {
      XCTFail()
    }
  }
  
  func test_fetch_locations_error() async {
    // Given
    mockNetworkService.error = NetworkServiceError.invalidResponse
    
    // When
    await viewModel.fetchLocations()
    
    // Then
    if case .error(let error) = viewModel.viewState {
      XCTAssertNotNil(error)
    } else {
      XCTFail("Expected error state")
    }
  }
  
  // MARK: - addLocation(latitude:longitude:)
  
  func test_add_location_by_coordinate_success() async {
    // Given
    mockReverseGeocodable.mockName = "Amsterdam"
    
    // When
    await viewModel.addLocation(latitude: "52.3676", longitude: "4.9041")
    
    // Then
    if case .success(let locations) = viewModel.viewState, case .idle = viewModel.bottomSheetState {
      XCTAssertEqual(locations.count, 1)
      XCTAssertEqual(locations.first?.name, "Amsterdam")
    } else {
      XCTFail()
    }
  }
  
  func test_add_location_by_coordinates_failure() async {
    // Given
    mockReverseGeocodable.error = ReverseGeocodableError.unknownLocation
    
    // When
    await viewModel.addLocation(latitude: "52.3676", longitude: "4.9041")
    
    // Then
    if case .error(let error) = viewModel.bottomSheetState {
      XCTAssertNotNil(error)
    } else {
      XCTFail("Expected error state")
    }
  }
  
  // MARK: - didTap(location:)
  
  func test_did_tap_location_success() {
    // Given
    let location = LocationsListViewModel.LocationViewEntity(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
    
    // When
    viewModel.didTap(location: location)
    
    // Then
    XCTAssertNotNil(mockURLOpenable.openedURL)
    XCTAssertEqual(mockURLOpenable.openedURL?.absoluteString, "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/Amsterdam")
  }
  
  func test_did_tap_location_error() {
    // Given
    let location = LocationsListViewModel.LocationViewEntity(name: nil, latitude: 52.3676, longitude: 4.9041)
    
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
    // Given - When
    viewModel.addLocation(name: "New Location")
    
    // Then
    if case .success(let locations) = viewModel.viewState {
      XCTAssertEqual(locations.count, 1)
      XCTAssertEqual(locations.first?.name, "New Location")
    } else {
      XCTFail("Expected success state with locations")
    }
  }
  
  func test_add_location_by_name_duplicate_does_not_add() async {
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
    
    // When
    await viewModel.fetchLocations()
    viewModel.addLocation(name: "Amsterdam")
    
    // Then
    if case .success(let locations) = viewModel.viewState {
      XCTAssertNotEqual(locations.count, 3)
      XCTAssertEqual(locations.count, 2)
      XCTAssertEqual(locations.first?.name, "Amsterdam")
    } else {
      XCTFail("Expected success state with locations")
    }
  }
  
  func test_did_tap_error_confirm() {
    // Given - When
    viewModel.didTapErrorConfirm()
    
    // Then
    if case .success = viewModel.viewState {
      XCTFail()
    } else {
      XCTAssert(true)
    }
  }
}
