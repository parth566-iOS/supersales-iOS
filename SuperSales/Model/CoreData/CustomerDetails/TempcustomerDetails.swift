//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 10/1/2020

import Foundation
import CoreData
import FastEasyMapping


@objc(TempcustomerDetails)
class TempcustomerDetails : NSManagedObject {
    
    @NSManaged var addressList : NSOrderedSet!
    @NSManaged var birthDate : String!
    @NSManaged var anniversaryDate : String!
    @NSManaged var companyID : Int64
    @NSManaged var companyTypeID : Int64
    @NSManaged var contactName : String!
    @NSManaged var contactLastName : String!
    
    @NSManaged var contactNo : String!
    @NSManaged var createdBy : Int64
    @NSManaged var customerClass : Int64
    @NSManaged var cCode : String!
    @NSManaged var customerGSTNo : String!
    @NSManaged var customerImage : String!
    @NSManaged var customerImage2 : String!
    @NSManaged var customerImage3 : String!
    @NSManaged var descriptionField : String!
    @NSManaged var distributorName: String!
    @NSManaged var distributorID : Int64
    @NSManaged var emailID : String!
    @NSManaged var emailTo : String!
    @NSManaged var iD : Int64
    @NSManaged var keyCustomer : Bool
    @NSManaged var landlineNo : String!
    @NSManaged var lastModified : String!
    @NSManaged var lastModifiedBy : Int64
    @NSManaged var logo : String!
    @NSManaged var mobileNo : String!
    @NSManaged var name : String!
    @NSManaged var ownerID : Int64
    @NSManaged var segmentID : Int64
    @NSManaged var statusID : Int16
    @NSManaged var taggedRole : Int64
    @NSManaged var taggedStatus : String!
    @NSManaged var taggedTo : Int64
    @NSManaged var taxType : String!
    @NSManaged var townID : Int64
    @NSManaged var transactional : Bool
    @NSManaged var type : String!
    @NSManaged var vATCode : Int16
    @NSManaged var visitFrequency : Int64
    @NSManaged var visitingCard : String!
    @NSManaged var desc:String!
    @NSManaged var addressID : Int64
    @NSManaged var isActive : Int64
    @NSManaged var isAdminSuperAdmin : Int64
    @NSManaged var priviledgeID : Int64
    @NSManaged var territoryCode : String!
    @NSManaged var territoryID : Double
    @NSManaged var verified : Bool
    @NSManaged var taggedToIDList:NSOrderedSet
    @NSManaged var townName:String!
    @NSManaged var custKyc:KYCDetailOFCustomer?
    
