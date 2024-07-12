//
//  Enums.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 12.07.24.
//

import UIKit

enum TrafficLightType {
    case red
    case orange
    case green
    
    var color: UIColor {
        switch self {
        case .red:
            .systemRed
        case .orange:
            .systemOrange
        case .green:
            .systemGreen
        }
    }
    
    var delay: DispatchTime {
        switch self {
        case .red:
            .now() + 4.0
        case .orange:
            .now() + 1.0
        case .green:
            .now() + 4.0
        }
    }
}
