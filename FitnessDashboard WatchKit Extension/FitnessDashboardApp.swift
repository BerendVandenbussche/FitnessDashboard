//
//  FitnessDashboardApp.swift
//  FitnessDashboard WatchKit Extension
//
//  Created by Berend Vandenbussche on 04/01/2021.
//

import SwiftUI

@main
struct FitnessDashboardApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
