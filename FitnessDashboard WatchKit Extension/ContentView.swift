//
//  ContentView.swift
//  FitnessDashboard WatchKit Extension
//
//  Created by Berend Vandenbussche on 04/01/2021.
//

import SwiftUI
import HealthKit
import WatchKit

struct ContentView: View {
    @EnvironmentObject var workoutSession: WorkoutManager
    @ObservedObject var locationManager = LocationManager()
    
    func getAuthorized(){
        self.workoutSession.requestAuthorization()
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("Dashboard")
                    .multilineTextAlignment(.leading)
            Spacer()
            NavigationLink(
                destination: WorkoutView()){Text("Start workout").onAppear(){getAuthorized()}
                
            }
            
            
            
 
    }
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(WorkoutManager())
    }
}
