import Foundation
import UIKit

/// Presented when the user wants to select another `TweakingOption` a `TweakableDemo`. Will list all available tweaks.
class TweakTableViewController: UIViewController {

    // MARK: - Private properties

    private let tweakableDemo: any TweakableDemo
    private let reuseIdentifier = "tableCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    // MARK: - Init

    init(tweakableDemo: any TweakableDemo) {
        self.tweakableDemo = tweakableDemo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

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

extension TweakTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweakableDemo.numberOfTweaks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let tweakCase = tweakableDemo.tweak(for: indexPath.row)

        var config = cell.defaultContentConfiguration()
        config.text = tweakCase.title
        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension TweakTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        State.selectedTweakIndex = indexPath.row

        tweakableDemo.configure(forTweakAt: indexPath.row)
        dismiss(animated: true)
    }
}
