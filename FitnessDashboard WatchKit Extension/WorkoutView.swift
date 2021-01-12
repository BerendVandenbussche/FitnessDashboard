/*
See LICENSE folder for this sample’s licensing information.

Abstract:
This file defines the workout view.
*/

import SwiftUI
import UIKit
import SocketIO

struct WorkoutView: View {
    @EnvironmentObject var workoutSession: WorkoutManager
    
    func handleData(){
        let manager = SocketManager(socketURL: URL(string: "http://192.168.0.191:5000")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("apple_watch_data") {data, ack in
            guard let heartrate = workoutSession.heartrate as? Double else { return }
            
            socket.emitWithAck("canUpdate", heartrate).timingOut(after: 0) {data in
                socket.emit("apple_watch_data", ["heartrate": heartrate])
            }

            ack.with("Got your heartrate", "dude")
        }

        socket.connect()
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
                .font(Font.system(size: 26, weight: .semibold, design: .default).monospacedDigit())
                
            //Calories burned.
            Text("\(workoutSession.activeCalories, specifier: "%.1f") cal")
            .font(Font.system(size: 26, weight: .regular, design: .default).monospacedDigit())
            .frame(alignment: .leading)
            
            //Heartrate.
            Text("\(workoutSession.heartrate, specifier: "%.1f") BPM")
                .font(Font.system(size: 26, weight: .regular, design: .default).monospacedDigit()).onAppear(){handleData()}
            
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
            ).simultaneousGesture(TapGesture().onEnded{workoutSession.endWorkout()})
             
        }}.onAppear(){workoutSession.startWorkout()}
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
