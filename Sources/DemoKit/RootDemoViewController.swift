import Foundation
import UIKit

public class RootDemoViewController: UIViewController {

    // MARK: - Private properties

    private let demoGroups: [any DemoGroup.Type]
    private let reuseIdentifier = "tableCell"

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
        super.init(nibName: nil, bundle: nil)
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
        view.addSubview(tableView)
        tableView.fillInSuperview()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension RootDemoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        demoGroups.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let demoGroup = demoGroups[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = String(describing: demoGroup.self)
        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension RootDemoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let demoGroup = demoGroups[indexPath.row]
        let demoGroupViewController = DemoGroupViewController(demoGroup: demoGroup)

        navigationController?.pushViewController(demoGroupViewController, animated: true)
    }
}
