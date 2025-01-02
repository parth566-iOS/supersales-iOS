//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 9/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(Lead)
class Lead : NSManagedObject{
    
	@NSManaged var addressMasterID : Int64
	@NSManaged var askedForProposal : Int64
	@NSManaged var assignedBy : Int64
	@NSManaged var assignedTime : String!
	@NSManaged var companyID : Int64
	@NSManaged var contactID : Int64
	@NSManaged var createdBy : Int64
	@NSManaged var createdTime : String!
	@NSManaged var customerClassID : Int64
	@NSManaged var customerID : Int64
    @NSManaged var customerName : String?
	@NSManaged var customerOrientationID : Int64
	@NSManaged var customerSegmentID : Int64
	@NSManaged var filterCategoryID : Int64
	@NSManaged var filterProduct : Int64
	//@NSManaged var filterSubCategoryID : Int64
	@NSManaged var filterType : Int64
	@NSManaged var filterUser : Int64
	@NSManaged var iD : Int64
	@NSManaged var influencerAddressMasterID : Int64
	@NSManaged var influencerID : Int64
    @NSManaged var secondInfluencerAddressMasterID : Int64
    @NSManaged var secondInfluencerID : Int64
	@NSManaged var isActive : Int64
	@NSManaged var isLeadQualified : Int64
	@NSManaged var isNegotiationDone : Int64
    @NSManaged var leadstage5 : Int64
    @NSManaged var leadstage6 : Int64
	@NSManaged var isTrialDone : Int64
	@NSManaged var keyCustomer : Bool
    @NSManaged var leadCheckInOutList : NSOrderedSet
    @NSManaged var leadStatusList : NSOrderedSet
	@NSManaged var lastModifiedBy : Int64
	@NSManaged var lastModifiedTime : String!
	@NSManaged var leadSourceID : Int64
	@NSManaged var leadStatusID : Int64
	@NSManaged var leadTypeID : Int64
//	@NSManaged var manualCheckInStatusID : Int16
//	@NSManaged var manualCheckOutStatusID : Int16
	@NSManaged var nextActionID : Int64
	@NSManaged var nextActionTime : String!
	@NSManaged var orderExpectedDate : String!
	@NSManaged var originalAssignee : Int64
	@NSManaged var originalNextActionID : Int64
	@NSManaged var originalNextActionTime : String!
	@NSManaged var productList : NSOrderedSet
	@NSManaged var proposalSubmitted : Int64
	@NSManaged var reAssigned : Int64
	@NSManaged var remarks : String?
	@NSManaged var response : String!
    @NSManaged var reminder : Int64
	@NSManaged var reminderTime : String?
	@NSManaged var seriesPostfix : Int64
	@NSManaged var seriesPrefix : String!
	@NSManaged var sortType : Int64
    @NSManaged var leadAttachementPath:String!
    class func entityName()->String{
        return "Lead"
    }
    
