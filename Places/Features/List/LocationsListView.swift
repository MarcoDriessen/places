//
//  LocationsListView.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//


import SwiftUI

struct LocationsListView: View {
  
  @State private var viewModel: LocationsListViewModel
    
  init(viewModel: LocationsListViewModel) {
    _viewModel = State(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      content
        .navigationTitle("Locations")
        .toolbar {
          Button {
            viewModel.showBottomSheet = true
          } label: {
           Image(systemName: "plus")
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
      VStack {
        List(locations, id: \.id) { location in
          Button(location.name ?? "") {
            viewModel.didTap(location: location)
          }
        }
      }
      .sheet(isPresented: $viewModel.showBottomSheet) {
        VStack {
          switch viewModel.bottomSheetState {
          case .idle:
            SearchView(didSetLocationName: { locationName in
              viewModel.addLocation(name: locationName)
            }, didSetCoordinates: { coordinates in
              Task {
                await viewModel.addLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
              }
            })
          case .loading:
            ProgressView("Searching Location...")
          case .error:
            VStack {
              Text("ERROR")
              Button("Got it") {
                viewModel.didTapErrorConfirm()
              }
              .buttonStyle(.borderedProminent)
            }
          }
        }
        .presentationDetents([.medium])
      }
    case .error(let error):
      Text(error?.localizedDescription ?? "")
    }
  }
}

#Preview {
  let networkService = DefaultNetworkService()
  let urlComposable = DefaultURLComposable()
  let urlOpenable = UIApplication.shared
  let reverseGeocodable = DefaultReverseGeocodable()
  
  let viewModel = LocationsListViewModel(
    networkService: networkService,
    urlComposable: urlComposable,
    urlOpenable: urlOpenable,
    reverseGeocodable: reverseGeocodable)
  return LocationsListView(viewModel: viewModel)
}
