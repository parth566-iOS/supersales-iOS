//
//  VisitSubDetail.swift
//  SuperSales
//
//  Created by Apple on 05/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class VisitSubDetail: BaseViewController {
    
  @IBOutlet weak var imgInteractionType: UIImageView!
    
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblContactNo: UILabel!
    
    
    @IBOutlet var lblContactValue: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblContactName: UILabel!
    

    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var tblCheckIn: UITableView!
    @IBOutlet weak var tblCheckinHeight: NSLayoutConstraint!
    @IBOutlet weak var lblContactPersonNo: UILabel!
    
    @IBOutlet weak var lblAssigneeName: UILabel!
    @IBOutlet weak var imgAssgineImg: UIImageView!
    @IBOutlet weak var vwDescription: UIView!
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var tblProduct: UITableView!
  
    
    @IBOutlet weak var btnCloseVisit: UIButton!
    
    @IBOutlet weak var btnCreateSalesOrder: UIButton!
    
    
    @IBOutlet weak var btnEditCustomer: UIButton!
    
    @IBOutlet weak var btnEditAssignee: UIButton!
   
    @IBOutlet weak var vwContactPersonInfo: UIView!
    
    @IBOutlet weak var vwScheduleInfo: UIView!
    
    @IBOutlet weak var vwCustomerDetail: UIView!
    
    @IBOutlet weak var vwVisitAssignInfo: UIView!
    
    @IBOutlet weak var vwProductInfo: UIView!
    @IBOutlet weak var vwButtonDetail: UIView!
    
    
    var selectedCustomer:CustomerDetails?
    var assignedUserId:NSNumber!
    var visitType:VisitType!
    var planVisit:PlannVisit?
    var unplanVisit:UnplannedVisit?
    var dateFormater:DateFormatter = DateFormatter()
    var arrOfExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
   
     var popup:CustomerSelection? = nil
    
    
    @IBOutlet weak var cnstProductHeight: NSLayoutConstraint!
    var tableViewHeight: CGFloat {
        tblProduct.layoutIfNeeded()
        return tblProduct.contentSize.height
    }
    var tablecheckInViewHeight: CGFloat {
        tblCheckIn.layoutIfNeeded()
        return tblCheckIn.contentSize.height
    }
    
    var selectedexecutive:CompanyUsers = CompanyUsers()
    
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        self.setUI()
            if(self.visitType ==  VisitType.coldcallvisit || self.visitType == VisitType.coldcallvisitHistory){
                
            }else{
            if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1)){
                if let countershare = self.planVisit?.visitCounterShare as? VisitCounterShare{
                
            }else{
                let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
              
                self.dateFormater.dateFormat = "dd/MM/yyyy"
                let days = calender.compare(self.dateFormater.date(from: self.planVisit?.createdTime ?? "2020/10/12 06:12:25") ?? Date(), to: Date() , toGranularity: Calendar.Component.day)
                if(days.rawValue < 90 && self.visitType == VisitType.planedvisit){
                    Common.showalert(msg: "please add counter share", view: self)
                }
              
             }
                
            }
            }
        })
       
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//        super.viewDidLoad()
//        self.setUI()
//        })
        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
     
       NotificationCenter.default.addObserver(forName: Notification.Name("updatecheckinInfo"), object: nil, queue: OperationQueue.main) { (notify) in
                
           DispatchQueue.main.async{
            
            
            SVProgressHUD.dismiss()
           print("checkin details should be updated \(self.planVisit?.checkInOutData.count) when  notification register")
            self.setUI()
            self.tblCheckinHeight.constant = self.tablecheckInViewHeight
               self.tblCheckIn.reloadData()
              self.updateViewConstraints()
           }
             
     }
       NotificationCenter.default.addObserver(forName: Notification.Name("updateColdCallData"), object: nil, queue: OperationQueue.main) { (notify) in
               
     
             
     }
       NotificationCenter.default.addObserver(forName: Notification.Name("updateVisitData"), object: nil, queue: OperationQueue.main) { (notify) in
                
           DispatchQueue.main.async{
           
           self.setUI()
           }
             
     }
  }
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)
      NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updatecheckinInfo"), object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateColdCallData"), object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateVisitData"), object: nil)
  }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        super.viewDidAppear(true)
        self.setUI()
            self.tblCheckinHeight.constant = self.tablecheckInViewHeight
            self.updateViewConstraints()
        })
       
    }
  

    
    // MARK: Method
    func setUI(){
//        self.btnCloseVisit.setbtnFor(title: "CLOSE VIST", type: Constant.kPositive)
//        self.btnCreateSalesOrder.setbtnFor(title: "CREATE SALES ORDER", type: Constant.kPositive)
        self.btnCreateSalesOrder.backgroundColor = UIColor.Appthemegreencolor
        self.btnCloseVisit.backgroundColor = UIColor.Appthemegreencolor
        self.btnCreateSalesOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.btnCloseVisit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
       // self.btnCreateSalesOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    if(self.activeuser?.role?.id?.intValue ?? 0 >  7){
            btnEditAssignee.isHidden = true
            btnCloseVisit.isHidden = true
        }
        if(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            if let cust = CustomerDetails.getCustomerByID(cid:  unplanVisit?.customerID ?? 0){
                selectedCustomer = cust
                self.changeAssigneeAsperCustomerSelection()
            }
            if(unplanVisit?.productList.count ?? 0 > 0 ){
              vwProductInfo.isHidden = false
                tblProduct.separatorColor = UIColor.clear
                tblProduct.delegate = self
                tblProduct.dataSource = self
                tblProduct.reloadData()
            }else{
              vwProductInfo.isHidden = true
            }
            

        }else{
            if let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: planVisit?.customerID ?? 0)){
                selectedCustomer = cust
                self.changeAssigneeAsperCustomerSelection()
            }
            if let arrproduct = planVisit?.productList as? NSOrderedSet{
            if(arrproduct.count ?? 0 > 0 ){
              vwProductInfo.isHidden = false
                tblProduct.separatorColor = UIColor.clear
                tblProduct.delegate = self
                tblProduct.dataSource = self
                tblProduct.reloadData()
               
            }else{
                vwProductInfo.isHidden = true
            }
                
            }else{
              vwProductInfo.isHidden = true
            }
        }
            
       
    
        vwCustomerDetail.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
         vwContactPersonInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
         vwScheduleInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        vwVisitAssignInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        vwProductInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
    //    DispatchQueue.global(qos: .background).async {
        self.fetchuser{
        (arrOfuser,error) in
        
  //  }
        }
      
        tblCheckIn.delegate = self
        tblCheckIn.dataSource  = self
        tblCheckIn.separatorColor = UIColor.clear
        tblCheckIn.tableFooterView = UIView()
        tvDescription.isUserInteractionEnabled = false
         let gestureCall = UITapGestureRecognizer(target: self, action: #selector(self.handleTapContactno(_:)))
          let gestureCustomerCall = UITapGestureRecognizer(target: self, action: #selector(self.handleTapCustomerContactno(_:)))

        
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.manualvisit){

            var strnt = ""
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: planVisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
               strnt = strn
            }
            self.dateFormatter.dateFormat =  "yyyy/MM/dd HH:mm:ss"
            let date = self.dateFormatter.date(from: strnt) ?? Date()
            let strnextactionDate =  self.dateFormatter.string(from: date)
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            let planDate = self.dateFormatter.date(from: strnextactionDate)
          //  plandate < createddate
            if(self.activesetting.allowEditVisitDataForPreviousDate == NSNumber.init(value: 0)){

                if(date.isEndDateIsSmallerThanCurrent(checkendDate: Date())){
                
                vwButtonDetail.isHidden = true
                btnEditCustomer.isHidden = true
                    }
                }
            
            
            let img = Utils.getNextActionImage(interactionId: Int(planVisit?.nextActionID as? Int64 ?? 0))
            self.imgInteractionType.image = img
              dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
          
           let createplanvisitdate = dateFormater.date(from: planVisit?.createdTime ?? "22/1/2020")
             dateFormater.dateFormat = "dd MMM"
            lblCreatedDate.text  = dateFormater.string(from: createplanvisitdate ?? Date())
            let attributedcustomername = NSAttributedString.init(string: planVisit?.customerName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
            lblCustomerName.attributedText = attributedcustomername
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(lblcustomertapped))
            lblCustomerName.isUserInteractionEnabled = true
            lblCustomerName.addGestureRecognizer(gesture)
            let strContactNo = NSMutableAttributedString.init(string:"Contact No:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
            if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0)){
                let contactno = NSAttributedString.init(string: customer.mobileNo ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor , NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue])
            //strContactNo.append(contactno)
