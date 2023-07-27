import Foundation
import UIKit

public enum DemoablePresentation {
    case none
    case sheet(detents: [UISheetPresentationController.Detent])
    case navigationController
}
