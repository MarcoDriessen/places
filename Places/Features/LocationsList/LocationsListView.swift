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
        .navigationTitle("location_list_title")
        .toolbar {
          Button {
            viewModel.showBottomSheet = true
          } label: {
            Image(systemName: "plus")
              .accessibilityLabel(Text("add_location"))
          }
        }
        .onAppear {
          viewModel.fetchLocations()
        }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.viewState {
    case .loading:
      ProgressView("location_list_loading")
    case .success(let locations):
      successView(locations: locations)
    case .error(let error):
      errorView(error: error)
    }
  }
  
  @ViewBuilder
  private func successView(locations: [LocationsListViewModel.LocationViewEntity]) -> some View {
    VStack {
      List(locations, id: \.id) { location in
        Button(action: {
          viewModel.didTap(location: location)
        }, label: {
          VStack(alignment: .leading) {
            Text(location.name ?? "")
            HStack {
              Text(location.latitude ?? "")
              Text(location.longitude ?? "")
            }
            .font(.caption)
          }
        })
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(location.name ?? "")
        .accessibilityAddTraits(.isButton)
      }
    }
    .sheet(isPresented: $viewModel.showBottomSheet) {
      bottomSheetSearchView
    }
  }
  
  @ViewBuilder 
  private func errorView(error: LocationsListViewModel.LocationsListError) -> some View {
    switch error {
    case .fetchError:
      VStack(spacing: 16, content: {
        Text("locations_list_fetch_error")
          .multilineTextAlignment(.center)
        Button("locations_list_try_again") {
          Task {
            await viewModel.fetchLocations()
          }
        }
        .buttonStyle(.borderedProminent)
      })
    case .urlError:
      VStack(spacing: 16, content: {
        Text("locations_list_url_error")
          .multilineTextAlignment(.center)
        Button("locations_list_url_error_confirm") {
          viewModel.didTapUrlErrorConfirm()
        }
        .buttonStyle(.borderedProminent)
      })
    }
  }
  
  @ViewBuilder 
  private var bottomSheetSearchView: some View {
    VStack {
      switch viewModel.bottomSheetState {
      case .idle:
        SearchView(didSetLocationName: { locationName in
          viewModel.addLocation(name: locationName)
        }, didSetCoordinates: { coordinates in
          viewModel.addLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
          )
        })
      case .loading:
        ProgressView("location_list_loading")
      case .error:
        VStack(spacing: 16) {
          Text("locations_list_geocode_error")
          Button("location_confirm_button_title") {
            viewModel.didTapGeocodeErrorConfirm()
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
    .presentationDetents([.medium])
  }
}
