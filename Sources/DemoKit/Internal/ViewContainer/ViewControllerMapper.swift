import Foundation
import SwiftUI
import UIKit

@MainActor
struct ViewControllerMapper {
    private init() {}

    static func viewController(for demoable: any Demoable) -> UIViewController {
        switch demoable {
        case _ as UIView:
            return UIViewContainer(demoable: demoable)
        case let demoView as any View:
            let anyView = AnyView(demoView)
            return SwiftUIContainer(rootView: anyView, demoable: demoable)
        case let previewProvider as any PreviewProvider:
            let previews = type(of: previewProvider).previews
            let anyView = AnyView(previews)
            return SwiftUIContainer(rootView: anyView, demoable: demoable)
        case let demoViewController as UIViewController:
            return demoViewController
        default:
            fatalError("⛔️ Got neither `UIView`, `View` nor `UIViewController` for demo item with identifier '\(demoable.identifier)'")
        }
    }
}
