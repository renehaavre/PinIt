//
//  MenuButton.swift
//  PinIt
//
//  Created by Rene Haavre on 27/10/2018.
//  Copyright © 2018 Rene Haavre. All rights reserved.
//

import UIKit

@IBDesignable class MenuButton: UIButton {

    override func awakeFromNib() {
//        layer.cornerRadius = 8
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
