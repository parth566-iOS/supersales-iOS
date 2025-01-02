//
//  PlannVisit.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping


@objc(PlannVisit)
class PlannVisit: NSManagedObject {
//
    @NSManaged var addressMasterID: Int64
    @NSManaged var approvedBy: Int64
    @NSManaged var approvedTo:Int64
    @NSManaged var assignedBy:Int64
    @NSManaged var assignedTime:String?
    @NSManaged var beatPlanID:Int64
    @NSManaged var companyID:Int64
    @NSManaged var conclusion:String?
    @NSManaged var contactID:Int64
    @NSManaged var contactMobileNo:String?
    @NSManaged var contactName:String?
    @NSManaged var createdBy:Int64
    @NSManaged var createdByName:String?
    @NSManaged var createdTime:String?
    @NSManaged var customerID:Int64
    @NSManaged var customerName:String?
    @NSManaged var filterCategoryID:Int64
    @NSManaged var filterProduct:Int64
    @NSManaged var filterType:Int64
    @NSManaged var filterUser:Int64
    @NSManaged var iD:Int64
    @NSManaged var isActive:Int64
    @NSManaged var isPictureAvailable:Int16
    @NSManaged var lastModifiedBy:Int64
    @NSManaged var lastModifiedTime:String?
    @NSManaged var nextActionID:Int64
    @NSManaged var nextActionTime:String?
    @NSManaged var  originalAssignee:Int64
    @NSManaged var  originalNextActionID:Int64
    @NSManaged var originalNextActionTime:String?
    @NSManaged var  reAssigned:Int64
    @NSManaged var ressigneeName:String?
    @NSManaged var  seriesPostfix:Int64
    @NSManaged var seriesPrefix:String?
    @NSManaged var checkInTime:String?
    @NSManaged var checkOutTime:String?
    @NSManaged var sortType:Int64
    @NSManaged var  tempCustomerID:Int64
    @NSManaged var visitStatusID:Int64
    @NSManaged var  visitTypeID:Int64
    @NSManaged var  isManual:Int16
    @NSManaged var checkInOutData:NSOrderedSet
    @NSManaged var productList:NSOrderedSet
    @NSManaged var visitStatusList:NSOrderedSet
    @NSManaged var visitCollection:VisitCollection?
    @NSManaged var visitCounterShare:VisitCounterShare?
    @NSManaged var isTertiaryAvailable:Int16
    @NSManaged var isFeedBackAvailable:Int16
    @NSManaged var isStockAvailable:Int16
    
    
    
    class func entityName()->String{
        return "PlannVisit"
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "PlannVisit")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "seriesPostfix", keyPath: "SeriesPostfix"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "tempCustomerID", keyPath: "TempCustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "contactID", keyPath: "ContactID"))
       
