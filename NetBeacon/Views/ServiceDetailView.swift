import SwiftUI

struct ServiceDetailView: View {
    let service: DiscoveredService

    var body: some View {
        List {
            Section("Identity") {
                LabeledContent("Name", value: service.name)
                LabeledContent("Type", value: service.displayType)
                LabeledContent("Raw Type", value: service.type)
                LabeledContent("Domain", value: service.domain)
            }

            if let hostname = service.hostname {
                Section("Network") {
                    LabeledContent("Hostname", value: hostname)
                    if let port = service.port {
                        LabeledContent("Port", value: "\(port)")
                    }
                }
            }

            if !service.addresses.isEmpty {
                Section("Addresses") {
                    ForEach(service.addresses, id: \.self) { addr in
                        Text(addr)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }

            if !service.txtRecords.isEmpty {
                Section("TXT Records") {
                    ForEach(Array(service.txtRecords.keys.sorted()), id: \.self) { key in
                        LabeledContent(key, value: service.txtRecords[key] ?? "")
                    }
                }
            }

            Section("Timeline") {
                LabeledContent("First Seen", value: service.discoveredAt.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Last Seen", value: service.lastSeen.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Active", value: service.isActive ? "Yes" : "No")
            }
        }
        .navigationTitle(service.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
