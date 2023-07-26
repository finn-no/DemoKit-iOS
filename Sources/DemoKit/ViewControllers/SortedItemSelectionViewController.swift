import Foundation
import UIKit

protocol SortedItemSelectionViewControllerDelegate: AnyObject {
    func sortedItemSelectionViewController(_ viewController: SortedItemSelectionViewController, didSelectItemAt index: Int)
}

class SortedItemSelectionViewController: UIViewController {

    // MARK: - Private properties

    private weak var delegate: SortedItemSelectionViewControllerDelegate?
    private let sortedItems: [SortedItem]
    private let selectedIndex: Int?
    private let reuseIdentifier = "tableCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    // MARK: - Init

    init(sortedItems: [SortedItem], selectedIndex: Int?, delegate: SortedItemSelectionViewControllerDelegate) {
        self.sortedItems = sortedItems
        self.selectedIndex = selectedIndex
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

extension SortedItemSelectionViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = sortedItems[indexPath.row].title
        config.textProperties.color = indexPath.row == selectedIndex ? .systemCyan : .label

        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SortedItemSelectionViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.sortedItemSelectionViewController(self, didSelectItemAt: indexPath.row)
    }
}
