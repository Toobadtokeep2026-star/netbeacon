import SwiftUI

struct ServiceListView: View {
    @Bindable var viewModel: DiscoveryViewModel
    var mediaOnly: Bool = false

    var body: some View {
        List {
            if viewModel.filteredServices.isEmpty {
                ContentUnavailableView(
                    mediaOnly ? "No Casting Services" : "No Services Found",
                    systemImage: mediaOnly ? "airplayvideo" : "network.slash",
                    description: Text(viewModel.manager.bonjour.isBrowsing ? "Scanning…" : "Start discovery to begin")
                )
            } else {
                ForEach(viewModel.filteredServices) { service in
                    NavigationLink(value: service) {
                        ServiceRow(service: service)
                    }
                }
            }
        }
        .navigationTitle(mediaOnly ? "Casting" : "Network Services")
        .searchable(text: $viewModel.searchText, prompt: "Search services")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle("Media only", isOn: $viewModel.showMediaOnly)
                    .toggleStyle(.button)
            }
        }
        .navigationDestination(for: DiscoveredService.self) { service in
            ServiceDetailView(service: service)
        }
        .onAppear {
            if mediaOnly { viewModel.showMediaOnly = true }
        }
    }
}

struct ServiceRow: View {
    let service: DiscoveredService

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(service.name)
                    .font(.body.weight(.medium))
                Text(service.displayType)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if service.isActive {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
    }

    private var iconName: String {
        if service.isMediaCasting { return "airplayvideo" }
        switch service.type {
        case "_hap._tcp.", "_homekit._tcp.": return "homekit"
        case "_ssh._tcp.": return "terminal"
        case "_printer._tcp.", "_ipp._tcp.": return "printer"
        default: return "network"
        }
    }

    private var color: Color {
        if service.isMediaCasting { return .orange }
        return .blue
    }
}
