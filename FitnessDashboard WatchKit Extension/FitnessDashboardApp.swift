//
//  FitnessDashboardApp.swift
//  FitnessDashboard WatchKit Extension
//
//  Created by Berend Vandenbussche on 04/01/2021.
//

import SwiftUI
import HealthKit

@main
struct FitnessDashboardApp: App {
    var workoutManager = WorkoutManager()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environmentObject(workoutManager)
                
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
   
}