    class func defaultmapping()->FEMMapping{
    let mapping = FEMMapping.init(entityName: "Lead")
    mapping.addAttribute(Mapping.intAttributeFor(property: "addressMasterID", keyPath: "AddressMasterID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "askedForProposal", keyPath: "AskedForProposal"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "assignedBy", keyPath: "AssignedBy"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "contactID", keyPath: "ContactID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "customerOrientationID", keyPath: "CustomerOrientationID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadstage5", keyPath: "LeadStage5"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadstage6", keyPath: "LeadStage6"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "filterCategoryID", keyPath: "FilterCategoryID"))
   // mapping.addAttribute(Mapping.intAttributeFor(property: "filterSubCategoryID", keyPath: "FilterSubCategoryID"))
        //
    mapping.addAttribute(Mapping.intAttributeFor(property: "filterProduct", keyPath: "FilterProduct"))
   
    mapping.addAttribute(Mapping.intAttributeFor(property: "filterType", keyPath: "FilterType"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "filterUser", keyPath: "FilterUser"))
    mapping.addAttribute(Mapping.boolAttributeFor(property: "keyCustomer", keyPath: "KeyCustomer"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "leadSourceID", keyPath: "LeadSourceID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "leadTypeID", keyPath: "LeadTypeID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "nextActionID", keyPath: "NextActionID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "originalAssignee", keyPath: "OriginalAssignee"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "originalNextActionID", keyPath: "OriginalNextActionID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "reAssigned", keyPath: "ReAssigned"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "reminder", keyPath: "Reminder"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "seriesPostfix", keyPath: "SeriesPostfix"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "sortType", keyPath: "SortType"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "proposalSubmitted", keyPath: "ProposalSubmitted"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "isLeadQualified", keyPath: "IsLeadQualified"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "isTrialDone", keyPath: "IsTrialDone"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "isNegotiationDone", keyPath: "IsNegotiationDone"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "leadStatusID", keyPath: "LeadStatusID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "customerClassID", keyPath: "CustomerClassID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "customerSegmentID", keyPath: "CustomerSegmentID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "influencerAddressMasterID", keyPath: "InfluencerAddressMasterID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "influencerID", keyPath: "InfluencerID"))
        
        
    mapping.addAttribute(Mapping.intAttributeFor(property: "secondInfluencerAddressMasterID", keyPath: "secondInfluencerAddressMasterID"))
        
    mapping.addAttribute(Mapping.intAttributeFor(property: "secondInfluencerID", keyPath: "secondInfluencerID"))
        
           
    mapping.addToManyRelationshipMapping(ProductsList.defaultmapping(), forProperty: "productList", keyPath: "ProductsList")
    mapping.addToManyRelationshipMapping(LeadStatusList.defaultmapping(), forProperty: "leadStatusList", keyPath: "LeadStatusList")
    mapping.addToManyRelationshipMapping(LeadCheckInOutList.defaultmapping(), forProperty: "leadCheckInOutList", keyPath: "LeadCheckInOutList")
        
        mapping.addAttributes(from: ["assignedTime": "AssignedTime","createdTime":"CreatedTime","lastModifiedTime":"LastModifiedTime","nextActionTime":"NextActionTime","orderExpectedDate":"OrderExpectedDate","originalNextActionTime":"OriginalNextActionTime","response":"Response","seriesPrefix":"SeriesPrefix","reminderTime":"ReminderTime","remarks":"Remarks","customerName":"CustomerName","leadAttachementPath":"leadAttachementPath"])
        mapping.primaryKey = "iD"
        return mapping
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		dictionary["AddressMasterID"] = addressMasterID
		dictionary["AskedForProposal"] = askedForProposal
		dictionary["AssignedBy"] = assignedBy
		if assignedTime != nil{
			dictionary["AssignedTime"] = assignedTime
		}
		dictionary["CompanyID"] = companyID
		dictionary["ContactID"] = contactID
		dictionary["CreatedBy"] = createdBy
		if createdTime != nil{
			dictionary["CreatedTime"] = createdTime
		}
		dictionary["CustomerClassID"] = customerClassID
		dictionary["CustomerID"] = customerID
		dictionary["CustomerOrientationID"] = customerOrientationID
		dictionary["CustomerSegmentID"] = customerSegmentID
		dictionary["FilterCategoryID"] = filterCategoryID
		dictionary["FilterProduct"] = filterProduct
//        if filterSubCategoryID !=  nil{
//		dictionary["FilterSubCategoryID"] = filterSubCategoryID
//        }
		dictionary["FilterType"] = filterType
		dictionary["FilterUser"] = filterUser
		dictionary["ID"] = iD
		dictionary["InfluencerAddressMasterID"] = influencerAddressMasterID
		dictionary["InfluencerID"] = influencerID
        dictionary["LeadStage5"] = leadstage5
        dictionary["LeadStage6"] = leadstage6
		dictionary["IsActive"] = isActive
		dictionary["IsLeadQualified"] = isLeadQualified
        
		dictionary["IsNegotiationDone"] = isNegotiationDone
		dictionary["IsTrialDone"] = isTrialDone
		dictionary["KeyCustomer"] = keyCustomer
		dictionary["LastModifiedBy"] = lastModifiedBy
		if lastModifiedTime != nil{
			dictionary["LastModifiedTime"] = lastModifiedTime
		}
	
		dictionary["LeadSourceID"] = leadSourceID
		dictionary["LeadStatusID"] = leadStatusID
		dictionary["LeadTypeID"] = leadTypeID
//		dictionary["ManualCheckInStatusID"] = manualCheckInStatusID
//		dictionary["ManualCheckOutStatusID"] = manualCheckOutStatusID
		dictionary["NextActionID"] = nextActionID
		if nextActionTime != nil{
			dictionary["NextActionTime"] = nextActionTime
		}
		if orderExpectedDate != nil{
			dictionary["OrderExpectedDate"] = orderExpectedDate
		}
		dictionary["OriginalAssignee"] = originalAssignee
		dictionary["OriginalNextActionID"] = originalNextActionID
		if originalNextActionTime != nil{
			dictionary["OriginalNextActionTime"] = originalNextActionTime
		}
		if productList != nil{
			var dictionaryElements = [[String:Any]]()
			for productsListElement in productList {
                dictionaryElements.append((productsListElement as? ProductsList)?.toDictionary() ?? [String:Any]())
			}
			dictionary["ProductsList"] = dictionaryElements
		}
		dictionary["ProposalSubmitted"] = proposalSubmitted
		dictionary["ReAssigned"] = reAssigned
		if remarks != nil{
			dictionary["Remarks"] = remarks
		}
		dictionary["Reminder"] = reminder
		if reminderTime != nil{
			dictionary["ReminderTime"] = reminderTime
		}
		dictionary["SeriesPostfix"] = seriesPostfix
		if seriesPrefix != nil{
			dictionary["SeriesPrefix"] = seriesPrefix
		}
		dictionary["SortType"] = sortType
		return dictionary
	}

    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    class func getAll()->[Lead]{
        let predicate = NSPredicate(format: "leadStatusID != 2")
        return Lead.mr_findAll(with: predicate) as? [Lead] ?? [Lead]()
       // return Lead.mr_findAll() as? [Lead] ?? [Lead]()
    }
    
    class func getAllBy(atrname:String,order:Bool)->[Lead]{
        let predicate = NSPredicate(format: "leadStatusID != 2")
        return Lead.mr_findAllSorted(by: atrname, ascending: order, with: predicate)  as? [Lead] ?? [Lead]()
    //return Lead.mr_findAllSorted(by: atrname, ascending: false, in: NSManagedObjectContext.mr_default()) as? [Lead] ?? [Lead]()//Lead.mr_findAllSorted(by: atrname, ascending: order) as? [Lead] ?? [Lead]()
    }
    
    class func getAllBy(withAttributeName: String, withAsc: Bool) ->[Lead]{
        let predicate = NSPredicate(format: "leadStatusID != 2")
        return Lead.mr_findAllSorted(by: withAttributeName, ascending: withAsc, with: predicate, in: NSManagedObjectContext.mr_default()) as? [Lead] ?? [Lead]()
    }
    
    class func getLeadByID(Id:Int)->Lead?{
        if let leadobj = Lead.mr_findFirst(byAttribute: "iD", withValue: Id, in: NSManagedObjectContext.mr_default()){
      //  if let leadobj = Lead.mr_findFirst(byAttribute: "iD", withValue: Id) { //Lead.mr_find(byAttribute: "iD", withValue: Id) as? Lead{
    return leadobj
        }else{
            return nil
        }
    }
    
    
    
    class func getPendingCheckOutLeadForToday()->[Lead]{
        let arr =  self.getAll()
        var arrOfPendingcheckoutlead = [Lead]()
        if(arr.count > 0){
        let arrOfVisitWithtodaysCheckin = arr.filter { (lead) -> Bool in
            if(lead.leadCheckInOutList.count > 0){
               
                return true
            }else{
                return false
            }
        }
            for lead in arrOfVisitWithtodaysCheckin{
                if let lastcheckin = lead.leadCheckInOutList.firstObject as? LeadCheckInOutList{
                    //Utils.getDateBigFormatToDefaultFormat(date: lastcheckin.checkInTime, format: "dd-MM-yyyy")
                    let checkintime = Utils.getDateBigFormatToDefaultFormat(date: lastcheckin.checkInTime, format: "dd-MM-yyyy")
                    let dateformatter = DateFormatter.init()
                    dateformatter.dateFormat = "dd-MM-yyyy"
                    let dateinstring = dateformatter.string(from: Date())
                    if let checkouttime = lastcheckin.checkOutTime as? String{
                       
                        if(checkintime == dateinstring && checkouttime.count == 0){
                            arrOfPendingcheckoutlead.append(lead)
                        }
                    }else{
                        if(checkintime == dateinstring){
                            arrOfPendingcheckoutlead.append(lead)
                        }
                        
                    }
                    
                }
            }
            return arrOfPendingcheckoutlead
        }else{
            return arrOfPendingcheckoutlead
        }
        
       
        
    }
    
    class func getFilteredByAttributes(withAttributeName:String,withAttributeValue:String)->[Lead]{
        return Lead.mr_find(byAttribute: withAttributeName, withValue: withAttributeValue, in: NSManagedObjectContext.mr_default()) as? [Lead] ?? [Lead]()
    }
    
    class func getfilterByProductID(withAttributeName:String,value:Int64)->[Lead]{
        let arroflead = Lead.getAll()
//        let predicate = NSPredicate(format: "SELF contains[c] %@", "l")
//            let searchData = arroflead.filter { predicate.evaluate(with: $0["first_name"] as? String ?? "") || predicate.evaluate(with: $0["last_name"] as? String ?? "") }
       // if let arrOfLead = Lead.mr_findFirst(with: NSPredicate.init(format: "", value))
        if let arrOfLead = Lead.mr_find(byAttribute: withAttributeName, withValue: value) as? [Lead] {
           
           
        return arrOfLead
        }else{
            return  [Lead]()
        }
    }
    
    class func getFilteredByAttributesComplex2(productIDs: [NSNumber]) -> [Lead] {
        let predicate = NSPredicate(format: "productID IN %@", productIDs)
        let array = (ProductsList.mr_findAll(with: predicate, in: NSManagedObjectContext.mr_default()) as? [ProductsList] ?? [ProductsList]()).map {NSNumber(value: $0.leadID)}

        let predicate1 = NSPredicate(format: "ANY iD IN %@", array)
        return Lead.mr_findAll(with: predicate1, in: NSManagedObjectContext.mr_default()) as? [Lead] ?? [Lead]()
    }
    
    class func getVisitByPredicate(predicate:NSPredicate)->[Lead]{
        return Lead.mr_findAllSorted(by: "iD", ascending: false, with: predicate) as? [Lead] ?? [Lead]()
    }
}
extension Lead{
    //- (void)insertObject:(LeadCheckInOutList *)value inLeadCheckInOutListAtIndex:(NSUInteger)idx;
    @objc (insertObject:inLeadCheckInOutListAtIndex:)
    @NSManaged public func insertObject(value:LeadCheckInOutList , at idx:Int)
    
    @objc (removeObject:inCheckInOutDataAtIndex:)
     @NSManaged public func removeObjectFromCheckInOutData(value:LeadCheckInOutList , at idx:Int)
    
    @objc (insertCheckInOutData:atIndexes:)
    @NSManaged public func insertCheckInOutData(value:[LeadCheckInOutList],atIndexes:Int)
    
    
     @objc (insertStatus:inVisitStatusAtIndex:)
    @NSManaged public func insertStatus(value:LeadStatus , at idx:Int)
    
}
