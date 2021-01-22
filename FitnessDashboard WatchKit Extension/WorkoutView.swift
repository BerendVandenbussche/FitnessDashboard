/*
See LICENSE folder for this sample’s licensing information.

Abstract:
This file defines the workout view.
*/

import SwiftUI
import UIKit
import SocketIO

let manager:SocketManager = SocketManager(socketURL: URL(string: "ws://192.168.0.191:8080")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

struct WorkoutView: View {
    @EnvironmentObject var workoutSession: WorkoutManager
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }

    var userLongitude: String {
            return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        }
    
    func connectSocketAndStartWorkout(){
        workoutSession.startWorkout()
        socket.connect()
    }
    
    func handleDataSocketIO(){
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        let heartrate = workoutSession.heartrate
        let calories = workoutSession.activeCalories
        let distance = workoutSession.distance
        let time = elapsedTimeString(elapsed: secondsToHoursMinutesSeconds(seconds: workoutSession.elapsedSeconds))
        socket.emit("watchData", ["heartrate": heartrate, "calories": calories, "distance": distance, "time": time, "latitude": userLatitude, "longitude": userLongitude])


    }
    
    func endWorkout(){
        workoutSession.endWorkout()
        socket.disconnect()
    }
    
    var body: some View {
        NavigationView{
        VStack(alignment: .leading) {
            HStack{
                Text("Dashboard")
                Spacer()
                Text(String(BatteryMonitoring().level) + "%")
            }
            // The workout elapsed time.
            Text("\(elapsedTimeString(elapsed: secondsToHoursMinutesSeconds(seconds: workoutSession.elapsedSeconds)))").frame(alignment: .leading)
                .font(Font.system(size: 26, weight: .semibold, design: .default).monospacedDigit()).onChange(of: workoutSession.elapsedSeconds){newValue in handleDataSocketIO()}
                
            //Calories burned.
            Text("\(workoutSession.activeCalories, specifier: "%.1f") cal")
            .font(Font.system(size: 26, weight: .regular, design: .default).monospacedDigit())
            .frame(alignment: .leading)
            
            //Heartrate.
            Text("\(workoutSession.heartrate, specifier: "%.1f") BPM")
                .font(Font.system(size: 26, weight: .regular, design: .default).monospacedDigit())
            
            //Distance
            Text("\(workoutSession.distance, specifier: "%.1f") m")
            .font(Font.system(size: 26, weight: .regular, design: .default).monospacedDigit())
            Spacer().frame(width: 1, height: 8, alignment: .leading)
            
            //Stop workout
            NavigationLink(
                destination: ContentView(),
                label: {
                    Text("End workout")
                }
            ).simultaneousGesture(TapGesture().onEnded{endWorkout()})
             
        }}.onAppear(){connectSocketAndStartWorkout()}
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
    }
    
    // Convert the seconds into seconds, minutes, hours.
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // Convert the seconds, minutes, hours into a string.
    func elapsedTimeString(elapsed: (h: Int, m: Int, s: Int)) -> String {
        return String(format: "%d:%02d:%02d", elapsed.h, elapsed.m, elapsed.s)
    }
    
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView().environmentObject(WorkoutManager())
    }
}
