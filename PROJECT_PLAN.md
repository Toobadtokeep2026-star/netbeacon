# NetBeacon — Project Plan (Completed Core)

## Mission
Native iOS network and device discovery utility focused on local network services, Bluetooth LE, and casting endpoints.

## Constraints (Honored)
- Free
- iPhone 14 / current iOS target
- Public Apple APIs only
- No backend
- Sideload-friendly (SideStore / LiveContainer)

## Implemented

### Phase 1 — Scaffold ✅
- Xcode-ready SwiftUI app structure
- Observation-based state

### Phase 2 — Local Network Discovery ✅
- NWBrowser multi-type Bonjour scanning
- AirPlay, Google Cast, Spotify Connect, HomeKit, Matter, printers, SSH, HTTP, and more
- Live updating list + search + media filter

### Phase 3 — BLE Discovery ✅
- CoreBluetooth central scanning
- RSSI tracking, advertisement parsing, connectable flag
- Sorted by signal strength

### Phase 4 — Casting Focus ✅
- Dedicated Casting tab
- Media service detection and highlighting

### Phase 5 — Dashboard ✅
- Live stats
- Status messages
- Start / Stop controls

### Remaining Optional
- Full endpoint resolution (hostname/port/TXT)
- SwiftData persistent history
- Export
- Widgets / Live Activities

## Architecture Summary
- Models: DiscoveredService, BLEDevice
- Services: BonjourBrowser, BLEScanner, DiscoveryManager
- ViewModel: DiscoveryViewModel
- Views: Dashboard, ServiceList, BLEDeviceList, ServiceDetail
- Entry: NetBeaconApp → ContentView (TabView)
