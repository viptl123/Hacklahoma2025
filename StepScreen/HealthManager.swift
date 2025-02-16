import HealthKit

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
