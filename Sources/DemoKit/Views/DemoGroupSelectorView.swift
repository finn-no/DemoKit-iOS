import Foundation
import UIKit

protocol DemoGroupSelectorViewDelegate: AnyObject {
    func demoGroupSelectorViewWasSelected(_ view: DemoGroupSelectorView)
}

class DemoGroupSelectorView: UIView {

    // MARK: - Internal properties

    weak var delegate: DemoGroupSelectorViewDelegate?

    var title: String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    var shouldShowChevron: Bool = true {
        didSet {
            updateButtonImage()
        }
    }

    // MARK: - Private properties

    private lazy var button: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 2
        buttonConfiguration.titlePadding = 2
        buttonConfiguration.imagePlacement = .trailing

        let button = UIButton(configuration: buttonConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.adjustsFontForContentSizeCategory = true

        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        updateButtonImage()

        addSubview(button)
        button.fillInSuperview()
    }

    // MARK: - Private methods

    private func updateButtonImage() {
        if shouldShowChevron {
            let image = UIImage(systemName: "chevron.down")
            button.setImage(image, for: .normal)
        } else {
            button.setImage(nil, for: .normal)
        }
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.demoGroupSelectorViewWasSelected(self)
    }
}
