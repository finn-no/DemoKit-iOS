import Foundation
import UIKit

extension UIViewController {
    func setupDismissal(for demoable: any Demoable) {
        switch demoable.dismissKind {
        case .button:
            var buttonConfiguration = UIButton.Configuration.filled()
            buttonConfiguration.buttonSize = .large
            buttonConfiguration.title = "Dismiss"

            let dismissButton = UIButton(configuration: buttonConfiguration, primaryAction: nil)
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            dismissButton.addTarget(self, action: #selector(didSelectDismiss), for: .touchUpInside)

            view.addSubview(dismissButton)
            NSLayoutConstraint.activate([
                dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                dismissButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
                dismissButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
                dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
            ])
        case .doubleTap:
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didSelectDismiss))
            doubleTap.numberOfTapsRequired = 2

//            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(doubleTap)
        case .none:
            break
        }
    }

    // MARK: - Actions

    @objc private func didSelectDismiss() {
        //        DemoState.lastSelectedIndexPath = nil
        dismiss(animated: true, completion: nil)
    }
}
