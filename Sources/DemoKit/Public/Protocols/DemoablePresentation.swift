import Foundation
import UIKit

@MainActor
public enum DemoablePresentation {
    case none
    case sheet(detents: [UISheetPresentationController.Detent])
    case navigationController
}
