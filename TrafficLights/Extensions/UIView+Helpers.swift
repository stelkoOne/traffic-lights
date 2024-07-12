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
    
    func setBackgroundColor(_ color: UIColor, animated: Bool = false) {
        let animationBlock = {
            self.backgroundColor = color
        }
        guard animated else {
            animationBlock()
            return
        }
        UIView.animate(withDuration: 0.2, animations: animationBlock)
    }
}
