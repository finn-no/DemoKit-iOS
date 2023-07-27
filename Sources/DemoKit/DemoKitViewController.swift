import Foundation
import UIKit
import SwiftUI

public class DemoKitViewController: UIViewController {

    // MARK: - Private properties

    private let demoGroups: [any DemoGroup.Type]
    private let sortedDemoGroups: [SortedItem]
    private var selectedDemoGroup: (any DemoGroup.Type)?
    private var tweakPresentationController: TweakPresentationController?
    private var hasPresentedLastSelectedDemo = false
    private lazy var titleView = TitleView(delegate: self)
    private lazy var groupItemsTableView = GroupItemsTableView(delegate: self)

    // MARK: - Init

    public init(demoGroups: [any DemoGroup.Type]) {
        self.demoGroups = demoGroups
        self.sortedDemoGroups = Self.mapAndSort(demoGroups)

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialDemoGroup()
        setup()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Prevent presenting the last selected demo, if the demo is dismissed.
        // Users of this lib has the option to present whatever `UIViewController` they want, so this seems to be
        // the easiest way of figuring out when we should reset the state.
        if hasPresentedLastSelectedDemo {
            State.selectedDemoableIndex = nil
            State.selectedTweakIndex = nil
        }

        // Present the last selected demo, if possible.
        if let selectedDemoableIndex = State.selectedDemoableIndex, let selectedDemoGroup {
            let demoable = selectedDemoGroup.demoable(for: selectedDemoableIndex)
            let viewController = ViewControllerMapper.viewController(for: demoable)

            // Configure for the last selected tweak, if possible.
            if let selectedTweakIndex = State.selectedTweakIndex, let tweakableDemo = demoable as? TweakableDemo {
                tweakableDemo.configure(forTweakAt: selectedTweakIndex)
            }

            hasPresentedLastSelectedDemo = true
            present(viewController: viewController, for: demoable)
        }
    }

    // MARK: - Setup

    private func setup() {
        navigationItem.titleView = titleView
        titleView.isClickable = demoGroups.count > 1

        view.addSubview(groupItemsTableView)
        groupItemsTableView.fillInSuperview()
    }

    // MARK: - Private methods

    private func setupInitialDemoGroup() {
        // Try to find the last selected group. Will fallback to the first in the list, if not found.
        if let selectedGroupIndex = State.selectedGroupIndex, demoGroups.indices.contains(selectedGroupIndex) {
            updateSelectedDemoGroup(demoGroups[selectedGroupIndex])
        } else {
            updateSelectedDemoGroup(sortedDemoGroups.first.map { demoGroups[$0.originalIndex] })
        }
    }

    private func updateSelectedDemoGroup(_ demoGroup: (any DemoGroup.Type)?) {
        selectedDemoGroup = demoGroup
        titleView.title = demoGroup?.groupTitle ?? "??"
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

// MARK: - TitleViewDelegate

extension DemoKitViewController: TitleViewDelegate {
    func titleViewWasSelected(_ view: TitleView) {
        let selectionController = GroupSelectionViewController(
            sortedItems: sortedDemoGroups,
            selectedOriginalIndex: demoGroups.firstIndex(where: { $0 == selectedDemoGroup }),
            delegate: self
        ).wrapInNavigationController(withTitle: "Demo groups").withDetents([.medium(), .large()])

        present(selectionController, animated: true)
    }
}

// MARK: - GroupSelectionViewControllerDelegate

extension DemoKitViewController: GroupSelectionViewControllerDelegate {
    func groupSelectionViewController(_ viewController: GroupSelectionViewController, didSelectItem sortedItem: SortedItem) {
        let demoGroup = demoGroups[sortedItem.originalIndex]
        updateSelectedDemoGroup(demoGroup)

        State.selectedGroupIndex = sortedItem.originalIndex

        viewController.dismiss(animated: true)
    }
}

// MARK: - GroupItemsTableViewDelegate

extension DemoKitViewController: GroupItemsTableViewDelegate {
    func groupItemsTableView(_ viewController: GroupItemsTableView, didSelectItemAt index: Int) {
        guard let selectedDemoGroup else { return }

        State.selectedDemoableIndex = index
        State.selectedTweakIndex = nil

        let demoable = selectedDemoGroup.demoable(for: index)
        let viewController = ViewControllerMapper.viewController(for: demoable)
        present(viewController: viewController, for: demoable)
    }
}
