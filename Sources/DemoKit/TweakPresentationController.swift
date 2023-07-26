import Foundation
import UIKit

class TweakPresentationController {

    // MARK: - Private properties

    private let demoViewController: UIViewController
    private let tweakableDemo: any TweakableDemo

    // MARK: - Init

    init(demoViewController: UIViewController, tweakableDemo: any TweakableDemo) {
        self.demoViewController = demoViewController
        self.tweakableDemo = tweakableDemo
    }
}

// MARK: - CornerAnchoringViewDelegate

extension TweakPresentationController: CornerAnchoringViewDelegate {
    func cornerAnchoringViewDidSelectTweakButton(_ cornerAnchoringView: CornerAnchoringView) {
        let tweakTableViewController = TweakTableViewController(tweakableDemo: tweakableDemo)
            .wrapInNavigationController(withTitle: "Tweaks")
            .withDetents([.medium(), .large()])

        demoViewController.present(tweakTableViewController, animated: true)
    }
}
