//
//  ControlsView.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 7/10/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    @State var showAlert: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Button(action: {activityManager.togglePause()},
                   label: {
                    Label(activityManager.running ? "Pause" : "Resume",
                          systemImage: activityManager.running ? "pause" : "play")
                    
                   })
                .foregroundColor(activityManager.running ? activityManager.activity?.activityType.color() : .green)
           
            Spacer()
            //Check if workout is longer then 1 min prod 5 sec debug
            // If workout is less then the time above show alert to discard or save
            //If workout is longer then time above save it and show loading spinner
            Button(action: {
                if activityManager.isWorkoutViableToSave {
                    activityManager.endWorkout()
                } else {
                    activityManager.togglePause()
                    showAlert = true
                }
                
            },
            label: {
                Label("Done",
                      systemImage: "xmark")
                    .font(.headline)
                
            })
            .foregroundColor(.red)
           
            
            Spacer()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Are you sure?"),
                  message: Text("Would You like to discard your workout"),
                  primaryButton: .cancel(Text("Continue"), action: {
                    activityManager.togglePause()
                  }),
                  secondaryButton: .destructive(Text("Discard"),
                                                action: {
                                                    activityManager.endWorkout()
                                                }))
        })
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
            .environmentObject(ActivityManagerWatchOS())
    }
}


