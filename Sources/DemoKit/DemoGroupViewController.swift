import Foundation
import UIKit
import SwiftUI

public class DemoGroupViewController: UIViewController {

    // MARK: - Private properties

    private var selectedDemoGroup: (any DemoGroup.Type)?
    private let demoGroups: [any DemoGroup.Type]
    private let sortedDemoGroups: [SortedItem]
    private var tweakPresentationController: TweakPresentationController?
    private lazy var demoGroupSelectorView = DemoGroupSelectorView(delegate: self)
    private lazy var groupItemsTableView = GroupItemsTableView(delegate: self)

    // MARK: - Init

    public init(demoGroups: [any DemoGroup.Type]) {
        self.demoGroups = demoGroups
        self.sortedDemoGroups = Self.mapAndSort(demoGroups)

        super.init(nibName: nil, bundle: nil)

        updateSelectedDemoGroup(sortedDemoGroups.first.map { demoGroups[$0.originalIndex] })
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        navigationItem.titleView = demoGroupSelectorView
        demoGroupSelectorView.isClickable = sortedDemoGroups.count > 1

        view.addSubview(groupItemsTableView)
        groupItemsTableView.fillInSuperview()
    }

    // MARK: - Private methods

    private func updateSelectedDemoGroup(_ demoGroup: (any DemoGroup.Type)?) {
        selectedDemoGroup = demoGroup
        demoGroupSelectorView.title = demoGroup?.groupTitle ?? "??"
        groupItemsTableView.demoGroup = demoGroup
    }

    private func present(viewController: UIViewController, for demoable: any Demoable) {
        configure(viewController: viewController, for: demoable)

        switch demoable.presentation {
        case .navigationController:
            let navigationController = viewController.wrapInNavigationController()

            if demoable.overridesModalPresentationStyle {
                navigationController.modalPresentationStyle = viewController.modalPresentationStyle
            } else {
                navigationController.modalPresentationStyle = .fullScreen
            }

            present(navigationController, animated: true)
        case .sheet(let detents):
            viewController.modalPresentationStyle = .pageSheet
            viewController.withDetents(detents)
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

    // MARK: - Static methods

    static private func mapAndSort(_ demoGroups: [any DemoGroup.Type]) -> [SortedItem] {
        demoGroups
            .enumerated()
            .map { SortedItem(originalIndex: $0.offset, title: $0.element.groupTitle) }
            .sortByTitle()
    }
}

// MARK: - DemoGroupSelectorViewDelegate

extension DemoGroupViewController: DemoGroupSelectorViewDelegate {
    func demoGroupSelectorViewWasSelected(_ view: DemoGroupSelectorView) {
        let selectionController = SortedItemSelectionViewController(
            sortedItems: sortedDemoGroups,
            selectedIndex: nil,
            delegate: self
        ).wrapInNavigationController(withTitle: "Demo groups").withDetents([.medium(), .large()])

        present(selectionController, animated: true)
    }
}

// MARK: - SortedItemSelectionViewControllerDelegate

extension DemoGroupViewController: SortedItemSelectionViewControllerDelegate {
    func sortedItemSelectionViewController(_ viewController: SortedItemSelectionViewController, didSelectItemAt index: Int) {
        let originalDemoGroupIndex = sortedDemoGroups[index].originalIndex
        let demoGroup = demoGroups[originalDemoGroupIndex]
        updateSelectedDemoGroup(demoGroup)

        viewController.dismiss(animated: true)
    }
}

// MARK: - GroupItemsTableViewDelegate

extension DemoGroupViewController: GroupItemsTableViewDelegate {
    func groupItemsTableView(_ viewController: GroupItemsTableView, didSelectItemAt index: Int) {
        guard let selectedDemoGroup else { return }

        let demoable = selectedDemoGroup.demoable(for: index)
        let viewController = ViewControllerMapper.viewController(for: demoable)
        present(viewController: viewController, for: demoable)
    }
}
