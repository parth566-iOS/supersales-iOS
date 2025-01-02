//
//  AddVisitCounterShare.swift
//  SuperSales
//
//  Created by Apple on 13/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import FastEasyMapping

class AddVisitCounterShare: BaseViewController {
    var planvisitobj:PlannVisit!
    var visitType:VisitType!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var txtLightSalesValue: UITextField!
    
    @IBOutlet weak var txtPhilipsSalesValue: UITextField!
    
    @IBOutlet weak var txtCompetitorName: UITextField!
    
    @IBOutlet weak var txtCompetitorShare: UITextField!
    
    @IBOutlet weak var txtCompetitorName2: UITextField!
    
    @IBOutlet weak var txtCompetitorShare2: UITextField!
    
    @IBOutlet weak var vwSubCat: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    var isEnteredCompShareValue:Bool = false
    @IBOutlet weak var cnstTableViewHeight: NSLayoutConstraint!
    
    var temp:[ProdCategory]! = [ProdCategory]()
    var tableViewHeight: CGFloat {
        tblView.layoutIfNeeded()
        return tblView.contentSize.height
    }
    var msg = ""
    var customer = CustomerDetails()
    var isEdit:Bool!
    var counterShare:VisitCounterShare?
     var arrSubCategory = [[String:Any]]()
//    var tableViewHeight: CGFloat {
//        tblProductListing.layoutIfNeeded()
//        return tblProductListing.contentSize.height
//    }
    var dropdownCompetitior1:DropDown = DropDown()
  //  var dropdownCompertitor2:DropDown = DropDown()
    var arrCompetitor:[StoreCompetition] = [StoreCompetition]()
    
    //for exapnd collapse
    var hiddenSections = Set<Int>()
    // MARK: View Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
            self.tblView.removeObserver(self, forKeyPath: "contentSize")
       
