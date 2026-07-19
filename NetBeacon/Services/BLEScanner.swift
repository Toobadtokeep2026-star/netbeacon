import Foundation
import CoreBluetooth
import Observation

@Observable
final class BLEScanner: NSObject, CBCentralManagerDelegate {
    private(set) var devices: [BLEDevice] = []
    private(set) var isScanning = false
    private(set) var statusMessage = "Bluetooth not ready"
    private(set) var bluetoothState: CBManagerState = .unknown

    private var central: CBCentralManager!
    private var seenPeripherals: [UUID: BLEDevice] = [:]

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

    func start() {
        guard central.state == .poweredOn else {
            statusMessage = "Bluetooth is not powered on"
            return
        }
        guard !isScanning else { return }

        seenPeripherals.removeAll()
        devices.removeAll()
        isScanning = true
        statusMessage = "Scanning for BLE devices…"

        central.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false
        ])
    }

    func stop() {
        if isScanning {
            central.stopScan()
            isScanning = false
            statusMessage = "Scan stopped — \(devices.count) devices found"
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothState = central.state
        switch central.state {
        case .poweredOn:
            statusMessage = "Bluetooth ready"
        case .poweredOff:
            statusMessage = "Bluetooth is powered off"
            isScanning = false
        case .unauthorized:
            statusMessage = "Bluetooth permission denied"
        case .unsupported:
            statusMessage = "Bluetooth LE not supported"
        default:
            statusMessage = "Bluetooth state: \(central.state.rawValue)"
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let device = BLEDevice(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
        seenPeripherals[peripheral.identifier] = device
        devices = seenPeripherals.values.sorted { $0.rssi > $1.rssi }
        statusMessage = "\(devices.count) BLE devices"
    }
}
