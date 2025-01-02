//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 31/12/2019

import Foundation
import CoreData
import FastEasyMapping

@objc(MenuTabs)
class MenuTabs : NSManagedObject{
    
    static let entity:String! = "CompanyMenus"
    @NSManaged var iD : Int32
    @NSManaged var companyID : Int32
    @NSManaged var isVisible : Bool
    @NSManaged var menuID : Int32
    @NSManaged var menuLocalText : String!
    @NSManaged var menuValue : String!
    
    //defaultMapping
  //  let femmapping = FEMMapping()
    class func entityName()->String{
        return "MenuTabs"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "MenuTabs")

        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "menuID", keyPath: "menuID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "companyID"))
         mapping.addAttribute(Mapping.boolAttributeFor(property: "isVisible", keyPath: "isVisible"))
        mapping.addAttributes(from: ["menuValue":"menuValue","menuLocalText":"menuLocalText"])
        mapping.primaryKey = "iD"
        return mapping
    }
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    class func getTabMenus(menu:[NSNumber],sort:Bool)->[MenuTabs]{
        
        let predicate = NSPredicate.init(format: "menuID IN %@ AND isVisible = 1", menu)
        
        print("menu  =  \(menu)")
        let requireMenu = MenuTabs.mr_findAllSorted(by: "menuID", ascending: true, with: predicate) as? [MenuTabs] ?? [MenuTabs]()
        print(requireMenu)
        return requireMenu
    }
   /* class func getTabMenus(menu:[Int32],sort:Bool)->[MenuTabs]{
        for i in self.getAll(){
            print("menu id \(i.menuID)")
            print("Title \(i.menuLocalText)")
        }
        let predicate = NSPredicate.init(format: "menuID IN %@ AND isVisible = 1", menu)
        return MenuTabs.mr_findAllSorted(by: "menuID", ascending: true, with: predicate) as? [MenuTabs] ?? [MenuTabs()]

    }*/
    class func getAll()->[MenuTabs]{
        //, in: AppDelegate().managedcontextobjectappdelegate
        return MenuTabs.mr_findAllSorted(by: "iD", ascending: true) as? [MenuTabs] ?? [MenuTabs]()
    }
}

