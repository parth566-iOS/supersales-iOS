//
//  Placeholdertextview.swift
//  SuperSales
//
//  Created by Apple on 23/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class Placeholdertextview: UITextView {

    
    var placholdertext:String?
    var border: UIView!
       var originalBorderFrame: CGRect!
       var originalInsetBottom: CGFloat!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
     {
       // make it look (initially) like a placeholder
        placholdertext = placeholderText
         aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
      
    }
   
//
//    deinit {
//        removeObserver(self, forKeyPath: "contentOffset")
//    }
//
//    override var frame: CGRect {
//        didSet {
//            border.frame = CGRect.init(x: 0, y: frame.height+contentOffset.y - border.frame.height, width: frame.width, height: border.frame.height)
//                //CGRectMake(0, frame.height+contentOffset.y-border.frame.height, frame.width, border.frame.height)
//            originalBorderFrame  = CGRect.init(x: 0, y: frame.height-border.frame.height, width: frame.width, height: border.frame.height)
//                //CGRectMake(0, frame.height-border.frame.height, frame.width, border.frame.height);
//        }
//    }
//
//    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
//        if keyPath == "contentOffset" {
//            border.frame = originalBorderFrame.offsetBy(dx: 0, dy: contentOffset.y)
//        }
//    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
//        border.backgroundColor = color
//        border.frame = CGRect.init(x: 0, y: frame.height+contentOffset.y-width, width: self.frame.width, height: width)
//        originalBorderFrame = CGRect.init(x: 0, y: frame.height-width, width: frame.width
//            , height: width)
//            //CGRectMake(0, frame.height-width, self.frame.width, width)
 //       textContainerInset.bottom = originalInsetBottom+width
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }


 func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
 {
   if  aTextView.text == placholdertext
   {
     // move cursor to start
     aTextView.text = ""
     moveCursorToStart(textView:aTextView)
    aTextView.textColor = UIColor.black
   }
   return true
 }

 func moveCursorToStart(textView: UITextView)
 {
    DispatchQueue.main.async {
     textView.selectedRange = NSMakeRange(0, 0)
   }
 }
func textViewDidEndEditing(aTextView: UITextView) {
    if (aTextView.text.count  == 0){
        aTextView.textColor = UIColor.lightGray
        aTextView.text = placholdertext
    }
}

}
