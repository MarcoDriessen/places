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
    VStack {
      Text("Add Location")

      Picker("", selection: $selectedIndex) {
        Text("Name").tag(SelectedIndex.name)
        Text("Coordinates").tag(SelectedIndex.coordinates)
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
    TextField("Location", text: $locationName)
      .textFieldStyle(.roundedBorder)

    Spacer()
    
    Button("Add") {
      didSetLocationName(locationName)
      locationName = ""
    }
    .buttonStyle(.borderedProminent)
  }
  
  @ViewBuilder
  private var searchByCoordinatesView: some View {
    VStack {
      TextField("Latitude", text: $latitude)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
      TextField("Longitude", text: $longitude)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)

      Spacer()
      
      Button("Search") {
        didSetCoordinates((latitude: latitude, longitude: longitude))
      }
      .buttonStyle(.borderedProminent)
    }
  }
}

#Preview {
  SearchView { _ in
    
  } didSetCoordinates: { _ in
    
  }

}
