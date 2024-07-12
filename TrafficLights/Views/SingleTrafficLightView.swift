//
//  SingleTrafficLightView.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 12.07.24.
//

import UIKit

final class SingleLightView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let height: CGFloat = 50.0
    }

    // MARK: - Properties
    private let type: TrafficLightType

    // MARK: - Initializers
    init(ofType type: TrafficLightType) {
        self.type = type
        super.init(frame: .zero)
        backgroundColor = .lightGray
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func turnOn() {
        setBackgroundColor(type.color, animated: true)
    }
    
    func turnOff() {
        setBackgroundColor(.lightGray, animated: true)
    }
    
    var delay: DispatchTime {
        type.delay
    }

    // MARK: - Private Methods
    private func setupLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Constants.height),
            widthAnchor.constraint(equalTo: heightAnchor)
        ])
        layer.cornerRadius = Constants.height / 2
    }
}

