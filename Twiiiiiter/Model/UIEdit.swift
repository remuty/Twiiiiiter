//
//  UIEdit.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/04.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}

@IBDesignable class RoundedTextField: UITextField {

    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}
