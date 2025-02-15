import SwiftUI
import HealthKit
import Intents

// MARK: - Main App Structure

struct StepScreen: App {
    var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }

    struct ContentView: View {
        var body: some View {
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                LeaderboardView()
                    .tabItem { Label("Leaderboard", systemImage: "chart.bar") }
                LoginView()
                    .tabItem { Label("Login", systemImage: "person.circle") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
        }
    }

    class HealthManager: ObservableObject {
        private let healthStore = HKHealthStore()
        @Published var steps: Int = 0

        func requestAuthorization() {
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
                if success { self.fetchSteps() }
            }
        }

        func fetchSteps() {
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                if let sum = result?.sumQuantity() {
                    DispatchQueue.main.async { self.steps = Int(sum.doubleValue(for: .count())) }
                }
            }
            healthStore.execute(query)
        }
    }

    class ShortcutManager {
        func createScreenTimeShortcut(forApp appIdentifier: String, stepGoal: Int) {
            let intent = INIntent()
            intent.suggestedInvocationPhrase = "Unlock \(appIdentifier) after \(stepGoal) steps"
        }
    }

    struct HomeView: View {
        @StateObject var healthManager = HealthManager()

        var body: some View {
            VStack {
                Text("Steps: \\(healthManager.steps)")
                Button("Refresh Steps") { healthManager.fetchSteps() }
            }.onAppear { healthManager.requestAuthorization() }
        }
    }

    struct LeaderboardView: View {
        var body: some View { Text("Leaderboard") }
    }

    struct LoginView: View {
        var body: some View { Text("Login") }
    }

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
                    manager.createScreenTimeShortcut(forApp: selectedApp, stepGoal: stepGoal)
                }
            }.navigationTitle("Settings")
        }
    }
