//
//  StatsView.swift
//  Trail Lab
//
//  Created by Nika Elashvili on 4/18/21.
//  Copyright © 2021 nika. All rights reserved.
//

import SwiftUI

enum SelectedStat: Int, CaseIterable {
    case hr = 0
    case steps
    case calories
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
                    .onTapGesture {
                        selectedStat = .time
                    }
                Spacer()
                Text("\(activityManager.activity?.distance?.formatDistane() ?? "--")")
                    .font(Font.system(size: fontSize(selectedStat == .distance), weight: .medium, design: .rounded).monospacedDigit())
                    .foregroundColor(fontColor(selectedStat == .distance))
                    .onTapGesture {
                        selectedStat = .distance
                    }
                Spacer()
                
                if activityManager.activity?.activityType == .biking {
                    Text("\((activityManager.activity?.speedCurrent ?? 0).formatSpeed())")
                        .font(Font.system(size: fontSize(selectedStat == .steps), weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundColor(fontColor(selectedStat == .steps))
                        .onTapGesture {
                            selectedStat = .steps
                        }
                } else {
                    Text("\((activityManager.activity?.pace ?? 0).formatPace()) Pace")
                        .font(Font.system(size: fontSize(selectedStat == .steps), weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundColor(fontColor(selectedStat == .steps))
                        .onTapGesture {
                            selectedStat = .steps
                        }
                    
                }
                
                Spacer()
                HStack {
                    Text("\(activityManager.activity?.calories?.formatCalories() ?? "--")")
                        .font(Font.system(size: fontSize(selectedStat == .calories), weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundColor(fontColor(selectedStat == .calories))
                        .onTapGesture {
                            selectedStat = .calories
                        }
                    Spacer()
                    Label {
                        Text(activityManager.activity?.currentHR == nil ? "--" : "\(Int(activityManager.activity?.currentHR ?? -1))").foregroundColor(fontColor(selectedStat == .hr))+Text("bpm").font(.system(size: 8)).foregroundColor(fontColor(selectedStat == .hr))
                            
                    } icon: {
                        Image(systemName: activityManager.activity?.currentHR == nil ? "heart.slash.fill" : "heart.fill")
                            .foregroundColor(.red)
                            .scaleEffect(self.isAnimating ? 1 : 0.8)
                    }
                    .opacity(activityManager.activity?.currentHR == nil ? 0.5 : 1)
                    .font(Font.system(size: fontSize(selectedStat == .hr), weight: .medium, design: .rounded).monospacedDigit())
                    .onTapGesture {
                        selectedStat = .hr
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut.repeatForever()) {
                            self.isAnimating = true
                        }
                    }
                }
                
            }
            .focusable(true)
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            .padding(.horizontal)
            .frame(height: proxy.size.height)
            .digitalCrownRotation(self.$scrollAmount ,
                                  from: 0,
                                  through: Double(SelectedStat.allCases.count),
                                  by: 1, sensitivity: .low,
                                  isContinuous: false,
                                  isHapticFeedbackEnabled: true)
            .onChange(of: scrollAmount) { value in
                DispatchQueue.main.async {
                    selectedStat = SelectedStat(rawValue: Int(scrollAmount)) ?? .distance
                }
            }
          
        }
    }
    
    func fontSize(_ focused: Bool) -> CGFloat {
        focused ? 28 : 22
    }
    
    func fontColor(_ focused: Bool) -> Color {
        focused ? activityManager.activity?.activityType.color() ?? .white : .white
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(ActivityManagerWatchOS())
    }
}
