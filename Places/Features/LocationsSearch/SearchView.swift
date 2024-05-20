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
  
  var didSetLocationName: (String) -> Void
  var didSetCoordinates: ((latitude: String, longitude: String)) -> Void
  
  @State private var selectedIndex: SelectedIndex = .name
  @State private var locationName: String = ""
  @State private var latitude: String = ""
  @State private var longitude: String = ""
  
  var body: some View {
    VStack(spacing: 16) {
      Text("search_title")
        .font(.headline)
        .accessibilityAddTraits(.isHeader)
      
      // Marco
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
    .padding()
  }
  
  @ViewBuilder
  private var searchByNameView: some View {
    TextField("search_name", text: $locationName)
      .textFieldStyle(.roundedBorder)
      .accessibility(label: Text("textfield"))
    
    Spacer()
    
    Button("search_button_add") {
      didSetLocationName(locationName)
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
        didSetCoordinates((latitude: latitude, longitude: longitude))
      }
      .buttonStyle(.borderedProminent)
      .disabled(latitude == "" || longitude == "")
    }
  }
}

//#Preview {
//  SearchView { _ in } didSetCoordinates: { _ in }
//}
