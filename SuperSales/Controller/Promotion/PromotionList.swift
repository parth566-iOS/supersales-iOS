//
//  PromotionList.swift
//  SuperSales
//
//  Created by Apple on 07/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit
import SVProgressHUD

//import Request

class PromotionList: BaseViewController {
   // swiftlint: disable line_length
    var updateDataCompletion:((_ arrData:Array<Any>)->())?
    var visitType:VisitType!
    var selecedstrForList:String!
    var objPlannedVisit:PlannVisit!
   // var ObjUnplannedVisit:UnplannedVisit!
    
    
    @IBOutlet weak var tblPromotionList: UITableView!
    var promoData : [Promotion] = [Promotion]()
    //self.entitleMentData
    var entitleMentData : [Entitlement] = [Entitlement]()
    var entitlementObjData:Entitlement = Entitlement([" "  : " "])
    
    override  func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(true)
        // NotificationCenter.default.addObserver(self, selector: #selector(setToPeru(notification:)), name: .peru, object: nil)
      
    }
    
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        super.viewDidLoad()
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(notification:)), name:NSNotification.Name(rawValue: "UpdatePromotionListNotification"), object: nil) //Notification.Name("UpdatePromotionListNotification"), object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(setToPeru(notification:)), name: .peru, object: nil)
       
        
//        if(ObjVisit == nil){
//            ObjVisit = Visit()
//        }
      //  self.delegate1.delegate = self
        
            self.tblPromotionList.delegate = self
            self.tblPromotionList.dataSource = self
            self.tblPromotionList.reloadData()
            self.tblPromotionList.tableFooterView = UIView(frame: CGRect.zero)
        //For Pull to refresh
        /*
         [_tblListing addPullToRefreshWithActionHandler:^{
         jointVisitPageNo=1;
         [self callWebservice];
         }];
         */
        
        