//            let textRange = NSMakeRange(0, customer.mobileNo.count)
//            contactno.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            lblContactNo.attributedText = strContactNo
                lblContactValue.attributedText = contactno
                lblContactValue.isUserInteractionEnabled = true
                lblContactValue.addGestureRecognizer(gestureCustomerCall)
            }else{
                lblContactNo.text = ""
                 lblContactValue.text = ""
            }
            if(planVisit?.conclusion?.count ?? 0 > 0){
                vwDescription.isHidden = false
              
                tvDescription.text = planVisit?.conclusion
                tvDescription.isHidden = false
                lblDescriptionTitle.isHidden = false
            }else{
                
                vwDescription.isHidden = true
            }
            
            
            var strAddress = ""
            if(planVisit?.addressMasterID ?? 0 > 0){
              //  if   let address = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:(planVisit?.addressMasterID ?? 0))){
                if let address = AddressList().getAddressStringByAddressId(aId:NSNumber.init(value:(planVisit?.addressMasterID ?? 0))){
              
                strAddress = address
                }else{
                    strAddress = ""
                }
            }
            var mutstrAddress:NSMutableAttributedString? =  NSMutableAttributedString()
            mutstrAddress = mutstrAddress?.stratributed(bold:"Address: ",normal:strAddress)
           lblAddress.setMultilineLabel(lbl: lblAddress)
            
            lblAddress.attributedText = mutstrAddress
            
            if(planVisit?.contactID ?? 0 > 0 &&  self.activesetting.RequiContactPersonInAddVisit == NSNumber.init(value: 1)){
                if  let  planvisitcontact = Contact.getContactFromID(contactID: NSNumber.init(value:planVisit?.contactID ?? 0)) as? Contact{
                lblContactName.text = String.init(format:"%@ %@", planvisitcontact.firstName,planvisitcontact.lastName)
                    let attributedcontactno = NSAttributedString.init(string: planvisitcontact.mobile ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                lblContactPersonNo.attributedText = attributedcontactno
                    lblContactPersonNo.isHidden = false
               
                }else{
                    self.lblContactName.text = "No Contact"
                    self.lblContactPersonNo.isHidden = true
                }//planVisit?.contactMobileNo
                lblContactPersonNo.isUserInteractionEnabled = true
                lblContactPersonNo.addGestureRecognizer(gestureCall)
                
                
            }else{
        lblContactName.text = "No Contact"
        lblContactPersonNo.isHidden = true
            }
        tblCheckinHeight.constant = tablecheckInViewHeight
        tblCheckIn.isUserInteractionEnabled =  false
//            if(planVisit?.checkInOutData.count ?? 0 > 0){
//                lbluserName.text = String.init(format: "%@ %@",self.activeuser?.firstName ?? "",self.activeuser?.lastName ?? " ")
//            }else{
//                lbluserName.text  =  " "
//            }
            // _CompanyUsers *user = (_CompanyUsers *)[_CompanyUsers getUser:[NSNumber numberWithLong:_objUnPlanVisit.reAssigned]];
    if   let user = CompanyUsers().getUser(userId:NSNumber.init(value:planVisit?.reAssigned ?? 0)){
                
    assignedUserId = NSNumber.init(value:planVisit?.reAssigned ??  0)
                if(assignedUserId.intValue > 0){
                    self.arrOfSelectedExecutive.removeAll()
                    self.arrOfSelectedExecutive = [user]
                }
    lblAssigneeName.text = String.init(format: "%@ %@", user.firstName,user.lastName)
            }else{
                lblAssigneeName.text = ""
            }
            if(planVisit?.visitStatusID == 2){
                 btnEditAssignee.isHidden = true
                btnCloseVisit.isHidden = true
            }
            
        }else if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            let img = Utils.getNextActionImage(interactionId: Int(unplanVisit?.nextActionID ?? 1))
            self.imgInteractionType.image = img
            dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
           let createdDate = dateFormater.date(from: unplanVisit?.createdTime ?? "22/10/2010")
            dateFormater.dateFormat = "dd MMM"
            lblCreatedDate.text = dateFormater.string(from: createdDate ?? Date())
            let attributedcustomername = NSAttributedString.init(string: unplanVisit?.tempCustomerObj?.CustomerName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
            lblCustomerName.attributedText = attributedcustomername
           // lblCustomerName.text = unplanVisit?.customerName
            let strContactNo = NSMutableAttributedString.init(string:"Contact No:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
            let contactno = NSAttributedString.init(string: unplanVisit?.tempCustomerObj?.MobileNo ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
            lblContactValue.isUserInteractionEnabled = true
            lblContactValue.addGestureRecognizer(gestureCustomerCall)
            //strContactNo.append(contactno)
            lblContactValue.attributedText = contactno
            lblContactNo.attributedText = strContactNo
            btnCreateSalesOrder.isHidden = true
            if(unplanVisit?.conclusion?.count ?? 0 > 0){
                vwDescription.isHidden = false
                tvDescription.text = unplanVisit?.conclusion
            //    tvDescription.backgroundColor = UIColor.red
                tvDescription.isHidden = false
                lblDescriptionTitle.isHidden = false
            }else{
                vwDescription.isHidden = true
            }
            
            var mutstrAddress:NSMutableAttributedString? =  NSMutableAttributedString()
          
           
            let strAddress1 = String.init(format:" %@, %@, %@-%@, %@ %@", unplanVisit?.tempCustomerObj?.AddressLine1 ?? "", unplanVisit?.tempCustomerObj?.AddressLine2 ?? "", unplanVisit?.tempCustomerObj?.City ?? "", unplanVisit?.tempCustomerObj?.Pincode ?? "", unplanVisit?.tempCustomerObj?.State ?? "", unplanVisit?.tempCustomerObj?.Country ?? "")
            
            
            mutstrAddress = mutstrAddress?.stratributed(bold:NSLocalizedString("Address", comment:""),normal:strAddress1)
           lblAddress.setMultilineLabel(lbl: lblAddress)
           // let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:unplanVisit?.tempCustomerID ?? 0))
            lblAddress.attributedText = mutstrAddress
            assignedUserId = unplanVisit?.reAssigned
            if  let user = CompanyUsers().getUser(userId:unplanVisit?.reAssigned ?? 0){
            
          
                lblAssigneeName.text = String.init(format: "%@ %@", user.firstName,user.lastName)
            }else{
                 lblAssigneeName.text = ""
            }
            
            if(unplanVisit?.contactName?.count ?? 0 > 0){
                var strcontactname = ""
                if let firstcontact =  unplanVisit?.tempCustomerObj?.ContactFirstName as? String{
                    strcontactname.append(firstcontact)
                }
                if let lastcontact = unplanVisit?.tempCustomerObj?.ContactLastName as? String {
                    if(strcontactname.count > 0){
                        strcontactname.append(String.init(format: " \(lastcontact)"))
                    }else{
                    strcontactname.append(lastcontact)
                    }
                }
                lblContactName.text = strcontactname
                lblContactPersonNo.text = unplanVisit?.contactMobileNo
                lblContactPersonNo.isHidden = false
                 lblContactPersonNo.isUserInteractionEnabled = true
                 lblContactPersonNo.addGestureRecognizer(gestureCall)
            }else{
                
                lblContactName.text = "No Contact"
                lblContactPersonNo.isHidden = true
            }
//            if(unplanVisit?.contactID?.intValue ?? 0  > 0){
//                if let contactname = Contact.getContactFromID(contactID: unplanVisit?.contactID ?? 0){
//                    lblContactName.text = String.init(format: "\(contactname.firstName) \(contactname.lastName)")
//                   
//                    lblContactPersonNo.text = contactname.mobile
//                    lblContactPersonNo.isHidden = false
//                }else{
//                    lblContactName.text = ""
//                    lblContactPersonNo.text = ""
//                }
//            }else{
//                lblContactName.text = "No Contact"
//                lblContactPersonNo.isHidden = true
//            }
            tblCheckinHeight.constant = tablecheckInViewHeight
             tblCheckIn.isUserInteractionEnabled =  false
//            if(unplanVisit?.checkInList.count ?? 0 > 0){
//                lbluserName.text = String.init(format: "%@ %@",self.activeuser?.firstName ?? " ",self.activeuser?.lastName ?? " ")
//            }else{
//              lbluserName.text  = " "
//            }
            if(unplanVisit?.visitStatusID == 2){
                 btnEditAssignee.isHidden = true
                 btnCloseVisit.isHidden = true
            }
//            if( self.arrOfSelectedExecutive.count == 0){
//
//                self.arrOfSelectedExecutive =  self.arrOfSelectedExecutive.append(user)
//            }
        }
        if((visitType == VisitType.planedvisitHistory) || (visitType == VisitType.coldcallvisitHistory)){
            btnCreateSalesOrder.isHidden = true
            btnCloseVisit.isHidden = true
            btnEditCustomer.isHidden =  true
            btnEditAssignee.isHidden = true
        }
        cnstProductHeight.constant = tableViewHeight
         tblCheckIn.reloadData()
       
         tvDescription.setFlexibleHeight()
        self.tblCheckIn.rowHeight = UITableView.automaticDimension
        self.tblCheckIn.estimatedRowHeight = 120.0
       
        
    }
    
    func changeAssigneeAsperCustomerSelection(){
        var taggedToIDListOfUserID  = [Int]()
        self.arrOfExecutive = [CompanyUsers]()
        if let selectedCustomer = selectedCustomer as? CustomerDetails{
        taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map(
            {
                //taggedUserID
                ($0 as! TaggedToIDList).taggedUserID
                
            })
        }
        for user in BaseViewController.staticlowerUser{
            if(user.entity_id == self.activeuser?.userID){
                self.arrOfExecutive.append(user)
            }else if(taggedToIDListOfUserID.contains(Int(user.entity_id)) && user.role_id != 9){
                self.arrOfExecutive.append(user)
            }
            
        }
    }
    @objc func handleTapContactno(_ sender: UITapGestureRecognizer) {
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            if let url = URL(string: "tel://\(lblContactPersonNo.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            }else{
                Utils.toastmsg(message:"can not call please try again",view:self.view)
            }
        }else{
            if let url = URL(string: "tel://\(lblContactPersonNo.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            }
            else{
                Utils.toastmsg(message:"can not call please try again",view:self.view)
            }
        }
    }
    
    @objc func handleTapCustomerContactno(_ sender: UITapGestureRecognizer) {
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            if let url = URL(string: "tel://\(lblContactValue.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        }else{
            
            if let url = URL(string: "tel://\(lblContactValue.text ?? "")"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
  //      tblCheckIn.beginUpdates()

   //     tblCheckIn.endUpdates()
        //tblCheckin.lay
        
        
        tblCheckinHeight.constant = tblCheckIn.contentSize.height

    }
    
    @objc func lblcustomertapped(){
        
        if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
            customerhistory.customerName = lblCustomerName.text
            customerhistory.isEdit = false
            customerhistory.customerID =  NSNumber.init(value:planVisit!.customerID)
            if CustomerDetails.getCustomerByID(cid: customerhistory.customerID) != nil{
        self.navigationController?.pushViewController(customerhistory, animated: true)
            }
        else{
            Utils.toastmsg(message:"Customer is not mapped so you can't view customer history",view:self.view)
        }
        }
        
    }
    
    
    // MARK: API Call
    func reassignVist(){
        var assignvisitdic = [String:Any]()
        assignvisitdic["OriginalAssignee"] = assignedUserId
        assignvisitdic["CompanyID"] =  self.activeuser?.company?.iD
        assignvisitdic["CreatedBy"] =  self.activeuser?.userID
        assignvisitdic["AssignedBy"] = self.activeuser?.userID
       if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
        assignvisitdic["ID"] = planVisit?.iD
             assignvisitdic["VisitTypeID"] =   1
        assignvisitdic["SeriesPostfix"] = planVisit?.seriesPostfix
       }else{
        assignvisitdic["ID"] = unplanVisit?.localID
        assignvisitdic["VisitTypeID"] =   2
         assignvisitdic["SeriesPostfix"] = unplanVisit?.seriesPostfix
        }
        
        var param = Common.returndefaultparameter()
        param["assignedVisitJson"] =  Common.json(from:assignvisitdic)
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAssignedVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            print(arr)
            print(responseType)
    if(error.code == 0){
    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }  //UIApplication.shared.keyWindow?.inputViewController?.view.makeToast(message)
        if(self.visitType == VisitType.planedvisit){
            self.planVisit?.reAssigned = self.assignedUserId.int64Value
            self.planVisit?.ressigneeName = String.init(format:"\(self.selectedexecutive.firstName) \(self.selectedexecutive.lastName)")
            self.planVisit?.managedObjectContext?.mr_save({ (context) in
                print("saving")
            }, completion: { (status, error) in
                if(error == nil){
                    print("Its saved")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } else{
            
            self.unplanVisit?.reAssigned = self.assignedUserId
//            self.unplanVisit?.ressigneeName = String.init(format:"\(self.selectedexecutive.firstName) \(self.selectedexecutive.lastName)")
          self.navigationController?.popViewController(animated: true)
        }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                      }
        }
    }
    
    func closeVisit(){
        var param = Common.returndefaultparameter()
        var closevisitdic = ["CompanyID":self.activeuser?.company?.iD ??  0,"VisitStatusID":NSNumber.init(value: 2) ?? 0 ,"CreatedBy":self.activeuser?.userID ?? 0] as? [String:Any] ?? [String:Any]()
        if(visitType == VisitType.planedvisit){
            closevisitdic["VisitTypeID"] = NSNumber.init(value: 1)
            closevisitdic["ID"] = NSNumber.init(value:planVisit?.iD ?? 0)
            closevisitdic["SeriesPostfix"] = NSNumber.init(value:planVisit?.seriesPostfix ?? 0)
            closevisitdic["SeriesPrefix"] = planVisit?.seriesPrefix
        }else{
closevisitdic["VisitTypeID"] = NSNumber.init(value: 2)
closevisitdic["ID"] = NSNumber.init(value:unplanVisit?.localID ?? 0)
closevisitdic["SeriesPostfix"] = unplanVisit?.seriesPostfix ?? NSNumber.init(value:0)
closevisitdic["SeriesPrefix"] = unplanVisit?.sereiesPrefix
        }
        param["closeVisitJson"] = Common.json(from: closevisitdic)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlCloseVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            print(arr)
            if(error.code == 0){
              if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                self.navigationController?.popViewController(animated: true)
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
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
    
    // MARK: IBAction
    
    @IBAction func btnCreateSalesOrderClicked(_ sender: UIButton) {
        guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: planVisit?.customerID ?? 0)), cust.statusID == 2 else {
            Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
            return
        }
        
        if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
            vc.objVisit = planVisit
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func btnEditCustomerClicked(_ sender: UIButton) {
        if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 1) {
            Utils.toastmsg(message:"You are not permitted to add customer, Please contact Admin for permission", view: self.view)
        } else if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 2) {
            Utils.toastmsg(message:"It require approval to add customer, Please contact Admin for permission", view: self.view)
        } else {
        if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            SVProgressHUD.show()
            addCustomer.isVendor = false
            AddCustomer.isFromInfluencer = 0
            addCustomer.isForAddAddress = false
            addCustomer.isFromColdCallVisit = false
           
            var editcustomer = CustomerDetails()
            if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.manualvisit){
                addCustomer.isEditCustomer = true
                if let editcustomer1 = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planVisit?.customerID ?? 0) ?? NSNumber.init(value:0)) as? CustomerDetails{
                    editcustomer = editcustomer1
                    addCustomer.isFromColdCallVisit = false
                    addCustomer.selectedCustomer = editcustomer
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(addCustomer, animated: true)
                    }
                   
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message:"Customer is not mapped So you can't edit",view:self.view)
                }
               
            }else{
                //editcustomer = unplanVisit.tempCustomerObj
                if let cust = CustomerDetails.getCustomerByID(cid: unplanVisit?.tempCustomerID ?? 0) as? CustomerDetails{
                addCustomer.isEditCustomer = true
                    addCustomer.isFromColdCallVisit = true
                   
                    editcustomer = cust
                    if let tempcustomer = unplanVisit?.tempCustomerObj{
                    addCustomer.selectedCustomerForUnplan = tempcustomer
                    }
                }else{
                    addCustomer.isEditCustomer = false
                    if let tempcustomer = unplanVisit?.tempCustomerObj{
                        addCustomer.selectedCustomerForUnplan = tempcustomer
                    }
                }
                if let tempcustomer = unplanVisit?.tempCustomerObj{

                addCustomer.selectedCustomerForUnplan = tempcustomer

                }
                addCustomer.origiAssigneeFromCCVisit = unplanVisit?.originalAssignee
                addCustomer.isFromColdCallVisit = true
                addCustomer.selectedCustomer = editcustomer
            self.navigationController?.pushViewController(addCustomer, animated: true)
            }
        }
           
        }
    }
    
    @IBAction func btnEditAssigneeClicked(_ sender: UIButton) {
        if((visitType == VisitType.planedvisit) && (self.activesetting.customTagging == NSNumber.init(value: 3)) && (Utils.isCustomerMapped(cid: NSNumber.init(value:(planVisit?.customerID)!)) == false)){
            Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_reassign_this_visit", comment: ""),view:self.view)
        }else{
            self.arrOfExecutive = BaseViewController.staticlowerUser
          
            if let cust  = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0))
                as? CustomerDetails
            {
                selectedCustomer = cust
                self.changeAssigneeAsperCustomerSelection()
            }
  
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.strTitle = "Select User"
        self.popup?.nonmandatorydelegate = self
        self.popup?.arrOfExecutive = self.arrOfExecutive
        self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
        self.popup?.strLeftTitle = "Ok"
        self.popup?.strRightTitle = "Cancel"
        self.popup?.selectionmode = SelectionMode.single
        //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
        self.popup?.isSearchBarRequire = false
        self.popup?.isFromSalesOrder =  false
        self.popup?.viewfor = ViewFor.companyuser
        self.popup?.parentViewOfPopup = self.view
        self.popup?.isFilterRequire = false
            Utils.addShadow(view: self.view)
        // popup?.showAnimate()
        self.present(self.popup!, animated: false, completion: nil)
        }
    }
    @IBAction func btnCloseVisitClicked(_ sender: UIButton) {
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default
            , handler:  nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
            //action for close visit
            self.closeVisit()
        }
        Common.showalertWithAction(msg: "Are  you sure you want to close visit", arrAction: [noAction,yesAction], view: self)
    }
}

