//
//	AddressList.swift
//
//	Create by Mukesh Yadav on 6/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(AddressList)
class AddressList : NSManagedObject{

	@NSManaged var rootClass : RootClass!
	@NSManaged var addressID : Int64
    @NSManaged var addressMasterID : Int64
	@NSManaged var addressLine1 : String?
	@NSManaged var addressLine2 : String?
	@NSManaged var city : String?
	@NSManaged var country : String?
	@NSManaged var custVenID : Int64
	@NSManaged var lastModifiedBy : Int
	@NSManaged var lattitude : String
	@NSManaged var longitude : String
	@NSManaged var pincode : String
	@NSManaged var state : String?
	@NSManaged var type : String
	@NSManaged var verified : Bool
//    var defaultaddress:AddressList = AddressList.mr_createEntity()!
    
    class func entityName()->String{
        return "AddressList"
    }
    
//     func defaultAddress() -> AddressList{
//       defaultaddress.addressID = 1
//         defaultaddress.addressLine1 = ""
//        defaultaddress.addressLine2 = ""
//        defaultaddress.city = ""
//        defaultaddress.country = ""
//        defaultaddress.custVenID = 1
//        defaultaddress.lastModifiedBy = 0
//        defaultaddress.lattitude = 0
//        defaultaddress.longitude = 0
//        defaultaddress.pincode = ""
//        defaultaddress.state = ""
//        defaultaddress.type = 0
//        defaultaddress.verified = false
//        return defaultaddress //AddressID
//    }
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "AddressList")
        mapping.addAttribute(Mapping.intAttributeFor(property: "addressID", keyPath: "AddressID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "addressMasterID", keyPath: "AddressMasterID"))
       //mapping.addAttribute(Mapping.intAttributeFor(property: "pincode", keyPath: "Pincode"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "lattitude", keyPath: "Lattitude"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "longitude", keyPath: "Longitude"))
       // mapping.addAttribute(Mapping.doubleAttributeFor(property: "pincode", keyPath: "Pincode"))
       // mapping.addAttribute(Mapping.intAttributeFor(property: "type", keyPath: "Type"))//LattitudeLongitude
        mapping.addAttribute(Mapping.boolAttributeFor(property: "verified", keyPath: "Verified"))
        mapping.addAttributes(from: ["country": "Country","state":"State","city":"City","addressLine1":"AddressLine1","addressLine2":"AddressLine2","createdTime":"CreatedTime","pincode":"Pincode","type":"Type","lattitude":"Lattitude","longitude":"Longitude"])//,"pincode":"Pincode","lattitude":"Lattitude","longitude":"Longitude
        mapping.primaryKey = "addressID"
        
        return mapping
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
//		if rootClass != nil{
//			dictionary["rootClass"] = rootClass.toDictionary()
//		}
		dictionary["AddressID"] = addressID
		if addressLine1 != nil{
			dictionary["AddressLine1"] = addressLine1
		}
		if addressLine2 != nil{
			dictionary["AddressLine2"] = addressLine2
		}
		if city != nil{
			dictionary["City"] = city
		}
		if country != nil{
			dictionary["Country"] = country
		}
        if longitude != nil{
            dictionary["Longitude"] = longitude //Longitude
        }
        if lattitude != nil{
            dictionary["Lattitude"] = lattitude //Lattitude
        }
		dictionary["CustVenID"] = custVenID
//        if let lastModifirfByvalue = lastModifiedBy as? Int{
//            dictionary["LastModifiedBy"] = lastModifirfByvalue
//        }
//        if lastModifiedBy != nil{
//            dictionary["LastModifiedBy"] = lastModifiedBy
//        }
        if pincode != nil{
            dictionary["Pincode"] = pincode
        }
		
		
		
			
		
			dictionary["State"] = state
	
			dictionary["Type"] = type
		
		dictionary["Verified"] = verified
		return dictionary
	}
    class func getAll()->[AddressList]{
     
        return AddressList.mr_findAll() as? [AddressList] ?? [AddressList]()
        // return ProdCategory.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [ProdCategory] ?? [ProdCategory]()
     }
    
    func getAddressByAddressId(aId:NSNumber)-> AddressList?{
        
        if  let address = AddressList.mr_findFirst(byAttribute: "addressID", withValue: aId){
            return address
        
    }else{
    return nil
    }
            
       
    }
    func getAddressStringByAddressId(aId:NSNumber)->String?{
       
        if let address = AddressList.mr_findFirst(byAttribute: "addressID", withValue: aId){
          
       // if  let address = AddressList.mr_findFirst(byAttribute: "addressID", withValue: aId){
            var strPincode = ""
            if let strpincode = address.pincode as? String{
                strPincode = strpincode
            }
            return String.init(format: "%@ , %@ , %@ - %@ , %@ %@", address.addressLine1 ?? "" , address.addressLine2  ?? "",address.city  ?? "", strPincode , address.state ?? "" , address.country  ?? "")
        
    }else{
    return nil
    }
            
       
    }
    func getAddressStringByAddressmasterId(aId:NSNumber)->String?{
        print("address id = \(aId)")
        if let address = AddressList.mr_findFirst(byAttribute: "addressMasterID", withValue: aId, in: NSManagedObjectContext.mr_default()){
       // if  let address = AddressList.mr_findFirst(byAttribute: "addressID", withValue: aId){
            var strPincode = ""
            if let strpincode = address.pincode as? String{
                strPincode = strpincode
            }
            return String.init(format: "%@ , %@ , %@ - %@ , %@ %@", address.addressLine1 ?? "" , address.addressLine2  ?? "",address.city  ?? "", strPincode , address.state ?? "" , address.country  ?? "")
        
    }else{
    return nil
    }
            
       
    }
    //addressMasterID
    func getAddressByAddressmasterId(aId:NSNumber)->AddressList?{
        
        if  let addressList = AddressList.mr_findFirst(byAttribute: "addressMasterID", withValue: aId){
        return addressList
        
    }else{
    return nil
    }
            
       
    }
    func getAllAddressUsingCustomerId(cID:NSNumber)->[AddressList]{
        if let addressList = AddressList.mr_find(byAttribute: "customerDetails.iD", withValue: cID) as? [AddressList]{
            if(addressList.count > 0){
        return addressList
            }
        else if let addressList = AddressList.mr_find(byAttribute: "tempcustomerDetails.iD", withValue: cID) as? [AddressList]{
            return addressList ?? [AddressList]()
        }else{
            return [AddressList]()
        }
        }else{
            return [AddressList]()
        }
    }
    
    func getAddressUsingPredicate(predicate:NSPredicate)->[AddressList]{
        let addressList = AddressList.mr_findAllSorted(by: "addressID", ascending: true, with: predicate) as? [AddressList]
        return addressList ?? [AddressList]()
    }
    
    
}
