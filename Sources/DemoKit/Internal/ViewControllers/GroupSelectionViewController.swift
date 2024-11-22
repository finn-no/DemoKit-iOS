import Foundation
import UIKit

@MainActor
protocol GroupSelectionViewControllerDelegate: AnyObject {
    func groupSelectionViewController(
        _ viewController: GroupSelectionViewController,
        didSelectItem sortedItem: SortedItem
    )
}

/// Used when presenting a list of `DemoGroup`s.
class GroupSelectionViewController: UIViewController {

    // MARK: - Private properties

    private weak var delegate: GroupSelectionViewControllerDelegate?
    private let sortedItems: [SortedItem]
    private let selectedOriginalIndex: Int?
    private let reuseIdentifier = "tableCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    // MARK: - Init

    /// - Parameters:
    ///   - sortedItems: A list of `SortedItem`s that'll be used to populate the list of groups.
    ///   - selectedOriginalIndex: The currently selected demo group index. Will be used to identify which cell to highlight, if non-nil.
    ///   - delegate: A type conforming to `GroupSelectionViewControllerDelegate`.
    init(sortedItems: [SortedItem], selectedOriginalIndex: Int?, delegate: GroupSelectionViewControllerDelegate) {
        self.sortedItems = sortedItems
        self.selectedOriginalIndex = selectedOriginalIndex
        self.delegate = delegate
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
        view.addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDataSource

extension GroupSelectionViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let sortedItem = sortedItems[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = sortedItem.title
        config.textProperties.color = sortedItem.originalIndex == selectedOriginalIndex ? .systemBlue : .label

        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension GroupSelectionViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sortedItem = sortedItems[indexPath.row]
        delegate?.groupSelectionViewController(self, didSelectItem: sortedItem)
    }
}
