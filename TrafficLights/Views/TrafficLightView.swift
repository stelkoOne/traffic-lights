//
//  TrafficLightView.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 12.07.24.
//

import UIKit

final class TrafficLightView: UIView {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layer.cornerRadius = TLConstants.defaultSideMargin
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func start() {
        startRedSignal()
    }

    // MARK: - Private Methods
    private func setupLayout() {
        containerView.addArrangedSubview(redLightView)
        containerView.addArrangedSubview(orangeLightView)
        containerView.addArrangedSubview(greenLightView)
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor .constraint(equalTo: leadingAnchor,  constant:  TLConstants.defaultSideMargin),
            containerView.topAnchor     .constraint(equalTo: topAnchor,      constant:  TLConstants.defaultSideMargin * 2),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TLConstants.defaultSideMargin),
            containerView.bottomAnchor  .constraint(equalTo: bottomAnchor,   constant: -TLConstants.defaultSideMargin * 2)
        ])
    }
    
    private func startRedSignal() {
        redLightView.turnOn()
        DispatchQueue.main.asyncAfter(deadline: redLightView.type.delay) { [weak self] in
            self?.redLightView.turnOff()
            self?.startOrangeSignal(next: .green)
        }
        
    }
    
    private func startOrangeSignal(next: TrafficLightType) {
        orangeLightView.turnOn()
        DispatchQueue.main.asyncAfter(deadline: orangeLightView.type.delay) { [weak self] in
            self?.orangeLightView.turnOff()
            switch next {
            case .green:
                self?.startGreenSignal()
            case .red:
                self?.startRedSignal()
            default:
                break
            }
        }
    }
    
    private func startGreenSignal() {
        greenLightView.turnOn()
        DispatchQueue.main.asyncAfter(deadline: greenLightView.type.delay) { [weak self] in
            self?.greenLightView.turnOff()
            self?.startOrangeSignal(next: .red)
        }
    }

    // MARK: - UI Elements
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .center
        stackView.spacing      = TLConstants.defaultSideMargin
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var redLightView: SingleLightView = {
        SingleLightView(ofType: .red)
    }()
    
    private lazy var orangeLightView: SingleLightView = {
        SingleLightView(ofType: .orange)
    }()

    private lazy var greenLightView: SingleLightView = {
        SingleLightView(ofType: .green)
    }()
}
