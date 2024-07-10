//
//  UIView+Helpers.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 11.07.24.
//

import UIKit

extension UIView {
    func setHidden() {
        // It's an old UIKit bug that can mess up UIStackView animation
        if !isHidden {
            isHidden = true
        }
    }
    
    func setShown() {
        isHidden = false
    }
}
