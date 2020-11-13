//
//  ShareManager.swift
//  Trail Lab
//
//  Created by Nika on 10/6/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import SwiftUI

enum OverlayOptions: Int, CaseIterable {
    case standard = 0
    case standardWithTitle = 1
    case trailLab = 2
    case magazine = 3
}

enum ShareSource {
    case IGStories
    case FBStories
    case Snap
    case other
}

enum ColorOptions: Int, CaseIterable {
    case white = 0
    case activity = 1
    case red = 2
}

class ShareManager: ObservableObject {
    enum SwipeHorizontalDirection: String {
        case left, right, none
    }

    @Published var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }

    @Published var overlayOptions: OverlayOptions = .standard
    @Published var colorOptions: ColorOptions = .white


     func changeOverlay() {
        if overlayOptions.rawValue + 1 < OverlayOptions.allCases.count {
            overlayOptions = OverlayOptions(rawValue: overlayOptions.rawValue + 1)!
        } else {
            overlayOptions = OverlayOptions(rawValue: 0)!
        }
    }

    func changeColor() {
       if colorOptions.rawValue + 1 < ColorOptions.allCases.count {
        colorOptions = ColorOptions(rawValue: colorOptions.rawValue + 1)!
       } else {
        colorOptions = ColorOptions(rawValue: 0)!
       }
   }

//    func getColor() -> Color {
//        switch colorOptions {
//        case .white:
//            return Color.white
//        case .activity:
//            return activity.activityType.color()
//        case .red:
//            return Color.red
//
//        }
//    }

   

    func shareOnSnap() {

//        guard let image = image else { return }
//        let imageData: Data = image.pngData()!


            let promoText = "Check out this great new video from , I found on talent app"
            let shareString = "snapchat://text=\(promoText)"
            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: escapedShareString)
            UIApplication.shared.openURL(url!)
    }

    func shareOnIG(image: UIImage?) {
        // 1
        if let urlScheme = URL(string: "instagram-stories://share") {

            // 2
            if UIApplication.shared.canOpenURL(urlScheme) {

                // 3
                guard let image = image else { return }
                let imageData: Data = image.pngData()!

                // 4
                let items = [["com.instagram.sharedSticker.backgroundImage": imageData]]
                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]

                // 5
                UIPasteboard.general.setItems(items, options: pasteboardOptions)

                // 6
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
            }
        }
    }
}

extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

        // locate far out of screen
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            // [!!] Uncomment to clip resulting image
            //             rendererContext.cgContext.addPath(
            //                UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
            //            rendererContext.cgContext.clip()

            // As commented by @MaxIsom below in some cases might be needed
            // to make this asynchronously, so uncomment below DispatchQueue
            // if you'd same met crash
            //            DispatchQueue.main.async {
            layer.render(in: rendererContext.cgContext)
            //            }
        }
    }
}


















import LinkPresentation

struct ShareSheet: UIViewControllerRepresentable {
    let photo: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let text = "Trail Lab App"
        let itemSource = ShareActivityItemSource(shareText: text, shareImage: photo)
        let url = URL(string: "https://apps.apple.com/us/app/trail-lab/id1221110315?itsct=apps_box&itscg=30200")!
        let activityItems: [Any] = [photo, text, itemSource, url]

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)

        return controller
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}

class ShareActivityItemSource: NSObject, UIActivityItemSource {

    var shareText: String
    var shareImage: UIImage
    var linkMetaData = LPLinkMetadata()

    init(shareText: String, shareImage: UIImage) {
        self.shareText = shareText
        self.shareImage = shareImage
        linkMetaData.title = shareText
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "AppIcon ") as Any
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
}
