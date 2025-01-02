//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 31/12/2019

import Foundation
import CoreData
import FastEasyMapping


@objc(CompanyMenus)
class CompanyMenus : NSManagedObject{
    
   static let entity:String! = "CompanyMenus"
    @NSManaged var iD : Int32
    @NSManaged var companyID : Int32
    @NSManaged var isVisible : Bool
    @NSManaged var menuID :Int32
    @NSManaged var menuLocalText : String!
    @NSManaged var menuValue : String!
    
    
    //defaultMapping
  
    class func entityName()->String{
        return "CompanyMenus"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "CompanyMenus")

        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "menuID", keyPath: "menuID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
         mapping.addAttribute(Mapping.boolAttributeFor(property: "isVisible", keyPath: "isVisible"))
        mapping.addAttributes(from: ["menuValue":"menuValue","menuLocalText":"menuLocalText"])
        mapping.primaryKey = "iD"
       
        return mapping
    }
    
    class func getComapnyMenus(menu:[NSNumber],sort:Bool)->[CompanyMenus]{
    
        let predicate = NSPredicate.init(format: "menuID IN %@ AND isVisible = 1", menu)//AND isVisible = 1
        var arrOfMenu = [CompanyMenus]()
       
        arrOfMenu = CompanyMenus.mr_findAllSorted(by: "menuID", ascending: sort, with: predicate, in:NSManagedObjectContext.mr_default())  as? [CompanyMenus] ?? [CompanyMenus]()
        return arrOfMenu
       
    }
    
    class func getComapnyMenusForSalesPlan(menu:[NSNumber],sort:Bool)->[CompanyMenus]{
    
        let predicate = NSPredicate.init(format: "menuID IN %@", menu)//AND isVisible = 1
        var arrOfMenu = [CompanyMenus]()
       
        arrOfMenu = CompanyMenus.mr_findAllSorted(by: "menuID", ascending: sort, with: predicate, in:NSManagedObjectContext.mr_default())  as? [CompanyMenus] ?? [CompanyMenus]()
        return arrOfMenu
       
    }
    
    class func getAll()->[CompanyMenus]{
        //, in: AppDelegate().managedcontextobjectappdelegate
        return CompanyMenus.mr_findAllSorted(by: "iD", ascending: true) as? [CompanyMenus] ?? [CompanyMenus]()
    }
    
    class func getImageFromMenu(menuID:Int)->UIImage{
       
        
        switch menuID {
        case 0:
            //visits
            return UIImage.init(named: "icon_visit")!
            
        case 1:
            return UIImage.init(named: "icon_lead")!
            
        case 2:
            //order
            return UIImage.init(named: "plus_order")!
            
        case 3:
            //tracking
            return UIImage.init(named: "icon_menu_tracking")!
            
        case 4:
            //attendance
            return UIImage.init(named: "plus_attendance")!
        case 5:
            //leave
            return UIImage.init(named: "icon_menu_leaves")!
        case 6:
            //expense
            return UIImage.init(named: "icon_menu_expense_claim")!
            
        case 7:
            //Activity
            return UIImage.init(named: "icon_menu_activity")!
            
        case 8:
            //knowledge center
            return UIImage.init(named: "icon_menu_knowledge")!
            
        case 10:
            //proposal
            return UIImage.init(named: "icon_menu_proposal")!
            
        case 12:
            //locate customer
            return UIImage.init(named: "icon_menu_target")!
            
        case 14:
            //Daily Sales Plan
            return UIImage.init(named: "icon_menu_daily_sales_plan")!
            
        case 15:
            //Daily Sales Report
            return UIImage.init(named: "icon_menu_sales_report")!
            
        case 16:
            //Customer & Vendor
            return UIImage.init(named: "icon_menu_customer")!
            
        case 18:
            //Report
            return UIImage.init(named: "icon_menu_report")!
            
        case 22:
            //Attendance
            return UIImage.init(named: "plus_attendance")!
            
        case 23:
            //visit
            return UIImage.init(named: "icon_visit")!
            
        case 24:
            //lead
            return UIImage.init(named: "icon_lead")!
            
        case 25:
            //order
            return UIImage.init(named: "plus_order")!
            
        case 26:
            //Activity
            return UIImage.init(named: "plus_activity")!
            
        case 27:
            //cold calling
            return UIImage.init(named:"icon_menu_coldcall")!
            
        case 28:
            //Plan a Visit
            return UIImage.init(named: "plus_activity")!
            
        case 29:
            //cold call visit
            return UIImage.init(named:"icon_menu_coldcall")!
            
        case 30:
            //Direct Visit Check-in
            return UIImage.init(named:"icon_menu_beatroute")!
            
        case 31:
            //corporate metting
            return UIImage.init(named:"plus_order")!
            
        case 32:
            //Manual Visit
            return UIImage.init(named:"plus_order")!
            
        case 33:
            //cold call visit
            return UIImage.init(named:"icon_menu_beatroute")!
            
            
        case 169:
            //Home
            return UIImage.init(named:"icon_menu_home")!
        case 504:
            //kpi data
            return UIImage.init(named: "plus_kpidata")!
            
        default:
            return UIImage.init(named: "icon_placeholder")!
        }
        
    }
}

