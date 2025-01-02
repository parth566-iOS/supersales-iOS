//
//  UIFont+Extension.swift
//  SuperSales
//
//  Created by Apple on 10/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation

struct AppFontName {
    static let regular = "Roboto-Regular"
    static let light = "Roboto-Light"
    static let bold = "Roboto-Bold"
    static let italic = "Roboto-Light"
    static let medium = "Roboto-Medium"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.medium, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        
        guard let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor else {
            self.init(myCoder: aDecoder)
            return
        }
        guard
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontMediumUsage":
            fontName = AppFontName.medium
        case "CTFontLightUsage":
            fontName = AppFontName.light
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
