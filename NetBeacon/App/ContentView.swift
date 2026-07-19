import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Discovery") {
                    Label("Bluetooth Scanner", systemImage: "dot.radiowaves.left.and.right")
                    Label("Network Discovery", systemImage: "network")
                    Label("AirPlay Devices", systemImage: "airplayvideo")
                    Label("Cast Services", systemImage: "play.tv")
                }

                Section("Status") {
                    Text("NetBeacon Foundation Running")
                }
            }
            .navigationTitle("NetBeacon")
        }
    }
}
