//
//  LocationsListView.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//


import SwiftUI

struct LocationsListView: View {
  
  @State private var showSearch = false
  @State private var placeName = ""
  @State private var coordinates = ("", "")
  
  @State private var viewModel: LocationsListViewModel
  
  init(viewModel: LocationsListViewModel) {
    _viewModel = State(wrappedValue: viewModel) // check this
  }
  
  var body: some View {
    NavigationView {
      content
        .navigationTitle("Locations")
        .toolbar{
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
              showSearch = true
            }, label: {
              Image(systemName: "plus")
            })
          }
        }
        .sheet(isPresented: $showSearch) {
          SearchView { locationName in
            
          } didSetCoordinates: { coordinates in
            Task {
              await viewModel.addLocation(with: coordinates.0, longitude: coordinates.1)
            }
          }
        }
        .task {
          await viewModel.fetchLocations()
        }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.viewState {
    case .loading:
      ProgressView("Loading...")
    case .success(let locations):
      List(locations, id: \.id) { location in
        Button(location.name ?? "") {
          viewModel.didTap(location: location)
        }
      }
    case .error(let error):
      Text(error?.localizedDescription ?? "") // fix domain error
    }
  }
}
