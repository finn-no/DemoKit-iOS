import UIKit

extension UIUserInterfaceStyle {
    var description: String {
        switch self {
        case .unspecified: return "unspecified"
        case .light: return "light"
        case .dark: return "dark"
        @unknown default: return "unknown"
        }
    }
}
