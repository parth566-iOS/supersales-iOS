//
//  Utils.swift
//  SuperSales
//
//  Created by Apple on 17/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import Reachability
import FastEasyMapping

class Utils: NSObject {
    //Check Internet Connection
    let defaultns = UserDefaults.standard
   static var hrTaskItem:[CompanyMenus]? = [CompanyMenus]()
    static var salesTaskItem:[CompanyMenus]? = [CompanyMenus]()
    static  let dateFormatter = DateFormatter.init()
    static  let calender = NSCalendar.current
    public static var shadowView:UIView?
    public static var shadowViewOnShadow:UIView?
    
    class func isReachable () -> Bool {
        
        do{
            let reachability: Reachability = try Reachability.init(hostname: "www.google.com")
            
            if(reachability.connection ==  .unavailable){
                return false
            }else{
                return true
            }
            
        }
        catch{
            return false
        }
    }
    
    class func isAppUpdated()->Bool{
        let strcurrentversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let savedcurrentversion = UserDefaults.standard.object(forKey: Constant.kCurrentAppVersion) as? String ?? ""
        if((savedcurrentversion.count > 0) && (strcurrentversion.count > 0))
        {
            if(savedcurrentversion == strcurrentversion){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    class func setDefultvalue(key:String,value:Any)->(){
        let userdefault = UserDefaults.standard
        userdefault.setValue(value, forKey: key)
        userdefault.synchronize()
    }
   
    class func getDefaultIntValue(key:String)->Int{
        if let string = UserDefaults.standard.value(forKey: key) as? Int{
            return string
        }else{
            return 0
        }
    }
    class func getDefaultStringValue(key:String)->String{
        if let string = UserDefaults.standard.value(forKey: key) as? String{
            return string
        }else{
            return ""
        }
    }
    class func getDefaultDicValue(key:String)->[String:Any]{
        if let dic = UserDefaults.standard.value(forKey: key) as? [String:Any]{
            return dic
        }else{
            return [String:Any]()
        }
    }
    class func getDefaultArrValue(key:String)->[[String:Any]]{
        if let arr = UserDefaults.standard.value(forKey: key) as? [[String:Any]]{
            return arr
        }else{
            return [[String:Any]]()
        }
    }
    class func getAllCustomerOrientation()->[String]{
        
        return ["Excellent","Very Good","Good","Average","Poor","Very Poor"]
    }
    
    class func getStringCustomerOrintationFromCustomerOrintationID(oriID:Int)->String{
        switch oriID {
        case 1:
            return "Excellent"
        case 2:
            return "Very Good"
        case 3:
            return "Good"
        case 4:
            return "Average"
        case 5:
            return "Poor"
        default:
            return "Very Poor"
        }
    }
    
    class func verifyAddressDetail(custID:NSNumber,addID:NSNumber,lat:NSNumber,long:NSNumber){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "AddressList")
        //fetchRequest.predicate = NSPredicate.init(format: "%d", arguments: nil)
        let predicate = NSPredicate(format: "addressID == %d", addID)
        fetchRequest.predicate = predicate//NSPredicate.init(format: String.init(format: "addressID == %d", addID), arguments:[])
        let context = NSManagedObjectContext.mr_default()
        // let results = context.execute(fetchRequest)
        do {
            let results = try context.fetch(fetchRequest) as! [AddressList]
            
            for entity in results {
                entity.lattitude = String.init(format: "%@", lat)//(lat)Double(lat) //
                entity.longitude = String.init(format: "%@", long)//String(long)Double(long) /
            }
            
            try context.mr_saveToPersistentStore(completion: { (status, error) in
                print("address changed now")
            })
        } catch {
            print(error)
        }
        
    }
    
    func getActiveAccount()->DataUser?{
        
        
        if let dicOfUser = defaultns.value(forKey: Constant.kCurrentUser) as? [String : Any] {
            let currentUser = DataUser.init(dictionary: dicOfUser)
            return currentUser
        }else{
            return nil
        }
    }
    
     func getActiveVisitStep()->[StepVisitList]{
        var arrOfVisitStep = StepVisitList.getAll()
        let activesetting = self.getActiveSetting()
        if(activesetting.storeCheckOwnBrand == 0 && activesetting.storeCheckCompetition == 0){
          
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 72
            }
            //arrAvoidablemenu.append(72)
        }
        
        if(activesetting.showShelfSpace == 0){
           
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 74
            }
        }
        if(activesetting.showProductDrive == 0){
           
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 73
            }
        }
        
