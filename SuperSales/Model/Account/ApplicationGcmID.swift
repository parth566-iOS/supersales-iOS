//
//	ApplicationGcmID.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class ApplicationGcmID: ParsableModel {



	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        let dictionary = [String:Any]()
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        super.init(dictionary: [:])
	}
    
    required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
        
       // fatalError("init(dictionary:) has not been implemented")
    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{

	}

}
