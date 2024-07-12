//
//  InputView.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 11.07.24.
//

import UIKit

final class InputView: UIStackView {
    // MARK: - Constants
    private enum Constants {
        static let textViewCornerRadius: CGFloat = 4.0
        static let shakeAnimationDuration: CGFloat = 0.55
        static let showHideAnimationDuration: CGFloat = 0.1
        static let errorSpacing: CGFloat = 4.0
    }

    // MARK: - Actions
    @objc func hideKeyboard() {
        textField.endEditing(true)
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupLayout()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
        setupLayout()
    }

    // MARK: - Public Methods
    func configure(withPlaceholder placeholder: String?, errorText: String) {
        textField.placeholder = placeholder
        errorLabel.text = errorText
    }

    func validate(for regex: String, completion: (Bool) -> Void) {
        let isValid = textField.text?.matches(regex) ?? false
        isValid ? hideError()
                : showError()
        completion(isValid)
    }
    
    var text: String? {
        textField.text
    }

    // MARK: - Private Methods
    private func hideError() {
        let animationBlock = { [unowned self] in
            errorLabel.setHidden()
            layoutIfNeeded()
        }
        UIView.animate(withDuration: Constants.showHideAnimationDuration, animations: animationBlock)
        textField.layer.borderColor = UIColor.gray.cgColor
    }

    private func showError() {
        let animationBlock = { [unowned self] in
            errorLabel.setShown()
            layoutIfNeeded()
        }
        UIView.animate(withDuration: Constants.showHideAnimationDuration, animations: animationBlock)
        textField.layer.borderColor = UIColor.systemRed.cgColor
        shake()
        hideKeyboard()
    }
    
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = Constants.shakeAnimationDuration
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }

    private func setupAppearance() {
        spacing      = Constants.errorSpacing
        axis         = .vertical
        distribution = .fill
        alignment    = .fill
        let leadingInsetView = UIView()
        leadingInsetView.frame.size.width = TLConstants.defaultSideMargin / 2
        textField.leftView = leadingInsetView
    }
    
    private func setupLayout() {
        addArrangedSubview(textField)
        addArrangedSubview(errorLabel)
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: TLConstants.appleTouchSize.height)
        ])
    }

    // MARK: - UI Elements
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font          = .systemFont(ofSize: TLConstants.FontSize.error)
        label.textColor     = .systemRed
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isHidden      = true
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font                   = .systemFont(ofSize: TLConstants.FontSize.text, weight: .semibold)
        textField.textColor              = .black
        textField.textAlignment          = .left
        textField.layer.borderColor      = UIColor.gray.cgColor
        textField.layer.borderWidth      = 1.0 / UIScreen.main.scale
        textField.layer.cornerRadius     = Constants.textViewCornerRadius
        textField.returnKeyType          = .done
        textField.autocorrectionType     = .no
        textField.spellCheckingType      = .no
        textField.autocapitalizationType = .none
        textField.delegate               = self
        textField.leftViewMode           = .always
        return textField
    }()

    private lazy var keyboardToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame.size.height = 12 // UIKit bug that raises warnings for broken constraints.
                                       // You need to set the height above 10.0 before calling sizeToFit()
        let barButtonItem = UIBarButtonItem(title: "Done",
                                            style: .done,
                                            target: self,
                                            action: #selector(hideKeyboard))
        toolBar.items = [.flexibleSpace(), barButtonItem]
        toolBar.sizeToFit()
        return toolBar
    }()
}

extension InputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideError()
    }
}
