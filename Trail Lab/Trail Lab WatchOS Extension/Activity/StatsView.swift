//
//  StatsView.swift
//  Trail Lab
//
//  Created by Nika Elashvili on 4/18/21.
//  Copyright © 2021 nika. All rights reserved.
//

import SwiftUI

enum SelectedStat: Int, CaseIterable {
    case steps = 0
    case calories
    case hr
    case distance
    case time
}

struct StatsView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    @State var isAnimating = false
    @Namespace var namespace

    @State var scrollAmount: Double = Double(SelectedStat.distance.rawValue)
    @State var selectedStat: SelectedStat = .distance
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                Text("\(TimeInterval(activityManager.elapsedSeconds).format(unitsStyle: .positional, zeroFormattingBehavior: .pad) ?? "-:-:-")")
                    .font(Font.system(size: 38, weight: .bold, design: .rounded).monospacedDigit())
                    .foregroundColor(fontColor(selectedStat == .time))
                
                Text("\(activityManager.distance.formatDistane())")
                    .font(Font.system(size: fontSize(selectedStat == .distance), weight: .medium, design: .rounded).monospacedDigit())
                    .foregroundColor(fontColor(selectedStat == .distance))

                
                Label {
                    Text("\(Int(activityManager.heartrate)) bpm")
                        .foregroundColor(fontColor(selectedStat == .hr))
                } icon: {
                   Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    .scaleEffect(self.isAnimating ? 1 : 0.8)
                }
                .font(Font.system(size: fontSize(selectedStat == .hr), weight: .medium, design: .rounded).monospacedDigit())
               
                .onAppear {
                    withAnimation(Animation.easeInOut.repeatForever()) {
                        self.isAnimating = true
                    }
                }
                Text("\(activityManager.activeCalories.formatCalories())")
                    .font(Font.system(size: fontSize(selectedStat == .calories), weight: .medium, design: .rounded).monospacedDigit())
                    .foregroundColor(fontColor(selectedStat == .calories))
                Text("\(activityManager.stepCount) Steps")
                    .font(Font.system(size: fontSize(selectedStat == .steps), weight: .medium, design: .rounded).monospacedDigit())
                    .foregroundColor(fontColor(selectedStat == .steps))
            }
            .focusable(true)
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .digitalCrownRotation(self.$scrollAmount ,
                                  from: 0,
                                  through: Double(SelectedStat.allCases.count),
                                  by: 1, sensitivity: .low,
                                  isContinuous: false,
                                  isHapticFeedbackEnabled: true)
            .onChange(of: scrollAmount) { value in
                selectedStat = SelectedStat(rawValue: Int(scrollAmount)) ?? .distance
            }
          
        }
    }
    
    func fontSize(_ focused: Bool) -> CGFloat {
        focused ? 28 : 22
    }
    
    func fontColor(_ focused: Bool) -> Color {
        focused ? activityManager.activityType.color() : .white
    }
    
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(ActivityManagerWatchOS())
    }
}
