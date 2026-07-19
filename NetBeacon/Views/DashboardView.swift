import SwiftUI

struct DashboardView: View {
    @Bindable var viewModel: DiscoveryViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    HStack {
                        Circle()
                            .fill(viewModel.manager.isRunning ? .green : .secondary)
                            .frame(width: 12, height: 12)
                        Text(viewModel.manager.isRunning ? "Discovery Active" : "Discovery Stopped")
                            .font(.headline)
                        Spacer()
                    }

                    Text(viewModel.manager.bonjour.statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(viewModel.manager.ble.statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(title: "Network Services", value: "\(viewModel.manager.totalServices)", icon: "network", color: .blue)
                    StatCard(title: "BLE Devices", value: "\(viewModel.manager.totalBLEDevices)", icon: "dot.radiowaves.left.and.right", color: .purple)
                    StatCard(title: "Casting Targets", value: "\(viewModel.manager.mediaServices.count)", icon: "airplayvideo", color: .orange)
                    StatCard(title: "Active", value: viewModel.manager.isRunning ? "Yes" : "No", icon: "bolt.fill", color: viewModel.manager.isRunning ? .green : .gray)
                }

                if !viewModel.manager.mediaServices.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Casting & Media")
                            .font(.headline)
                        ForEach(viewModel.manager.mediaServices.prefix(6)) { service in
                            HStack {
                                Image(systemName: "airplayvideo")
                                    .foregroundStyle(.orange)
                                VStack(alignment: .leading) {
                                    Text(service.name)
                                        .font(.subheadline.weight(.medium))
                                    Text(service.displayType)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                HStack(spacing: 16) {
                    Button {
                        viewModel.start()
                    } label: {
                        Label("Start All", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.manager.isRunning)

                    Button {
                        viewModel.stop()
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.manager.isRunning)
                }
            }
            .padding()
        }
        .navigationTitle("NetBeacon")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
