import Foundation
import CoreBluetooth

struct BLEDevice: Identifiable, Hashable {
    let id: UUID
    let peripheralID: UUID
    let name: String?
    let rssi: Int
    let advertisementData: [String: String]
    let manufacturerData: Data?
    let serviceUUIDs: [String]
    let discoveredAt: Date
    var lastSeen: Date
    var isConnectable: Bool

    var displayName: String {
        name ?? "Unknown (\(peripheralID.uuidString.prefix(8)))"
    }

    var signalStrength: String {
        switch rssi {
        case -50...0: return "Excellent"
        case -70 ..< -50: return "Good"
        case -85 ..< -70: return "Fair"
        default: return "Weak"
        }
    }

    init(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        self.id = UUID()
        self.peripheralID = peripheral.identifier
        self.name = peripheral.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String
        self.rssi = rssi.intValue
        self.discoveredAt = Date()
        self.lastSeen = Date()
        self.isConnectable = (advertisementData[CBAdvertisementDataIsConnectable] as? Bool) ?? false

        var ads: [String: String] = [:]
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            ads["Local Name"] = localName
        }
        if let txPower = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber {
            ads["Tx Power"] = "\(txPower) dBm"
        }
        self.advertisementData = ads

        self.manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data

        if let uuids = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            self.serviceUUIDs = uuids.map { $0.uuidString }
        } else {
            self.serviceUUIDs = []
        }
    }
}