//        tblPromotionList.addPullToRefresh {
//             self.getPromotionList()
//        }
//
        // Do any additional setup after loading the view.
      //  self.showAleert()
      //  SVProgressHUD.show(withStatus: "Loading Data")
       
        self.getPromotionList()
         })
        
        
    }
    
    func refreshData(){
        self.updateDataCompletion =
            {
                (arrData)in
                print(arrData)
                if(arrData.count > 0){
                    self.tblPromotionList.reloadData()
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

      
    }
   
    
    // MARK: -  APICall
    //api call
    
    
  
    func getPromotionList()
    {
        SVProgressHUD.showInfo(withStatus: "Loading")
        var customerID = NSNumber.init(value: 0)
        if(visitType == VisitType.planedvisit || visitType == VisitType.manualvisit){
              customerID = NSNumber.init(value:objPlannedVisit.customerID)
         
        }else{
           //  customerID = ObjUnplannedVisit.customerID ?? NSNumber.init(value: 0)
        }
        var strUrl = ""
        if(selecedstrForList == "Promotion"){
            
            strUrl = ConstantURL.KWSUrlAvailablePromotionList
        }
        else{
            strUrl = ConstantURL.KWSUrlAvailableEntitlementList
        }
        self.apihelper.getPromotionList(strurl:strUrl,customerId:customerID) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
             SVProgressHUD.dismiss()
            self.promoData.removeAll()
            self.entitleMentData.removeAll()
            if(error.code == 0){
                let arrOfPromotion = arr as? [[String:Any]] ?? [[String:Any]]()
                if(responseType == ResponseType.arr){
                    if(self.selecedstrForList == "Promotion"){
                    for Dictionary in arrOfPromotion {
                        let promo = Promotion.init(Dictionary)
                        self.promoData.append(promo)
                    }
                if(self.promoData.count == 0){
                Utils.toastmsg(message:"No Promotion Data Found",view: self.view)
                        }
                    }else{
                       
                        for Dictionary in arrOfPromotion {
                            let entitle = Entitlement.init(Dictionary)
                         
                            self.entitleMentData.append(entitle)
                        }
                        if(self.entitleMentData.count == 0){
                        Utils.toastmsg(message:"No Entitlement Data Found",view: self.view)
                                }
                    }
                    self.tblPromotionList.reloadData()
                }
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
      
     
        
    }
    func callAPIForResponse(entitlement:Entitlement,status:Int){
        
        let apistatus = status
        
        self.apihelper.updateEntitlementStatus(entitlementID: NSNumber.init(value: entitlement.ID), status: status) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                self.getPromotionList()
                 if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                if(apistatus == 2){
                
                 self.navigationController?.popViewController(animated: true)
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
  /*
        let account = Utils().getActiveAccount()
        
        let param = NSMutableDictionary()
       
        param.setObject(account?.user_id ?? 1, forKey: "UserID" as NSCopying)
        param.setObject(account?.securityToken ?? 1, forKey: "TokenID" as NSCopying)
        param.setObject(account?.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
       
        param.setObject(entitlement.ID , forKey: "EntitlementID" as NSCopying)
        param.setObject(status, forKey: "IsReceived" as NSCopying)
        print(param)
        
       
        
        callAPIPost(methodName: "Post", url:kBaseTeamworkURL + kWSUrlForEntitlementStatus , parameter: param as! [String : Any]) { (status, result) in
            print(status)
            if(status.lowercased() == "success"){
                do{
                    //here dataResponse received from a network request
                    
                    print(result )
                    let resultModel = Result(result as! [String : Any])
                    
                    print(resultModel)
                    if(resultModel.status.lowercased() == "success" ){
                        self.getPromotionList()
                        //  if(resultModel.data != nil){
                        if(self.selecedstrForList == "Promotion"){
                            let arrOfPromo = NSMutableArray()
                            for Dictionary in resultModel.data {
                                let promo = promotion.init(Dictionary)
                                arrOfPromo.add(promo)
                            }
                            self.promoData = arrOfPromo
                        }
                        else{
                            let arrOfEntitle = NSMutableArray()
                            for Dictionary in resultModel.data {
                                let entitle = Entitlement.init(Dictionary)
                                arrOfEntitle.add(entitle)
                            }
                            self.entitleMentData = arrOfEntitle
                        }
                        self.tblPromotionList.reloadData()
                        
                     
                    }
                    else{
                        self.showAlert(withMessage: "SomeThing Went Wrong")
                        
                    }
                }
            }
            else if (status == "false"){
                Utils.toastmsg(message:NSLocalizedString("internet-failure", comment: ""))
            }
            else{
                Utils.toastmsg(message:"SomeThing Went Wrong Please try again")
            }
        }
        */
    }
    func callAPIForSendOTP()  {
       
        if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: objPlannedVisit.customerID)){
       self.apihelper.sendOTP(mobileNo: customer.mobileNo) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
                let AlertForGetOTP = UIAlertController.init(title: "OTP Verification", message: "" , preferredStyle: UIAlertController.Style.alert)
                //  let text = UITextField.init()
                // text.placeholder = "AddOTP"
                
                AlertForGetOTP.addTextField { (textField : UITextField!) -> Void in
                    textField.setCommonFeature()
                    textField.placeholder = "Please enter OTP"
                }
                
let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (action) in
self.navigationController?.popViewController(animated: true)
                })
                
                let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                    if((AlertForGetOTP.textFields!.first?.text?.isEmpty)!){
                       Utils.toastmsg(message:"Please Enter OTP",view: self.view)
                        //self.showAleert(withMessage: "Please Enter OTP")
                    }
                    else{
                        self.callAPIForVerifyOTP(OTP: (AlertForGetOTP.textFields!.first?.text)!)
                    }
                })
                AlertForGetOTP.addAction(okAction)
                AlertForGetOTP.addAction(cancelAction)
                
                
                self.present(AlertForGetOTP, animated: true, completion: nil)
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        }
        
        /*
         @Field("CustomerMobileNo") String CustomerMobileNo,
         @Field(Constants.COMPANY_ID) Integer companyID,
         @Field(Constants.USER_ID) Integer userID,
         @Field(Constants.TOKEN_ID) String tokenID);

         */
      /*  let account = Utils().getActiveAccount()
        
        let param = NSMutableDictionary()

        //var customer = _CustomerDetails()
        //_CustomerDetails.getCustomerByID(NSNumber.init(value: ObjVisitForPromotionDetail?.customerID ?? 1))
         if(objPlannedVisit == nil){
            let   customerForUnPlan = _CustomerDetails.getCustomerByID(NSNumber.init(value: ObjUnplannedVisit?.customerID ?? 1))
            param.setObject(customerForUnPlan?.mobileNo ?? 3223545 , forKey: "CustomerMobileNo" as NSCopying)
         }
         else{
            //customerForPlan
          let   customerForPlan = _CustomerDetails.getCustomerByID(NSNumber.init(value: objPlannedVisit?.customerID ?? 1))
            param.setObject(customerForPlan?.mobileNo ?? 3223545 , forKey: "CustomerMobileNo" as NSCopying)
         }
        
      
        param.setObject(account?.user_id ?? 1, forKey: "UserID" as NSCopying)
        param.setObject(account?.securityToken ?? 1, forKey: "TokenID" as NSCopying)
        param.setObject(account?.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
   
        print("parameter for send OTP:",param)
        
        callAPIPost(methodName: "Post", url: kBaseURL + kWSUrlForSendOTP , parameter: param as! [String : Any]) { (status, result) in
            print(status)
            if(status.lowercased() == "success"){
                do{
                    //here dataResponse received from a network request
                    
                    print(result )
                    let resultModel = Result(result as! [String : Any])
                    
                    print(resultModel)
                    if(resultModel.status.lowercased() == "success" ){
                        Utils.toastmsg(message:resultModel.message)
                        let AlertForGetOTP = UIAlertController.init(title: "OTP Verification", message: "" , preferredStyle: UIAlertController.Style.alert)
                        //  let text = UITextField.init()
                        // text.placeholder = "AddOTP"
                        
                        AlertForGetOTP.addTextField { (textField : UITextField!) -> Void in
                            textField.placeholder = "Please enter OTP"
                        }
                        
                        let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                            if((AlertForGetOTP.textFields!.first?.text?.isEmpty)!){
                                self.showAlert(withMessage: "Please Enter OTP")
                            }
                            else{
                                self.callAPIForVerifyOTP(OTP: (AlertForGetOTP.textFields!.first?.text)!)
                            }
                        })
                        AlertForGetOTP.addAction(okAction)
                        AlertForGetOTP.addAction(cancelAction)
                        
                    
                        self.present(AlertForGetOTP, animated: true, completion: nil)
                        
                    }
                    else{
                        self.showAlert(withMessage: "SomeThing Went Wrong")
                        
                    }
                }
            }
            else if (status == "false"){
                Utils.toastmsg(message:NSLocalizedString("internet-failure", comment: ""))
            }
            else{
                self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
            }
        }
        
        */
    }
    
    func callAPIForVerifyOTP(OTP:String)  {
        
        if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: objPlannedVisit.customerID)){
        
        self.apihelper.verifyOTP(mobileNo: customer.mobileNo, OTP: OTP) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                self.callAPIForResponse(entitlement: self.entitlementObjData, status: 1)
            }else{
                AppDelegate.shared.alertWindow.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription) //UIApplication.shared.windows.first?.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
            }
        }
        }
        /*
         @Field("CustomerMobileNo") String CustomerMobileNo,
         @Field("Otp") String Otp,
         @Field(Constants.APPLICATION) String application,
         @Field(Constants.COMPANY_ID) Integer companyID,
         @Field(Constants.USER_ID) Integer userID,
         @Field(Constants.TOKEN_ID) String tokenID);
         
         */
   /*     let account = Utils().getActiveAccount()
        
        let param = NSMutableDictionary()
        
        //var customer = _CustomerDetails()
        
        if(objPlannedVisit == nil){
            let   customerForUnPlan = _CustomerDetails.getCustomerByID(NSNumber.init(value: ObjUnplannedVisit?.customerID ?? 1))
            param.setObject(customerForUnPlan?.mobileNo ?? 3223545 , forKey: "CustomerMobileNo" as NSCopying)
        }
        else{
            //customerForPlan
            let   customerForPlan = _CustomerDetails.getCustomerByID(NSNumber.init(value: objPlannedVisit?.customerID ?? 1))
            param.setObject(customerForPlan?.mobileNo ?? 3223545 , forKey: "CustomerMobileNo" as NSCopying)
        }
        
        
        
        
       
        param.setObject(OTP, forKey: "Otp" as NSCopying)
     
        
    
        
        callAPIPost(methodName: "Post", url: kBaseURL + kWSUrlForVerifyOTP , parameter: param as! [String : Any]) { (status, result) in
            print(status)
             let resultModel = Result(result as! [String : Any])
            if(resultModel != nil){
                
            if(status.lowercased() == "success"){
                do{
                    //here dataResponse received from a network request
                    
                    print(result )
                   
                    
                    print(resultModel)
                    if(resultModel.status.lowercased() == "success" ){
                         Utils.toastmsg(message:resultModel.message)
                        self.callAPIForResponse(entitlement: self.entitlementObjData, status: 1)
                      
                    }
                    else{
                        self.showAlert(withMessage: "SomeThing Went Wrong")
                         Utils.toastmsg(message:resultModel.message)
                        if(!resultModel.message.isEmpty){
                             Utils.toastmsg(message:resultModel.message)
//                            if let app = UIApplication.shared.delegate as? AppDelegate, let _ = app.window { Utils.toastmsg(message:resultModel.message)
//                            app.window.makeToast(resultModel.message)                            }
                            AppDelegate().window.makeToast(resultModel.message)
                           //  [[AppDelegate appDelegate].window makeToast:result[@"message"]];
//                            UIWindow.makeToast(self.)
                        }
                        else{
                            
                        }
                        
                    }
                }
            }else if (status == "false"){
                Utils.toastmsg(message:NSLocalizedString("internet-failure", comment: ""))
                }
            }
            else{
                Utils.toastmsg(message:resultModel.message)
                self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
                
            }
        }
        
     */
    }
    
    @objc private func updateData(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        
        print(notification)
    }
    @objc func setToPeru(notification: NSNotification) {
        print(notification)
      //  cityChosenLabel.text = "Peru"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //For Json Parsing
//    struct r:Decodable {
//        let apistatusr : String
//        let messager : String
//      //  let data : Array<promotion>
//       // let datar : Array<Dictionary<String, Any>>
//
////       init(){
////        self.apistatusr = apistatus
////        self.messager = message
////        self.datar = data
////       }
//    }
//    struct Result: Codable {
//        let weather: [r]
//    }

 
}
//extension Notification.Name {
//    static let peru = Notification.Name("peru")
//    static let argentina = Notification.Name("argentina")
//}
extension PromotionList : promotionDetailDelegate{
    
