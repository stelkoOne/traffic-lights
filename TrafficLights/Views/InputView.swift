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
    // MARK: - Properties
    private var placeholderText: String?

    // MARK: - Actions
    @objc private func hideKeyboard() {
        textView.endEditing(true)
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
        placeholderText = placeholder
        errorLabel.text = errorText
        setPlaceholderIfPresent()
    }

    func validate(for regex: String, completion: (Bool) -> Void) {
        var isValid = textView.text != placeholderText
        isValid = isValid && textView.text?.matches(regex) ?? false
        isValid ? hideError()
                : showError()
        completion(isValid)
    }
    
    var text: String? {
        textView.text
    }

    // MARK: - Private Methods
    private func hideError() {
        let animationBlock = { [unowned self] in
            errorLabel.setHidden()
            layoutIfNeeded()
        }
        UIView.animate(withDuration: Constants.showHideAnimationDuration, animations: animationBlock)
        textView.layer.borderColor = UIColor.gray.cgColor
    }

    private func showError() {
        let animationBlock = { [unowned self] in
            errorLabel.setShown()
            layoutIfNeeded()
        }
        UIView.animate(withDuration: Constants.showHideAnimationDuration, animations: animationBlock)
        textView.layer.borderColor = UIColor.systemRed.cgColor
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
    }
    
    private func setupLayout() {
        addArrangedSubview(textView)
        addArrangedSubview(errorLabel)
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalToConstant: TLConstants.appleTouchSize.height)
        ])
    }
    
    private func setPlaceholderIfPresent() {
        guard let placeholder = placeholderText, placeholder.isNotEmpty else {
            return
        }
        textView.text = placeholder
        textView.textColor = .placeholderText
        DispatchQueue.main.async { [unowned self] in
            textView.font = .systemFont(ofSize: TLConstants.FontSize.placeholder, weight: .regular)
            textView.layoutIfNeeded()
        }
    }

    // MARK: - UI Elements
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: TLConstants.FontSize.error)
        label.textColor = .systemRed
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var textView: TextView = {
        let textView = TextView()
        textView.font = .systemFont(ofSize: TLConstants.FontSize.text, weight: .semibold)
        textView.textColor = .black
        textView.textAlignment = .left
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0 / UIScreen.main.scale
        textView.layer.cornerRadius = Constants.textViewCornerRadius
        textView.inputAccessoryView = keyboardToolBar
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        textView.showsHorizontalScrollIndicator = false
        textView.delegate = self
        return textView
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

extension InputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
            textView.font = .systemFont(ofSize: TLConstants.FontSize.text, weight: .semibold)
        }
        hideError()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setPlaceholderIfPresent()
        }
    }
}