    class func entityName()->String{
        return "TempcustomerDetails"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "TempcustomerDetails")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "ownerID", keyPath: "OwnerID"))
        //  mapping.addAttribute(Mapping.intAttributeFor(property: "addressID", keyPath: "addressID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyTypeID", keyPath: "CompanyTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "isActive"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitFrequency", keyPath: "VisitFrequency"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "taggedTo", keyPath: "TaggedToID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "taggedRoleID", keyPath: "TaggedRole"))
        
        mapping.addAttribute(Mapping.boolAttributeFor(property: "keyCustomer", keyPath: "Key_Customer"))
        
        mapping.addAttribute(Mapping.boolAttributeFor(property: "transactional", keyPath: "Transactional"))
        
        mapping.addAttribute(Mapping.boolAttributeFor(property: "keyCustomerVendor", keyPath: "KeyCustomerVendor"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerClass", keyPath: "CustomerClass"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "ownerID", keyPath: "OwnerID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "segmentID", keyPath: "SegmentID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "distributorID", keyPath: "DistributorID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "statusID", keyPath: "StatusID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "townID", keyPath: "TownID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "vATCode", keyPath: "VATCode"))
        
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "territoryID", keyPath: "territoryID"))
        
        mapping.addToManyRelationshipMapping(AddressList.defaultmapping(), forProperty: "addressList", keyPath: "AddressList")
        mapping.addToManyRelationshipMapping(TaggedToIDList.defaultmapping(), forProperty: "taggedToIDList", keyPath: "TaggedToIDList")
        mapping.addRelationshipMapping(KYCDetailOFCustomer.defaultmapping(), forProperty:"custKyc", keyPath:"custKyc")
        
        mapping.addAttributes(from: ["birthDate":"BirthDate","contactName":"ContactName","contactLastName":"ContactLastName","contactNo":"ContactNo","customerImage":"CustomerImage","customerImage2":"CustomerImage1","customerImage3":"CustomerImage2","name":"Name","logo":"Logo","mobileNo":"MobileNo","landlineNo":"LandlineNo","emailID":"EmailID","createdTime":"CreatedTime","type":"Type","desc":"Description","taxType":"Tax_Type","taggedUserName":"TaggedToName","visitingCard":"VisitingCard","lastModified":"LastModified","customerGSTNo":"CustomerGSTNo","taggedStatus":"TaggedStatus","cCode":"CustomerCode","emailTo":"EmailTo","distributorName":"DistributorName","townName":"TownName","territoryCode":"TerritoryCode","anniversaryDate":"AnniversaryDate"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func isCustomerExist(cid:NSNumber)->Bool{
        if  let customer = TempcustomerDetails.mr_findFirst(byAttribute: "iD", withValue: cid) {
            if (customer.iD >  0){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    class func getAllCustomers()->[TempcustomerDetails]{
//        let predicate = NSPredicate.init(format: "type contains[cd] 'V' ", argumentArray: nil)
//        return Vendor.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [Vendor] ?? [Vendor]()
//        return TempcustomerDetails.mr_findAll() as? [TempcustomerDetails] ?? [TempcustomerDetails()]
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
    }
    class func getAllInfluencers()->[TempcustomerDetails]{
        let setting = Utils().getActiveSetting()
        let predicate:NSPredicate!
        if(setting.customTagging == 3){
            predicate =  NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND (NOT (taggedStatus CONTAINS[cd] 'none')) AND isActive = 1 AND companyTypeID = 3", argumentArray: nil)
        }else{
            predicate =  NSPredicate.init(format: "type Contains[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 3", argumentArray: [])
        }
        
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
    }
    class func getAllWithNoPending()->[TempcustomerDetails]{
        let setting = Utils().getActiveSetting()
        let predicate:NSPredicate!
        if(setting.customTagging == 3){
            predicate =  NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND (NOT (taggedStatus CONTAINS[cd] 'none')) AND isActive = 1", argumentArray: nil)
        }else{
            predicate =  NSPredicate.init(format: "type Contains[cd] 'U' AND statusID = 2 AND isActive = 1", argumentArray: [])
        }
        
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
    }
    
    class func customerNameFromCustomerID(cid:NSNumber)->String{
        let customer = TempcustomerDetails.mr_find(byAttribute: "iD", withValue: cid) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
        let custom  = customer.first
        return custom?.name ?? ""
    }
    class func getCustomersUsingPredicate(predicate:NSPredicate)->[TempcustomerDetails]{
        print("predicate = \(predicate)")
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: false, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
    }
    
    class func getCustomerByID(cid:NSNumber)->TempcustomerDetails?{

        if let customer = TempcustomerDetails.mr_findFirst(byAttribute: "iD", withValue: cid){
            return customer

        }else{
            return nil
        }
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    
    
    class func getCustomerNameByID(cid:NSNumber)->String?{
        if let customer = TempcustomerDetails.mr_findFirst(byAttribute: "iD", withValue: cid){
            return customer.name
        }else{
            return nil
        }
    }
    
    class func getAllDistributors()->[TempcustomerDetails]{
        let setting = Utils().getActiveSetting()
        var predicate = NSPredicate()
        /*
         if (setting.customTagging == 3) {
         predicate = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 5 AND (NOT (taggedStatus CONTAINS[cd] 'none'))"];
         }else{
         predicate = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 5"];
         }
         
         if(setting.customTagging == 3){
             predicate =  NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND (NOT (taggedStatus CONTAINS[cd] 'none')) AND isActive = 1 AND companyTypeID = 3", argumentArray: nil)
         }else{
             predicate =  NSPredicate.init(format: "type Contains[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 3", argumentArray: [])
         }
         **/
        if(setting.customTagging == 3){
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 5 AND (NOT (taggedStatus CONTAINS[cd] 'none'))")
        }else{
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 5")
        }
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
        //mr_findAllSorted(by: "name", ascending: true, with: predicate) ?? [TempcustomerDetails]()
    }
    
    class func getAllRetails()->[TempcustomerDetails]{
        let setting = Utils().getActiveSetting()
        var predicate = NSPredicate()
        if(setting.customTagging == 3){
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND companyTypeID = 4 AND statusID = 2 AND isActive = 1 AND (NOT (taggedStatus CONTAINS[cd] 'none'))")
        }else{
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND companyTypeID = 4 AND statusID = 2 AND isActive = 1")
        }
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
    }

    class func getAllRetailsAndDistributors()->[TempcustomerDetails]{
        let setting = Utils().getActiveSetting()
        var predicate = NSPredicate()
        if(setting.customTagging == 3){
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND (companyTypeID = 4 OR companyTypeID = 5) AND (NOT (taggedStatus CONTAINS[cd] 'none'))")
        }else{
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND (companyTypeID = 4 OR companyTypeID = 5)")
        }
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
    }

    
    class func getAllStockist()->[TempcustomerDetails]{
        let setting = Utils().getActiveSetting()
        var predicate = NSPredicate()
        /*
         if (setting.customTagging == 3) {
         predicate = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 5 AND (NOT (taggedStatus CONTAINS[cd] 'none'))"];
         }else{
         predicate = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 5"];
         }
         
         if(setting.customTagging == 3){
             predicate =  NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND (NOT (taggedStatus CONTAINS[cd] 'none')) AND isActive = 1 AND companyTypeID = 3", argumentArray: nil)
         }else{
             predicate =  NSPredicate.init(format: "type Contains[cd] 'U' AND statusID = 2 AND isActive = 1 AND companyTypeID = 3", argumentArray: [])
         }
         **/
        if(setting.customTagging == 3){
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND (companyTypeID = 5 OR companyTypeID = 6) AND (NOT (taggedStatus CONTAINS[cd] 'none'))")
        }else{
            predicate = NSPredicate.init(format: "type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1 AND (companyTypeID = 5 OR companyTypeID = 6)")
        }
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails] ?? [TempcustomerDetails]()
        //mr_findAllSorted(by: "name", ascending: true, with: predicate) ?? [TempcustomerDetails]()
    }
    //    class func isKeyCustomer(cid:NSNumber)->Bool{
    //        let customer = TempcustomerDetails.mr_find(byAttribute: "iD", withValue: cid)?.first ?? TempcustomerDetails()
    //        if(customer.keyCustomer == true){
    //            return true
    //        }else{
    //            return false
    //        }
    //    }
    //    +(BOOL )isKeyCustomer:(NSNumber *)cID {
    //    TempcustomerDetails *customer = [TempcustomerDetails MR_findFirstByAttribute:@"iD" withValue:cID inContext:[NSManagedObjectContext MR_defaultContext]];
    //    if (customer && customer.keyCustomer == YES) {
    //    return YES;
    //    }
    //    return NO;
    //    }
    class func getAllCustomerBySearch(searchString: String)->[TempcustomerDetails]?{
        let setting = Utils().getActiveSetting()
        let predicate:NSPredicate!
        if(setting.customTagging == 3){
            predicate = NSPredicate(format: "name beginswith[c] %@ AND type CONTAINS[cd] 'U' AND statusID = 2 AND (NOT (taggedStatus CONTAINS[cd] 'none')) AND isActive = 1", searchString)
        }else{
            predicate = NSPredicate(format: "name beginswith[c] %@ AND type CONTAINS[cd] 'U' AND statusID = 2 AND isActive = 1", searchString)
        }
        
        return TempcustomerDetails.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [TempcustomerDetails]
    }
    
    
}
