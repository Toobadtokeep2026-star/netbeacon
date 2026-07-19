import Foundation
import Network
import Observation

@Observable
final class BonjourBrowser {
    private(set) var services: [DiscoveredService] = []
    private(set) var isBrowsing = false
    private(set) var statusMessage = "Idle"

    private var browsers: [NWBrowser] = []
    private let queue = DispatchQueue(label: "com.netbeacon.bonjour", qos: .userInitiated)

    private let serviceTypes: [String] = [
        "_airplay._tcp.",
        "_raop._tcp.",
        "_googlecast._tcp.",
        "_spotify-connect._tcp.",
        "_companion-link._tcp.",
        "_hap._tcp.",
        "_matter._tcp.",
        "_http._tcp.",
        "_ssh._tcp.",
        "_printer._tcp.",
        "_ipp._tcp.",
        "_smb._tcp.",
        "_afpovertcp._tcp.",
        "_nfs._tcp.",
        "_workstation._tcp.",
        "_device-info._tcp.",
        "_sleep-proxy._udp.",
        "_homekit._tcp.",
        "_thread._udp.",
        "_meshcop._udp."
    ]

    func start() {
        guard !isBrowsing else { return }
        isBrowsing = true
        statusMessage = "Browsing \(serviceTypes.count) service types…"
        services.removeAll()

        for type in serviceTypes {
            let descriptor = NWBrowser.Descriptor.bonjour(type: type, domain: "local.")
            let browser = NWBrowser(for: descriptor, using: .tcp)

            browser.stateUpdateHandler = { [weak self] _, state in
                DispatchQueue.main.async {
                    switch state {
                    case .ready:
                        self?.statusMessage = "Browsing active"
                    case .failed(let error):
                        self?.statusMessage = "Browser error: \(error.localizedDescription)"
                    default:
                        break
                    }
                }
            }

            browser.browseResultsChangedHandler = { [weak self] results, _ in
                self?.handleResults(results, type: type)
            }

            browser.start(queue: queue)
            browsers.append(browser)
        }
    }

    func stop() {
        browsers.forEach { $0.cancel() }
        browsers.removeAll()
        isBrowsing = false
        statusMessage = "Stopped"
    }

    private func handleResults(_ results: Set<NWBrowser.Result>, type: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            var updated: [DiscoveredService] = self.services.filter { $0.type != type }

            for result in results {
                let name: String
                switch result.endpoint {
                case .service(let serviceName, _, _, _):
                    name = serviceName
                default:
                    name = result.endpoint.debugDescription
                }

                let service = DiscoveredService(
                    name: name,
                    type: type,
                    domain: "local.",
                    hostname: nil,
                    port: nil,
                    addresses: [],
                    txtRecords: [:],
                    discoveredAt: Date(),
                    lastSeen: Date(),
                    isActive: true
                )
                updated.append(service)
            }

            var seen = Set<String>()
            self.services = updated.filter { s in
                let key = "\(s.name)|\(s.type)"
                if seen.contains(key) { return false }
                seen.insert(key)
                return true
            }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

            self.statusMessage = "\(self.services.count) services discovered"
        }
    }
}
