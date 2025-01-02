//
//  Activity.swift
//  SuperSales
//
//  Created by Apple on 12/05/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(Activity)
class Activity: NSManagedObject {
    @NSManaged var activityId:Int64
   // @NSManaged var activityID:Int64
    @NSManaged var modifiedBy:Int64
    @NSManaged var addressMasterID:Int64
    @NSManaged var checkInOutLongitude:Double
    @NSManaged var remarks:String!
    @NSManaged var noOfParticipants:Int64
    @NSManaged var customerID:Int64
    @NSManaged var activityTypeName:String!
    @NSManaged var picture1:String!
    @NSManaged var picture2:String!
    @NSManaged var picture3:String!
    @NSManaged var picture4:String!
    @NSManaged var picture5:String!
    @NSManaged var checkInTime:String?
    //@NSManaged var checkOutTime:String?
    @NSManaged var customerName:String?
    @NSManaged var customerMobile:String!
    @NSManaged var createdTime:String!
    @NSManaged var createdby:Int64
    @NSManaged var companyID:Int64
    @NSManaged var activityTypeID:Int64
    @NSManaged var checkInCheckOutID:Int64
    @NSManaged var activitydescription:String!
    @NSManaged var nextActionTime:String!
    @NSManaged var statusDescription:String
    @NSManaged var lastModifiedTime:String
    @NSManaged var imageTimeStamp:String
    @NSManaged var originalNextActionTime:String
    @NSManaged var checkInOutLattitude:Double
    @NSManaged var imageLattitude:String
    //imageLongitude
    @NSManaged var imageLongitude:String
    @NSManaged var isActive:Int
    @NSManaged var activityCheckInCheckOutList:NSOrderedSet
    @NSManaged var activityParticipantList:NSOrderedSet
    @NSManaged var addressDetails:AddressList
    class func entityName()->String{
        return "Activity"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        mapping.addAttribute(Mapping.intAttributeFor(property: "activityId", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "addressMasterID", keyPath: "AddressMasterID"))
      //
       mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "customerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property:"isActive", keyPath: "IsActive"))
      //  customerI
        mapping.addAttribute(Mapping.intAttributeFor(property: "noOfParticipants", keyPath: "NoOfParticipants"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "checkInOutLongitude", keyPath: "checkInOutLongitude"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "checkInOutLattitude", keyPath: "checkInOutLattitude"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "imageLattitude", keyPath: "ImageLattitude"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "imageLongitude", keyPath: "ImageLongitude"))
        //
        mapping.addAttribute(Mapping.intAttributeFor(property: "modifiedBy", keyPath: "ModifiedBy"))
     
       // mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "lastmodifiedTime", keyPath: "LastModifiedTime"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "productcatId", keyPath: "productcatId"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "Createdby", keyPath: "createdBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "activityTypeID", keyPath: "ActivityTypeID"))
       
        mapping.addAttribute(Mapping.intAttributeFor(property: "checkInCheckOutID", keyPath: "checkInCheckOutID"))
       
        mapping.addToManyRelationshipMapping(ActivityCheckinCheckout.defaultMapping(), forProperty: "activityCheckInCheckOutList", keyPath: "ActivityCheckInCheckOutList")
        // mapping.addToManyRelationshipMapping(SOrderProducts.defaultMapping(), forProperty: "soProductList", keyPath: "Products")
        
       mapping.addToManyRelationshipMapping(ActivityCheckinCheckout.defaultMapping(), forProperty: "ActivityCheckInCheckOutList", keyPath: "activityCheckInCheckOutList")
    //    mapping.addToManyRelationshipMapping(ActivityParticipant.defaultMapping(), forProperty: "ActivityParticipantList", keyPath: "activityParticipantList")
      mapping.addToManyRelationshipMapping(ActivityParticipant.defaultMapping(), forProperty: "activityParticipantList", keyPath: "ActivityParticipantList")
       // mapping.addRelationshipMapping(ActivityCheckinCheckout.defaultMapping(), forProperty: "ActivityCheckInCheckOutList", keyPath: "activityCheckInCheckOutList")
        mapping.addRelationshipMapping(AddressList.defaultmapping(), forProperty: "addressDetails", keyPath: "AddressDetails")
       
    //    mapping.addRelationshipMapping(AttendanceUser.defaultMapping(),forProperty: "attendanceuser", keyPath:"user")
        
        mapping.addAttributes(from:["picture1":"Picture1","picture2":"Picture2","picture3":"Picture3","picture4":"Picture4","picture5":"Picture5","activityTypeName":"ActivityTypeName","checkInTime":"CheckInTime","createdTime":"CreatedTime","customerName":"customerName","customerMobile":"customerMobile","activitydescription":"Description","statusDescription":"StatusDescription","nextActionTime":"NextActionTime","lastModifiedTime":"LastModifiedTime","imageTimeStamp":"ImageTimeStamp","originalNextActionTime":"OriginalNextActionTime","imageLattitude":"ImageLattitude","imageLongitude":"ImageLongitude"])//,"checkOutTime":"CheckOutTime","customerID":"customerID"
        mapping.primaryKey = "activityId"
        return mapping
    }
    
    class func getContext()->NSManagedObjectContext{
        //return NSManagedObjectContext.mr_default()
        return NSManagedObjectContext.mr_default()
    }
    
    class func getAll()->[Activity]{
        let predicate =  NSPredicate.init(format: "isActive = %d", 1)
        return Activity.mr_findAllSorted(by: "activityId", ascending: true, with: predicate) as? [Activity] ?? [Activity]()
     //   return Activity.mr_findAll() as? [Activity] ?? [Activity]()
    }
    
   
    
    func getActivityFromId(userID:NSNumber)->Activity?{
        if let activity = Activity.mr_findFirst(byAttribute: "activityId", withValue: userID, in: NSManagedObjectContext.mr_default()){
//            print("activity id = \(activity.activityId) , activity = \(activity) , count of checkin = \(activity.activityCheckInCheckOutList.count) in database")
            return activity
        }else{
            return nil
        }
//        if let  activity =  Activity.mr_findFirst(byAttribute: "activityId", withValue: userID){
//            print("activity id = \(activity.activityId) , count of checkin = \(activity.activityCheckInCheckOutList.count) in database")
//            return activity
//        }else{
//            return nil
//        }
    }
    
    
}

extension Activity{
    
    @objc (insertObject:inCheckInOutAtIndex:)
    
    @NSManaged public func insertObject(value:ActivityCheckinCheckout , at idx:Int)
   // @NSManaged public func insertObject(value:ActivityCheckinCheckout , at idx:Int)
    
    @objc(replaceObjectInCheckInOutDataAtIndex:withObject:)
    
    @NSManaged public func replaceObjectFrom(value:ActivityCheckinCheckout , at idx:Int)
   
    
    @objc (removeObjectFromCheckInOutDataAtIndex:)

    @NSManaged public func removeObjectFromCheckInOutData(at idx:Int)
    
    
    @objc (insertCheckInOutData:atIndexes:)
    
    @NSManaged public func insertCheckInOutData(value:[ActivityCheckinCheckout],atIndexes:Int)
   
        
        
       
        
     
        
        
      
        
        
       
        
        
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
    

    
//     @objc (insertStatus:inVisitStatusAtIndex:)
//    @NSManaged public func insertStatus(value:VisitStatus , at idx:Int)
}
