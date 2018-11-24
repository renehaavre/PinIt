//
//  UIView+Extension.swift
//  PinIt
//
//  Created by Rene Haavre on 26/10/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(firstColor: UIColor, secondColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}
