import SwiftUI

struct ContentView: View {
    @State private var viewModel = DiscoveryViewModel()

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationStack {
                DashboardView(viewModel: viewModel)
            }
            .tabItem {
                Label(DiscoveryViewModel.Tab.dashboard.rawValue, systemImage: DiscoveryViewModel.Tab.dashboard.systemImage)
            }
            .tag(DiscoveryViewModel.Tab.dashboard)

            NavigationStack {
                ServiceListView(viewModel: viewModel)
            }
            .tabItem {
                Label(DiscoveryViewModel.Tab.network.rawValue, systemImage: DiscoveryViewModel.Tab.network.systemImage)
            }
            .tag(DiscoveryViewModel.Tab.network)

            NavigationStack {
                BLEDeviceListView(viewModel: viewModel)
            }
            .tabItem {
                Label(DiscoveryViewModel.Tab.bluetooth.rawValue, systemImage: DiscoveryViewModel.Tab.bluetooth.systemImage)
            }
            .tag(DiscoveryViewModel.Tab.bluetooth)

            NavigationStack {
                ServiceListView(viewModel: viewModel, mediaOnly: true)
            }
            .tabItem {
                Label(DiscoveryViewModel.Tab.media.rawValue, systemImage: DiscoveryViewModel.Tab.media.systemImage)
            }
            .tag(DiscoveryViewModel.Tab.media)
        }
        .onAppear {
            viewModel.start()
        }
    }
}

#Preview {
    ContentView()
}
