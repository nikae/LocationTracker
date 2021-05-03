//
//  ContentView.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 4/17/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    @EnvironmentObject var handler: ContentViewHandler
    
    var body: some View {
        if activityManager.running {
            InActivityView()
        } else {
            ActivityStartView()
                .onAppear {
                    activityManager.requestAuthorization()
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



extension Binding {
    @inlinable
    public func onChange(perform action: @escaping (Value) -> ()) -> Self where Value: Equatable {
        return .init(
            get: { self.wrappedValue },
            set: { newValue in
                let oldValue = self.wrappedValue
                
                self.wrappedValue = newValue
                
                if newValue != oldValue  {
                    action(newValue)
                }
            }
        )
    }
    
    @inlinable
    public func onChange(toggle value: Binding<Bool>) -> Self where Value: Equatable {
        onChange { _ in
            value.wrappedValue.toggle()
        }
    }
}
