import AppIntents

class ShortcutManager {
    static let shared = ShortcutManager()
    private var provider: AppShortcutsProvider
    
    init(provider: AppShortcutsProvider = DefaultAppShortcutsProvider()) {
        self.provider = provider
    }
    
    /*func checkAndCreateShortcut(with apps: [String]) {
        if shortcutExists(named: "Restrict Screen Time Based on Steps") {
            print("Shortcut already exists.")
        } else {
            print("Creating new shortcut...")
            self.createShortcut(with: apps)
        }
    }
    
    func shortcutExists(named name: String) -> Bool {
        return provider.appShortcuts.contains {
            $0.name()
        }
    }*/
    
    private func createShortcut(with apps: [String]) {
        let restrictionIntent = ScreenTimeRestrictionIntent()
        restrictionIntent.stepGoal = 5000 // Default step goal, can be changed
        restrictionIntent.appsToRestrict = apps  // Pass the app list
        
        let newShortcut = AppShortcut(
            intent: restrictionIntent,
            phrases: ["Limit my screen time if I don’t walk enough"]
        )
        
        provider.addShortcut(newShortcut)
    }
}

protocol AppShortcutsProvider {
    var appShortcuts: [AppShortcut] { get }
    mutating func addShortcut(_ shortcut: AppShortcut)
}

struct DefaultAppShortcutsProvider: AppShortcutsProvider {
    private(set) var appShortcuts: [AppShortcut] = []
    
    mutating func addShortcut(_ shortcut: AppShortcut) {
        appShortcuts.append(shortcut)
    }
}
