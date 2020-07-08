//
//  Gradient.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 12/14/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import Foundation

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.2]
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
}
