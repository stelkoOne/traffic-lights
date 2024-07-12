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
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor .constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor     .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor  .constraint(equalTo: view.bottomAnchor)
        ])
        let bufferView = UIView()
        bufferView.backgroundColor = .clear
        containerView.addArrangedSubview(carModelLabel)
        containerView.addArrangedSubview(trafficLightView)
        containerView.addArrangedSubview(bufferView)
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor .constraint(equalTo: scrollView.leadingAnchor,  constant:  TLConstants.defaultSideMargin),
            containerView.topAnchor     .constraint(equalTo: scrollView.topAnchor,      constant:  TLConstants.defaultSideMargin),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -TLConstants.defaultSideMargin),
            containerView.bottomAnchor  .constraint(equalTo: scrollView.bottomAnchor,   constant: -TLConstants.defaultSideMargin),
            containerView.centerXAnchor .constraint(equalTo: scrollView.centerXAnchor)
        ])
    }

    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
}
