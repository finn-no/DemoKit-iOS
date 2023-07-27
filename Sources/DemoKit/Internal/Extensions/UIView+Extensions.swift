import UIKit

extension UIView {
    convenience init(withAutoLayout autoLayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !autoLayout
    }

    func fillInSuperview(insets: UIEdgeInsets = .zero, withinSafeAre: Bool = false) {
        guard let superview = self.superview else { return }

        translatesAutoresizingMaskIntoConstraints = false

        if withinSafeAre {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
            ])
        } else {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            ])

        }
    }
}
