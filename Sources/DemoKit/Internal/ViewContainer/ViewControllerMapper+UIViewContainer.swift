import Foundation
import UIKit

extension ViewControllerMapper {
    /// Wrapper for `Demoable`s that are `UIView`.
    class UIViewContainer: UIViewController {

        // MARK: - Private properties

        private let demoable: any Demoable

        // MARK: - Init

        init(demoable: any Demoable) {
            self.demoable = demoable
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            setup()
        }

        // MARK: - Setup

        private func setup() {
            view.backgroundColor = .systemBackground

            // Insert demo view.
            guard let demoView = demoable as? UIView else {
                fatalError("⛔️ \(String(describing: Self.self)).\(#function): Given Demoable is not of type `UIView`.")
            }
            demoView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(demoView)

            NSLayoutConstraint.activate([
                demoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                demoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                demoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                demoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }
}