        if(activesetting.customerProfileInUnplannedVisit == 0){
          
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 67
                
            }
        }
        if(activesetting.requireVisitCounterShare == 0){
           
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 66
                
            }
        }
        if(activesetting.requireVisitCollection == 0){
          
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 65
                
            }
        }
        if(activesetting.requirePromotionInSO == 0){
          
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 70
                
            }
        }
        return arrOfVisitStep
    }
    
    class func getOrderLostReason()->[String]{
        return ["Price", "Specifications do not meet requirement", "Brand", "Stock not available", "Competition Relationship","Other"]
    }
    
     func getActiveSetting()->Setting{
        let dicOfSetting = defaultns.value(forKey: Constant.kUserSetting) as? [String:Any] ?? [String:Any]()
        if(dicOfSetting != nil){
            let currentSetting = Setting.init(dictionary: dicOfSetting )
            
            return currentSetting
        }else{
            return Setting.init(dictionary: [:])
        }
        
    }
    
    //filter step according to customer type and segment
    func filterStepAccordingToCustTypeCustSegment(arrOfVisitStep:[StepVisitList],customer:CustomerDetails,completion:@escaping([StepVisitList])->()){
        print("before filter visit steprs = \(arrOfVisitStep) count = \(arrOfVisitStep.count)")
        var arrStepShouldbeFilter = [StepVisitList]()
        var arrOfFilteredStep  = [StepVisitList]()
            let companytypeid = NSNumber.init(value:customer.companyTypeID)
            let segment = NSNumber.init(value:customer.segmentID)
            for stepvisit in  arrOfVisitStep{
                if let visitStatusType = stepvisit.customerType as? String{
                    if let visitStatusSegment = stepvisit.customerSegment as? String{
                      
                            let arrOfKYCType = visitStatusType.components(separatedBy: ",")
                            let arrOfKYCSegment = visitStatusSegment.components(separatedBy: ",")
                            if((arrOfKYCType.contains(companytypeid.stringValue)) && (arrOfKYCSegment.contains(segment.stringValue))){
                                print("type of customer = \(companytypeid) , segment of customer = \(segment) , arr of type = \(arrOfKYCType) , arr of segment = \(arrOfKYCSegment) name of step is = \(stepvisit.menuLocalText), \(visitStatusType) , \(visitStatusSegment) \(arrOfKYCType.contains(companytypeid.stringValue)) , \(arrOfKYCSegment.contains(segment.stringValue))")
                            }else{
                                print("type of customer = \(companytypeid) , segment of customer = \(segment) , arr of type = \(arrOfKYCType) , arr of segment = \(arrOfKYCSegment) name of step is = \(stepvisit.menuLocalText), \(visitStatusType) , \(visitStatusSegment) \(arrOfKYCType.contains(companytypeid.stringValue)) , \(arrOfKYCSegment.contains(segment.stringValue)) not done")
                              
                                //as grishma said so
                                arrStepShouldbeFilter.append(stepvisit)
                               
                            }
                            
                        
                           
                        }
                    }
                }
           
        arrOfFilteredStep = arrOfVisitStep.filter({ step in
            !arrStepShouldbeFilter.contains(step)
        })
        print("So after filter visit step is = \(arrOfFilteredStep)")
        completion(arrOfFilteredStep)
        
    }
   //func getLeadDetail()
    
    //MARK: API Calling

    func getTaagedCustomer(pageno:Int,trimmedstring:String,savepermenent:Bool,completion:@escaping([TempcustomerDetails]?,String)->Void){
        
        var param = Common.returndefaultparameter()
        param["Filter"] = trimmedstring
        param["PageNo"] = pageno
        print("parameter is = \(param)")
        ApiHelper().getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAllTaggedCustomer, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                let arrOfTaggedCustomer = arr as? [[String:Any]] ?? [[String:Any]]()
                
                
                print("array of customer = \(arrOfTaggedCustomer.count) for page no  = \(pageno) , \(pagesavailable),\(totalpages)")
                if(arrOfTaggedCustomer.count > 0){
                    
                    MagicalRecord.save({ (localcontext) in
                        if(savepermenent){
                            CustomerDetails.mr_truncateAll(in: localcontext)
                            FEMDeserializer.collection(fromRepresentation: arrOfTaggedCustomer, mapping: CustomerDetails.defaultmapping(), context: localcontext)
                            
                            
                            localcontext.mr_save({ (localcontext) in
                                //print("saving")
                            }, completion: { (status, error) in
                                //print("saved")
                            })
                        }else{
                            TempcustomerDetails.mr_truncateAll(in: localcontext)
                            FEMDeserializer.collection(fromRepresentation: arrOfTaggedCustomer, mapping: TempcustomerDetails.defaultmapping(), context: localcontext)
                            
                            
                            localcontext.mr_save({ (localcontext) in
                                //print("saving")
                            }, completion: { (status, error) in
                                //print("saved")
                            })
                        }
                        
                        
                        
                      
                        
                        
                        
                    }, completion: { (status, error) in
                        
                        if(error?.localizedDescription == ""){
                            print("tagged customer saved sucessfully total customer = \(TempcustomerDetails.getAllCustomers().count)")
                           
                           
                            

                        }else{
                          
                        }
                        
                    })
                    
                    if(pageno < totalpages){
                        print("page is available for tagged customer api \(pagesavailable)")
                        self.getTaagedCustomer(pageno: pageno + 1 ,trimmedstring: trimmedstring, savepermenent: savepermenent){
                            (arr,message) in
                            
                        }
                        
                    }else{
                      //  SVProgressHUD.dismiss()
                        if(savepermenent){
                            let   arrOfCustomers = CustomerDetails.getAllCustomers()
                            completion([TempcustomerDetails](),message)
                              //completion(arrOfCustomers,message)
                        }else{
                      let   arrOfCustomers = TempcustomerDetails.getAllCustomers()
                        completion(arrOfCustomers,message)
                        }
//                        arrAllCustomer = self.arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
//
//                        self.filteredCustomer =
//                            self.arrAllCustomer.filter({(item: NSString) -> Bool in
//                                return item.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
//                            })
//
//                        self.arrOffilteredCustomer =
//                            self.arrOfCustomers.compactMap { (temp) -> CustomerDetails in
//                                return temp
//                            }.filter { (aUser) -> Bool in
//                                return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
//                            }
//
//                        self.customerDropdown.dataSource = self.filteredCustomer as [String]
//                        self.customerDropdown.reloadAllComponents()
//                        self.customerDropdown.show()
                        
                    }
                }else{
                    if(savepermenent){
                        let   arrOfCustomers = CustomerDetails.getAllCustomers()
                        completion([TempcustomerDetails](),message)
                          //completion(arrOfCustomers,message)
                    }else{
                    let   arrOfCustomers = TempcustomerDetails.getAllCustomers()
                      completion(arrOfCustomers,message)
                    }
                  //  SVProgressHUD.dismiss()
                  //  Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String ?? "" ?? message, view: self.view)
                }
            }else{
                if(savepermenent){
                    let   arrOfCustomers = CustomerDetails.getAllCustomers()
                    completion([TempcustomerDetails](),message)
                      //completion(arrOfCustomers,message)
                }else{
                let   arrOfCustomers = TempcustomerDetails.getAllCustomers()
                  completion(arrOfCustomers,message)
                }
               // SVProgressHUD.dismiss()
             //   Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String ?? "" ?? message, view: self.view)
                
            }
        }
    }
    func getLeadDetail(leadid:NSNumber,completion:@escaping(Lead?,String)->Void){
        var jsonlead = [String:Any]()
        jsonlead["ID"] = leadid
        jsonlead["CompanyID"] = self.getActiveAccount()?.company?.iD
        jsonlead["CreatedBy"] = self.getActiveAccount()?.userID
        var param = Common.returndefaultparameter()
        param["getleadjson"] = Common.returnjsonstring(dic: jsonlead)
        print("parameter of get lead detail = \(param)")
        ApiHelper().getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
          
            if(status.lowercased() == Constant.SucessResponseFromServer){
               print(responseType)
                let arrLead = arr as? [String:Any] ?? [String:Any]()
                if let objLead  = Lead.getLeadByID(Id: leadid.intValue) as? Lead{
                    completion(objLead,message)
                }else{
                MagicalRecord.save({ (localContext) in
                    let arrlead = FEMDeserializer.collection(fromRepresentation: [arrLead], mapping: Lead.defaultmapping(), context: localContext)
                    print("lead from get lead detail = \(arrlead.first)")
                    localContext.mr_saveToPersistentStoreAndWait()
                }, completion: { (contextdidsave, error) in
                    
                    if let objLead  = Lead.getLeadByID(Id: leadid.intValue) as? Lead{
                        completion(objLead,message)
                    }
                })
                }
            }else{
                if(message.count > 0){
                    completion(nil,message)
                }else{
                completion(nil,error.localizedDescription)
                }
            }
    }
    }
    
    func getCustomerDetail(cid:NSNumber,completion:@escaping(Bool)->Void){
      
        var param = Common.returndefaultparameter()
        param["CustomerID"] =  cid
        ApiHelper().getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCustomerDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
          
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let custdic = arr as? [String:Any] ?? [String:Any]()
                let arrOfAdd = custdic["AddressList"] as? [[String:Any]] ?? [[String:Any]]()
                let dicOfAdd = arrOfAdd.first as? [String:Any] ?? [String:Any]()
                let customerID = custdic["ID"] as? Int
                let type = custdic["Type"] as? String
                let nsnumCustomerID = NSNumber.init(value: customerID ?? 0)
                var nsnumContactID = NSNumber.init(value:  0)
                if((type == "U") && (nsnumCustomerID.intValue > 0)){
                MagicalRecord.save { (localcontext) in
            
                    FEMDeserializer.object(fromRepresentation: custdic, mapping: CustomerDetails.defaultmapping(), context: localcontext)
                    FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                    localcontext.mr_saveToPersistentStore { (status, error
                                        ) in
                                            print(error?.localizedDescription ?? "gbdfgdfgb")
                                            print("after saving persistant")
                        if let customer = CustomerDetails.getCustomerByID(cid:nsnumCustomerID) as? CustomerDetails{
                            

                            print("address = \(customer.addressList)" )
                            if  let adlist = customer.addressList{
                            for add in adlist{
                                if let address = add as? AddressList{
                                    print("late = \(address.lattitude) , long = \(address.longitude) , address = \(address)")
                                }
                            }
                            }
                        }


                                        }

                                    } completion: { (status , error) in
                                        
                                        completion(true)
                                   let strAdd =      AddressList().getAddressStringByAddressId(aId:NSNumber.init(value:dicOfAdd["AddressID"] as? Int ?? 0))
                                    //    print("string address = \(strAdd) ,  dic of address = \(dicOfAdd)")
                                        let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                                        if(arrOFContact.count > 0){
                                            nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                                        }
                                        
                                        
                                       

                                      
              
            if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                if(arrOFContact.count > 0){
                    nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                }

                                        }
                                    }
                }
                else if((type == "V") && (nsnumCustomerID.intValue > 0)){
                    MagicalRecord.save { (localcontext) in
               
                        FEMDeserializer.object(fromRepresentation: custdic, mapping: Vendor.defaultmapping(), context: localcontext)
                        FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                        localcontext.mr_saveToPersistentStore { (status, error
                                            ) in
                                                print(error?.localizedDescription ?? "gbdfgdfgb")
                                                print("after saving persistant")
                                              
                                            }

                    } completion: { (status , error) in
                     completion(true)
                    }
                }else{
                    if ( message.count > 0 ) {
                      
                }
                }
                
            }else{
                completion(false)
            }
        }
    }
    
     func getMenuSetting()->[NSNumber]{
        var arr:[NSNumber]! = [NSNumber]()
        if let  activeaccount  = getActiveAccount(){
            
            let activesetting =  getActiveSetting()
            let roleId = activeaccount.role?.id ?? 0
            
            if (roleId == 5) {
                arr = [NSNumber.init(value:0),
                       NSNumber.init(value:1),
                       NSNumber.init(value:2),
                       NSNumber.init(value:3),
                       NSNumber.init(value:4),
                       NSNumber.init(value:5),
                       NSNumber.init(value:6),
                       NSNumber.init(value:7),
                       NSNumber.init(value:8),
                       NSNumber.init(value:10),
                       NSNumber.init(value:12),
                       NSNumber.init(value:14),
                       NSNumber.init(value:15),
                       NSNumber.init(value:16),
                       NSNumber.init(value:68),
                       NSNumber.init(value:18)]
                
            }else if (roleId == 6){
                arr = [NSNumber.init(value:0),
                       NSNumber.init(value:1),
                       NSNumber.init(value:2),
                       NSNumber.init(value:3),
                       NSNumber.init(value:4),
                       NSNumber.init(value:5),
                       NSNumber.init(value:6),
                       NSNumber.init(value:7),
                       NSNumber.init(value:8),
                       NSNumber.init(value:10),
                       NSNumber.init(value:12),
                       NSNumber.init(value:14),
                       NSNumber.init(value:15),
                       NSNumber.init(value:16),
                       NSNumber.init(value:68),
                       NSNumber.init(value:18)]
                
            }else if roleId == 7{
                arr = [NSNumber.init(value: 0),
                       NSNumber.init(value: 1),
                       NSNumber.init(value: 2),
                       NSNumber.init(value: 3),
                       NSNumber.init(value:4),
                       NSNumber.init(value:5),
                       NSNumber.init(value:6),
                       NSNumber.init(value:7),
                       NSNumber.init(value:8),
                       NSNumber.init(value:10),
                       NSNumber.init(value:12),
                       NSNumber.init(value:14),
                       NSNumber.init(value:15),
                       NSNumber.init(value:16),
                       NSNumber.init(value:68),
                       NSNumber.init(value:18)]
                
            }else if (roleId == 8){
                arr = [NSNumber.init(value:0),
                       NSNumber.init(value:1),
                       NSNumber.init(value:2),
                       NSNumber.init(value:3),
                       NSNumber.init(value:4),
                       NSNumber.init(value:5),
                       NSNumber.init(value:6),
                       NSNumber.init(value:7),
                       NSNumber.init(value:8),
                       NSNumber.init(value:10),
                       NSNumber.init(value:12),
                       NSNumber.init(value:15),
                       NSNumber.init(value:16),
                       NSNumber.init(value:18),
                       NSNumber.init(value:68)]
                
            }else{
                arr = [NSNumber.init(value:1),
                       NSNumber.init(value:3),
                       NSNumber.init(value:4),
                       NSNumber.init(value:5),
                       NSNumber.init(value:6),
                       NSNumber.init(value:8),
                       NSNumber.init(value:16),
                       NSNumber.init(value:18),
                       NSNumber.init(value:68)]
                
            }
            
            if (roleId == 8 && activesetting.salesExecutiveShowTracking == 0) {
                //            let recordno = arr.index(before: 3)
                //            arr.remove(at: recordno+1)
                
                arr =  arr.filter{
                    $0 !=  NSNumber.init(value:3)
                }
                //[arr removeObject:@3];
            }else if (roleId == 9 && activesetting.salesRepresentativeShowTracking == 0) {
                //            let recordno = arr.index(before: 3)
                //            arr.remove(at: recordno+1)
                arr =  arr.filter{
                    $0 !=  NSNumber.init(value:3)
                }
            }
            
            
          
        }
        
        return arr
        
        
    }
    
    class func getSubMenuSettings(roleid:NSNumber)->[MenuTabs]{
        var arr = [NSNumber]()
        print(roleid)
        if(roleid == 5){
            arr = [NSNumber.init(value:7),NSNumber.init(value:16),NSNumber.init(value:8),NSNumber.init(value:9),NSNumber.init(value:10),NSNumber.init(value:11),NSNumber.init(value:12),NSNumber.init(value:13),NSNumber.init(value:14),NSNumber.init(value:15),NSNumber.init(value:17)]
            
            /*  arr = [NSNumber.init(value:0),NSNumber.init(value:1),NSNumber.init(value:2),NSNumber.init(value:7),NSNumber.init(value:16),NSNumber.init(value:8),NSNumber.init(value:9),NSNumber.init(value:10),NSNumber.init(value:11),NSNumber.init(value:12),NSNumber.init(value:13),NSNumber.init(value:14),NSNumber.init(value:15),NSNumber.init(value:17)]*/
        }else if(roleid == 6){
            arr = [NSNumber.init(value:7),NSNumber.init(value:16),NSNumber.init(value:8),NSNumber.init(value:9),NSNumber.init(value:10),NSNumber.init(value:11),NSNumber.init(value:12),NSNumber.init(value:13),NSNumber.init(value:14),NSNumber.init(value:15),NSNumber.init(value:17)]
        }else if((roleid == 7) || (roleid == 8)){
            arr = [NSNumber.init(value: 7),NSNumber.init(value:16),NSNumber.init(value:8),NSNumber.init(value:9),NSNumber.init(value:10),NSNumber.init(value:11),NSNumber.init(value:12),NSNumber.init(value:13),NSNumber.init(value:14),NSNumber.init(value:17)]
        }else {
            arr = [NSNumber.init(value:13),NSNumber.init(value:15),NSNumber.init(value:17)]
        }
        let menutab = MenuTabs.getTabMenus(menu: arr, sort: true)
        var temp = [MenuTabs]()
        for numb in arr{
            for item in menutab{
                if(item.menuID == numb.intValue){
                    
                    temp.append(item)
                    break
                }
            }
        }
        return temp
    }
    
    class func getVisitMenu()->[Int]{
        return [35,38,40,72,66,65,70,74,73,71,39,36,37,47,50,51,503,67,42,49,41,43,36,44,46,45]
    ///  return [503,35,67,65,66,73,74,36,38,39,40,41,42,44,45,46,47,70,71,72,49,50,51,43];,76 for custom form
    }
    class func getLeadMenu()->[Int]{
        return [56]
        //   return [57, 56, 55, 54, 53, 52, 58, 59, 60]
    }
    
    class func getNextActionImage(interactionId:Int)->(UIImage){
        switch interactionId {
        
        case 1:
            return UIImage.init(named: "icon_interaction_call")!
        //  return UIImage.init(named: "icon_visitList_meeting")!
        
        
        case 2:
            return UIImage.init(named: "icon_visitList_meeting")!
        //   return UIImage.init(named: "icon_visitList_call")!
        
        
        case 3:
            // return UIImage.init(named: "icon_planvisit_interaction_mail_selected")!
            return UIImage.init(named: "icon_interaction_mail")!
        case 4:
            return UIImage.init(named: "icon_interaction_message")!
            
        case 5:
            return UIImage.init(named: "icon_time")!
            
        default:
            return UIImage.init(named:"icon_placeholder_user")!
        }
    }
    class func addShadow(view:UIView){
        Utils.shadowView = UIView.init(frame: view.frame)
        Utils.shadowView?.backgroundColor = UIColor.lightGray
        Utils.shadowView?.alpha = 0.5//CGFloat(alpha)
        if let sview = Utils.shadowView{
            if(view.subviews.contains(sview)){
                sview.removeFromSuperview()
            }
            view.addSubview(sview)
        }
    }
    class func addShadowOnSahdow(view:UIView){
        Utils.shadowViewOnShadow = UIView.init(frame: view.frame)
        Utils.shadowViewOnShadow?.backgroundColor = UIColor.lightGray
        Utils.shadowViewOnShadow?.alpha = 0.7//CGFloat(alpha)
        if let sview = Utils.shadowViewOnShadow{
            view.addSubview(sview)
        }
    }
    
    //save  image to directory
    class func saveImageDocumentDirectory(img:UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).strings(byAppendingPaths: ["apple.jpg"])
        
        print(paths)
        let imageData = img.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: (paths.first ?? "") as String , contents: imageData, attributes: nil)
        //img.jpegData(compressionQuality: 0.5).fil
        //img.jpegData(compressionQuality: 0.5) fileManager.createFileAtPath(paths as String, contents: imageData, attributes: nil)
    }
    
    //Get Directory
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Get image from Directory
    class  func getImage(imgName:String) -> UIImage? {
        var img = UIImage()
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("apple.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            if let  img = UIImage(contentsOfFile: imagePAth) as? UIImage{
                return img
            }else{
                return nil
            }
        }else{
            print("No Image")
            return nil
        }
    }
    //    func removeShadowFromShadow(view:UIView){
    //        if let sview = Utils.shadowViewOnShadow{
    //            if(view.subviews.contains(sview)){
    //            sview.removeFromSuperview()
    //            }else{
    //                sview.removeFromSuperview()
    //            }
    //        }
    //    }
    class func removeShadow(view:UIView){
     
        
        if let sview = Utils.shadowView{
            if(view.subviews.contains(sview)){
                sview.removeFromSuperview()
            }else if let shadowview =  Utils.shadowViewOnShadow{
                if(view.subviews.contains(shadowview)){
                    shadowview.removeFromSuperview()
                }else{
                    shadowview.removeFromSuperview()
                }
            }else{
                sview.removeFromSuperview()
            }
        }
        if let shadowview =  Utils.shadowViewOnShadow{
            if(view.subviews.contains(shadowview)){
                shadowview.removeFromSuperview()
            }else{
                shadowview.removeFromSuperview()
            }
        }
        if let sview = Utils.shadowView{
            if(view.subviews.contains(sview)){
                sview.removeFromSuperview()
            }else if let shadowview =  Utils.shadowViewOnShadow{
                if(view.subviews.contains(shadowview)){
                    shadowview.removeFromSuperview()
                }else{
                    shadowview.removeFromSuperview()
                }
            }else{
                sview.removeFromSuperview()
            }
        }
        
    }
    class func getImageFrom(interactionId:Int)->(UIImage){
        /*
         if (nextActionID ==1)
         return [UIImage imageNamed:@"05_Existing_leads_phone"];
         else if(nextActionID ==2)
         return [UIImage imageNamed:@"05_Existing_leads_meeting"];
         else if(nextActionID ==3)
         return [UIImage imageNamed:@"05_Existing_leads_Email"];
         else if(nextActionID ==4)
         return [UIImage imageNamed:@"05_Existing_leads_message"];
         else if(nextActionID ==5)
         return [UIImage imageNamed:@"10_Cold_call_watsapp"];
         else
         return [UIImage imageNamed:@"lead_order"];
         */
        print(interactionId)
        switch interactionId {
        
        case 1:
            return UIImage.init(named: "icon_visitList_call")!
        //  return UIImage.init(named: "icon_visitList_meeting")!
        
        
        case 2:
            return UIImage.init(named: "icon_visitList_meeting")!
        //   return UIImage.init(named: "icon_visitList_call")!
        
        
        case 3:
            // return UIImage.init(named: "icon_planvisit_interaction_mail_selected")!
            return UIImage.init(named: "icon_planvisit_interaction_message_selected")!
        case 4:
            return UIImage.init(named: "icon_planvisit_interaction_mail_selected")!
            
            
        default:
            return UIImage.init(named:"icon_placeholder_user")!
        }
        
    }
    //icon_planvisit_interaction_call
    class    func getImageFromForLead(interactionId:Int)->(UIImage){
        /*
         if (nextActionID ==1)
         return [UIImage imageNamed:@"05_Existing_leads_phone"];
         else if(nextActionID ==2)
         return [UIImage imageNamed:@"05_Existing_leads_meeting"];
         else if(nextActionID ==3)
         return [UIImage imageNamed:@"05_Existing_leads_Email"];
         else if(nextActionID ==4)
         return [UIImage imageNamed:@"05_Existing_leads_message"];
         else if(nextActionID ==5)
         return [UIImage imageNamed:@"10_Cold_call_watsapp"];
         else
         return [UIImage imageNamed:@"lead_order"];
         */
        print(interactionId)
        switch interactionId {
        
        case 1:
            return UIImage.init(named: "icon_planvisit_interaction_call")!
        //  return UIImage.init(named: "icon_visitList_meeting")!
        
        
        case 2:
            return UIImage.init(named: "icon_planvisit_interaction_metting")!
        //   return UIImage.init(named: "icon_visitList_call")!
        
        
        case 3:
            // return UIImage.init(named: "icon_planvisit_interaction_mail_selected")!
            return UIImage.init(named: "icon_planvisit_interaction_message_selected")!
        case 4:
            return UIImage.init(named: "icon_planvisit_interaction_mail_selected")!
            
            
        default:
            return UIImage.init(named:"icon_placeholder_user")!
        }
        
    }
    class   func getVisitOptionMenu(roleId:NSNumber)->[CompanyMenus]{
        var arrMenuId:[NSNumber] = [NSNumber.init(value: 28),NSNumber.init(value: 29),NSNumber.init(value: 30),NSNumber.init(value: 32),NSNumber.init(value: 34),NSNumber.init(value: 33)]
        //NSNumber.init(value: 31), remove corporate
        if(roleId != NSNumber.init(value: 7)){
            arrMenuId.remove(at: 4)
        }
        let companymenusForvisitType = CompanyMenus.getComapnyMenus(menu: arrMenuId, sort: true)
        return companymenusForvisitType
    }
    
    class func isCustomerMapped(cid:NSNumber)->Bool{
        //isCustomerExist
      
        return CustomerDetails.isCustomerExist(cid:cid)
    }
    
    class func isTempCustomerMapped(cid:NSNumber) -> Bool{
        return TempcustomerDetails.isCustomerExist(cid: cid)
    }
    
    func getCustomerClassification()->[String]{
        var arrOfClass = [String]()
        if(self.getActiveSetting().classA.count > 0){
            arrOfClass.append(self.getActiveSetting().classA)
        }else{
            arrOfClass.append("Class A")
        }
        if(self.getActiveSetting().classB.count > 0){
            arrOfClass.append(self.getActiveSetting().classB)
        }else{
            arrOfClass.append("Class B")
        }
        if(self.getActiveSetting().classC.count > 0){
            arrOfClass.append(self.getActiveSetting().classC)
        }else{
            arrOfClass.append("Class C")
        }
        if(self.getActiveSetting().classD.count > 0){
            arrOfClass.append(self.getActiveSetting().classD)
        }else{
            arrOfClass.append("Class D")
        }
        
        return arrOfClass
        //return ["Class A","Class B","Class C","Class D"]
        
    }
    
    class func validateEmail(email:String)->Bool{
        //        let emailregex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        //        let predicate = NSPredicate.init(format: "SELF MATCHES \(emailregex)")
        //        return predicate.evaluate(with: email)
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    class func getorderByVisitId(visitID:NSNumber)-> SOrder?{
        let order = SOrder.getAll().filter({ (order) -> Bool in
            print(order.visitID)
            return order.visitID == visitID.int64Value
            
        })
        if(order.count > 0){
            return order.first
        }else{
            return nil
        }
       
    }
    // MARK: Slider data
    
    class func getHrTask(type:String)->[CompanyMenus]{
        var array = Utils().getMenuSetting()
       
       
        let cmenus = CompanyMenus.getComapnyMenus(menu:array,sort:true)
      print("menus of hr = \(cmenus)")
        if(cmenus.count > 0 && array.count > 0){
        hrTaskItem = [CompanyMenus]()
           salesTaskItem = [CompanyMenus]()
            
            for index in 0..<cmenus.count {
                for element in 0..<array.count {
                    
                    let news = cmenus[index]
                    let value = array[element]
                    
                    if(news.menuID == Int32(value)){
                        if((news.menuID == 5) || (news.menuID == 4)||(news.menuID == 6)){
                            hrTaskItem?.append(news)
                            
                        }
                        else if((news.menuID == 0) || (news.menuID == 1)||(news.menuID == 2)||(news.menuID == 12)){
                            
                        }else{
                            if(news.menuID == 15 && ((Utils().getActiveAccount()?.role?.id == NSNumber.init(value:7))||(Utils().getActiveAccount()?.role?.id == NSNumber.init(value:5)))){
                                
                                
                            }else{
                                // removing profile , traking 
                                if(news.menuID == 68 || news.menuID == 10 || news.menuID == 69 || news.menuID == 15 || news.menuID == 3){
                                    //removing profile , proposal ,setting , sales report
                                }else{
                                salesTaskItem?.append(news)
                                }
                              
                               // salesTaskItem?.append(CompanyMenus.getComapnyMenus(menu: [NSNumber.init(value: 169)], sort: true).first ?? CompanyMenus())
                             //   salesTaskItem?.append()
                            }
                            
                        }
                        
                        
                        
                    }else{
                        
                    }
                    
                }
            }
            //Adding Home
            if let homemenu = CompanyMenus.getComapnyMenus(menu: [NSNumber.init(value: 169)], sort: true).first {
            salesTaskItem?.insert(homemenu, at: 0)
            }else{
              
                
                var dicOfofflineMenu = [String:Any]()
                dicOfofflineMenu["ID"] =  95204
                dicOfofflineMenu["menuID"] = 169
                dicOfofflineMenu["CompanyID"] = 1469
                dicOfofflineMenu["isVisible"] = NSNumber.init(value: 1)
                dicOfofflineMenu["menuValue"] = "Home"
                dicOfofflineMenu["menuLocalText"] = "Home"
                
                MagicalRecord.save({ (localcontext) in
                    
                    
                    let  arr = FEMDeserializer.collection(fromRepresentation: [dicOfofflineMenu], mapping: CompanyMenus.defaultMapping(), context: localcontext)
                    localcontext.mr_saveToPersistentStore { (status, error) in
                                    
                    }
                } , completion: { (contextdidsave, error) in
                    if let homemenu = CompanyMenus.getComapnyMenus(menu: [NSNumber.init(value: 169)], sort: true).first {
                        salesTaskItem?.insert(homemenu, at: 0)
                    }
                    
                })
            }
        }
        if(type == "HR"){
            return hrTaskItem ?? [CompanyMenus]()
        }else{
            return salesTaskItem ?? [CompanyMenus]()
        }
    }
    
    
    
    
    // MARK: Visit
    class func getCollectinPaymentMode()->[String]{
        return ["Cash", "Cheque", "Draft", "NEFT", "RTGS", "Card", "e-Wallet"]
    }
    
      func FirstCheckInAttendance(view:UIViewController)->Bool{
        if(self.getActiveSetting().firstCheckInAttendance == NSNumber.init(value: 1)){
            Utils.dateFormatter.dateFormat = "dd-MM-yyyy"
            let currentaccount =  self.getActiveAccount()
            if(currentaccount?.role?.id?.intValue ?? 0 >  6)
            {
                let attendancehistory =  AttendanceHistory.getAll()
                var isuserCheckedIn =  false
                if(attendancehistory.count > 0){
                    for atte in attendancehistory{
                        if let checkintime = atte.checkInTime as? Date{
                            if(Utils.dateFormatter.string(from: checkintime) == Utils.dateFormatter.string(from: Date())){
                                isuserCheckedIn =  true
                            }
                        }else if let updatedtime = atte.updatedTimeIn as? Date{
                            if(Utils.dateFormatter.string(from: updatedtime) == Utils.dateFormatter.string(from: Date())){
                                                       isuserCheckedIn =  true
                                
                            }
                        }
//                        if(Utils.dateFormatter.string(from: atte.checkInTime as! Date) == Utils.dateFormatter.string(from: Date())){
//                            isuserCheckedIn =  true
//                        }else if(Utils.dateFormatter.string(from: atte.updatedTimeIn as? Date ?? Date()) == Utils.dateFormatter.string(from: Date())){
//                            isuserCheckedIn =  true
//                        }
                        //                        if([[self.dateFormatter stringFromDate:atte.checkInTime]isEqualToString:[self.dateFormatter stringFromDate:Date()]]){
                        //                            isuserCheckedIn=  true
                        //                        }else if([[self.dateFormatter stringFromDate:atte.updatedTimeIn]isEqualToString:[self.dateFormatter stringFromDate:Date()]){
                        //                             isuserCheckedIn=  true
                        //                        }
                    }
                    if(isuserCheckedIn == true){
                        return true
                    }else{
                        let noaction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.destructive, handler: nil)
                        let yesaction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                            if  let attendanceview = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                                if let navigation = view.navigationController as? UINavigationController{
                                    navigation.pushViewController(attendanceview, animated: true)
                                }else{
                                    if let topController = UIApplication.shared.keyWindow?.rootViewController {
                                        topController.navigationController?.pushViewController(attendanceview, animated: true)
                                    }
                                }
                            }
                        }
                        if var topController = UIApplication.shared.keyWindow?.rootViewController {
                           if  let presentedViewController = topController.presentedViewController {
                            //    topController = presentedViewController
                                Common.showalert(title: "Super sales", msg: "You have not checked in attendance. Please check in attendance before checkin here", yesAction: yesaction, noAction: noaction,view:topController)
                                //Common.showalert(msg: "The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh",view:topController)
                            }else{
                                Common.showalert(title: "Super sales", msg: "You have not checked in attendance. Please check in attendance before visit", yesAction: yesaction, noAction: noaction,view:topController)
                            }
                            
                            // topController should now be your topmost view controller
                        }
                    
                        
                        return false
                    }
                    
                }else{
                    let noaction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.destructive, handler: nil)
                    let yesaction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                        if  let attendanceview = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                            if let navigation = view.navigationController as? UINavigationController{
                                navigation.pushViewController(attendanceview, animated: true)
                            }else{
                                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                                    topController.navigationController?.pushViewController(attendanceview, animated: true)
                                }
                            }
                        }
                    }
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                       if  let presentedViewController = topController.presentedViewController {
                        //    topController = presentedViewController
                            Common.showalert(title: "Super sales", msg: "You have not checked in attendance. Please check in attendance before visit", yesAction: yesaction, noAction: noaction,view:topController)
                            //Common.showalert(msg: "The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh",view:topController)
                        }else{
                            Common.showalert(title: "Super sales", msg: "You have not checked in attendance. Please check in attendance before visit", yesAction: yesaction, noAction: noaction,view:topController)
                        }
                        
                        // topController should now be your topmost view controller
                    }
                
                    return false
                }
            }
            else{
                return true
            }
        }else{
            return true
        }
    }
    // MARK: Date & Alarm
    /*
     +(NSString *)getDate:(NSDate *)date andFormat:(NSString *)format{
     dateFormat2.locale = [NSLocale localeWithLocaleIdentifier:@"en_EN"];
     [dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *dayComponent = [NSDateComponents new];
     dayComponent.day = 0;
     date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
     NSString * dateStr = [dateFormat2 stringFromDate:date];
     return dateStr;
     }
     
     **/
    
    class  func getDateinstrwithaspectedFormat(givendate:Date,format:String,defaultTimZone:Bool)->String{
        var str = ""
        dateFormatter.dateFormat = format
        dateFormatter.locale  = NSLocale.init(localeIdentifier: "en_EN") as Locale
        //  dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
        //        if  let  settingzone = Utils().getActiveAccount()?.company?.timeZone as? String{
        //            if(defaultTimZone == false){
        //            dateFormatter.timeZone = TimeZone.init(identifier: settingzone)
        //            }else{
        //                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        //            }
        //        }else{
        //            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        //        }
        
        
        let calender = Calendar.current
        var dateComponent = DateComponents.init()
        dateComponent.day = 0
        
        
        if(defaultTimZone == false){
            if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
                if(defaultTimZone == false){
                    dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
                    dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
                }else{
                    dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
                }
            }
        }else{
            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        }
        let givendate1 = calender.date(byAdding: dateComponent, to: givendate)
        
        str = dateFormatter.string(from: givendate1!)
        return str
    }
    
    //    func getDateinUTCstrwithaspectedFormat(givendate:Date,format:String,day:Int)->String{
    //        dateFormatter.dateFormat = format
    //        dateFormatter.locale  = NSLocale.init(localeIdentifier: "en_EN") as Locale
    //        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
    //        let calender = Calendar.current
    //        var dateComponent = DateComponents.init()
    //        dateComponent.day = day
    //       let givendate1 = calender.date(byAdding: dateComponent, to: givendate)
    //        let str = dateFormatter.string(from: givendate1!)
    //        return str
    //    }
    // MARK: Lead
     func CheckInPossible(view:UIViewController)->Bool{
        if(self.getActiveSetting()
            .firstCheckInAttendance == 1){
            let account =  self.getActiveAccount()
            Utils.dateFormatter.dateFormat = "dd-MM-yyyy"
            if(account?.role?.id?.intValue ?? 0 > 6){
                let arrAllAtten = AttendanceHistory.getAll()
                var isUserCheckIn = false
                if(arrAllAtten.count > 0){
                    for ate in arrAllAtten{
                        Utils.dateFormatter.dateFormat = "yyyy/MM/dd"
                        if let checkintime = ate.checkInTime as? Date{
                            if(Utils.dateFormatter.string(from: checkintime) == Utils.dateFormatter.string(from: Date())){
                                isUserCheckIn  =  true
                            }
                        }else if let updatedtime = ate.updatedTimeIn as? Date{
                            if(Utils.dateFormatter.string(from: updatedtime) == Utils.dateFormatter.string(from: Date())){
                                isUserCheckIn  =  true
                                
                            }
                        }
//                        if(Utils.dateFormatter.string(from: ate.checkInTime as! Date) == Utils.dateFormatter.string(from: Date())){
//                            isUserCheckIn = true
//                        }else if(Utils.dateFormatter.string(from: ate.updatedTimeIn as! Date) == Utils.dateFormatter.string(from: Date())){
//                            isUserCheckIn = true
//                        }
                    }
                    if(isUserCheckIn == false){
                        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
                        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
                            if let attendanceview = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                                if let navigation = view.navigationController as? UINavigationController{
                                    navigation.pushViewController(attendanceview, animated: true)
                                }else{
                                    if let topController = UIApplication.shared.keyWindow?.rootViewController {
                                        topController.navigationController?.pushViewController(attendanceview, animated: true)
                                    }
                                }
                            }
                        }
                        Common.showalertWithAction(msg: "You have not checked in attendance. Please check in attendance before visit", arrAction: [okAction,cancelAction], view: view)
                        return false
                    }else{
                        return true
                    }
                }else{
                    let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
                    let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
                        if let attendanceview = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                            if let navigation = view.navigationController as? UINavigationController{
                                navigation.pushViewController(attendanceview, animated: true)
                            }else{
                                print("not get navigation")
                                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                                    topController.navigationController?.pushViewController(attendanceview, animated: true)
                                }else{
                                  
                                }
                            }
                        }
                    }
                    Common.showalertWithAction(msg: "You have not checked in attendance. Please check in attendance before visit", arrAction: [okAction,cancelAction], view: view)
                    return false
                }
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
   class func toastmsg(message:String,view:UIView){
        // self.parentView.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription, duration: 2.0, position: CGPoint.init(x: 180, y: self.view.frame.height - 100))
        if let publicview = UIApplication.shared.keyWindow?.rootViewController?.view{
            publicview.makeToast(message, duration: 2.0, position: CGPoint.init(x: publicview.frame.size.width/2, y: publicview.frame.height - 100))
        }else{
            view.makeToast(message, duration: 2.0, position: CGPoint.init(x: view.frame.size.width/2, y: view.frame.height - 100))
        }
    }
    class func centertoastmsg(message:String,view:UIView){
         // self.parentView.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription, duration: 2.0, position: CGPoint.init(x: 180, y: self.view.frame.height - 100))
         if let publicview = UIApplication.shared.keyWindow?.rootViewController?.view{
             publicview.makeToast(message, duration: 2.0, position: CGPoint.init(x: publicview.frame.size.width/2, y: publicview.frame.height/2 - 50))
         }else{
             view.makeToast(message, duration: 2.0, position: CGPoint.init(x: view.frame.size.width/2, y: view.frame.height/2 - 50))
         }
     }
   class  func latestCheckinDetailForLead(lead:Lead)->(String,UserLatestActivityForLead){
        if(lead.leadCheckInOutList.count == 0){
            return ("Not checked-in yet",UserLatestActivityForLead.none
            )
        }else{
            
            
            let activeuser = Utils().getActiveAccount()
            let arrOfCheckedinLeadByAll = lead.leadCheckInOutList.array as? [LeadCheckInOutList]
            let arrOfCheckedinLeadByActiveUser = arrOfCheckedinLeadByAll?.filter { checkin in
          
              return
                checkin.createdBy == activeuser?.userID?.int64Value
            }
        
            if let latestCheckin =  arrOfCheckedinLeadByActiveUser?.first as? LeadCheckInOutList{
                var strTime = ""
                if(latestCheckin.checkInTime.count > 0){
                    if let checkout = latestCheckin.checkOutTime as? String{
                        if let strco = Utils.getDateBigFormatToDefaultFormat(date:  checkout , format: "yyyy/MM/dd HH:mm:ss") as? String{
                            if(strco.count > 0){
                                strTime = Utils.getDatestringWithGMT(gmtDateString:strco, format: "hh:mm a")
                                return("you have checkout at \(strTime)",UserLatestActivityForLead.checkedOut)
                            }else{
                                if let strci = Utils.getDateBigFormatToDefaultFormat(date:  latestCheckin.checkInTime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                    if(strci.count > 0){
                                        strTime = Utils.getDatestringWithGMT(gmtDateString: strci, format: "hh:mm a")
                                        let checkintime = Utils.getDateBigFormatToDefaultFormat(date: latestCheckin.checkInTime, format: "dd-MM-yyyy")
                                        let dateformatter = DateFormatter.init()
                                        dateformatter.dateFormat = "dd-MM-yyyy"
                                        let dateinstring = dateformatter.string(from: Date())
                                        if(dateinstring == checkintime){
                                        return("You have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                                        }else{
                                            return("Not Checked-in yet",UserLatestActivityForLead.none)
                                            
                                        }
                                      //  return("you have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                                    }else{
                                        return ("Not checked-in yet",UserLatestActivityForLead.none
                                        )
                                    }
                                }else{
                                    return ("Not checked-in yet",UserLatestActivityForLead.none
                                    )
                                }
                            }
                        }else{
                            if let strci = Utils.getDateBigFormatToDefaultFormat(date:  latestCheckin.checkInTime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strTime = Utils.getDatestringWithGMT(gmtDateString: strci, format: "hh:mm a")
                                let checkintime = Utils.getDateBigFormatToDefaultFormat(date: latestCheckin.checkInTime, format: "dd-MM-yyyy")
                                let dateformatter = DateFormatter.init()
                                dateformatter.dateFormat = "dd-MM-yyyy"
                                let dateinstring = dateformatter.string(from: Date())
                                if(dateinstring == checkintime){
                                    let checkintime = Utils.getDateBigFormatToDefaultFormat(date: latestCheckin.checkInTime, format: "dd-MM-yyyy")
                                    let dateformatter = DateFormatter.init()
                                    dateformatter.dateFormat = "dd-MM-yyyy"
                                    let dateinstring = dateformatter.string(from: Date())
                                    if(dateinstring == checkintime){
                                    return("You have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                                    }else{
                                        return("Not Checked-in yet",UserLatestActivityForLead.none)
                                        
                                    }
                              //  return("You have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                                }else{
                                    return("Not Checked-in yet",UserLatestActivityForLead.none)
                                    
                                }
                               // return("you have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                                
                            }else{
                                return ("Not checked-in yet",UserLatestActivityForLead.none)
                            }
                        }
                        
                    }else{
                        if let strci = Utils.getDateBigFormatToDefaultFormat(date:  latestCheckin.checkInTime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strTime = Utils.getDatestringWithGMT(gmtDateString: strci, format: "hh:mm a")
                        }
                        let checkintime = Utils.getDateBigFormatToDefaultFormat(date: latestCheckin.checkInTime, format: "dd-MM-yyyy")
                        let dateformatter = DateFormatter.init()
                        dateformatter.dateFormat = "dd-MM-yyyy"
                        let dateinstring = dateformatter.string(from: Date())
                        if(dateinstring == checkintime){
                            let checkintime = Utils.getDateBigFormatToDefaultFormat(date: latestCheckin.checkInTime, format: "dd-MM-yyyy")
                            let dateformatter = DateFormatter.init()
                            dateformatter.dateFormat = "dd-MM-yyyy"
                            let dateinstring = dateformatter.string(from: Date())
                            if(dateinstring == checkintime){
                            return("You have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                            }else{
                                return("Not Checked-in yet",UserLatestActivityForLead.none)
                                
                            }
                    //    return("You have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                        }else{
                            return("Not Checked-in yet",UserLatestActivityForLead.none)
                            
                        }
                       // return("you have checked-in at \(strTime)",UserLatestActivityForLead.checkedIn)
                    }
                }else if(latestCheckin.checkOutTime.count > 0){
                    
                    if  let checkouttime = latestCheckin.checkOutTime  as? String{
                        if let strco = Utils.getDateBigFormatToDefaultFormat(date:checkouttime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strTime = Utils.getDatestringWithGMT(gmtDateString:strco, format: "hh:mm a")
                        }
                        return("you have checkout at \(strTime)",UserLatestActivityForLead.checkedOut)
                    }else{
                        return("Not Checked-in yet",UserLatestActivityForLead.none)
                    }
                }else{
                    return ("Not checked-in yet",UserLatestActivityForLead.none)
                }
            }else{
                return ("Not checked-in yet",UserLatestActivityForLead.none)
            }
        }
    }
    func isCheckedOut(leadID:NSNumber,userID:NSNumber)->Bool{
        if let checkoutList = LeadCheckInOutList.getLeadCheckinoutFromIdForUser(leadId: leadID,createdBy: userID) as? LeadCheckInOutList{
            if(checkoutList.createdTime.components(separatedBy: " ").first == Utils.getDateinstrwithaspectedFormat(givendate: Date(), format: "yyyy/MM/dd",defaultTimZone:false)){
                if let checkouttime = checkoutList.checkOutTime as? String{
                    return true
                }else{
                    return false
                }
            }
        }
        return true
    }
    class func isCheckOutLead1(leadID:NSNumber,userID:NSNumber)->LeadCheckInOutList?{
        
        if let checkoutList = LeadCheckInOutList.getLeadCheckinoutFromIdForUser(leadId: leadID,createdBy: userID) as? LeadCheckInOutList{
            return checkoutList
        }else{
            return nil
        }
    }
    
    //MARK: - Color
   class  func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK: - Extra Method
    class  func isAlaramPossible(dict:[String:Any])->Bool{
        let account = Utils().getActiveAccount()
        if(NSNumber.init(value: dict["ReAssigned"] as? Int ?? 0 ) == account?.userID){
            //if(dict["LeadCheckInOutList"] )
            let arrcheckincheckout = dict["VisitCheckInCheckOutList"] as? [[String:Any]] ?? [[String:Any]]()
            var v1 = [String:Any]()
            if(arrcheckincheckout.count > 0){
                for dict in arrcheckincheckout{
                    if((dict["CreatedBy"]) as? Int ?? 0 == account?.userID?.intValue){
                        v1 = dict
                        break
                    }
                }
                if(v1.keys.count > 0){
                    if ((dict["NextActionTime"] as? String ?? "") == (dict["OriginalNextActionTime"] as? String ?? "")) {
                        return false;
                    }else{
                        return true;
                    }
                }else{
                    return true
                }
            }else{
                return true
            }
            
        }else{
            return true
        }
        
    }
    func isAlaram1Possible(dict:[String:Any])->Bool{
        let account = Utils().getActiveAccount()
        if(NSNumber.init(value: dict["ReAssigned"] as? Int ?? 0 ) == account?.userID){
            //if(dict["LeadCheckInOutList"] )
            let arrcheckincheckout = dict["LeadCheckInOutList"] as? [[String:Any]] ?? [[String:Any]]()
            var v1 = [String:Any]()
            if(arrcheckincheckout.count > 0){
                for dict in arrcheckincheckout{
                    if((dict["CreatedBy"]) as? Int ?? 0 == account?.userID?.intValue){
                        v1 = dict
                        break
                    }
                }
                if(v1.keys.count > 0){
                    if ((dict["NextActionTime"] as? String ?? "") == (dict["OriginalNextActionTime"] as? String ?? "")) {
                        return false;
                    }else{
                        return true;
                    }
                }else{
                    return true
                }
            }else{
                return true
            }
            
        }else{
            return true
        }
        
    }
    
   class  func cancelAlaram(userInfo:[String:Any]){
        let arrOfLocalNotification = UIApplication.shared.scheduledLocalNotifications ?? [UILocalNotification]()
        if(arrOfLocalNotification.count > 0){
            for localNotification in arrOfLocalNotification {
                if(localNotification .isEqual(userInfo)){
                    UIApplication.shared.cancelLocalNotification(localNotification)
                }
            }
        }
    }
    
    /*+(void)scheduleAlarm:(NSString *)nTitle category:(NSString *)nCategory message:(NSString *)nMessage date:(NSDate *)nDate userInfo:(NSDictionary *)userInfo{
     UILocalNotification *alarm = [[UILocalNotification alloc] init];
     alarm.alertTitle = nTitle;
     alarm.category = nCategory;
     alarm.alertBody = nMessage;
     alarm.fireDate = nDate;
     alarm.soundName = UILocalNotificationDefaultSoundName;
     alarm.userInfo = userInfo;
     [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
     NSLog(@"the alarm is scheduled is %@", alarm.userInfo);
     }*/
    class func scheduleAlarm(title:String,category:String,message:String,date:Date,userInfo:[String:Any]){
        let alaram = UILocalNotification()
        alaram.alertTitle = title
        alaram.category =  category
        alaram.alertBody =  message
        alaram.fireDate = date
        alaram.soundName = UILocalNotificationDefaultSoundName
        alaram.userInfo =  userInfo
        UIApplication.shared.scheduleLocalNotification(alaram)
    }
    
    class func getDateBigFormatToCurrent(date:String,format:String)->Date{
        var date3 = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy, hh:mm a"
//        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
//        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
//        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
//           
//                dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
//                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
//              
//            }else{
//                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
//                
//            }
        let date1 = dateFormatter.date(from: date)
        if let date11 = date1 {
            date3 = date11
        }else{
            dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm a"
            let date2 = dateFormatter.date(from: date)
            if let date44  = date2{
                date3 =  date44
            }else{
                dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"//"dd-MM-YYYY, hh:mm a"
                let date5 = dateFormatter.date(from: date)
                date3 = date5 ?? Date()
            }
        }
        return date3
    }
    
    class func getDatestringWithGMT(gmtDateString:String,format:String)->String{
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //Create the date assuming the given string is in GMT
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
        if  let date = dateFormatter.date(from: gmtDateString) as? Date{
        //Create a date string in the local timezone
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
       
//        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
//           
//               // dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
//                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
//              //  datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
//            }else{
//                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
//              //  datecomponent.timeZone = NSTimeZone.default
//            }
        dateFormatter.dateFormat = format
        let localdatestring = dateFormatter.string(from: date)
      
        return localdatestring
        }else{
            dateFormatter.dateFormat = "dd-MM-yyyy"
            //Create the date assuming the given string is in GMT
            dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
            if  let date1 = dateFormatter.date(from: gmtDateString) as? Date{
            //Create a date string in the local timezone
            dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
           
    //        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
    //
    //               // dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
    //                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
    //              //  datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
    //            }else{
    //                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
    //              //  datecomponent.timeZone = NSTimeZone.default
    //            }
            dateFormatter.dateFormat = format
            let localdatestring1 = dateFormatter.string(from: date1)
          
            return localdatestring1
            }else{
                let date2 = Date()
                dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
               
        //        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
        //
        //               // dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
        //                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
        //              //  datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
        //            }else{
        //                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        //              //  datecomponent.timeZone = NSTimeZone.default
        //            }
                dateFormatter.dateFormat = format
                let localdatestring1 = dateFormatter.string(from: date2)
              
                return localdatestring1
            }
        }
    }
    
    /*func getDateBigFormatToDefaultFormat(date:String,format:String)->String{
     dateFormatter.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
     if(date.contains(",")){
     dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
     }else{
     dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
     }
     let date1 = dateFormatter.date(from: date)
     dateFormatter.dateFormat =  format
     let strdate = dateFormatter.string(from: date1 ?? Date())
     return strdate
     }*/
    
    class func getDateBigFormatToDefaultFormat(date:String,format:String)->String?{
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
//        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
//           
//               // dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
//                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
//              //  datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
//            }else{
//                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
//              //  datecomponent.timeZone = NSTimeZone.default
//            }
        if(date.contains(",")){
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        }else{
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        }
        if let date1 = dateFormatter.date(from: date) as? Date{
            dateFormatter.dateFormat =  format
            if let strdate = dateFormatter.string(from: date1) as? String{
                return strdate
            }
        }else{
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            if let date1 = dateFormatter.date(from: date) as? Date{
                dateFormatter.dateFormat =  format
                if let strdate = dateFormatter.string(from: date1) as? String{
                    return strdate
                }else{
            return nil
                }
            }else{
                return nil
            }
    }
    }
    class func getDateFromString(date:String)->Date{
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
        if let strdate = dateFormatter.date(from: date) {
            return strdate
        }else{
            return Date()
        }
    }
    
    class func getstringFromOneFormatToOther(fFormat:String,stringindate:String,sFormat:String)->String?{
        dateFormatter.dateFormat = fFormat
        if let date = dateFormatter.date(from: stringindate) as? Date{
        dateFormatter.dateFormat = sFormat
        let string = dateFormatter.string(from: date)
        return string
        }else{
            return nil
        }
    }
    class func getDateFromStringWithFormat(gmtDateString:String)->Date{
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"//"yyyy/MM/dd"
        //Create the date assuming the given string is in GMT
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
        if  let strdate = dateFormatter.date(from: gmtDateString){
            return strdate
        }else{
            return Date()
        }
    }
    
    class func getNSDateWithAppendingDay(day:Int,date1:Date,format:String)->Date{
        /*
         date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
         NSString * dateStr = [dateFormat2 stringFromDate:date];
         NSDate *nsdate = [dateFormat2 dateFromString:dateStr];
         return nsdate;
         */
        dateFormatter.dateFormat =  format
        
        var datecomponent = DateComponents.init()
        datecomponent.day = day
        let date = calender.date(byAdding: datecomponent, to: date1)
        let datestr = dateFormatter.string(from: date ?? Date())
        let datereturn = dateFormatter.date(from: datestr)
        return datereturn ?? Date()
    }
    
    class func getDateWithAppendingDay(day:Int,date:Date,format:String,defaultTimeZone:Bool)->String{
        dateFormatter.dateFormat =  format
        var datecomponent = DateComponents()
        datecomponent.day = day
        // dateFormatter.locale =  Locale(identifier: "en_EN")//NSLocale().local//"en_EN"
       // datecomponent.timeZone = NSTimeZone.default
        if(defaultTimeZone){
        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
           
                dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
                datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
            }else{
                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
                datecomponent.timeZone = NSTimeZone.default
            }
        }else{
          //  dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
            datecomponent.timeZone = NSTimeZone.default
        }
    
        let  date1 = calender.date(byAdding: datecomponent, to: date)
        let str = dateFormatter.string(from: date1 ?? Date())
        return str
        
    }
    class func getDateUTCWithAppendingDay(day:Int,date:Date,format:String,defaultTimeZone:Bool)->String{
        dateFormatter.dateFormat =  format
        var datecomponent = DateComponents()
        datecomponent.day = day
         dateFormatter.locale =  Locale(identifier: "en_EN")//NSLocale().local//"en_EN"
       // datecomponent.timeZone = NSTimeZone.default
        if(!defaultTimeZone){
        if let companytimezone = Utils().getActiveAccount()?.company?.timeZone as? String{
           
                dateFormatter.locale  = NSLocale.init(localeIdentifier: "US") as Locale
                dateFormatter.timeZone =  TimeZone.init(identifier:companytimezone)
                datecomponent.timeZone = TimeZone.init(identifier:companytimezone)
            }else{
                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
                datecomponent.timeZone = NSTimeZone.default
            }
        }else{
            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
            datecomponent.timeZone = NSTimeZone.default
        }
    
        let  date1 = calender.date(byAdding: datecomponent, to: date)
        let str = dateFormatter.string(from: date1 ?? Date())
        return str
    }
    
    
    class func getDate(date:NSDate,withFormat:String)->String{
        dateFormatter.dateFormat = withFormat
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        var datecomponent = DateComponents()
        datecomponent.day = 0
        var str = ""
        if  let  date1 = calender.date(byAdding: datecomponent, to: date as Date){
            if let str3 = dateFormatter.string(from: date1) as? String{
                str = str3
            }
            
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
            if(str.count == 0){
            if let str1 = dateFormatter.string(from: date1) as? String{
                str = str1
            }
            }
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if(str.count == 0){
                if let str2 = dateFormatter.string(from: date1) as? String{
                    str = str2
                }
            }
        }
       
        
        return str
    }
    /*
     +(NSString *)getDate:(NSDate *)date andFormat:(NSString *)format{
     NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
     [dateFormat2 setDateFormat:format];
     dateFormat2.locale = [NSLocale localeWithLocaleIdentifier:@"en_EN"];
     [dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *dayComponent = [NSDateComponents new];
     dayComponent.day = 0;
     date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
     NSString * dateStr = [dateFormat2 stringFromDate:date];
     return dateStr;
     }
     
     
     **/
    
    class func    getDateWithAppendingDayLang(day:Int,date:Date,format: String) -> String {
        //   let df = DateFormatter.init()
        dateFormatter.locale = Locale.init(identifier: "en_EN")
        dateFormatter.dateFormat =  format
        let calender = Calendar.current
        var dayComponent = DateComponents.init()
        dayComponent.day = day
        dayComponent.timeZone = NSTimeZone.default
        let  date1 = calender.date(byAdding: dayComponent , to: date)
        //calender.date(byAdding: dayComponent, to: date , options:[])
        let datestr = dateFormatter.string(from: date1 ?? Date())
        return datestr
    }
    
    
    class func    getDateWithAppendingmonthLang(month:Int,date:Date,format: String) -> String {
        //   let df = DateFormatter.init()
        dateFormatter.locale = Locale.init(identifier: "en_EN")
        dateFormatter.dateFormat =  format
        let calender = Calendar.current
        var dayComponent = DateComponents.init()
        dayComponent.month = month
        dayComponent.timeZone = NSTimeZone.default
        let  date1 = calender.date(byAdding: dayComponent , to: date)
        //calender.date(byAdding: dayComponent, to: date , options:[])
        let datestr = dateFormatter.string(from: date1 ?? Date())
        return datestr
    }
    
    class func getStringFromDateInRequireFormat(format:String,date:Date)      -> String{
        dateFormatter.dateFormat =  format
        let str = dateFormatter.string(from: date)
        return str
    }
    
    class func date(date: Date, beginDate: Date, endDate: Date) -> Bool {
        if (date.compare(beginDate) == .orderedAscending){
            return false;
        }
        if (date.compare(endDate) == .orderedDescending){
            return false;
        }
        return true;
    }
    
    // MARK: Useful methods
    //
    
    class func secondsToMinutesSeconds(seconds: Int) -> String {
        let secondsFromSeconds: Int = seconds % 60
        let minutes: Int = (seconds / 60) //% 60
        let hours: Int = seconds / 120 //%02d,
        if (secondsFromSeconds == 0 && minutes < 10) {
            return String(format: "%01d:%01d", minutes, secondsFromSeconds)
        }
        else if (secondsFromSeconds > 0 && minutes < 10) {
            return String(format: "%01d:%02d", minutes, secondsFromSeconds)
        }
        else if(secondsFromSeconds > 0 && minutes > 10){
            return String(format: "%02d:%02d", minutes, secondsFromSeconds)
        }
        else if((minutes < 10) && (hours == 0)){
            return String(format: "%01d:%02d", minutes, secondsFromSeconds)
        }else if((minutes > 10)&&(hours == 0)){
            return String(format: "%02d:%02d", minutes, secondsFromSeconds)
        }else if((minutes < 10) && (hours < 10)){
            return String(format: "%01d%01d:%02d",hours, minutes, secondsFromSeconds)
        }else if(hours > 24){
            return String(format: "%02d:%01d:%02d", hours,minutes, secondsFromSeconds)
        }else{
            return String(format: "%01d:%02d", minutes, secondsFromSeconds)
        }
    }
    
    class func differenceOfMinutes(previTime:String,nextTime:String)->Int{
        //return minute
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        let previDate = dateformatter.date(from: previTime) ?? Date()
        let nextDate = dateformatter.date(from: nextTime) ?? Date()
        dateformatter.dateFormat = "HH:mm"
//        print("previus time = \(previTime) , next time = \(nextTime)")
//        print("previos date = \(previDate) , next Date = \(nextDate)")
        let strPreTime = dateformatter.string(from: previDate)
        let strNextTime = dateformatter.string(from: nextDate)
       // print("String Previous time = \(strPreTime) , next time = \(strNextTime)")
        //  let str24hrformat =
        let oldcomponents = strPreTime.components(separatedBy: ":")//previTime.components(separatedBy: ":")
        let newcomponents = strNextTime.components(separatedBy: ":")//nextTime.components(separatedBy: ":")
        var min = 0
        if(oldcomponents.first != newcomponents.first){
          
            var newmhours = Int(newcomponents.first ?? "0") ?? 0
            var oldhours = Int(oldcomponents.first ?? "0") ?? 0
            if let newminute = Int(newcomponents.first ?? "0") {
                newmhours = newminute
            }
            if let oldminute = Int(oldcomponents.first ?? "0") {
                oldhours = oldminute
            }
            var hours = 0
            if(newmhours > oldhours){
                hours =  newmhours - oldhours
            }
            
            min = hours*60
            print("different of minutes = \(min) with hours")
            //  min as! Decimal += NSNumber.init(value:hours*60)
        }
        
        if(oldcomponents.last != newcomponents.last){
          
            // let stronlyminold = oldcomponents.last.re
            
            var newmin = Int(newcomponents.last ?? "0") ?? 0
            var oldmin = Int(oldcomponents.last ?? "0") ?? 0
            if let newminute = Int(newcomponents.last ?? "0") {
                newmin = newminute
            }
            if let oldminute = Int(oldcomponents.last ?? "0") {
                oldmin = oldminute
            }
            var minus  = 0
            // let minus = newmin - oldmin
//            if(newmin > oldmin){
//                minus =  newmin - oldmin
//            }else{
//                minus = oldmin - newmin
//            }
         
            if(newmin > 0){
                min += newmin
            }
           // if(min > 60){
            if(oldmin > 0){
                min -=  oldmin
            }
       // }
            print("different of minutes = \(minus)")
           // min += minus
        }
        print("minutes = \(min) , previous time = \(previTime) , nexttime = \(nextTime) in method ")
        return min
    }
    class func minutesSecondsToSeconds(totalTime:String)->NSNumber{
        /*NSArray *components = [string componentsSeparatedByString:@":"];
         
         NSInteger hours   = [[components objectAtIndex:0] integerValue];
         NSInteger minutes = [[components objectAtIndex:1] integerValue];
         NSInteger seconds = [[components objectAtIndex:2] integerValue];
         
         return [NSNumber numberWithInteger:(hours * 60 * 60) + (minutes * 60) + seconds];*/
        let components = totalTime.components(separatedBy: ":")
        var minutes = Int64(0)
        var seconds = Int64(0)
        if(components.count > 1){
            minutes = Int64(components[0]) ?? 0
            seconds = Int64(components[1]) ?? 0
        }else if(components.count > 0){
            seconds = Int64(components[0]) ?? 0
        }
        return NSNumber.init(value: (((minutes) * 60) + seconds))
    }
    
    class func isCheckedOUT(visitID:NSNumber,userId:NSNumber)->Bool{
        if  let visitcheckinoutlist = VisitCheckInOutList().getVisitCheckInOutListFromID(visitby: visitID,cby: userId){
//            if(visitcheckinoutlist.iD == 0){
//                return false
//            }else
            if(self.getDateBigFormatToDefaultFormat(date:visitcheckinoutlist.createdTime , format: "yyyy/MM/dd HH:mm:ss")?.components(separatedBy: " ").first == Utils.getDate(date: Date() as NSDate, withFormat: "yyyy/MM/dd") ){//self.getDateinstrwithaspectedFormat(givendate: Date(), format: "yyyy/MM/dd", defaultTimZone: false)
                if((visitcheckinoutlist.checkInTime.count) > 0 ){
                    if let checkout = visitcheckinoutlist.checkOutTime as? String{
                        if(checkout.count == 0){
                            return true
                        }else{
                            return true
                        }
                   
                    }else{
                        return true
                    }
                }else{
                    return false
                }
            }else{
                return false
            }
        }
        else{
            return false
        }
        
    }
    
    class func isCheckedOUT1(visitID:NSNumber,createdBy:NSNumber)->VisitCheckInOutList?{
        if  let visitcheckinout = VisitCheckInOutList().getVisitCheckInOutListFromID(visitby: visitID,cby: createdBy){
            return visitcheckinout
        }else{
            return nil
        }
    }
    
    class func latestCheckinDetailForPlanedVisit(visit:PlannVisit)->(String,UserLatestActivityForVisit){
        
        if(visit.checkInOutData.count == 0){
            return("Not checked-in yet",UserLatestActivityForVisit.none)
        }else{
            let activeuser = Utils().getActiveAccount()
            let arrOfCheckedinVisitByAll = visit.checkInOutData.array as? [VisitCheckInOutList]
            let arrOfCheckedinVisitByActiveUser = arrOfCheckedinVisitByAll?.filter { checkin in
            //    print("created by = \(checkin.createdBy) , active user = \(activeuser?.userID?.int64Value)")
              return  checkin.createdBy == activeuser?.userID?.int64Value
            }
            if    let LatestCheckInOut = arrOfCheckedinVisitByActiveUser?.first as? VisitCheckInOutList {
//                if let checkintime = LatestCheckInOut.checkInTime as? String{
//
//                }
                var strTime = ""
              
               
              
                if(LatestCheckInOut.checkInTime.count > 0){
                    if  let checkouttime = LatestCheckInOut.checkOutTime {
                        if let strco = self.getDateBigFormatToDefaultFormat(date:  checkouttime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strTime = self.getDatestringWithGMT(gmtDateString:
                                                                    strco
                                                                , format: "hh:mm a")
                        }
                        return("You have checkout at \(strTime)",UserLatestActivityForVisit.checkedOut)
                    }else{
                        print("checkin time = \(LatestCheckInOut.checkInTime)")
                        if let strci = self.getDateBigFormatToDefaultFormat(date:  LatestCheckInOut.checkInTime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strTime = self.getDatestringWithGMT(gmtDateString: strci, format: "hh:mm a")
                        }
                        
                        let checkintime = //Utils.getDateBigFormatToDefaultFormat(date: LatestCheckInOut.checkInTime, format: "dd-MM-yyyy")
                        Utils.getDatestringWithGMT(gmtDateString: LatestCheckInOut.checkInTime, format: "dd-MM-yyyy")
                        let dateformatter = DateFormatter.init()
                        dateformatter.dateFormat = "dd-MM-yyyy"
                        let dateinstring = dateformatter.string(from: Date())
                        if(dateinstring == checkintime){
                        return("You have checked-in at \(strTime)",UserLatestActivityForVisit.checkedIn)
                        }else{
                            print("dateinstring = \(dateinstring) and checkintime = \(checkintime)")
                            return("Not Checked-in yet",UserLatestActivityForVisit.none)
                            
                        }
                    }
                }else if(LatestCheckInOut.checkOutTime.count > 0){
                    
                    if  let checkouttime = LatestCheckInOut.checkOutTime {
                        if let strco = self.getDateBigFormatToDefaultFormat(date:checkouttime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strTime = self.getDatestringWithGMT(gmtDateString:strco
                                                                
                                                                , format: "hh:mm a")
                        }
                        return("You have checkout at \(strTime)",UserLatestActivityForVisit.checkedOut)
                    }else{
                        return("Not Checked-in yet",UserLatestActivityForVisit.none)
                    }
                }else{
                    return("Not Checked-in yet",UserLatestActivityForVisit.none)
                }
            
        
            }else{
                return("Not Checked-in yet",UserLatestActivityForVisit.none)
            }
        }
    }
    
    class func latestCheckinForActivity(activity:Activity)->(String,UserLatestActivityForVisit){
        if(activity.activityCheckInCheckOutList.count == 0){
            return("Not Checked-in yet",UserLatestActivityForVisit.none)
        }else{
            let arrOfCheckedinActivityByAll = activity.activityCheckInCheckOutList.array as? [ActivityCheckinCheckout]
            let activeuser = Utils().getActiveAccount()
            let arrOfCheckedinActivityByActiveUser = arrOfCheckedinActivityByAll?.filter { checkin in
             //   print("created by = \(checkin.createdBy) , active user = \(activeuser?.userID?.int64Value)")
              return  checkin.createdBy == activeuser?.userID?.int64Value
            }
       //     if    let LatestCheckInOut = arrOfCheckedinUnVisitByActiveUser
            if  let LatestCheckInOut = arrOfCheckedinActivityByActiveUser?.first as? ActivityCheckinCheckout {
                
                var strTime = ""
                
                if(LatestCheckInOut.checkInTime.count > 0){
                    if  let checkouttime = LatestCheckInOut.checkOutTime as? String{
                        if(checkouttime.count > 0){
                            if let strco = self.getDateBigFormatToDefaultFormat(date:  checkouttime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strTime = self.getDatestringWithGMT(gmtDateString:
                                                                        strco
                                                                    , format: "hh:mm a")
                            }
                            return("You have checkout at \(strTime)",UserLatestActivityForVisit.checkedOut)
                        }else{
                            if let strci = self.getDateBigFormatToDefaultFormat(date:  LatestCheckInOut.checkInTime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strTime = self.getDatestringWithGMT(gmtDateString: strci, format: "hh:mm a")
                            } //self.getDatestringWithGMT(gmtDateString: LatestCheckInOut.checkInTime, format: "hh:mm a")
                            let checkintime = Utils.getDateBigFormatToDefaultFormat(date: LatestCheckInOut.checkInTime, format: "dd-MM-yyyy")
                            let dateformatter = DateFormatter.init()
                            dateformatter.dateFormat = "dd-MM-yyyy"
                            let dateinstring = dateformatter.string(from: Date())
                            if(dateinstring == checkintime){
                            return("You have checked-in at \(strTime)",UserLatestActivityForVisit.checkedIn)
                            }else{
                                return("Not Checked-in yet",UserLatestActivityForVisit.none)
                                
                            }
                           // return("You have checked-in at \(strTime)",UserLatestActivityForVisit.checkedIn)
                        }
                    }else{
                        if let strci = self.getDateBigFormatToDefaultFormat(date:  LatestCheckInOut.checkInTime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strTime = self.getDatestringWithGMT(gmtDateString: strci, format: "hh:mm a")
                        } //self.getDatestringWithGMT(gmtDateString: LatestCheckInOut.checkInTime, format: "hh:mm a")
                        let checkintime = Utils.getDateBigFormatToDefaultFormat(date: LatestCheckInOut.checkInTime, format: "dd-MM-yyyy")
                        let dateformatter = DateFormatter.init()
                        dateformatter.dateFormat = "dd-MM-yyyy"
                        let dateinstring = dateformatter.string(from: Date())
                        if(dateinstring == checkintime){
                        return("You have checked-in at \(strTime)",UserLatestActivityForVisit.checkedIn)
                        }else{
                            return("Not Checked-in yet",UserLatestActivityForVisit.none)
                            
                        }
                      //  return("You have checked-in at \(strTime)",UserLatestActivityForVisit.checkedIn)
                    }
                }else if(LatestCheckInOut.checkOutTime.count > 0){
                    
                    if  let checkouttime = LatestCheckInOut.checkOutTime as? String{
                        if(checkouttime.count > 0){
                            if let strco = self.getDateBigFormatToDefaultFormat(date:checkouttime , format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strTime = self.getDatestringWithGMT(gmtDateString:strco
                                                                    
                                                                    , format: "hh:mm a")
                            }
                            return("You have checkout at \(strTime)",UserLatestActivityForVisit.checkedOut)
                        }else{
                            return("Not Checked-in yet",UserLatestActivityForVisit.none)
                        }
                    }else{
                        return("Not Checked-in yet",UserLatestActivityForVisit.none)
                    }
                }else{
                    return("Not Checked-in yet",UserLatestActivityForVisit.none)
                }
            }else{
                return("Not Checked-in yet",UserLatestActivityForVisit.none)
            }
        }
    }
    
    class func latestCheckinDetailForUnPlanedVisit(visit:UnplannedVisit)->(String,UserLatestActivityForVisit){
        if(visit.checkInList?.count == 0){
            return("Not Checked-in yet",UserLatestActivityForVisit.none)
        }else{
            var strTime = ""
            let activeuser = Utils().getActiveAccount()
            let arrOfCheckedinUnVisitByAll = visit.checkInList as? [CheckInData]
            let arrOfCheckedinUnVisitByActiveUser = arrOfCheckedinUnVisitByAll?.filter { checkin in
              //  print("created by = \(checkin.createdBy) , active user = \(activeuser?.userID?.int64Value)")
              return  checkin.createdBy == activeuser?.userID?.intValue
            }
       //     if    let LatestCheckInOut = arrOfCheckedinUnVisitByActiveUser
            let lastcheckinDetail = arrOfCheckedinUnVisitByActiveUser?.first
           
            if(lastcheckinDetail?.checkInTime?.count ?? 0  > 0){
                if(lastcheckinDetail?.checkOutTime?.count ?? 0 > 0 ){
                    strTime = self.getDatestringWithGMT(gmtDateString: lastcheckinDetail?.checkOutTime ?? "", format: "hh:mm a")
                    return("you have checkedout at \(strTime)",UserLatestActivityForVisit.checkedOut)
                }else{
                    strTime = self.getDatestringWithGMT(gmtDateString: lastcheckinDetail?.checkInTime ?? "", format: "hh:mm a")
                    let checkintime = Utils.getDateBigFormatToDefaultFormat(date: lastcheckinDetail?.checkInTime ?? "", format: "dd-MM-yyyy")
                    let dateformatter = DateFormatter.init()
                    dateformatter.dateFormat = "dd-MM-yyyy"
                    let dateinstring = dateformatter.string(from: Date())
                    if(dateinstring == checkintime){
                    return("You have checked-in at \(strTime)",UserLatestActivityForVisit.checkedIn)
                    }else{
                        return("Not Checked-in yet",UserLatestActivityForVisit.none)
                        
                    }
                  
                }
            }else{
                return("Not Checked-in yet",UserLatestActivityForVisit.none)
            }
            
            // return("checkin or checkout have to check",LatestCheckinForEmployee.none)
        }
    }
    class func numberOfDaysBetween(_ from: Date, _ to: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: from, to: to)
        if components.day ?? 0 > 1 {
            return components.day ?? 0 + 1
        }else{
            return components.day ?? 0
        }
       
    }

    
    //    func isreachable()->(Bool){
    //       let reachability = try! Reachability()
    //        reachability.whenReachable = { reachability in
    //            if reachability.connection == .wifi {
    //                print("Reachable via WiFi")
    //
    //            } else {
    //                print("Reachable via Cellular")
    //            }
    //            return true
    //        }
    //        reachability.whenUnreachable = { _ in
    //            print("Not reachable")
    //            return false
    //        }
    //
    //        do {
    //            try reachability.startNotifier()
    //        } catch {
    //            print("Unable to start notifier")
    //        }
    //    }
}
//func getActiveAccount()->Account{
//    
//    
//}
