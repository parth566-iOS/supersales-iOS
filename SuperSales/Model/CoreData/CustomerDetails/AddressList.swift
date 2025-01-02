//
//	AddressList.swift
//
//	Create by Mukesh Yadav on 10/1/2020

import Foundation
import CoreData


class AddressList : ParsableModel{

	@NSManaged var rootClass : RootClass!
	@NSManaged var addressID : Int
	@NSManaged var addressLine1 : String!
	@NSManaged var addressLine2 : String!
	@NSManaged var city : String!
	@NSManaged var country : String!
	@NSManaged var custVenID : Int
	@NSManaged var lastModifiedBy : Int
	@NSManaged var lattitude : String!
	@NSManaged var longitude : String!
	@NSManaged var pincode : String!
	@NSManaged var state : String!
	@NSManaged var type : String!
	@NSManaged var verified : Bool


}