import SwiftUI

struct SettingsView: View {
    @State private var selectedApp = "Instagram"
    @State private var stepGoal = 1500

    var body: some View {
        Form {
            Picker("Select App", selection: $selectedApp) {
                Text("Instagram").tag("Instagram")
                Text("YouTube").tag("YouTube")
                Text("TikTok").tag("TikTok")
            }
            Stepper(value: $stepGoal, in: 500...20000, step: 500) {
                Text("Step Goal: \(stepGoal)")
            }
            Button("Create Shortcut") {
                let manager = ShortcutManager()
               // manager.createScreenTimeShortcut(forApp: selectedApp, stepGoal: stepGoal)
            }
        }.navigationTitle("Settings")
    }
}