extension VisitSubDetail:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblCheckIn){
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.manualvisit){
           // print("count of planned visit  checkin = \(planVisit?.checkInOutData.count )")
            return (planVisit?.checkInOutData.count ?? 0) + 1
        }else {
            print("count of unplanned visit  checkin = \(unplanVisit?.checkInList?.count)")
            return (unplanVisit?.checkInList?.count ?? 0) + 1
        }
        }else{
            if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                return (unplanVisit?.productList.count ?? 0) +  1
            }else{
                return (planVisit?.productList.count ?? 0) + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblCheckIn){
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CheckinDetailCell, for: indexPath) as? CheckInDetailCell{
            
            cell.lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
         //   cell.lblTitle.font = UIFont.myBoldSystemFont(ofSize: 18)
    if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.manualvisit || visitType == VisitType.directvisitcheckin){
    
            if(indexPath.row == 0){
                cell.lblTitle.text = "Plan"
                dateFormater.dateFormat = "MMM d, yyyy hh:mm:ss"//"yyyy/MM/dd hh:mm:ss"
         /*       let date = dateFormater.date(from: planVisit?.originalNextActionTime ?? "22/10/2010")
        /*
                 if(visit.nextActionTime?.count ?? 0 > 0){
                     var strnt = ""
                     if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                        strnt = strn
                     }
                    self.lblNextActionDetail.text = String.init(format: "%@:%@", arguments: [NSLocalizedString("next_action", comment: ""),Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy , hh:mm a")])
                 }
                 **/

                cell.lblCheckinTime.text = Utils.getDateinstrwithaspectedFormat(givendate:date ?? Date(), format: "hh:mm a  EEE,d MMM yy", defaultTimZone: false)*/
                if(planVisit?.originalNextActionTime?.count ?? 0 > 0){
                    var strnt = ""
                    if let strn = Utils.getDateBigFormatToDefaultFormat(date: planVisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                       strnt = strn
                    }
                    dateFormater.dateFormat =  "yyyy/MM/dd HH:mm:ss"
                    let date = dateFormater.date(from: strnt)
                    cell.lblCheckinTime.text = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a  EEE,d MMM yy") //Utils.getDateinstrwithaspectedFormat(givendate: date ?? Date(), format: "hh:mm a  EEE,d MMM yy", defaultTimZone: false)//String.init(format: "%@", arguments: [Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a  EEE,d MMM yy")])
                }
                cell.lblINTitle.isHidden = true
                cell.lblInTime.isHidden = true
                cell.lblOutTitle.isHidden = true
                cell.lblOutTime.isHidden = true
            }else{
       
if let checkin = planVisit?.checkInOutData.object(at: indexPath.row - 1 ) as? VisitCheckInOutList{
 
if let executive = CompanyUsers().getUser(userId:NSNumber.init(value:checkin.createdBy)){
cell.lblTitle.text = String.init(format:"\(executive.firstName)  \(executive.lastName)")
}else{
cell.lblTitle.text = checkin.createdByName
}
cell.lblCheckinTime.isHidden = true
dateFormater.dateFormat = "MMM dd, yyyy hh:mm:ss a"
    cell.lblINTitle.text = "In"
    if let checkintime = checkin.checkInTime{
       
        cell.lblTitle.text = "In"
        var strchit = ""
        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
        strchit = strch

                        if let checkin = planVisit?.checkInOutData.object(at: indexPath.row - 1 ) as? VisitCheckInOutList{
                                
                                if let executive = CompanyUsers().getUser(userId:NSNumber.init(value:checkin.createdBy)){
                                    cell.lblTitle.text = String.init(format:"\(executive.firstName)  \(executive.lastName)")
                                }else{
                                    cell.lblTitle.text = checkin.createdByName
                                }
                                cell.lblCheckinTime.isHidden = true
                                dateFormater.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                                if(checkin.statusID == 3){
                                    cell.lblINTitle.text = "In"
                                    let date = dateFormater.date(from: checkin.checkOutTime ?? "22/10/2010")
                                    dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
                                    cell.lblCheckinTime.text = dateFormater.string(from: date ?? Date())
                                    if let checkouttime = checkin.checkOutTime{
                                        print("Checkout time \(checkouttime)")
                                        cell.lblOutTitle.text = "Out"
                                        var strch =   ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                        }
                                        
                                        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy")
                                    }
                                    else if let checkintime = checkin.checkInTime{
                                        
                                        cell.lblTitle.text = "In"
                                        var strchit = ""
                                        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                            strchit = strch
                                        }
                                        cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                    }
                                    
                                }
                                else{
                                    
                                    if(checkin.visitManualCheckIn == 0 ){
                                        cell.lblINTitle.text = "In"
                                        if let checkintime = checkin.checkInTime{
                                            var strchit = ""
                                            if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                strchit = strch
                                            }
                                            cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                        }
                                    }else if let manualCheckInStatusID  =  checkin.manualCheckInStatusID as? Int16{
                                        if (manualCheckInStatusID == 1 || manualCheckInStatusID == 2){
                                            cell.lblINTitle.text = "In"
                                            if let checkintime = checkin.checkInTime{
                                                var strchit = ""
                                                if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                    strchit = strchi
                                                }
                                                cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                                cell.lblInTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                                            }
                                            
                                        }
                                    }else{
                                        if let checkintime = checkin.checkInTime{
                                            
                                            cell.lblTitle.text = "In"
                                            var strchit = ""
                                            if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                strchit = strch
                                            }
        cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
        if(cell.lblCheckinTime.text?.count == 0){
            cell.lblCheckinTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "yyyy/MM/dd hh:mm:ss")
                                        }
                                    }
                                }
                                    
                                    if(checkin.visitManualCheckOut == 0){
                                        cell.lblOutTitle.isHidden = false
                                        cell.lblOutTime.isHidden =  false
                                        if let checkouttime = checkin.checkOutTime{
                                            cell.lblOutTitle.text = "Out"
                                            var strchit = ""
                                            if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                strchit = strch
                                            }
                                            cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                        }else{
                                            cell.lblOutTitle.isHidden = true
                                            cell.lblOutTime.isHidden =  true
                                        }
                                    }
                                    else if let manualCheckOutStatusID  =  checkin.manualCheckOutStatusID as? Int16 {
                                        cell.lblOutTitle.isHidden = false
                                        cell.lblOutTime.isHidden =  false
                                        if (manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
                                            cell.lblOutTitle.text = "Out"
                                            if let checkouttime = checkin.checkOutTime{
                                                var strchit = ""
                                                if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                    strchit = strchi
                                                }
                                                cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                                cell.lblOutTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                                            }
                                            
                                        }
                                    }
                                    
                                    else{
                                        cell.lblOutTitle.isHidden = true
                                        cell.lblOutTime.isHidden = true
                                        
                                    }
                                }
                            }else{
                                cell.lblTitle.isHidden = true
                                cell.lblCheckinTime.isHidden = true
                                cell.lblINTitle.isHidden = true
                                cell.lblInTime.isHidden = true
                                cell.lblOutTitle.isHidden = true
                                cell.lblOutTime.isHidden = true

                            }
                            cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                        }

                    }else if let checkouttime = checkin.checkOutTime{
                        print("Checkout time \(checkouttime)")
                        cell.lblOutTitle.text = "Out"
                        var strch =   ""
                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"){
                        strch = strcht
                        }
                                                

                        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy")
                        }
    else{
        
        if(checkin.visitManualCheckIn == 0 ){
        cell.lblINTitle.text = "In"
        if let checkintime = checkin.checkInTime{
        var strchit = ""
        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                          strchit = strch
                        }
    cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                    }
        }else if let manualCheckInStatusID  =  checkin.manualCheckInStatusID as? Int16{
        if (manualCheckInStatusID == 1 || manualCheckInStatusID == 2){
                        cell.lblINTitle.text = "In"
                if let checkintime = checkin.checkInTime{
                var strchit = ""
    if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strchit = strchi
                        }
    cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
    cell.lblInTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                    }
                        
                    }
        }

        if(checkin.visitManualCheckOut == 0){
            cell.lblOutTitle.isHidden = false
            cell.lblOutTime.isHidden =  false
          if let checkouttime = checkin.checkOutTime{
            cell.lblOutTitle.text = "Out"
            var strchit = ""
            if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                    strchit = strch
            }
        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                        }else{
            cell.lblOutTitle.isHidden = true
            cell.lblOutTime.isHidden =  true
                        }
                        }
        else if let manualCheckOutStatusID  =  checkin.manualCheckOutStatusID as? Int16 {
            cell.lblOutTitle.isHidden = false
            cell.lblOutTime.isHidden =  false
                            if (manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
                                cell.lblOutTitle.text = "Out"
        if let checkouttime = checkin.checkOutTime{
        var strchit = ""
        if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                    strchit = strchi
                                }
            cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
        cell.lblOutTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                            }
                                
                            }
                        }

    else{
    cell.lblOutTitle.isHidden = true
    cell.lblOutTime.isHidden = true
        
    }
    }
