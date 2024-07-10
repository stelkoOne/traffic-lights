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
        view.backgroundColor = .systemGray6
        setupLayout()
    }
    
    // MARK: - Actions
    @objc private func startDrivingAction() {
        carModelInputView.validate(for: Constants.carModelRegex) { [weak self] isValid in
            print(isValid ? "VALID" : "INVALID")
        }
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [carModelInputView, startDrivingButton])
        stackView.spacing      = Constants.stackViewSpacing
        stackView.axis         = .vertical
        stackView.distribution = .fill
        stackView.alignment    = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startDrivingButton.heightAnchor.constraint(equalToConstant: TLConstants.appleTouchSize.height)
        ])
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor .constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,  constant:  TLConstants.defaultSideMargin * 2),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -TLConstants.defaultSideMargin * 2)
        ])
    }

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
}
