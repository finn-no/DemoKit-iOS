import Foundation
import UIKit

/// A simple button to present for a `Demoable` when its `dismissKind == .button`.
class DismissButton: UIButton {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("Dismiss", for: .normal)
    }
}
