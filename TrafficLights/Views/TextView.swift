//
//  TextView.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 11.07.24.
//

import UIKit

final class TextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            let topInset = (bounds.height - contentSize.height) / 2.0
            contentInset.top = max(0, topInset)
        }
    }
}
