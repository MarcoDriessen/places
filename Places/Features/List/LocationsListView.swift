import SwiftUI

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsListViewModel

    init(viewModel: LocationsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Locations")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "plus")
                        })
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
            List {
                ForEach(locations) { location in
                    Text(location.name ?? "")
                }
            }
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
}