        super.viewDidAppear(true)
        if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planvisitobj.customerID)){
            
        }else{
            self.apihelper.getCustomerDetail(cid: NSNumber.init(value:planvisitobj.customerID))
        }
        
        self.setUI()
        self.getCompetitior()
    }
    // MARK: Method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){

            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                cnstTableViewHeight.constant = newsize.height
            }
        }
    }
    func setUI(){
        if(visitType == VisitType.planedvisitHistory || visitType  == VisitType.coldcallvisitHistory){
            btnSubmit.isHidden = true
            
            btnSubmit.isUserInteractionEnabled = false
        }else{
            btnSubmit.isHidden = false
            
            
            btnSubmit.isUserInteractionEnabled = true
        }
        
        
        
        btnSubmit.setbtnFor(title:NSLocalizedString("submit", comment:""), type: Constant.kPositive)
        vwSubCat.isHidden = true
        
        txtLightSalesValue.delegate = self
        txtCompetitorName.delegate = self
        txtCompetitorName2.delegate = self
        txtCompetitorShare.delegate = self
        txtCompetitorShare2.delegate = self
        txtPhilipsSalesValue.delegate = self
        
        
        
        
        txtLightSalesValue.setCommonFeature()
        txtCompetitorName.setCommonFeature()
        txtCompetitorName2.setCommonFeature()
        txtCompetitorShare.setCommonFeature()
        txtCompetitorShare2.setCommonFeature()
        txtPhilipsSalesValue.setCommonFeature()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        CustomeTextfield.setBottomBorder(tf: txtLightSalesValue)
        CustomeTextfield.setBottomBorder(tf: txtPhilipsSalesValue)
        CustomeTextfield.setBottomBorder(tf: txtCompetitorShare)
        CustomeTextfield.setBottomBorder(tf: txtCompetitorShare2)
        
        
        cnstTableViewHeight.constant = tableViewHeight
        if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:  planvisitobj!.customerID)){
        if let companytypeId = customer.companyTypeID as?
            Int64{ if(customer.companyTypeID == 5){
            txtLightSalesValue.placeholder = String.init(format:"%@ (%@)", NSLocalizedString("business_share_value", comment:""),self.activeuser?.company?.currCode ?? "$")
        }else{
            txtLightSalesValue.placeholder = String.init(format:"%@ (%@)", NSLocalizedString("lighting_share_value", comment:""),self.activeuser?.company?.currCode ?? "$")
        }
            }
        }
        txtPhilipsSalesValue.placeholder = String.init(format:"%@ Sales Value (%@)",self.activeuser?.company?.brandName ?? "" ,self.activeuser?.company?.currCode ?? "$")
         

        txtCompetitorName.placeholder = NSLocalizedString("top1_competitor_name", comment:"")
        txtCompetitorName2.placeholder = NSLocalizedString("top2_competitor_name", comment:"")

        txtCompetitorShare.placeholder =  String.init(format:"%@ (%@)",NSLocalizedString("competitor_share_value1", comment:""), self.activeuser?.company?.currCode ?? "$")
        txtCompetitorShare2.placeholder =  String.init(format:"%@ (%@)",NSLocalizedString("competitor_share_value2", comment:""), self.activeuser?.company?.currCode ?? "$")

        
        temp =  ProdCategory.getAll()
       
        for prodcat in temp{
            var subcatdic = [String:Any]()
            subcatdic["Name"] = prodcat.name
            subcatdic["ID"] = NSNumber.init(value:prodcat.iD)
            
            var arsubcat = [[String:Any]]()
            let tempSubcat = ProductSubCat.getSubProductFromCategoryID(categoryID: NSNumber.init(value:prodcat.iD))
            for psc in tempSubcat{
                if(psc.isActive == true){
                    var dic = [String:Any]()
                    dic["Name"]  =  psc.name
                    dic["ID"] =  NSNumber.init(value:psc.iD)
                    dic["Quantity"] = NSNumber.init(value:0)
                    arsubcat.append(dic)
                }
            }
            
                subcatdic["subCategory"] =  arsubcat
                arrSubCategory.append(subcatdic)
            
        }
        for sec in 0..<arrSubCategory.count{
            self.hiddenSections.insert(sec)
        }
      
        if let counterShare = planvisitobj.visitCounterShare as? VisitCounterShare{
            txtLightSalesValue.text = String.init(format:"%ld",counterShare.companySegmentShareValue )
            txtPhilipsSalesValue.text = String.init(format:"%ld",counterShare.companyShareValue )
            if(counterShare.companyShareValue == 0){
                self.initialise()
            }else{
                isEnteredCompShareValue = true
            }
            
            
            if(counterShare.counterShareSubCategoryList.count > 0){
                for obj in 0...(counterShare.counterShareSubCategoryList.count)-1{
                    let objvisitcountershare = counterShare.counterShareSubCategoryList[obj]
                as? VisitCounterShareSubCategoryList

                    for subc in 0...arrSubCategory.count-1{
                        var subcat = arrSubCategory[subc]
                        if  let arrsubc = subcat["subCategory"] as? [[String:Any]]{
                        var mutarrsubc  = arrsubc
                        if(arrsubc.count > 0){
                        for dic in 0...arrsubc.count-1{
                        var dicprodcat = arrsubc[dic]
                        let subcid = dicprodcat["ID"] as? Int64;
                           
                    if(subcid == objvisitcountershare?.subcategoryID){
                            dicprodcat["Quantity"] = objvisitcountershare?.companyShareValue
                        mutarrsubc.remove(at: dic)
                       
                        mutarrsubc.insert(dicprodcat, at: dic)
                        print("arr = \(mutarrsubc)")
                        }
                    }
                }
                    subcat["subCategory"] = mutarrsubc
            }
                        
                      
                        arrSubCategory.remove(at: subc)
                        arrSubCategory.insert(subcat, at: subc)
                       
                }
                    tblView.reloadData()
               // counterShare?.counterShareSubCategoryList.
            }
            }
         
            txtCompetitorName.text = counterShare.competitorName
            txtCompetitorShare.text = String.init(format:"%ld",counterShare.competitorShare )

            //FormatString(@"%ld", objVisitCounterShare.competitorShare);
            txtCompetitorName2.text = counterShare.competitorName2
                    //objVisitCounterShare.competitorName2;
            txtCompetitorShare2.text = String.init(format:"%ld",counterShare.competitorShare2 )
                    //FormatString(@"%ld", objVisitCounterShare.competitorShare2);
            if(txtLightSalesValue.text?.count ?? 0 > 0){
                vwSubCat.isHidden = false
            }else{
                vwSubCat.isHidden = true
            }
            tblView.reloadData()
             cnstTableViewHeight.constant = tableViewHeight
        }else{
            self.initialise()
        }
        tblView.estimatedRowHeight = 120
        tblView.rowHeight = UITableView.automaticDimension
      
        tblView.reloadData()
         cnstTableViewHeight.constant = tableViewHeight
        /*
               for (VisitCounterShareSubCategoryList *a in objVisitCounterShare.counterShareSubCategoryList) {
                   for (NSDictionary *d in arySubCategories) {
                       for (NSMutableDictionary *dictProdCat in [d valueForKey:@"subCategory"]) {
                           if ([dictProdCat[@"ID"] longLongValue] == (long)a.subcategoryID) {
                               [dictProdCat setObject:@(a.companyShareValue) forKey:@"Quantity"];
                           }
                       }
                   }
               }
               txtCompetitorName.text = objVisitCounterShare.competitorName;
               txtCompetitorShare.text = FormatString(@"%ld", objVisitCounterShare.competitorShare);
               txtCompetitorName2.text = objVisitCounterShare.competitorName2;
               txtCompetitorShare2.text = FormatString(@"%ld", objVisitCounterShare.competitorShare2);
               [tblView reloadData];
           }else{
               [self performSelector:@selector(initialise) withObject:self afterDelay:0.1];
           }

         

           [tblView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
           [tblView reloadData];*/
        
        if(arrCompetitor.count > 0){
            self.txtCompetitorName.inputView = dropdownCompetitior1
            self.txtCompetitorName2.inputView = dropdownCompetitior1
           
            dropdownCompetitior1.dataSource.insert("Select Top-1 Competitor", at: 0)
            dropdownCompetitior1.selectionAction =   { [unowned self] (index: Int, item: String) in
                if(self.dropdownCompetitior1.tag == 0){
                    self.txtCompetitorName.text = item
                }else{
                    self.txtCompetitorName2.text = item
                }
            }
        }
    }
    
    func initialise(){
        vwSubCat.isHidden = true
    }

    func getCompetitior(){
        let param =  Common.returndefaultparameter()
       
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kwsurlgetCompetitionList, method: Apicallmethod.get) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
            
                let dicofResponse = arr as? [String:Any] ?? [String:Any]()
               let  arrOfStoreCompetitorList = dicofResponse["storeCompetitionList"] as? [[String:Any]] ?? [[String:Any]]()
                
                if(arrOfStoreCompetitorList.count > 0){
                    self.arrCompetitor = [StoreCompetition]()
                    for dic in arrOfStoreCompetitorList{
                        let storecompetitor = StoreCompetition().initwithdic(dict: dic)
                        self.arrCompetitor.append(storecompetitor)
                        self.dropdownCompetitior1.dataSource =  self.arrCompetitor.map{
                            return ($0.storeCompetition ?? "")
                        }
                        self.txtCompetitorName.inputView = self.dropdownCompetitior1
                        self.txtCompetitorName2.inputView = self.dropdownCompetitior1
                        if(self.dropdownCompetitior1.tag == 0){
                            self.dropdownCompetitior1.dataSource.insert("Select  Top-1 Competitor", at: 0)
                            
                        }else{
                            self.dropdownCompetitior1.dataSource.insert("Select  Top-2 Competitor", at: 0)
                        }
                        self.dropdownCompetitior1.selectionAction =   { [unowned self] (index: Int, item: String) in
                        if(self.dropdownCompetitior1.tag == 0){
                            self.txtCompetitorName.text = item
                        }else{
                            self.txtCompetitorName2.text = item
                        }
                    }
                    }
                }
                
            }else if(error.code == 0){
            self.dismiss(animated: true, completion: nil)
                     if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                 }else{
            self.dismiss(animated: true, completion: nil)
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                 }
            }
    }
   
    // MARK: IBAction
    
    @IBAction func submit(_ sender: UIButton) {
 if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:  planvisitobj!.customerID)){
//  if let addid = customer.addressID  as? Int {
        if(customer.companyTypeID == 5){
            if(txtLightSalesValue.text?.count == 0){
               msg = NSLocalizedString("please_enter_business_share_value", comment:"")
            }else if(Int(txtLightSalesValue.text!) ?? 0 == 0){
                msg = NSLocalizedString("please_enter_business_share_value", comment:"")
            }else if(txtPhilipsSalesValue.text?.count == 0){
                msg = String.init(format: "Please enter \(self.activeuser?.company?.brandName ?? "") Sales Value")//String.init(format:"Enter %@ Sales Value (%@)",self.activeuser?.company?.brandName ?? "" ,self.activeuser?.company?.currCode ?? "$")//NSLocalizedString("", comment: "")
            }else{
                msg = ""
            }
        
    }
        else{
            if(txtLightSalesValue.text?.count == 0){
                          msg = NSLocalizedString("please_enter_lighting_share_value", comment:"")
                       }else if(Int(txtLightSalesValue.text!) ?? 0 == 0){
                           msg = NSLocalizedString("please_enter_minimal_lighting_share_value", comment:"")
                       }else if(txtPhilipsSalesValue.text?.count == 0){
                        msg = String.init(format: "Please enter \(self.activeuser?.company?.brandName ?? "") Sales Value")//String.init(format:"Enter %@ Sales Value (%@)",self.activeuser?.company?.brandName ?? "" ,self.activeuser?.company?.currCode ?? "$")//NSLocalizedString("", comment: "")
                       }else{
                        msg = ""
                       }
    }
    
        }
        if(msg.count > 0){
            Utils.toastmsg(message:msg,view: self.view)
            return
        }
         SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var visitcountersharedic = [String:Any]()
        if(isEdit == true){
            visitcountersharedic["ID"] = counterShare?.iD
        }
        var jsonArray = [[String:Any]]()
        for sec in 0...arrSubCategory.count-1{
        if  let arrSubCat =  arrSubCategory[sec] as? [String:Any]{
            if(arrSubCat.keys.contains("subCategory")){
                if    let arrcatdic = arrSubCat["subCategory"] as? [[String:Any]]{
        for sub in arrcatdic{
            print("\(sub["Quantity"]) , type of = \(type(of: sub["Quantity"]))")
            if(sub["Quantity"] as? NSNumber ?? NSNumber.init(value: 0) == NSNumber.init(value: 1)){
                var jsondic = [String:Any]()
                jsondic["subcategoryID"] =  sub["ID"]
                jsondic["companyShareValue"] =  sub["Quantity"]
                jsonArray.append(jsondic)
            }
        }
                }
            }
        }
        }
        visitcountersharedic["createdBy"] = self.activeuser?.userID
        visitcountersharedic["visitID"] = NSNumber.init(value:planvisitobj.iD)
        visitcountersharedic["companySegmentShareValue"] = txtLightSalesValue.text
        visitcountersharedic["companyShareValue"] =  txtPhilipsSalesValue.text
        if(txtCompetitorName.text?.count ?? 0 > 0 && txtCompetitorName2.text?.count ?? 0 > 0){
            visitcountersharedic["competitorName"] = txtCompetitorName.text
            visitcountersharedic["competitorShare"] = (txtCompetitorShare.text?.count ?? 0 > 0) ? txtCompetitorShare.text:"0"
            visitcountersharedic["competitorName2"] = txtCompetitorName2.text
            visitcountersharedic["competitorShare2"] = (txtCompetitorShare2.text?.count ?? 0 > 0) ? txtCompetitorShare2.text:"0"
        }else{
            if(txtCompetitorName.text?.count ?? 0 > 0){
                visitcountersharedic["competitorName"] = txtCompetitorName.text
                
                visitcountersharedic["competitorShare"] = (txtCompetitorShare.text?.count ?? 0 > 0) ? txtCompetitorShare.text:"0"
                visitcountersharedic["competitorName2"] = ""
                visitcountersharedic["competitorShare2"] =  NSNumber.init(value:0)
            }else if(txtCompetitorName2.text?.count ?? 0 > 0){
                visitcountersharedic["competitorName"] = ""
                           visitcountersharedic["competitorShare"] = NSNumber.init(value:0)
                           visitcountersharedic["competitorName2"] = txtCompetitorName2.text
                visitcountersharedic["competitorShare2"] = (txtCompetitorShare2.text?.count ?? 0 > 0) ? txtCompetitorShare2.text:"0"
            }else{
                visitcountersharedic["competitorName"] = ""
                visitcountersharedic["competitorShare"] = NSNumber.init(value:0)
                visitcountersharedic["competitorName2"] = ""
                visitcountersharedic["competitorShare2"] = NSNumber.init(value:0)
            }
            
        }
            if(txtPhilipsSalesValue.text == "0"){
            jsonArray.removeAll()
            }
            visitcountersharedic["counterShareSubCategoryList"] = jsonArray
        print("jsonarray = \(jsonArray)")
            var maindic = Common.returndefaultparameter()
            if(isEdit ==  true){
                maindic["updateVisitCounterShareJson"] = Common.json(from: visitcountersharedic)
            }else{
              maindic["addVisitCounterShareJson"]  = Common.json(from: visitcountersharedic)
            }
           
            if(isEdit == true){
                self.apihelper.getdeletejoinvisit(param: maindic, strurl: ConstantURL.kWSUrlUpdateVisitCounterShare, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
              
                if(status.lowercased() == Constant.SucessResponseFromServer){
                          print(responseType)
                        let diccountershare = arr as? [String:Any] ?? [String:Any]()
                MagicalRecord.save({ (localcontext) in
                      
                FEMDeserializer.object(fromRepresentation: diccountershare, mapping: VisitCounterShare.defaultmapping(), context: localcontext)
                                                     
                    }) { (status , error) in
            if  let latestcountershare = VisitCounterShare().getVisitCounterShareFromID(visitID: NSNumber.init(value:self.planvisitobj?.iD ?? 0)) as? VisitCounterShare{
        self.planvisitobj.visitCounterShare = latestcountershare
        self.planvisitobj.visitCounterShare?.managedObjectContext?.mr_save({ (context) in
                                                        
                                                                        
        }, completion: { (status, error) in
        if(error == nil){
        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                
                VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
      //  self.navigationController?.popViewController(animated: true)
            }                                                                        }else{
                SVProgressHUD.dismiss()
            }

                                                                    })
                                                                }
                                                           }
                    } else if(error.code == 0){
                        SVProgressHUD.dismiss()
                                     self.dismiss(animated: true, completion: nil)
                                              if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                          }else{
                                            SVProgressHUD.dismiss()
                                     self.dismiss(animated: true, completion: nil)
                                             Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                                          }
                                   }
                
            }else{
                self.apihelper.getdeletejoinvisit(param: maindic, strurl: ConstantURL.kWSUrlAddVisitCounterShare, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            
                    
            if(status.lowercased() == Constant.SucessResponseFromServer){
                                    print(responseType)
                                    let diccountershare = arr as? [String:Any] ?? [String:Any]()
                                    MagicalRecord.save({ (localcontext) in
//                                FEMDeserializer.object(fromRepresentation: [diccountershare], mapping: VisitCounterShare.defaultmapping(), context: localcontext)
                                        FEMDeserializer.object(fromRepresentation: diccountershare, mapping: VisitCounterShare.defaultmapping(), context: localcontext)
                                    }) { (status , error) in
    if  let latestcountershare = VisitCounterShare().getVisitCounterShareFromID(visitID: NSNumber.init(value:self.planvisitobj?.iD ?? 0)) as? VisitCounterShare{
    self.planvisitobj.visitCounterShare = latestcountershare
    self.planvisitobj.managedObjectContext?.mr_save({ (context) in
                                
    },completion:{(status, error) in
      if(error == nil){
       
    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
            SVProgressHUD.dismiss()
  //  self.navigationController?.popViewController(animated: true)
        }
    }else{
        SVProgressHUD.dismiss()
        Utils.toastmsg(message:error?.localizedDescription ?? "" ,view: self.view)
        }
                                            })
                                        }
                                   }
                                        
                                        
                                   } else if(error.code == 0){
                                    SVProgressHUD.dismiss()
                                                    self.dismiss(animated: true, completion: nil)
                                                             if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                                         }else{
                                                            SVProgressHUD.dismiss()
                                                    self.dismiss(animated: true, completion: nil)
                                                            Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                                                         }
                                                  }
            }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddVisitCounterShare : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == txtCompetitorName || textField == txtCompetitorName2 ){
            if(arrCompetitor.count > 0)
            {
                
                 dropdownCompetitior1.anchorView = textField
                
                dropdownCompetitior1.bottomOffset = CGPoint.init(x: 0.0, y: textField.bounds.size.height)
                if(textField == txtCompetitorName){
                    dropdownCompetitior1.tag = 0
                }else{
                     dropdownCompetitior1.tag = 1
                }
             dropdownCompetitior1.show()
            return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if(textField == txtPhilipsSalesValue || textField == txtCompetitorShare || textField ==  txtLightSalesValue || textField == txtCompetitorShare){
//               let maxLength = 20
//               let currentString: NSString = textField.text! as NSString
//               let newString: NSString =
//                   currentString.replacingCharacters(in: range, with: string) as NSString
//               return newString.length <= maxLength
//               }
//
      if let text = textField.text,
                  let textRange = Range(range, in: text) {
                  let updatedText = text.replacingCharacters(in: textRange,
                                                              with: string)
        if(textField == txtPhilipsSalesValue || textField == txtLightSalesValue || textField == txtCompetitorShare || textField == txtCompetitorShare2){
        if(updatedText.count < 13){
            if(textField == txtPhilipsSalesValue){
                if(Int(updatedText) ?? 0 > 0){
                    vwSubCat.isHidden = false
                    isEnteredCompShareValue = true
                }else{
                    vwSubCat.isHidden = true
                    isEnteredCompShareValue = false
                }
                tblView.reloadData()
                cnstTableViewHeight.constant = tableViewHeight
            }
        }else{
            return false
            }
        }
        }
        return true
    }
}


extension AddVisitCounterShare:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(isEnteredCompShareValue == true){
           
            return arrSubCategory.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isEnteredCompShareValue == true){
            if (!self.hiddenSections.contains(section)) {
                
            
            let dicsubCat  = arrSubCategory[section]
            if  let arrsubcattbl = dicsubCat["subCategory"] as? [[String:Any]]{
               
            return arrsubcattbl.count + 1
            }else{
                return 1
            }
            
            }else{
                return 1
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "countersharesubcatcell1") as? CountershareSubcatCell{
         //   cell.txtQty.setCommonFeature()
            cell.selectionStyle = .none
            cell.delegate = self
            if  let arrSubCat =  arrSubCategory[indexPath.section] as? [String:Any]{
                if(arrSubCat.keys.contains("subCategory")){
                    if    let arrcatdic = arrSubCat["subCategory"] as? [[String:Any]]{
                
                        if(isEnteredCompShareValue == true){
                            let dicsubCat  = arrSubCategory[indexPath.section]
                           
                           // cell.btnSwitch.setImage(UIImage.init(named: "icon_up_arrow_black"), for: UIControl.State.selected)
                            if (self.hiddenSections.contains(indexPath.section)) {
                                cell.lblSubCatName.isHidden = true
                                cell.btnSwitch.setImage(UIImage.init(named: "icon_down_arrow_blue"), for: UIControl.State.normal)
                            
                            }
                            else{
                                if  let arrsubcattbl = dicsubCat["subCategory"] as? [[String:Any]]{
                                if(indexPath.row == (arrsubcattbl.count )){
                                   
                                    cell.lblSubCatName.isHidden = true
                              //      cell.btnSwitch.setImage(UIImage.init(named: "icon_down_arrow_blue"), for: UIControl.State.normal)
                                cell.btnSwitch.setImage(UIImage.init(named: "icon_up_arrow_black"), for: UIControl.State.selected)
                                 
                                }else{
                                    
                                    cell.lblSubCatName.isHidden = false
                                    cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
                                    cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.selected)
    let dic = arrcatdic[indexPath.row]
    cell.lblSubCatName.text = dic["Name"] as? String ?? ""
    
                    
            if let switchbtn = arrcatdic[indexPath.row]["Quantity"] as? NSNumber{
               
                if(switchbtn == NSNumber.init(value: 1)){
        cell.btnSwitch.isSelected = true
       
            }else{
            cell.btnSwitch.isSelected = false
                }
            }else{
               cell.btnSwitch.isSelected = false
                    }
                }
                                }else{
                                    cell.lblSubCatName.isHidden = true
                                   
                                    cell.btnSwitch.setImage(UIImage.init(named: "icon_down_arrow_blue"), for: UIControl.State.normal)
                                    cell.btnSwitch.setImage(UIImage.init(named: "icon_up_arrow_black"), for: UIControl.State.selected)
                               //     cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.selected)
                                }
                            }
                        }
                    }
                }
          //  cell.lblCatName.text = cat["Name"] as? String ??  "catname"
            }
            
           
          
            
        return cell
        }else{
          return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 5, y: 0, width: self.view.frame.size.width-10
            
            
            , height: 40))
        let lblcatname = UILabel.init(frame: CGRect.init(x: 5, y: 10, width: self.view.frame.size.width-55,height: 18))
        lblcatname.font = UIFont.systemFont(ofSize: 18)
        lblcatname.textColor = UIColor().colorFromHexCode(rgbValue:(0x2196F3)) //UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x464646)
        let dic = arrSubCategory[section]

        view.tag =  section
