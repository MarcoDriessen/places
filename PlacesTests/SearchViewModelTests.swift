//
//  SearchViewModelTests.swift
//  PlacesTests
//
//  Created by Marco Driessen on 01/06/2024.
//

import XCTest
@testable import Places

final class SearchViewModelTests: XCTestCase {
  
  var viewModel: SearchViewModel!
  var mockReverseGeocodable: MockReverseGeocodable!
  var mockLocationAddable: MockLocationAddable!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    mockReverseGeocodable = MockReverseGeocodable()
    mockLocationAddable = MockLocationAddable()
    
    viewModel = SearchViewModel(
      reverseGeocodable: mockReverseGeocodable
    )
    
    viewModel.locationAddable = mockLocationAddable
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
    mockReverseGeocodable = nil
    mockLocationAddable = nil
    try super.tearDownWithError()
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
      if case .idle = self.viewModel.viewState {
        XCTAssertTrue(self.mockLocationAddable.isAddLocationCalled)
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
      if case .error(let error) = self.viewModel.viewState {
        XCTAssertNotNil(error)
        expectation.fulfill()
      } else {
        XCTFail("Expected error state")
        expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func test_did_tap_geocode_error_confirm() {
    // Given - When
    viewModel.didTapGeocodeErrorConfirm()
    
    // Then
    if case .idle = viewModel.viewState {
      XCTAssert(true)
    } else {
      XCTFail()
    }
  }
  
}
