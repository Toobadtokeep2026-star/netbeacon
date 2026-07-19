import SwiftUI

struct BLEDeviceListView: View {
    @Bindable var viewModel: DiscoveryViewModel

    var body: some View {
        List {
            if viewModel.filteredBLEDevices.isEmpty {
                ContentUnavailableView(
                    "No BLE Devices",
                    systemImage: "dot.radiowaves.left.and.right",
                    description: Text(viewModel.manager.ble.isScanning ? "Scanning…" : "Start discovery or check Bluetooth permission")
                )
            } else {
                ForEach(viewModel.filteredBLEDevices) { device in
                    BLEDeviceRow(device: device)
                }
            }
        }
        .navigationTitle("Bluetooth")
        .searchable(text: $viewModel.searchText, prompt: "Search devices")
    }
}

struct BLEDeviceRow: View {
    let device: BLEDevice

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.title3)
                .foregroundStyle(.purple)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(device.displayName)
                    .font(.body.weight(.medium))
                HStack(spacing: 8) {
                    Text("\(device.rssi) dBm")
                        .font(.caption.monospacedDigit())
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(device.signalStrength)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }

            Spacer()

            if device.isConnectable {
                Image(systemName: "link")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
