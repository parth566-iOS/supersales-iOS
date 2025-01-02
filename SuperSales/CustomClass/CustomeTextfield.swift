//
//  CustomeTextfield.swift
//  SuperSales
//
//  Created by Apple on 16/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
@IBDesignable
 class CustomeTextfield: UITextField {
     
    @IBInspectable var inset: CGFloat = 0
    @IBInspectable var textCustompadding:UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0){
    didSet {
       // self.textRect(forBounds: UIEdgeInsets.init(top: padding.top, left: padding.left , bottom: padding.bottom , right: padding.right))
       
    }
    }
//    @IBInspectable var textpadding:UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0){
//        didSet {
//        setTextField()
//        }
//        
//       
//    }
    
   /* @IBInspectable var topInset: CGFloat = 0 {
           didSet {
            self.textRect(forBounds: UIEdgeInsetsMake(topInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right))
             //  self.contentInset = UIEdgeInsetsMake(topInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)
           }
       }

       @IBInspectable var bottmInset: CGFloat = 0 {
           didSet {
            self.inset = UIEdgeInsetsMake(topInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)
              // self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, bottmInset, self.contentInset.right)
           }
       }

       @IBInspectable var leftInset: CGFloat = 0 {
           didSet {
            self.inset = UIEdgeInsetsMake(topInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)
            //   self.contentInset = UIEdgeInsetsMake(self.contentInset.top, leftInset, self.contentInset.bottom, self.contentInset.right)
           }
       }

       @IBInspectable var rightInset: CGFloat = 0 {
           didSet {
            self.inset = UIEdgeInsetsMake(topInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)
            //   self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom, rightInset)
           }
       }*/
    
  
    override  func leftViewRect(forBounds bounds:CGRect)->CGRect{
        var ract = super.leftViewRect(forBounds: bounds)
         let padding:CGFloat = 5
         ract.origin.x += padding
         return ract
      }
   
    override func textRect(forBounds bounds: CGRect) -> CGRect {
             var ract = super.textRect(forBounds: bounds)
             let padding:CGFloat = 5
             if leftView != nil{
                 ract.origin.x += padding
             }else{
                ract.origin.x = textCustompadding.left
             }
             
             ract.size.width   -=  2 * padding
             if rightView != nil{
                 ract.size.width -= 5
             }
             return ract
                   }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
                      // return bounds.inset(by: UIEdgeInsets(top: 0, left:  10 , bottom: 0, right: 5))
                     var ract = super.placeholderRect(forBounds: bounds)
                     let padding:CGFloat = 5
                     if leftView != nil{
                         ract.origin.x += padding
                     }else{
                        ract.origin.x = textCustompadding.left
                     }
                     
                     ract.size.width -=  2 * padding
                     if rightView != nil{
                         ract.size.width -= 5
                     }
                     return ract
                     
                   }
             
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
                   
                      // return bounds.inset(by: UIEdgeInsets(top: 0, left:  10 , bottom: 0, right: 5))
             var ract = super.editingRect(forBounds: bounds)
             let padding:CGFloat = 5
             if leftView != nil{
                 ract.origin.x += padding
             }else{
                 ract.origin.x = textCustompadding.left
             }
             
             ract.size.width -=  2 * padding
             if rightView != nil{
                 ract.size.width -= 5
             }
             return ract
                   } 
    
    class func setBottomBorder(tf:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0.0, y: tf.frame.height + 2, width: tf.frame.width - 2, height: 1.0)
       
        //CGRectMake(0.0, tf.frame.height - 1, tf.frame.width, 1.0)
        tf.layoutIfNeeded()
        bottomLine.backgroundColor = UIColor.black.cgColor
     //   tf.borderStyle = UITextField.BorderStyle.none
        tf.layer.addSublayer(bottomLine)
//        tf.layoutIfNeeded()
//        tf.layoutSubviews()
    }
    
//     func setImg(direction:Alignment,img:UIImage,tf:UITextField){
//        if(direction == Alignment.left){
//            tf.leftView = UIImageView.init(image: img)
//            tf.leftViewMode = .always
//
//        }else if(direction == Alignment.right){
//            tf.rightView = UIImageView.init(image: img)
//            tf.rightViewMode = .always
//
//        }
//    }
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }

//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = super.textRect(forBounds: bounds)
//        return rect.inset(by: padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//        }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = super.editingRect(forBounds: bounds)
//        return rect.inset(by: padding)
//    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
