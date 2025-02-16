import SwiftUI
import HealthKit
import FamilyControls
import DeviceActivity
import ManagedSettings

import AppIntents

struct ScreenTimeRestrictionIntent: AppIntent {
    static var title: LocalizedStringResource = "Restrict Screen Time"

    @Parameter(title: "Step Goal")
    var stepGoal: Int

    @Parameter(title: "Apps to Restrict")
    var appsToRestrict: [String]

    func perform() async throws -> some IntentResult {
        // Logic to enforce the restriction (e.g., trigger screen time limits)
        return .result()
    }
}


class HealthScreenTimeManager {
    static let shared = HealthScreenTimeManager()
    let healthStore = HKHealthStore()

    func requestPermissions() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if !success { print("HealthKit Authorization Failed: \(error?.localizedDescription ?? "Unknown error")") }
        }

        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("Screen Time Authorization Success")
            } catch {
                print("Screen Time Authorization Failed: \(error)")
            }
        }
    }

    func fetchStepCount(completion: @escaping (Int) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            completion(Int(steps))
        }
        healthStore.execute(query)
    }

    func restrictScreenTime(for apps: [ApplicationToken], ifStepsBelow threshold: Int) {
        fetchStepCount { steps in
            if steps < threshold {
                let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("ScreenTimeRestriction"))
                store.shield.applications = Set(apps)
                print("Screen time restricted for apps")
            } else {
                print("Step goal achieved, no restrictions.")
            }
        }
    }
}

@main
struct StepScreen: App {
    var body: some Scene {
            WindowGroup {
                ContentView().onAppear {
                    HealthScreenTimeManager.shared.requestPermissions()
                    //HealthScreenTimeManager.shared.restrictScreenTime(for: ["com.instagram.ios"], ifStepsBelow: 10000)
                }
            }
        }
    }
