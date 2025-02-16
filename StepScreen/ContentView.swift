import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            StatisticsPage()
                .tabItem { Label("Leaderboard", systemImage: "chart.bar") }
            LoginView()
                .tabItem { Label("Login", systemImage: "person.circle") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
