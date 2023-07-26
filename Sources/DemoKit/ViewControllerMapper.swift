import Foundation
import SwiftUI
import UIKit

struct ViewControllerMapper {
    static func viewController(for demoable: any Demoable) -> UIViewController {
        switch demoable {
        case _ as UIView:
            return UIViewDemoViewController(demoable: demoable)
        case let demoView as any View:
            let anyView = AnyView(demoView)
            return SwiftUIDemoViewController(rootView: anyView, demoable: demoable)
        case let previewProvider as any PreviewProvider:
            let previews = type(of: previewProvider).previews
            let anyView = AnyView(previews)
            return SwiftUIDemoViewController(rootView: anyView, demoable: demoable)
        case let demoViewController as UIViewController:
            return demoViewController
        default:
            fatalError("⛔️ Got neither `UIView`, `View` nor `UIViewController` for demo item with identifier '\(demoable.identifier)'")
        }
    }
}
