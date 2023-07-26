import Foundation
import UIKit
import SwiftUI

public class DemoGroupViewController: UIViewController {

    // MARK: - Private properties

    private var selectedDemoGroup: (any DemoGroup.Type)?
    private let demoGroups: [any DemoGroup.Type]
    private let sortedDemoGroups: [SortedItem]
    private let reuseIdentifier = "tableCell"
    private var tweakPresentationController: TweakPresentationController?

    private lazy var demoGroupSelectorView: DemoGroupSelectorView = {
        let view = DemoGroupSelectorView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

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

        view.addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Private methods

    private func updateSelectedDemoGroup(_ demoGroup: (any DemoGroup.Type)?) {
        selectedDemoGroup = demoGroup
        demoGroupSelectorView.title = demoGroup?.groupTitle ?? "??"
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
        let sortedItems = demoGroups.enumerated().map { SortedItem(originalIndex: $0.offset, title: $0.element.groupTitle) }
        return sortedItems.sorted(by: { $0.title <= $1.title })
    }
}

// MARK: - UITableViewDataSource

extension DemoGroupViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedDemoGroup?.numberOfDemos ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedDemoGroup else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = selectedDemoGroup.demoGroupItem(for: indexPath.row).groupItemTitle
        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension DemoGroupViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let selectedDemoGroup else { return }

        let demoable = selectedDemoGroup.demoable(for: indexPath.row)
        let viewController = ViewControllerMapper.viewController(for: demoable)
        present(viewController: viewController, for: demoable)
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
        updateSelectedDemoGroup(demoGroups[originalDemoGroupIndex])

        viewController.dismiss(animated: true)
        tableView.reloadData()
    }
}