//        btnexp.addTarget(self,
//                                    action: #selector(self.btnexpClicked(sender:)),
//                                    for: .touchUpInside)
        lblcatname.text = dic["Name"] as? String
        view.addSubview(lblcatname)
 //       view.addSubview(btnexp)
//        let tapRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(self.hideSection(sender:)))
//        view.isUserInteractionEnabled = true
//
//        view.addGestureRecognizer(tapRecogniser)
//        lblcatname.backgroundColor = UIColor.yellow
//        view.backgroundColor =  UIColor.red
        
        return view
    }
//    @objc func isExpandClicked(sender:UIButton){
//        sender.isSelected = !sender.isSelected
//        let section = sender.tag
//
//
//    }
    func indexPathsForSection(section:Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()

      //  for section in 0..<self.tblView.numberOfSections {
            for row in 0..<self.tblView.numberOfRows(inSection: section){
            indexPaths.append(IndexPath(row: row,
                                        section: section))
            }
     //   }

        return indexPaths
    }
    
//    @objc
//    private func btnexpClicked(sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//
//    }
//@objc
//private func hideSection(sender: UITapGestureRecognizer) {
//   // sender.isSelected = !sender.isSelected
//    if  let section = sender.view?.tag as? Int{
//
//
//    if self.hiddenSections.contains(section) {
//        self.hiddenSections.remove(section)
//       /* self.tblView.insertRows(at: indexPathsForSection(section: section),
//                                  with: .fade)*/
//    } else {
//        self.hiddenSections.insert(section)
//     /*  self.tblView.deleteRows(at: indexPathsForSection(section: section),
//                                  with: .fade)*/
//    }
//    }
//    tblView.reloadData()
//    cnstTableViewHeight.constant = tableViewHeight
//}
    