    func updatePromotionData(arr:Array<Promotion>){
        self.selecedstrForList = "Promotion"
        DispatchQueue.main.async {
            self.promoData = NSMutableArray.init(array: arr) as? [Promotion] ?? [Promotion]()
            self.tblPromotionList.reloadData()
        }
        
    }
    
    func updateEntitlementData(arr:Array<Entitlement>){
        self.selecedstrForList =  "Entitlement"
        DispatchQueue.main.async {
            self.entitleMentData =  NSMutableArray.init(array: arr) as? [Entitlement] ?? [Entitlement]()
            self.tblPromotionList.reloadData()
        }
    }
}
extension PromotionList :UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.selecedstrForList == "Promotion") {
         return   self.promoData.count
        }
        else
        {
          return  self.entitleMentData.count
            
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      if   let promocell = tableView.dequeueReusableCell(withIdentifier: "promotioncell", for: indexPath)
        as? PromotionCell{
       promocell.bgView.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
   
        
        promocell.heightlblStatusConstant.constant = 0;
        promocell.bgView.layer.cornerRadius = 10
        
        if(self.selecedstrForList == "Promotion"){
            let promotionData:Promotion =  promoData[indexPath.row]
            if(promotionData.status  == 1){
                promocell.lblStatusPromotion.text = "Joined"
                promocell.heightlblStatusConstant.constant = 25
            }
            else if (promotionData.status  == 2){
                promocell.lblStatusPromotion.text = "Not Joined"
                promocell.heightlblStatusConstant.constant = 25
            }
         //   promocell
        promocell.lblPromoTitle.text = promotionData.promotionTitle//"Test"
        if(promotionData.promotionType == Int(Common.PROMOTION_TYPE_FLAT)){
            promocell.lblPromoType.text = "Flat"
        }
        else if (promotionData.promotionType == Int(Common.PROMOTION_TYPE_BONUS)){
            promocell.lblPromoType.text = "Bonus"
        }
        else{
            promocell.lblPromoType.text = "Default"
        }
        }
        else{
            
            let entitlementData:Entitlement = entitleMentData[indexPath.row]
            promocell.lblPromoTitle.text = entitlementData.promotionTitle
            promocell.lblPromoType.text = entitlementData.entitlementDesc
            
            
        }
        return promocell
      }else{
        return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selecedstrForList == "Promotion"){

            if  let PromotionDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.PromotionDetail) as? PromotionDetail{
            PromotionDetail.delegateDetail =  self
            PromotionDetail.ObjVisitForPromotionDetail = objPlannedVisit
         //   PromotionDetail.ObjUnPlanedVisitForPromotionDetail = ObjUnplannedVisit
            PromotionDetail.visitType = self.visitType
            PromotionDetail.promotionDetail = promoData[indexPath.row]
            PromotionDetail.promotionData = promoData
            PromotionDetail.selectedPromotionID = indexPath.row as NSNumber
           
            self.navigationController?.pushViewController(PromotionDetail, animated: true)
            }
        }
        else{
            entitlementObjData = entitleMentData[indexPath.row]
            let title = entitlementObjData.promotionTitle
           // let entitlementData:Entitlement = entitleMentData[indexPath.row]
            let alertforAck =  UIAlertController.init(title: "SuperSales", message: "Have you received the entitlement " + title! , preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction.init(title: "YES", style: UIAlertAction.Style.default) { (action) in
              //  self.callAPIForResponse(entitlement: entitlementData,status: 2 )
                self.callAPIForSendOTP()
               
            }
            
            let cancelAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: {
                (action) in
                self.callAPIForResponse(entitlement: self.entitlementObjData,status: 2)
               
                
            })
            alertforAck.addAction(okAction)
            alertforAck.addAction(cancelAction)
            self.present(alertforAck, animated: true, completion: nil)
        }
    }

    func showAleert(){
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert) //if you increase actionSheet height to move default button down increase \n \n count and get your layout proper
        
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 320)
        let customView = UIView(frame: rect)
        
        customView.backgroundColor = .clear //Background colour as clear
        let buttonn:UIButton = UIButton()
        let buttonn1:UIButton = UIButton()
        let buttonn2:UIButton = UIButton()
        let label:UILabel = UILabel()
        let label1:UILabel = UILabel()
        let label2:UILabel = UILabel()
        buttonn.titleLabel?.text = "TEST"
        buttonn1.titleLabel?.text = "TEST1"
        buttonn2.titleLabel?.text = "TEST2"
        
        
        customView.addSubview(buttonn)
        customView.addSubview(buttonn1)
        customView.addSubview(buttonn2)
        
        customView.addSubview(label)
        customView.addSubview(label1)
        customView.addSubview(label2)
        
        alertController.view.addSubview(customView)
        let ExitAction = UIAlertAction(title: "Go", style: .default, handler: {(alert: UIAlertAction!) in
            

            
            
        })
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80) //here you can define new height for action Sheet
        alertController.view.addConstraint(height);
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("Cancel")})
        alertController.addAction(ExitAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
        
    }
}
