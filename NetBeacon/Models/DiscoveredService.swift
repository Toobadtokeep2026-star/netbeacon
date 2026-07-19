import Foundation
import Network

struct DiscoveredService: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let type: String
    let domain: String
    let hostname: String?
    let port: Int?
    let addresses: [String]
    let txtRecords: [String: String]
    let discoveredAt: Date
    var lastSeen: Date
    var isActive: Bool

    var displayType: String {
        switch type {
        case "_airplay._tcp.": return "AirPlay"
        case "_googlecast._tcp.": return "Google Cast"
        case "_spotify-connect._tcp.": return "Spotify Connect"
        case "_hap._tcp.": return "HomeKit"
        case "_matter._tcp.": return "Matter"
        case "_http._tcp.": return "HTTP"
        case "_ssh._tcp.": return "SSH"
        case "_printer._tcp.", "_ipp._tcp.": return "Printer"
        case "_raop._tcp.": return "AirPlay Audio"
        case "_companion-link._tcp.": return "Companion Link"
        default: return type.replacingOccurrences(of: "._tcp.", with: "").replacingOccurrences(of: "._udp.", with: "")
        }
    }

    var isMediaCasting: Bool {
        ["_airplay._tcp.", "_googlecast._tcp.", "_spotify-connect._tcp.", "_raop._tcp.", "_companion-link._tcp."].contains(type)
    }

    init(id: UUID = UUID(),
         name: String,
         type: String,
         domain: String = "local.",
         hostname: String? = nil,
         port: Int? = nil,
         addresses: [String] = [],
         txtRecords: [String: String] = [:],
         discoveredAt: Date = Date(),
         lastSeen: Date = Date(),
         isActive: Bool = true) {
        self.id = id
        self.name = name
        self.type = type
        self.domain = domain
        self.hostname = hostname
        self.port = port
        self.addresses = addresses
        self.txtRecords = txtRecords
        self.discoveredAt = discoveredAt
        self.lastSeen = lastSeen
        self.isActive = isActive
    }
}
