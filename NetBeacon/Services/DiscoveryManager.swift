import Foundation
import Observation

@Observable
final class DiscoveryManager {
    let bonjour = BonjourBrowser()
    let ble = BLEScanner()

    var isRunning: Bool {
        bonjour.isBrowsing || ble.isScanning
    }

    var totalServices: Int { bonjour.services.count }
    var totalBLEDevices: Int { ble.devices.count }
    var mediaServices: [DiscoveredService] {
        bonjour.services.filter { $0.isMediaCasting }
    }

    func startAll() {
        bonjour.start()
        ble.start()
    }

    func stopAll() {
        bonjour.stop()
        ble.stop()
    }

    func startBonjourOnly() {
        bonjour.start()
    }

    func startBLEOnly() {
        ble.start()
    }
}
