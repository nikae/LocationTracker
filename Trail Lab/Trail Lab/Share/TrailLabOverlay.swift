//
//  TrailLabOverlay.swift
//  Trail Lab
//
//  Created by Nika on 10/14/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct TrailLabOverlay: View {
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
        Text("\(activity.title ?? activity.activityType.name())\n\(activity.distance?.formatDistane() ?? "")".capitalized)
            .font(.system(.title, design: .rounded))
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .foregroundColor(getColor())
            .minimumScaleFactor(0.2)
            .onTapGesture {
                shareManager.changeColor()
            }
            if showTapLable && showExtras {
                VStack {
                    Spacer()
                    if #available(iOS 14.0, *) {
                        Label("Tap label to change color", systemImage: "hand.tap.fill")
                            .font(.footnote)
                            .padding()
                            .onTapGesture {
                                shareManager.changeColor()
                            }
                    } else {
                        Text("Tap label to change color")
                            .font(.footnote)
                            .padding()
                            .onTapGesture {
                                shareManager.changeColor()
                            }
                    }
                }
            }
        } .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showTapLable = false
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
            return Color.white
        case .activity:
            return activity.activityType.color()
        case .red:
            return Color.red

        }
    }
}

//struct TrailLabOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        TrailLabOverlay(activity: MocActivity, showExtras: true)
//    }
//}
