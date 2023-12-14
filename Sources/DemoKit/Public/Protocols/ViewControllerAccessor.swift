import Foundation
import UIKit

/// Provides access to the viewController used to demo/present a `Demoable`,
@MainActor
public protocol ViewControllerAccessor: AnyObject {
    var viewController: UIViewController? { get set }
}
