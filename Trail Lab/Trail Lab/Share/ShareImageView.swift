//
//  ShareImageView.swift
//  Trail Lab
//
//  Created by Nika on 9/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct SharebleImage: View {
    @Binding var image: UIImage?
    @EnvironmentObject var shareManager: ShareManager
    @Binding var overlayOptions: OverlayOptions

    let activity: Activity
    let showExtras: Bool

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width * 0.9,
                    height: UIScreen.main.bounds.width * 0.6)
                .clipped()
                .overlay(getOverlayView())
        }
    }

    func getOverlayView() -> some View {
        switch overlayOptions {
        case .trailLab:
            return AnyView(TrailLabOverlay(
                            activity: activity,
                            showExtras: showExtras)
                            .environmentObject(shareManager))
        case .magazine:
            return AnyView(TextWithBackgroundOverlay(
                            activity: activity,
                            showExtras: showExtras)
                            .environmentObject(shareManager))
        case .standardWithTitle:
            return AnyView(StandardOverlay(activity: activity, withTitle: true))
        case .standard:
            return AnyView(StandardOverlay(activity: activity, withTitle: false))
        }
    }
}

struct ShareImageView: View {
    @Binding var image: UIImage?
    let activity: Activity
    @State private var uiImage: UIImage? = nil
    @State private var rect: CGRect = .zero
    @State private var showShareSheet = false
    @EnvironmentObject var shareManager: ShareManager
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                DismissIcon()
                    .padding(.bottom)

                SharebleImage(image: $image, overlayOptions: $shareManager.overlayOptions, activity: activity, showExtras: true)
                    .environmentObject(shareManager)
                    .onTapGesture {
                        shareManager.changeOverlay()
                    }
                if #available(iOS 14.0, *) {
                    Label("Tap to change", systemImage: "hand.tap.fill")
                        .font(.body)
                        .padding()
                        .onTapGesture {
                            shareManager.changeOverlay()
                        }
                } else {
                    Text("Tap to change")
                        .font(.body)
                        .padding()
                        .onTapGesture {
                            shareManager.changeOverlay()

                        }
                }
                Spacer()
                VStack(spacing: 20) {
                Button(action: {
                    render(for: .IGStories)
                }) {
                    ShareButton(text: "Share on IG Stories", color: activity.activityType.color())
                }

                //                Button(action: {
                //                    render()
                //                }) {
                //                    ShareButton(text: "Share on Face Book Stories", color: Color.red)
                //                }
                //
                //                Button(action: {
                //                    render()
                //                }) {
                //                    ShareButton(text: "Share on Snap Chat", color: Color.red)
                //                }

                Button(action: {
                    render(for: .other)
                }) {
                    ShareButton(text: "Other", color: activity.activityType.color())
                }
                }

               
            }.padding()
        }
        .sheet(isPresented: self.$showShareSheet) {
            if let image = self.uiImage {
                ShareSheet(photo: image)
            }
        }
    }

    private func render(for shareSource: ShareSource)  {
        self.uiImage = SharebleImage(image: $image, overlayOptions: $shareManager.overlayOptions, activity: activity, showExtras: false)
            .environmentObject(shareManager)
            .asImage()

        switch shareSource {
        case .IGStories:
            shareManager.shareOnIG(image: self.uiImage)
        case .Snap:
            shareManager.shareOnSnap()
        default:
            self.showShareSheet.toggle()
        }
    }

}

struct ShareImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        ShareImageView(
            image: .constant(UIImage(named: "Icon-App")),
            activity: MocActivity)
            ShareImageView(
                image: .constant(UIImage(named: "Icon-App")),
                activity: MocActivity)
                .environment(\.colorScheme, .dark)
        }
    }
}



