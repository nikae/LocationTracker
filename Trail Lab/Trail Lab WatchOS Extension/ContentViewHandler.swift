//
//  ContentViewHandler.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 5/2/21.
//  Copyright © 2021 nika. All rights reserved.
//

import Foundation
import HealthKit

enum ViewState {
    case onboarding
    case permissions
    case beforeActivity
    case inActivity
    case summary
}


class ContentViewHandler: ObservableObject {
    static let shared = ContentViewHandler()
    
    @Published var viewState: ViewState = .onboarding
    @Published var healthAuthorized: Bool = false
    
    var permissions: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    init() {
        configureViewState()
    }
    
    func configureViewState() {
        if !Preferences.hasSeenOnboarding {
            viewState = .onboarding
        } else if !permissions {
            viewState = .permissions
        } else {
            viewState = .beforeActivity
        }
    }
}
