//
//  ProgressBar.swift
//  Trail Lab
//
//  Created by Nika on 7/20/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    @Binding var progressLabel: String
    @Binding var animated: Bool
    let title: String


    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.yellow, Color.red]),
                        startPoint: .leading,
                        endPoint: .trailing),
                            lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: -215))

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress * 0.7, 0.7)))
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.yellow, Color.red]),
                        startPoint: .leading,
                        endPoint: .trailing),
                            lineWidth: 20)
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: -215))
                    .animation(animated ? .linear : .none)
                Text(progressLabel)
                    .font(.system(.body, design: .default))
                    .multilineTextAlignment(.center)
            }
            Text(title)
                .font(.system(.headline, design: .default))
                .padding(.top, -30)
            //                .offset(y: -20)
        }
    }
}

struct ProgressPicker: View {

    @EnvironmentObject var historyViewHandler: HistoryViewHandler

    let intArray: [Int] = Array(1...100)
    @Binding var open: Bool
    let isDistancePicker: Bool

    var strengths: [Double] {
        return intArray.map { Double($0) }
    }

    let hArray: [Int] = Array(0...100)

    var hstrengths: [Double] {
        return hArray.map { Double($0) * 3600 }
    }

    let mArray: [Int] = Array(0..<60)

    var mstrengths: [Double] {
        return mArray.map { Double($0) * 60 }
    }

    @State private var selectedStrength = Int(Preferences.distanceGoal.convert(fromMiters: true))
    @State private var selecteHour = Preferences.timeGoal.secondsToHoursMinutesSeconds().hours
    @State private var selectedminute = Preferences.timeGoal.secondsToHoursMinutesSeconds().minutes

    @State private var birthDate = Date()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .blendMode(.destinationOut)
                .onTapGesture {
                    self.open.toggle()
            }

            VStack {
                if isDistancePicker {
                    Picker(selection: $selectedStrength, label: Text("Strength")) {
                        ForEach(0 ..< strengths.count) {
                            Text(String(Double(self.strengths[$0]).formatDistaneForGoals()))

                        }
                    }
                    .padding()
                    .frame(maxWidth: 300, maxHeight: 200)
                    .clipped()
                    .labelsHidden()
                    .background(AppBackground().cornerRadius(12))
                } else {
                    HStack {
                        Picker(selection: $selecteHour, label: Text("")) {
                            ForEach(0 ..< hstrengths.count) {
                                Text(self.hstrengths[$0].format(using: .hour) ?? "")

                            }
                        }
                        .frame(minWidth: .zero, maxWidth: .infinity)
                            .clipped()
                        Picker(selection: $selectedminute, label: Text("")) {
                            ForEach(0 ..< mstrengths.count) {
                                Text(self.mstrengths[$0].format(using: .minute) ?? "")

                            }
                        }
                        .frame(minWidth: .zero, maxWidth: .infinity)
                            .clipped()
                    }
                    .padding()
                    .frame(maxWidth: 300, maxHeight: 200)
                    .clipped()
                    .labelsHidden()
                    .background(AppBackground().cornerRadius(12))
                }

                Button(action: {
                    if self.isDistancePicker {
                        print("distance goal here")
                        Preferences.distanceGoal = Double(self.selectedStrength).convert(fromMiters: false)
                    } else {
                        Preferences.timeGoal = TimeInterval(self.selecteHour * 3600) + TimeInterval(self.selectedminute * 60)
                    }

                    self.historyViewHandler.gerMod()
                    self.open.toggle()
                }, label: {
                    Text("Done")
                        .frame(maxWidth: 298, maxHeight: 40)
                        .background(AppBackground().cornerRadius(12))
                        .foregroundColor(Color(.label))
                })

            }

        }.edgesIgnoringSafeArea(.all)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(
            progress: .constant(0.5),
            progressLabel: .constant("--"),
            animated: .constant(true),
            title: "--")
    }
}
