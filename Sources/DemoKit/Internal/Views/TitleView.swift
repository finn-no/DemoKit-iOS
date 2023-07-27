import Foundation
import UIKit

protocol TitleViewDelegate: AnyObject {
    func titleViewWasSelected(_ view: TitleView)
}

class TitleView: UIView {

    // MARK: - Internal properties

    weak var delegate: TitleViewDelegate?

    var title: String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    var isClickable: Bool = true {
        didSet {
            updateButtonState()
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
        button.setTitleColor(.label, for: .disabled)

        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    init(delegate: TitleViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        updateButtonState()

        addSubview(button)
        button.fillInSuperview()
    }

    // MARK: - Private methods

    private func updateButtonState() {
        button.isEnabled = isClickable

        if isClickable {
            button.configuration?.image = UIImage(systemName: "chevron.down")
        } else {
            button.configuration?.image = nil
        }
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.titleViewWasSelected(self)
    }
}
