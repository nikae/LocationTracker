//
//  TextWithBackgroundOverlay.swift
//  Trail Lab
//
//  Created by Nika on 11/2/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct TextWithBackgroundOverlay: View {
    @EnvironmentObject var shareManager: ShareManager
    let activity: Activity
    @State var showTapLable: Bool = true

    let showExtras: Bool
    var body: some View {
        ZStack {
            VStack {
                Logo()
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                if showTapLable && showExtras {
                    tapLabel
                }
                HStack {
                    if shareManager.swipeHorizontalDirection == .right {
                        Spacer()
                    }
                    Text("\(activity.title ?? activity.activityType.name())".capitalized)
                        .fontWeight(.medium)
                        .background(getColor())
                    if shareManager.swipeHorizontalDirection != .right {
                        Spacer()
                    }
                }
                HStack {
                    if shareManager.swipeHorizontalDirection == .right {
                        Spacer()
                    }
                    Text("\(activity.distance?.formatDistane() ?? ""), \(activity.duration.format() ?? "")".capitalized)
                        .fontWeight(.medium)
                        .background(getColor())
                    if shareManager.swipeHorizontalDirection != .right {
                        Spacer()
                    }
                }
                //                    .font(.system(.title, design: .rounded))
                //                    .fontWeight(.medium)
                //                    .background(getColor())
                //                    .minimumScaleFactor(0.2)
            }
            .font(.system(.title, design: .rounded))
            .minimumScaleFactor(0.2)
            .padding(4)
            .onTapGesture {
                shareManager.changeColor()
            }
            .gesture(
                DragGesture()
                    .onChanged {
                        if $0.startLocation.x > $0.location.x {
                            shareManager.swipeHorizontalDirection = .left
                        } else if $0.startLocation.x == $0.location.x {
                            shareManager.swipeHorizontalDirection = .none
                        } else {
                            shareManager.swipeHorizontalDirection = .right
                        }
                    })

        } .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showTapLable = false
                }
            }
        }
    }

    private var tapLabel: some View {
        ZStack {
            if #available(iOS 14.0, *) {
                Label("Tap or swipe on the label", systemImage: "hand.tap.fill")
                    .font(.footnote)
                    .padding()
                    .onTapGesture {
                        shareManager.changeColor()
                    }
            } else {
                Text("Tap or swipe on the label")
                    .font(.footnote)
                    .padding()
                    .onTapGesture {
                        shareManager.changeColor()
                    }
            }
        }
    }


    //    func changeColor() {
    //       if colorOptions.rawValue + 1 < ColorOptions.allCases.count {
    //        colorOptions = ColorOptions(rawValue: colorOptions.rawValue + 1)!
    //       } else {
    //        colorOptions = ColorOptions(rawValue: 0)!
    //       }
    //   }
    //
    func getColor() -> Color {
        switch shareManager.colorOptions {
        case .white:
            return Color(.systemBackground)
        case .activity:
            return activity.activityType.color()
        case .red:
            return Color.red

        }
    }
}

