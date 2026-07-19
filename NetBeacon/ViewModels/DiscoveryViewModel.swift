import Foundation
import Observation

@Observable
final class DiscoveryViewModel {
    let manager = DiscoveryManager()

    var selectedTab: Tab = .dashboard
    var searchText = ""
    var showMediaOnly = false

    enum Tab: String, CaseIterable, Identifiable {
        case dashboard = "Dashboard"
        case network = "Network"
        case bluetooth = "Bluetooth"
        case media = "Casting"

        var id: String { rawValue }

        var systemImage: String {
            switch self {
            case .dashboard: return "gauge.with.dots.needle.33percent"
            case .network: return "network"
            case .bluetooth: return "dot.radiowaves.left.and.right"
            case .media: return "airplayvideo"
            }
        }
    }

    var filteredServices: [DiscoveredService] {
        var list = manager.bonjour.services
        if showMediaOnly {
            list = list.filter { $0.isMediaCasting }
        }
        if !searchText.isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.displayType.localizedCaseInsensitiveContains(searchText) ||
                $0.type.localizedCaseInsensitiveContains(searchText)
            }
        }
        return list
    }

    var filteredBLEDevices: [BLEDevice] {
        if searchText.isEmpty { return manager.ble.devices }
        return manager.ble.devices.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.serviceUUIDs.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func start() {
        manager.startAll()
    }

    func stop() {
        manager.stopAll()
    }
}
