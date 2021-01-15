//
//  Socketio.swift
//  FitnessDashboard WatchKit Extension
//
//  Created by Berend Vandenbussche on 13/01/2021.
//

import Foundation
import SocketIO

//func handleData(){
//    let manager = SocketManager(socketURL: URL(string: "http://192.168.0.191:5000")!, config: [.log(true), .compress])
//    let socket = manager.defaultSocket
//
//    socket.on(clientEvent: .connect) {data, ack in
//        print("socket connected")
//    }
//
//    socket.on("apple_watch_data") {data, ack in
//        guard let heartrate = workoutSession.heartrate as? Double else { return }
//
//        socket.emitWithAck("canUpdate", heartrate).timingOut(after: 0) {data in
//            socket.emit("apple_watch_data", ["heartrate": heartrate])
//        }
//
//        ack.with("Got your heartrate", "dude")
//    }
//
//    socket.connect()
//}
