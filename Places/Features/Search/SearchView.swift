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
  var didSetCoordinates: ((String, String)) -> Void
  
  @State private var selectedIndex: SelectedIndex = .name
  @State private var locationName: String = ""
  @State private var latitude: String = ""
  @State private var longitude: String = ""
  
  var body: some View {
    NavigationView {
      content
        .navigationTitle("Search location")
    }
  }
  
  @ViewBuilder
  private var content: some View {
    VStack {
      Picker("", selection: $selectedIndex) {
        Text("Name").tag(SelectedIndex.name)
        Text("Coordinates").tag(SelectedIndex.coordinates)
      }
      .pickerStyle(.segmented)
      .padding()
      
      switch selectedIndex {
      case .name: searchByNameView
      case .coordinates: searchByCoordinatesView
      }
    }
  }
  
  @ViewBuilder
  private var searchByNameView: some View {
    TextField("Location", text: $locationName)
      .textFieldStyle(.roundedBorder)
      .padding()
    
    Spacer()
    
    Button("Add") {
      didSetLocationName(locationName)
    }
    .buttonStyle(.borderedProminent)
  }
  
  @ViewBuilder
  private var searchByCoordinatesView: some View {
    VStack {
      TextField("Latitude", text: $latitude)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
        .padding()
      TextField("Longitude", text: $longitude)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
        .padding()
      
      Spacer()
      
      Button("Search") {
        didSetCoordinates((latitude, longitude))
      }
      .buttonStyle(.borderedProminent)
    }
  }
}

//#Preview {
//    SearchView(placeName: <#Binding<String>#>)
//}
