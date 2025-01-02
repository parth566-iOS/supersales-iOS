//
//  UITextfield+Extension.swift
//  SuperSales
//
//  Created by Apple on 03/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /*func leftViewRect(forbounds bounds:CGRect)->CGRect{
     var ract = self.leftViewRect(forbounds: bounds)//self.leftViewRect(leftViewRect(forbounds: bounds))
     let padding:CGFloat = 5
     ract.origin.x += padding
     return ract
     }
     
     func textRect(forBounds bounds: CGRect) -> CGRect {
     var ract = self.textRect(forBounds: bounds)
     let padding:CGFloat = 5
     if leftView != nil{
     ract.origin.x += padding
     }else{
     ract.origin.x = padding
     }
     
     ract.size.width   -=  2*padding
     if rightView != nil{
     ract.size.width -= 5
     }
     return ract
     }
     
     func placeholderRect(forBounds bounds: CGRect) -> CGRect {
     // return bounds.inset(by: UIEdgeInset@objc s(top: 0, l@@objc objc eft:  10 , bottom: 0, right: 5))
     var ract = self.placeholderRect(forBounds: bounds)
     let padding:CGFloat = 5
     if leftView != nil{
     ract.origin.x += padding
     }else{
     ract.origin.x = padding
     }
     
     ract.size.width -=  2 * padding
     if rightView != nil{
     ract.size.width -= 5
     }
     return ract
     
     }
     
     func editingRect(forBounds bounds: CGRect) -> CGRect {
     
     // return bounds.inset(by: UIEdgeInsets(top: 0, left:  10 , bottom: 0, right: 5))
     var ract = self.editingRect(forBounds: bounds)
     let padding:CGFloat = 5
     if leftView != nil{
     ract.origin.x += padding
     }else{
     ract.origin.x = padding
     }
     
     ract.size.width -=  2 * padding
     if rightView != nil{
     ract.size.width -= 5
     }
     return ract
     }
     */
    
    func setrightImage(img:UIImage){
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(rightbtnTapped))
        let imgview = UIImageView.init(image: img)
        imgview.addGestureRecognizer(gesture)
        imgview.isUserInteractionEnabled = true
        imgview.frame = CGRect.init(x: self.frame.size.width - self.frame.height, y: self.frame.origin.y, width: 25, height: 25)
        self.rightView =  imgview
        self.rightViewMode = .always
    }
    
    func setrightBtn(btn:UIButton){
        // btn.setImage(UIImage.init(named: ""), for: .normal)
        btn.addTarget(self, action: #selector(rightbtnTapped), for: UIControl.Event.touchUpInside)
        self.rightView =  btn
        self.rightViewMode = UITextField.ViewMode.always
        self.rightViewMode = .always
        
        
    }
    
    @objc func rightbtnTapped(){
        self.delegate?.textFieldShouldBeginEditing?(self)
    }
    
    
    func setleftImage(img:UIImage){
        
        let imgview = UIImageView.init(image: img)
        // imgview.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.leftView =  imgview
        self.leftViewMode = UITextField.ViewMode.always
        
        
    }
    func setCommonFeatureForTf(){
        
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.leftViewMode = .always
        
    }
    func setBottomBorder(tf:UITextField,color:UIColor) {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect.init(x: 0.0, y: self.frame.height + 2, width: self.frame.width - 2, height: 1.0)
        
        
        self.layoutIfNeeded()
        bottomLine.backgroundColor = color.cgColor
        
        self.layer.addSublayer(bottomLine)
        
    }
    
    func isEmptyField()->Bool{
        if(self.text?.count == 0 || self.text?.trimString.count == 0){
            return true
        }else{
            return false
        }
    }
    
    func emailValidation(email:String)->Bool{
        if(email.count == 0){
            return false
        }else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return  emailPred.evaluate(with: email)
            
        }
    }
    
    
    /*
     - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
     -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
     if([text isEqualToString:@". "])
     return NO;
     }
     
     **/
}
//extension UIButton{
//func setrightImage(img:UIImage){
//    let imgview = UIImageView.init(image: img)
//    self.rightView =  imgview
//    self.rightViewMode = UITextField.ViewMode.always
//    self.rightViewMode = .always
//}
//
//func setleftImage(img:UIImage){
//    let imgview = UIImageView.init(image: img)
//    imgview.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//    self.leftView =  imgview
//    self.leftViewMode = UITextField.ViewMode.always
//    self.leftViewMode = .always
//    self.addSubview(imgview)
//}
//    
//}
extension UIDatePicker{
    func setCommonFeature(){
        
        
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        }
        self.backgroundColor = UIColor.white
    }
}
extension UITableView{
    func setCommonFeature(){
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.estimatedRowHeight = 300.0
        self.rowHeight = UITableView.automaticDimension
    }
}
extension UIImageView{
    func makeImgRound(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        
    }
}
