//
//  UIColor+Extension.swift
//  SuperSales
//
//  Created by Apple on 06/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import UIKit


extension UIColor{
   
    
    public static let Appthemecolor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
    public static let Appsplashthemecolor =  UIColor.init(red: 24/255.0, green: 109/255.0, blue: 167/255.0, alpha: 1.0)
    public static let Appthemegreencolor = UIColor.init(red: 0/255.0, green: 185/255.0, blue: 80/255.0, alpha: 1.0)
    
    public static let AppthemeAqvacolor = UIColor().colorFromHexCode(rgbValue: 0xE1EFFC)
    
    public static let Appwhitecolor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    public static let Appthemebluecolor = UIColor.init(red: 72/255.0, green: 66/255.0, blue: 184/255.0, alpha: 1.0)
    public static let Appthemevioletcolor = UIColor.init(red: 172/255.0, green: 0/255.0, blue: 177/255.0, alpha: 1.0)
    public static let Appskybluecolor = UIColor.init(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    public static let UnPlannedVisitIndicationcolor =
        UIColor.init(red: 233/255.0, green: 30/255.0, blue: 99/255.0, alpha: 1.0)
    
    public static let CollectionIndicaationcolor = UIColor.init(red: 0/255/0, green: 71/255.0, blue: 99/255.0, alpha: 1)
    //UIColor.init(red: 245/255.0, green: 168/255.0, blue: 49/255.0, alpha: 1.0)
    public static let ActivityVisitIndicationcolor = UIColor.init(red: 85/255.0, green: 38/255.0, blue: 187/255.0, alpha: 1.0)
    public static let BeatPlanVisitIndicationcolor = UIColor.init(red: 56/255.0, green: 182/255.0, blue: 255/255.0, alpha: 1.0)
    public static let  PlannedVisitIndicationcolor  = UIColor.init(red: 0/255.0, green: 140/255.0, blue: 124/255.0, alpha: 1.0)
    public static let lightBackgroundColor = UIColor.init(red: 225/255.0, green: 227/255.0, blue: 230/255.0, alpha: 1.0)
    
    public static let graphGreenColor = Common().UIColorFromRGB(rgbValue: 0x4CAF50)
    
    public static let graphYellowColor = Common().UIColorFromRGB(rgbValue: 0xF9A825)
    
    public static let graphRedColor = Common().UIColorFromRGB(rgbValue: 0xEF5350)
    
    public static let graphBlueColor = Common().UIColorFromRGB(rgbValue: 0x3F51B5)
    
    public static let graphDarkCyanColor = Common().UIColorFromRGB(rgbValue: 0x009688)
    
    public static let graphDarkVioletColor = Common().UIColorFromRGB(rgbValue: 0x6f44ba)
    
    public static let lightBlueColor = Common().UIColorFromRGB(rgbValue: 0x00BCD4)
    
    public static let fontBlueColor = Common().UIColorFromRGB(rgbValue: 0x2B3894)
    
    public static let productBgColor = Common().UIColorFromRGB(rgbValue: 0xDEEFFE)
    
    public static let rawBlueColor = Common().UIColorFromRGB(rgbValue: 0x77E5FC)
    
    public static let attendanceBGColor = Common().UIColorFromRGB(rgbValue: 0xC7E5FC)
    public static let darkblueColor = Common().UIColorFromRGB(rgbValue: 0x114761)
    
    func colorFromHexCode(rgbValue:UInt)->UIColor{
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
   // public static let collectionIndicatorColor = Common().UIColorFromRGB(#9c27b0)
}