/*if(checkin.statusID == 3){
    
cell.lblINTitle.text = "In"
let date = dateFormater.date(from: checkin.checkOutTime ?? "22/10/2010")
    dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
cell.lblInTime.text = dateFormater.string(from: date ?? Date())
if let checkouttime = checkin.checkOutTime{
print("Checkout time \(checkouttime)")
cell.lblOutTitle.text = "Out"
var strch =   ""
if let strcht = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"){
strch = strcht
}
                        

cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy")
}
else if let checkintime = checkin.checkInTime{
   
    cell.lblTitle.text = "In"
    var strchit = ""
    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
    strchit = strch

                    if let checkin = planVisit?.checkInOutData.object(at: indexPath.row - 1 ) as? VisitCheckInOutList{
                            
                            if let executive = CompanyUsers().getUser(userId:NSNumber.init(value:checkin.createdBy)){
                                cell.lblTitle.text = String.init(format:"\(executive.firstName)  \(executive.lastName)")
                            }else{
                                cell.lblTitle.text = checkin.createdByName
                            }
                            cell.lblCheckinTime.isHidden = true
                            dateFormater.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                            if(checkin.statusID == 3){
                                cell.lblINTitle.text = "In"
                                let date = dateFormater.date(from: checkin.checkOutTime ?? "22/10/2010")
                                dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
                                cell.lblCheckinTime.text = dateFormater.string(from: date ?? Date())
                                if let checkouttime = checkin.checkOutTime{
                                    print("Checkout time \(checkouttime)")
                                    cell.lblOutTitle.text = "Out"
                                    var strch =   ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    
                                    cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy")
                                }
                                else if let checkintime = checkin.checkInTime{
                                    
                                    cell.lblTitle.text = "In"
                                    var strchit = ""
                                    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                        strchit = strch
                                    }
                                    cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                }
                                
                            }
                            else{
                                
                                if(checkin.visitManualCheckIn == 0 ){
                                    cell.lblINTitle.text = "In"
                                    if let checkintime = checkin.checkInTime{
                                        var strchit = ""
                                        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                            strchit = strch
                                        }
                                        cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                    }
                                }else if let manualCheckInStatusID  =  checkin.manualCheckInStatusID as? Int16{
                                    if (manualCheckInStatusID == 1 || manualCheckInStatusID == 2){
                                        cell.lblINTitle.text = "In"
                                        if let checkintime = checkin.checkInTime{
                                            var strchit = ""
                                            if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                strchit = strchi
                                            }
                                            cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                            cell.lblInTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                                        }
                                        
                                    }
                                }
                                
                                if(checkin.visitManualCheckOut == 0){
                                    cell.lblOutTitle.isHidden = false
                                    cell.lblOutTime.isHidden =  false
                                    if let checkouttime = checkin.checkOutTime{
                                        cell.lblOutTitle.text = "Out"
                                        var strchit = ""
                                        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                            strchit = strch
                                        }
                                        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                    }else{
                                        cell.lblOutTitle.isHidden = true
                                        cell.lblOutTime.isHidden =  true
                                    }
                                }
                                else if let manualCheckOutStatusID  =  checkin.manualCheckOutStatusID as? Int16 {
                                    cell.lblOutTitle.isHidden = false
                                    cell.lblOutTime.isHidden =  false
                                    if (manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
                                        cell.lblOutTitle.text = "Out"
                                        if let checkouttime = checkin.checkOutTime{
                                            var strchit = ""
                                            if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                strchit = strchi
                                            }
                                            cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                                            cell.lblOutTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                                        }
                                        
                                    }
                                }
                                
                                else{
                                    cell.lblOutTitle.isHidden = true
                                    cell.lblOutTime.isHidden = true
                                    
                                }
                            }
                        }else{
                            cell.lblTitle.isHidden = true
                            cell.lblCheckinTime.isHidden = true
                            cell.lblINTitle.isHidden = true
                            cell.lblInTime.isHidden = true
                            cell.lblOutTitle.isHidden = true
                            cell.lblOutTime.isHidden = true

                        }
                        cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                    }

                }
else{
    
    if(checkin.visitManualCheckIn == 0 ){
    cell.lblINTitle.text = "In"
    if let checkintime = checkin.checkInTime{
    var strchit = ""
    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                      strchit = strch
                    }
cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                }
    }else if let manualCheckInStatusID  =  checkin.manualCheckInStatusID as? Int16{
    if (manualCheckInStatusID == 1 || manualCheckInStatusID == 2){
                    cell.lblINTitle.text = "In"
            if let checkintime = checkin.checkInTime{
            var strchit = ""
if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                        strchit = strchi
                    }
cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
cell.lblInTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                }
                    
                }
    }

    if(checkin.visitManualCheckOut == 0){
        cell.lblOutTitle.isHidden = false
        cell.lblOutTime.isHidden =  false
      if let checkouttime = checkin.checkOutTime{
        cell.lblOutTitle.text = "Out"
        var strchit = ""
        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                strchit = strch
        }
    cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                    }else{
        cell.lblOutTitle.isHidden = true
        cell.lblOutTime.isHidden =  true
                    }
                    }
    else if let manualCheckOutStatusID  =  checkin.manualCheckOutStatusID as? Int16 {
        cell.lblOutTitle.isHidden = false
        cell.lblOutTime.isHidden =  false
                        if (manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
                            cell.lblOutTitle.text = "Out"
    if let checkouttime = checkin.checkOutTime{
    var strchit = ""
    if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strchit = strchi
                            }
        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
    cell.lblOutTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                        }
                            
                        }
                    }

else{
cell.lblOutTitle.isHidden = true
cell.lblOutTime.isHidden = true
    
}
}
//}
//else{
//cell.lblTitle.isHidden = true
//cell.lblCheckinTime.isHidden = true
//cell.lblINTitle.isHidden = true
//cell.lblInTime.isHidden = true
//                    cell.lblOutTitle.isHidden = true
//                    cell.lblOutTime.isHidden = true
//                }
    
   */
        }
            }
        
    }else{
        
            if(indexPath.row ==  0){
                cell.lblTitle.text = "Plan"
               
                //dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
                dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let date = dateFormater.date(from: unplanVisit?.NextActionTime ?? "22/10/2010")
                cell.lblCheckinTime.text = Utils.getDatestringWithGMT(gmtDateString: unplanVisit?.NextActionTime ?? "22/10/2010 15:20:21", format: "hh:mm a  EEE,d MMM yy")//dateFormater.string(from: date ?? Date())
                cell.lblINTitle.isHidden  = true
                cell.lblInTime.isHidden   = true
                cell.lblOutTitle.isHidden = true
                cell.lblOutTime.isHidden  = true
            }else{
                let checkin = unplanVisit?.checkInList?[indexPath.row - 1]
                
             //   cell.lblTitle.isHidden = true
                if let executive = CompanyUsers().getUser(userId:NSNumber.init(value:checkin?.createdBy ?? 0)){
                cell.lblTitle.text = String.init(format:"\(executive.firstName)  \(executive.lastName)")
                }else{
                    cell.lblTitle.isHidden = true
               // cell.lblTitle.text = checkin.cre
                }
                
                
                
            cell.lblCheckinTime.isHidden = true
    if let checkintime = checkin?.checkInTime {
        print(checkintime)
        cell.lblINTitle.text = "In"
        dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
        
                var strcht = ""
                    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkin?.checkInTime ?? "", format: "yyyy/MM/dd HH:mm:ss"){
                   strcht =  strch
                    }
                cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strcht, format: "hh:mm a  EEE,dd MMM yy")
                    //dateFormater.string(from: date ?? Date())
                }
                else{
                cell.lblINTitle.isHidden = true
                cell.lblInTime.isHidden = true
                cell.lblOutTitle.isHidden = true
                cell.lblOutTime.isHidden = true
                }
                
    if let checkouttime =  checkin?.checkOutTime{
                    print("check out time = \(checkouttime)")
                    if(checkouttime.count > 0){
                    cell.lblOutTitle.isHidden = false
                    cell.lblOutTime.isHidden = false
                cell.lblOutTitle.text = "Out"
                dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
               // let date = dateFormater.date(from: checkin?.checkInTime ?? "22/10/2010")
               var strchot = ""
                    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
          strchot = strch
                    }
                    cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchot, format: "hh:mm a  EEE,dd MMM yy")
                    }else{
                        cell.lblOutTitle.isHidden = true
                        cell.lblOutTime.isHidden = true
                    }
               // cell.lblCheckinTime.text = Utils.getDatestringWithGMT(gmtDateString: strchot, format: "hh:mm a  EEE,dd MMM yy")
                }else{
//                    cell.lblOutTitle.isHidden = true
//                    cell.lblOutValue.isHidden = true
//                    cell.lblINTitle.isHidden = true
//                    cell.lblInTime.isHidden = true
                }
            }
        }
        
        return cell
        }else{
            return UITableViewCell()
        }
        }else{
          if  let cell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontal", for: indexPath) as? ThreeLblHorizontalCell{
          
            
               // let product =
            if(indexPath.row == 0 ){
                var productbold = NSMutableAttributedString()
                productbold  = productbold.stratributed(bold:"Product",normal:"")
                var qtybold = NSMutableAttributedString()
                qtybold  = qtybold.stratributed(bold:"Qty",normal:"")
                
                var budgetbold = NSMutableAttributedString()
                budgetbold  = budgetbold.stratributed(bold:"Budget",normal:"")
                cell.lbl1.attributedText = productbold
                cell.lbl2.attributedText = qtybold
                    cell.lbl3.attributedText = budgetbold
            }else{
    if (visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
        if let product = unplanVisit?.productList[indexPath.row - 1]{
            
           
//print(Product.getProductName(productID: NSNumber.init(value:product?.productID ?? 0       )))
            cell.lbl1.text = Product.getProductName(productID: product.productID ?? NSNumber.init(value:0)) //product?.productName
           
            cell.lbl2.text = "\(product.quantity ?? "0")"
   // cell.lbl3.text =  String.init(format:"%@",product?.budget ?? "0")
            if  let price = product.budget{
               
           cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", String(describing:price))
                           }else{
                               cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", "0")
                           }
        }
                }else{
                    if  let product = planVisit?.productList[indexPath.row - 1] as? ProductsList{
                    
                        cell.lbl1.text = Product.getProductName(productID: NSNumber.init(value:product.productID ?? 0))
                        if  let price = product.budget{
    cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", String(describing:price))
}else{
cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", "0")
                    }
                    cell.lbl2.text = String.init(format:"%d",product.quantity ?? "0")
                }
//  cell.lbl2.text = String.init(format:"%d",product?.quantity ?? "0"
//   cell.lbl3.text = String.init(format:"%@","0")
//                    cell.lbl1.text = product.pro
//                                       cell.lbl2.text = String.init(format:"%d",product?.quantity ?? "0")
//                                       cell.lbl3.text =  String.init(format:"%d",product?.budget ?? "0")
                }
            }
                return cell
            }else{
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension  VisitSubDetail:PopUpDelegateNonMandatory{
func completionSelectedExecutive(arr: [CompanyUsers]) {
    Utils.removeShadow(view: self.view)
    print(arr)
    if(arr.count > 0){
    self.arrOfSelectedExecutive = arr
        selectedexecutive = arr.first ?? CompanyUsers()
        
        if(assignedUserId == selectedexecutive.entity_id){
            Utils.toastmsg(message:String.init(format: "This is visit is already assigned to %@",selectedexecutive.firstName ?? self.activeuser?.firstName ?? ""),view:self.view)
        }else{
            assignedUserId = selectedexecutive.entity_id
            self.reassignVist()
        }
//        filterUser = selectedexecutive?.entity_id as! Int
//        self.getPlannedVisit()
    }
}


}
