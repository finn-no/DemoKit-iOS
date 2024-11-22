import Foundation
import UIKit

@MainActor
protocol GroupItemsTableViewDelegate: AnyObject {
    func groupItemsTableView(_ viewController: GroupItemsTableView, didSelectItemAt index: Int)
}

/// Used in `DemoKitViewController` to present the list of demos within a `DemoGroup`.
///
/// Demos within the provided `DemoGroup` are sorted alphabetically grouped by first letter to allow for easy overview of available demos.
class GroupItemsTableView: UIView {

    // MARK: - Internal properties

    var demoGroup: (any DemoGroup.Type)? {
        didSet {
            prepareGroupItems(from: demoGroup)
            tableView.reloadData()
        }
    }

    // MARK: - Private properties

    private weak var delegate: GroupItemsTableViewDelegate?
    private let reuseIdentifier = "tableCell"
    private var sortedGroupItems = [String: [SortedItem]]()

    private var sectionKeys: [String] {
        sortedGroupItems.keys.sorted()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    // MARK: - Init

    init(delegate: GroupItemsTableViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Private methods

    private func prepareGroupItems(from demoGroup: (any DemoGroup.Type)?) {
        guard let demoGroup, demoGroup.numberOfDemos > 0 else {
            sortedGroupItems = [:]
            return
        }

        // Map `GroupItem`s into `SortedItem` so we can sort and group them.
        let sortedItems = (0..<demoGroup.numberOfDemos)
            .map { index in
                let groupItem = demoGroup.demoGroupItem(for: index)
                return SortedItem(originalIndex: index, title: groupItem.groupItemTitle)
            }
            .sortByTitle()

        sortedGroupItems = Dictionary(grouping: sortedItems, by: { String($0.title.prefix(1)) })
    }

    private func sortedItem(for indexPath: IndexPath) -> SortedItem {
        let sectionKey = sectionKeys[indexPath.section]

        guard let sectionItems = sortedGroupItems[sectionKey] else {
            fatalError("⛔️ \(String(describing: self)).\(#function): Could not get sectionItems for sectionKey '\(sectionKey)'.")
        }

        return sectionItems[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension GroupItemsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionKeys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionKeys[section]
        return sortedGroupItems[sectionKey]?.count ?? 0
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionKeys
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionKeys[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let demoGroup else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let sortedItem = sortedItem(for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = demoGroup.demoGroupItem(for: sortedItem.originalIndex).groupItemTitle
        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension GroupItemsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sortedItem = sortedItem(for: indexPath)
        delegate?.groupItemsTableView(self, didSelectItemAt: sortedItem.originalIndex)
    }
}
