//
//  PaddingLabel.swift
//  SuperSales
//
//  Created by mac on 31/10/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation
//@IBDesignable class PaddingLabel: UILabel {
//
//    @IBInspectable var topInset: CGFloat = 5.0
//    @IBInspectable var bottomInset: CGFloat = 5.0
//    @IBInspectable var leftInset: CGFloat = 16.0
//    @IBInspectable var rightInset: CGFloat = 16.0
//
//    override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: rect.inset(by: insets))
//    }
//
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        return CGSize(width: size.width + leftInset + rightInset,
//                      height: size.height + topInset + bottomInset)
//    }
//}
//

//class PaddingLabel: UILabel {
//    
//    var topInset: CGFloat
//    var bottomInset: CGFloat
//    var leftInset: CGFloat
//    var rightInset: CGFloat
//    
//    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
//        self.topInset = top
//        self.bottomInset = bottom
//        self.leftInset = left
//        self.rightInset = right
//        super.init(frame: CGRect.zero)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: rect.inset(by: insets))
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        get {
//            var contentSize = super.intrinsicContentSize
//            contentSize.height += topInset + bottomInset
//            contentSize.width += leftInset + rightInset
//            return contentSize
//        }
//    }
//    
//}
