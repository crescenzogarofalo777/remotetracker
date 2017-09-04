//
//  Extensions.swift
//  RemoteTracker
//
//  Created by crescenzo garofalo on 04/09/2017.
//  Copyright © 2017 crescenzo garofalo. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 0.3
        
        pulse.fromValue = 0.95
        pulse.toValue = 1
        
        pulse.autoreverses = true
        
        pulse.repeatCount = 1
        
        pulse.initialVelocity = 0.5
        
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
        
        
    }
}
