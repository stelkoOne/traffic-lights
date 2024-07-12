//
//  StartViewController.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 9.07.24.
//

import UIKit


final class StartViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let carModelRegex = #"^.{3,}$"#
        static let stackViewSpacing: CGFloat = 12.0
    }

    // MARK: - Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = .systemGray6
        navigationItem.title = "Garage"
        setupLayout()
    }
    
    // MARK: - Deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    @objc private func startDrivingAction() {
        carModelInputView.validate(for: Constants.carModelRegex) { [weak self] isValid in
            if isValid {
                let controller = TrafficLightViewController()
                controller.carModelText = self?.carModelInputView.text
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let buttonGlobalFrame = containerView.convert(startDrivingButton.frame, to: nil)
        let buttonBottomSpace = keyboardFrame.origin.y - buttonGlobalFrame.maxY
        
        if buttonBottomSpace < TLConstants.defaultSideMargin {
            containerCenterYConstraint.constant = buttonBottomSpace - TLConstants.defaultSideMargin
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat ?? 0.0
            UIView.animate(withDuration: animationDuration, animations: view.layoutIfNeeded)
        }
        scrollView.contentInset.bottom = keyboardFrame.height + TLConstants.defaultSideMargin - view.safeAreaInsets.bottom
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        containerCenterYConstraint.constant = .zero
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat ?? 0.0
        UIView.animate(withDuration: animationDuration, animations: view.layoutIfNeeded)
        scrollView.contentInset.bottom = .zero
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor .constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor     .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor  .constraint(equalTo: view.bottomAnchor)
        ])
        containerView.addArrangedSubview(carModelInputView)
        containerView.addArrangedSubview(startDrivingButton)
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor .constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,  constant:  TLConstants.defaultSideMargin * 2),
            containerView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -TLConstants.defaultSideMargin * 2),
            containerView.bottomAnchor  .constraint(equalTo: scrollView.bottomAnchor),
            containerView.centerXAnchor .constraint(equalTo: scrollView.safeAreaLayoutGuide.centerXAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor, constant: TLConstants.defaultSideMargin),
            containerCenterYConstraint
        ])
        NSLayoutConstraint.activate([
            startDrivingButton.heightAnchor.constraint(equalToConstant: TLConstants.appleTouchSize.height)
        ])
    }

    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing      = Constants.stackViewSpacing
        stackView.axis         = .vertical
        stackView.distribution = .fill
        stackView.alignment    = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var carModelInputView: InputView = {
        let inputView = InputView()
        inputView.configure(withPlaceholder: "Please enter your car model",
                            errorText: "Car model must contains 3 or more characters")
        return inputView
    }()
    
    private lazy var startDrivingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Driving", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = TLConstants.appleTouchSize.height / 2
        button.addTarget(self, action: #selector(startDrivingAction), for: .touchUpInside)
        return button
    }()

    private lazy var containerCenterYConstraint: NSLayoutConstraint = {
        let constraint = containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        constraint.priority = .defaultHigh - 1
        return constraint
    }()
}
