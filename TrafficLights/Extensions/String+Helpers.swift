//
//  String+Helpers.swift
//  TrafficLights
//
//  Created by Stiliyan Yankov on 11.07.24.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}
