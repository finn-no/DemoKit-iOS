import Foundation
import UIKit
import SwiftUI
import FINNBottomSheet

class DemoGroupViewController: UIViewController {

    // MARK: - Private properties

    private let demoGroup: any DemoGroup.Type
    private let reuseIdentifier = "tableCell"
    private var tweakPresentationController: TweakPresentationController?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    private let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(
        contentHeights: [.bottomSheetAutomatic, UIScreen.main.bounds.size.height - 200],
        startTargetIndex: 0
    )

    // MARK: - Init

    init(demoGroup: any DemoGroup.Type) {
        self.demoGroup = demoGroup
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        title = demoGroup.title
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Private methods

    private func present(viewController: UIViewController, for demoable: any Demoable) {
        configure(viewController: viewController, for: demoable)

        switch demoable.presentation {
        case .navigationController:
            let navigationController = UINavigationController(rootViewController: viewController)

            if demoable.overridesModalPresentationStyle {
                navigationController.modalPresentationStyle = viewController.modalPresentationStyle
            } else {
                navigationController.modalPresentationStyle = .fullScreen
            }

            present(navigationController, animated: true)
        case .sheet(let detents):
            viewController.modalPresentationStyle = .pageSheet
            viewController.sheetPresentationController?.detents = detents
            present(viewController, animated: true)
        case .none:
            present(viewController, animated: true)
        }
    }

    private func configure(viewController: UIViewController, for demoable: any Demoable) {
        viewController.setupDismissal(for: demoable)
        viewController.title = demoable.title
        viewController.navigationItem.rightBarButtonItems = demoable.rightBarButtonItems

        if !demoable.overridesModalPresentationStyle {
            viewController.modalPresentationStyle = .fullScreen
        }

        if let tweakableDemo = demoable as? any TweakableDemo {
            let tweakPresentationController = TweakPresentationController(demoViewController: viewController, tweakableDemo: tweakableDemo)
            self.tweakPresentationController = tweakPresentationController

            let cornerAnchoringView = CornerAnchoringView(withAutoLayout: true)
            cornerAnchoringView.delegate = tweakPresentationController
            viewController.view.addSubview(cornerAnchoringView)
            cornerAnchoringView.fillInSuperview(withinSafeAre: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension DemoGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        demoGroup.numberOfDemos
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = demoGroup.demoGroupItem(for: indexPath.row).title
        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension DemoGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let demoable = demoGroup.demoable(for: indexPath.row)

        switch demoable {
        case _ as UIView:
            let viewController = UIViewDemoViewController(demoable: demoable)
            present(viewController: viewController, for: demoable)
        case let demoView as any View:
            let anyView = AnyView(demoView)
            let viewController = SwiftUIDemoViewController(rootView: anyView, demoable: demoable)
            present(viewController: viewController, for: demoable)
        case let previewProvider as any PreviewProvider:
            let previews = type(of: previewProvider).previews
            let anyView = AnyView(previews)
            let viewController = SwiftUIDemoViewController(rootView: anyView, demoable: demoable)
            present(viewController: viewController, for: demoable)
        case let demoViewController as UIViewController:
            present(viewController: demoViewController, for: demoable)
        default:
            fatalError("⛔️ Got neither `UIView`, `View` nor `UIViewController` for demo item with identifier '\(demoable.identifier)'")
        }
    }
}