//    func indexPathsForSection() -> [IndexPath] {
//        var indexPaths = [IndexPath]()
//
//        for row in 0..<self.tblView[section].count {
//            indexPaths.append(IndexPath(row: row,
//                                        section: section))
//        }
//
//        return indexPaths
//    }
    
//    @objc func isProductCategoryInterested(sender:UIButton){
//
//     //   let btnSwitch = sender
//        sender.isSelected = !sender.isSelected
//        let indexPath = tblView.indexPathForRow(at: tblView.convert(CGPoint.zero, to: sender))
//
//
//        var arrSubCat = arrSubCategory[indexPath?.section ?? 0]
//
//        if var dic = arrSubCat["subCategory"] as? [[String:Any]]{
//
//            for i in 0..<dic.count {
//                var dicsubcat = dic[i]
//               // dic.remove(at: i)
//                if(i == indexPath?.row){
//                     if(sender.isSelected ==  true){
//                        dicsubcat["Quantity"] = NSNumber.init(value:1)
//                                }else{
//                        dicsubcat["Quantity"] = NSNumber.init(value:0)
//                    }
//
//                    dic.remove(at: i)
//                    dic.insert(dicsubcat, at: i)
//
//                }
//            }
//            arrSubCat["subCategory"] = dic
//
//            arrSubCategory.remove(at: indexPath?.section ?? 0)
//            arrSubCategory.insert(arrSubCat, at: indexPath?.section ?? 0)
//    }
//
//    }
    
    func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return  10
    }
    
}
extension AddVisitCounterShare:CountershareSubcatCellDelegate{
    func switchClicked(sender: UIButton, cell: CountershareSubcatCell) {
        sender.isSelected = !sender.isSelected
        
        let indexPath =  tblView.indexPath(for: cell)
        
        
        if  let section = indexPath?.section as? Int{
            let countOfRow = tblView.numberOfRows(inSection: section)
           
            
        if(indexPath?.row == (countOfRow-1)){
              if self.hiddenSections.contains(section) {
                    self.hiddenSections.remove(section)
                 
                } else {
                    self.hiddenSections.insert(section)
                
                }
            self.tblView.reloadData()
            cnstTableViewHeight.constant = tableViewHeight
               
        }else{

        var arrSubCat = arrSubCategory[indexPath?.section ?? 0]
        
        if var dic = arrSubCat["subCategory"] as? [[String:Any]]{

            for i in 0..<dic.count {
                var dicsubcat = dic[i]
               // dic.remove(at: i)
                if(i == indexPath?.row){
                     if(sender.isSelected ==  true){
                        dicsubcat["Quantity"] = NSNumber.init(value:1)
                                }else{
                        dicsubcat["Quantity"] = NSNumber.init(value:0)
                    }
                    
                    dic.remove(at: i)
                    dic.insert(dicsubcat, at: i)
                   
                }
            }
            arrSubCat["subCategory"] = dic
            print(arrSubCategory)
            arrSubCategory.remove(at: indexPath?.section ?? 0)
            arrSubCategory.insert(arrSubCat, at: indexPath?.section ?? 0)
            print(arrSubCategory)
    }
    }
        }
    }
}
