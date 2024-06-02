//
//  SearchView.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import SwiftUI

struct SearchView: View {
  
  enum SelectedIndex: Int {
    case name
    case coordinates
  }
  
  @State private var viewModel: SearchViewModel
  @State private var selectedIndex: SelectedIndex = .name
  @State private var locationName: String = ""
  @State private var latitude: String = ""
  @State private var longitude: String = ""
  
  init(viewModel: SearchViewModel) {
    _viewModel = State(wrappedValue: viewModel)
  }
  
  var body: some View {
    content
      .padding()
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.viewState {
    case .idle: searchView
    case .loading: ProgressView("location_list_loading")
    case .error(let geocodeError): errorView(error: geocodeError)
    }
  }
  
  @ViewBuilder
  private var searchView: some View {
    VStack(spacing: 16) {
      Text("search_title")
        .font(.headline)
        .accessibilityAddTraits(.isHeader)
      
      Picker("", selection: $selectedIndex) {
        Text("search_segmented_name").tag(SelectedIndex.name)
        Text("search_segmented_coordinates").tag(SelectedIndex.coordinates)
      }
      .pickerStyle(.segmented)
      
      switch selectedIndex {
      case .name: searchByNameView
      case .coordinates: searchByCoordinatesView
      }
    }
  }
  
  @ViewBuilder
  private var searchByNameView: some View {
    TextField("search_name", text: $locationName)
      .textFieldStyle(.roundedBorder)
      .accessibility(label: Text("textfield"))
    
    Spacer()
    
    Button("search_button_add") {
      viewModel.addLocation(name: locationName)
      locationName = ""
    }
    .buttonStyle(.borderedProminent)
    .disabled(locationName == "")
  }
  
  @ViewBuilder
  private var searchByCoordinatesView: some View {
    VStack {
      TextField("search_latitude", text: $latitude)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
        .accessibility(label: Text("textfield"))
      TextField("search_longitude", text: $longitude)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
        .accessibility(label: Text("textfield"))
      
      Spacer()
      
      Button("search_button_title") {
        viewModel.addLocation(latitude: latitude, longitude: longitude)
      }
      .buttonStyle(.borderedProminent)
      .disabled(latitude == "" || longitude == "")
    }
  }
  
  @ViewBuilder
  private func errorView(error: SearchViewModel.GeocodeError) -> some View {
    VStack(spacing: 16) {
      Text("locations_list_geocode_error")
      Button("location_confirm_button_title") {
        viewModel.didTapGeocodeErrorConfirm()
      }
      .buttonStyle(.borderedProminent)
    }
  }
}
