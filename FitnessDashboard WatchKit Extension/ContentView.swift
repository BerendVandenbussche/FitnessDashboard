//
//  ContentView.swift
//  FitnessDashboard WatchKit Extension
//
//  Created by Berend Vandenbussche on 04/01/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Fitness Dashboard")
                    .multilineTextAlignment(.leading)
                Text("Battery")
                    .multilineTextAlignment(.trailing)
        }
            Spacer()
 
    }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
