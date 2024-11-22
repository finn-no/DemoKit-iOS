import Foundation
import SwiftUI

extension ViewControllerMapper {
    /// Wrapper for `Demoable`s that are `View`.
    class SwiftUIContainer<Content: View>: UIHostingController<Content> {

        // MARK: - Private properties

        private let demoable: any Demoable

        // MARK: - Init

        init(rootView: Content, demoable: any Demoable) {
            self.demoable = demoable
            super.init(rootView: rootView)
        }

        @MainActor required dynamic init?(coder aDecoder: NSCoder) { fatalError() }

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            setup()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            view.setNeedsUpdateConstraints()
        }

        // MARK: - Setup

        private func setup() {
            view.backgroundColor = .systemBackground
        }
    }
}
