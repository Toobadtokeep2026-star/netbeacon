# NetBeacon

**Native iOS network, device, and casting discovery utility.**

Free. Local-first. Public Apple APIs only. Built for iPhone (tested target: iPhone 14 / iOS 27).

## What it does

- Discovers Bonjour / mDNS / DNS-SD services on the local network (AirPlay, Google Cast, Spotify Connect, HomeKit, Matter, printers, SSH, HTTP, and more)
- Scans Bluetooth Low Energy devices with RSSI and advertisement data
- Dedicated Casting tab focused on media receivers
- Live dashboard with counts and status
- Search and filtering
- Fully offline after discovery starts — no backend, no accounts

## Architecture

- SwiftUI + Observation
- Network.framework (`NWBrowser`) for Bonjour
- CoreBluetooth for BLE
- Clean MVVM-style separation
- No third-party dependencies

## Requirements for Sideloading / Running

You must add these keys to `Info.plist` (or the target Info tab):

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>NetBeacon discovers devices and services on your local network.</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>NetBeacon scans for nearby Bluetooth devices.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>NetBeacon scans for nearby Bluetooth devices.</string>
```

Also enable the **Outgoing Connections (Client)** capability if using the Network framework in certain configurations, and ensure Local Network permission is granted at runtime.

## Project Structure

```
NetBeacon/
├── App/                  # Entry point + root ContentView
├── Models/               # DiscoveredService, BLEDevice
├── Services/             # BonjourBrowser, BLEScanner, DiscoveryManager
├── ViewModels/           # DiscoveryViewModel
├── Views/                # Dashboard, lists, detail
└── Supporting/           # Future assets / helpers
```

## Status

Core discovery engines and UI are implemented and ready for Xcode / SideStore build.

## Next Possible Enhancements

- Full service resolution (hostname + port + TXT via NWConnection)
- SwiftData history persistence
- Export discovered devices
- Widget / Live Activity for active discovery status
- Wake-on-LAN (limited on pure iOS)
- Deeper Matter / Thread details

---

Built as a free, sideloadable tool. No tracking. No accounts. Your network stays on your phone.
