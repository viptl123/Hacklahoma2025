//
//  StepScreenApp.swift
//  StepScreen
//
//  Created by Arman Riaz on 2/15/25.
//

import SwiftUI


struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let appsToRestrict = [
                        "com.instagram.ios",
                        "com.tiktok.app",
                        "com.snapchat.ios"
                    ]  // Example apps
                    //ShortcutManager.shared.checkAndCreateShortcut(with: appsToRestrict)
                }
        }
    }
}
