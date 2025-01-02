//
//  Mapping.swift
//  SuperSales
//
//  Created by Apple on 01/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

class Mapping: NSManagedObject {
    
    class func intAttributeFor(property:String,keyPath:String)->FEMAttribute{
      /*  let atr = FEMAttribute(property: property, keyPath: keyPath, map: { value -> Any? in
           
           if let value = value as? String, let convertedValue = Double(value) {
            return NSNumber(value: convertedValue).intValue
           }
           return nil
       }, reverseMap: { value -> Any? in
           if let value = value as? NSNumber {
               return value.stringValue
           }
           return nil
       })
       return atr*/
        let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Int? in
            
            if(type(of: valueInt) == String.Type.self){
              //  return NSNumber.init(value: Int(valueInt as? String ?? "0") ?? 0) as? Int
                print("key  = \(property),\( Float(valueInt as? String ?? "") ?? 100)")
                return NSNumber.init(value: Float(valueInt as? String ?? "") ?? 100).intValue as? Int
            }else if(type(of: valueInt) == NSString.self){
                print("key  = \(property),\(NSNumber.init(value: Float(valueInt as? String ?? "") ?? 100))")
                return NSNumber.init(value: Float(valueInt as? String ?? "") ?? 100).intValue as? Int
            }
            return valueInt as? Int
        }, reverseMap: { (valueInt) -> Any? in
           print("key  = \(property),\(String(format: "%d", arguments: [Int(valueInt as? String ?? "") ?? 322]))")
            return String(format: "%d", arguments: [Int(valueInt as? String ?? "") ?? 322])
        })
        return atr
    }
    
    class func timeAttributFor(property:String,keyPath:String) -> FEMAttribute{
        let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Date? in
            if(type(of: valueInt) == String.Type.self){
                let formatter = DateFormatter.init()
                formatter.dateFormat = "HH:mm:ss"
                
                let date = formatter.date(from:valueInt as? String ?? "12:00:00")
                return date
            }
            return Date()
        },reverseMap:{ (valueInt) -> Any? in
            return String.init(format: "\(valueInt)" , arguments:[])
        })
        return atr
    }
//    class func valueFromArray(property:String,keyPath:String)->FEMAttribute{
//    let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Any? in
//    if(type(of: valueInt) == String.Type.self){
//    return NSNumber.init(value: Float(valueInt as? String ?? "") ?? 0.0)
//    
//    return valueInt
//    }, reverseMap: { (valueInt) -> Any? in
//    return String(format: "%d", arguments: [Int(valueInt as? String ?? "") ?? 0])
//    })
//    return atr
//    }
    
    class func doubleAttributeFor(property:String,keyPath:String)->FEMAttribute{
    //For Product Class
   /*  let atr = FEMAttribute(property: property, keyPath: keyPath, map: { value -> Any? in
            
            if let value = value as? String, let convertedValue = Double(value) {
                return NSNumber(value: convertedValue)
            }
            return nil
        }, reverseMap: { value -> Any? in
            if let value = value as? NSNumber {
                return value.stringValue
            }
            return nil
        })
        return atr*/
        
        // For Customer class 
      let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Double? in
     //  print(type(of:valueInt))
            if(type(of: valueInt) == String.Type.self){
             
                return NSNumber.init(value: Double(valueInt as? String ?? "0.00") ?? 0.00000) as? Double
            }
            return valueInt as? Double
        }, reverseMap: { (valueInt) -> Any? in
           
            return String(format: "%.02f", arguments: [Double(valueInt as? String ?? "0.00") ?? 0.00000])
        })
        return atr
    }
    
    class func floatAttributeFor(property:String,keyPath:String)->FEMAttribute{
        let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Any? in
            if(type(of: valueInt) == String.Type.self){
                return NSNumber.init(value: Float(valueInt as? String ?? "") ?? 0.00000)
            }
            return valueInt
        }, reverseMap: { (valueInt) -> Any? in
            return String(format: "%.02f", arguments: [Float(valueInt as? String ?? "") ?? 0.00000])
        })
        return atr
    }
    
    class func boolAttributeFor(property:String,keyPath:String)->FEMAttribute {
        let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Any? in
            if(type(of: valueInt) == String.Type.self){
                return NSNumber.init(value: Bool(valueInt as? String ?? "") ?? false)
            }
            return valueInt
        }, reverseMap: { (valueInt) -> Any? in
            return String(format: "%d", arguments: [Bool(valueInt  as? String ?? "") ?? false])
        })
        return atr
    }
    
    class func dateTimeAttributeFor(property:String,keyPath:String)->FEMAttribute{
        
        let formatter = DateFormatter.init()
       formatter.locale = Locale.init(identifier: "en")
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
    // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let atr = FEMAttribute.init(property: property , keyPath: keyPath, map: { (valueInt) -> Any? in
            if(type(of: valueInt) == String.Type.self){
                formatter.date(from: valueInt as? String ?? "")
            }
            return formatter.date(from: valueInt as? String ?? "")
        }, reverseMap:  { (valueInt) -> Any? in
            return formatter.string(from: valueInt)
            } as? FEMMapBlock)
//        FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"updateDate" keyPath:@"timestamp" map:^id(id value) {
//        if ([value isKindOfClass:[NSString class]]) {
//        return [formatter dateFromString:value];
//        }
//        return nil;
//        } reverseMap:^id(id value) {
//        return [formatter stringFromDate:value];
//        }];
//        let atr = FEMAttribute.init(property: property, keyPath: keyPath, map: { (valueInt) -> Any? in
//            if(type(of: valueInt) == String.Type.self){
//                return Date().getDateFromJSONString(str:valueInt as? String ?? "")//NSNumber.init(value: Bool(valueInt as? String ?? "") ?? false)
//            }
//            return valueInt
//        }, reverseMap: { (valueInt) -> Any? in
//            return String(format: "%@", arguments: [valueInt  as? String ?? ""])
//        })
        return atr
    }
}
