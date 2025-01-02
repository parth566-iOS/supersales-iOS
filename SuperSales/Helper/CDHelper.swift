//
//  CDHelper.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class CDHelper: NSObject {
//    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Mapping" ofType:@"plist"]];
//    NSDictionary *keys = [dictRoot objectForKey:NSStringFromClass(cls)];
//    return keys;
    func mappingForClass(classname:AnyClass)->Dictionary<String, String>{
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = ["":"" as AnyObject] //Our data
        let plistPath: String? = Bundle.main.path(forResource: "Mapping", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String:AnyObject] ?? [String:AnyObject]()
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        let keys = plistData[String(describing: classname.self)] as? [String:String] ?? ["":""]
        
        return keys
    }
}
