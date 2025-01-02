//
//  UIView+extension.swift
//  SuperSales
//
//  Created by Apple on 26/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set(newValue) {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            if (self.layer.borderColor != nil) {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            else  {
                return nil
            }
        }
        set(newValue) {
            if newValue != nil {
                self.layer.borderColor = newValue?.cgColor
            }
            else {
                self.layer.borderColor = nil
            }
        }
    }
    
    // Draw shadow
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
}
