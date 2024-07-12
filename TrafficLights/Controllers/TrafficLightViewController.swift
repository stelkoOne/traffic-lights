//
//  TrafficLightViewController.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 11.07.24.
//

import UIKit

final class TrafficLightViewController: UIViewController {
    // MARK: - Properties
    var carModelText: String? {
        didSet {
            carModelLabel.text = carModelText
        }
    }
    
    // MARK: - Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Driving..."
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trafficLightView.start()
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        let bufferView = UIView()
        bufferView.backgroundColor = .clear
        containerView.addArrangedSubview(carModelLabel)
        containerView.addArrangedSubview(trafficLightView)
        containerView.addArrangedSubview(bufferView)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,  constant:  TLConstants.defaultSideMargin),
            containerView.topAnchor     .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,      constant:  TLConstants.defaultSideMargin),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -TLConstants.defaultSideMargin),
            containerView.bottomAnchor  .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,   constant: -TLConstants.defaultSideMargin)
        ])
    }

    // MARK: - UI Elements
    private lazy var trafficLightView: TrafficLightView = {
        TrafficLightView()
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.spacing      = TLConstants.defaultSideMargin
        stackView.alignment    = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var carModelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font          = .systemFont(ofSize: TLConstants.FontSize.carModel, weight: .semibold)
        label.textColor     = .darkText
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
}
