import SwiftUI

struct HomeView: View {
    @StateObject var healthManager = HealthManager()

    var body: some View {
        VStack {
            Text("Steps: \\(healthManager.steps)")
            Button("Refresh Steps") { healthManager.fetchSteps() }
        }.onAppear { healthManager.requestAuthorization() }
    }
}