        mapping.addAttribute(Mapping.intAttributeFor(property: "nextActionID", keyPath: "NextActionID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "originalNextActionID", keyPath: "OriginalNextActionID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitTypeID", keyPath: "VisitTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitStatusID", keyPath: "VisitStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "addressMasterID", keyPath: "AddressMasterID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "originalAssignee", keyPath: "OriginalAssignee"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "reAssigned", keyPath: "ReAssigned"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "assignedBy", keyPath: "AssignedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedBy", keyPath: "ApprovedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedTo", keyPath: "ApprovedTo"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterType", keyPath: "FilterType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "sortType", keyPath: "SortType"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterUser", keyPath: "FilterUser"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterProduct", keyPath: "FilterProduct"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterCategoryID", keyPath: "FilterCategoryID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "beatPlanID", keyPath: "BeatPlanID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isManual", keyPath: "IsManual"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isPictureAvailable", keyPath: "isPictureAvailable"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isStockAvailable", keyPath: "isStockAvailable"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isFeedBackAvailable", keyPath: "isFeedBackAvailable"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isTertiaryAvailable", keyPath: "isTertiaryAvailable"))
        mapping.addToManyRelationshipMapping(ProductsList.defaultmapping(), forProperty: "productList", keyPath: "ProductsList")
        mapping.addToManyRelationshipMapping(VisitStatus.defaultmapping(), forProperty: "visitStatusList", keyPath: "VisitStatusList")
       // @NSManaged var checkInOutData:NSOrderedSet
        mapping.addToManyRelationshipMapping(VisitCheckInOutList.defaultmapping(), forProperty: "checkInOutData", keyPath: "VisitCheckInCheckOutList")
        mapping.addRelationshipMapping(VisitCollection.defaultmapping(), forProperty: "visitCollection", keyPath: "visitCollection")
        mapping.addRelationshipMapping(VisitCounterShare.defaultmapping(), forProperty: "visitCounterShare", keyPath: "visitCounterShare")
        //mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "createdTime", keyPath: "CreatedTime"))
        //
        mapping.addAttributes(from: ["seriesPrefix": "SeriesPrefix",
                                "customerName":"CustomerName","contactName":"ContactName",
                                    "contactMobileNo":"ContactMobileNo",
                                    "originalNextActionTime":"OriginalNextActionTime",
                                    "nextActionTime":"NextActionTime",
                                    "createdTime":"CreatedTime", "conclusion":"Conclusion","assignedTime":"AssignedTime","ressigneeName":"RessigneeName","createdByName":"CreatedByName","lastModifiedTime":"LastModifiedTime","checkInTime":"CheckInTime","checkOutTime":"CheckOutTime"])
        
        
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getVisit(visitID:NSNumber) -> PlannVisit?{
        let arrvisit = PlannVisit.mr_find(byAttribute: "iD", withValue: visitID, andOrderBy: "iD", ascending: false) as? [PlannVisit] ?? [PlannVisit]()
        if(arrvisit.count > 0){
            return arrvisit.first!
        }else{
            return nil
        }
    }
    
    
    class func getPendingCheckOutVisitForSelectedDate(date:Date)->[PlannVisit]{
        let arr =  PlannVisit.getAll()
        var arrOfPendingcheckoutvisit = [PlannVisit]()
        if(arr.count > 0){
        let arrOfVisitWithtodaysCheckin = arr.filter { (visit) -> Bool in
            if(visit.checkInOutData.count > 0){
               
                return true
            }else{
                return false
            }
        }
            for visit in arrOfVisitWithtodaysCheckin{
                if let lastcheckin = visit.checkInOutData.firstObject as? VisitCheckInOutList{
                    if let checkintimestr = lastcheckin.checkInTime  as? String{
                    let checkintime = Utils.getDateBigFormatToDefaultFormat(date: lastcheckin.checkInTime, format: "dd-MM-yyyy")
                    let dateformatter = DateFormatter.init()
                    dateformatter.dateFormat = "dd-MM-yyyy"
                    let dateinstring = dateformatter.string(from: date)
//                    if let checkinarr = visit.checkInOutData as? checkInOutData{
                    if let checkouttime = lastcheckin.checkOutTime as? String{
                        if(checkintime == dateinstring && checkouttime.count == 0){
                           // if(checkinarr.count == 1){
                            arrOfPendingcheckoutvisit.append(visit)
                           // }
                        }
                    }else{
                        if(checkintime == dateinstring){
                           // if(checkinarr.count == 1){
                            arrOfPendingcheckoutvisit.append(visit)
                           // }
                        }
                        
                    
                    }
                    }
                    //}
                    
                }
            }
            return arrOfPendingcheckoutvisit
        }else{
            return arrOfPendingcheckoutvisit
        }
        
       
        
    }
    
    class func getAll()->[PlannVisit]{
        return PlannVisit.mr_findAll() as? [PlannVisit] ?? [PlannVisit]()
    }
    
    class func getAllBy(atrname:String,order:Bool)->[PlannVisit]{
        let predicate = NSPredicate.init(format: "visitTypeID == 1 AND visitStatusID != 2")
        
        return PlannVisit.mr_findAllSorted(by: atrname, ascending: order, with: predicate, in: NSManagedObjectContext.mr_default()) as? [PlannVisit] ?? [PlannVisit]()
        
        // NSPredicate.init(format: ,)
        //return PlannVisit.mr_findAllSorted(by: atrname, ascending: order) as? [PlannVisit] ?? [PlannVisit]()
    }
    class func getFilteredByAttributes(withAttributeName:String,withAttributeValue:String)->[PlannVisit]{
        return PlannVisit.mr_find(byAttribute: withAttributeName, withValue: withAttributeValue) as? [PlannVisit] ?? [PlannVisit]()
    }
    
    class func getFilteredByAttributesComplex2(productIDs: [NSNumber]) -> [PlannVisit] {
        let predicate = NSPredicate(format: "productID IN %@", productIDs)
        let array = (ProductsList.mr_findAll(with: predicate, in: NSManagedObjectContext.mr_default()) as? [ProductsList] ?? [ProductsList]()).map {NSNumber(value: $0.visitID)}

        let predicate1 = NSPredicate(format: "ANY iD IN %@", array)
        return PlannVisit.mr_findAll(with: predicate1, in: NSManagedObjectContext.mr_default()) as? [PlannVisit] ?? [PlannVisit]()
    }
    
    class func getVisitByPredicate(predicate:NSPredicate)->[PlannVisit]{
        return PlannVisit.mr_findAllSorted(by: "iD", ascending: false, with: predicate) as? [PlannVisit] ?? [PlannVisit]()
    }
  
    
}
extension PlannVisit{
    
    @objc (insertObject:inCheckInOutDataAtIndex:)
    @NSManaged public func insertObject(value:VisitCheckInOutList , at idx:Int)
    
    @objc (replaceObjectInCheckInOutDataAtIndex:withObject:)
    @NSManaged public func replaceObjectFrom(value:VisitCheckInOutList , at idx:Int)
   
    
    @objc (removeObjectFromCheckInOutDataAtIndex:)
     @NSManaged public func removeObjectFromCheckInOutData(at idx:Int)
    
    @objc (insertCheckInOutData:atIndexes:)
    @NSManaged public func insertCheckInOutData(value:[VisitCheckInOutList],atIndexes:Int)
    
    
     @objc (insertStatus:inVisitStatusAtIndex:)
    @NSManaged public func insertStatus(value:VisitStatus , at idx:Int)
    
    
  /*  - (void)removeObjectFromCheckInOutDataAtIndex:(NSUInteger)idx;
    - (void)insertCheckInOutData:(NSArray<VisitCheckInOutList *> *)value atIndexes:(NSIndexSet *)indexes;
    - (void)removeCheckInOutDataAtIndexes:(NSIndexSet *)indexes;
    - (void)replaceObjectInCheckInOutDataAtIndex:(NSUInteger)idx withObject:(VisitCheckInOutList *)value;
    - (void)replaceCheckInOutDataAtIndexes:(NSIndexSet *)indexes withCheckInOutData:(NSArray<VisitCheckInOutList *> *)values;
    - (void)addCheckInOutDataObject:(VisitCheckInOutList *)value;
    - (void)removeCheckInOutDataObject:(VisitCheckInOutList *)value;
    - (void)addCheckInOutData:(NSOrderedSet<VisitCheckInOutList *> *)values;
    - (void)removeCheckInOutData:(NSOrderedSet<VisitCheckInOutList *> *)values;
    
    - (void)insertObject:(ProductList *)value inProductListAtIndex:(NSUInteger)idx;
    - (void)removeObjectFromProductListAtIndex:(NSUInteger)idx;
    - (void)insertProductList:(NSArray<ProductList *> *)value atIndexes:(NSIndexSet *)indexes;
    - (void)removeProductListAtIndexes:(NSIndexSet *)indexes;
    - (void)replaceObjectInProductListAtIndex:(NSUInteger)idx withObject:(ProductList *)value;
    - (void)replaceProductListAtIndexes:(NSIndexSet *)indexes withProductList:(NSArray<ProductList *> *)values;
    - (void)addProductListObject:(ProductList *)value;
    - (void)removeProductListObject:(ProductList *)value;
    - (void)addProductList:(NSOrderedSet<ProductList *> *)values;
    - (void)removeProductList:(NSOrderedSet<ProductList *> *)values;
    
    - (void)insertObject:(VisitStatus *)value inVisitStatusListAtIndex:(NSUInteger)idx;
    - (void)removeObjectFromVisitStatusListAtIndex:(NSUInteger)idx;
    - (void)insertVisitStatusList:(NSArray<VisitStatus *> *)value atIndexes:(NSIndexSet *)indexes;
    - (void)removeVisitStatusListAtIndexes:(NSIndexSet *)indexes;
    - (void)replaceObjectInVisitStatusListAtIndex:(NSUInteger)idx withObject:(VisitStatus *)value;
    - (void)replaceVisitStatusListAtIndexes:(NSIndexSet *)indexes withVisitStatusList:(NSArray<VisitStatus *> *)values;
    - (void)addVisitStatusListObject:(VisitStatus *)value;
    - (void)removeVisitStatusListObject:(VisitStatus *)value;
    - (void)addVisitStatusList:(NSOrderedSet<VisitStatus *> *)values;
    - (void)removeVisitStatusList:(NSOrderedSet<VisitStatus *> *)values;*/
}
