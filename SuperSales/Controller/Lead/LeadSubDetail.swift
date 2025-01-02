//
//  LeadSubDetail.swift
//  SuperSales
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class LeadSubDetail: BaseViewController {

    let setting = Utils().getActiveSetting()


    @IBOutlet var vwPostPone: UIView!
    
    //@IBOutlet var tfOrderexpectedDate: UITextField!
    @IBOutlet var vwCustomerProfile: UIView!
    @IBOutlet var cnstProductListHeight: NSLayoutConstraint!
    
    
    @IBOutlet var lblPlanDate: UILabel!
    
    @IBOutlet weak var imgInteractionType: UIImageView!
    
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblContactNo: UILabel!
    
 
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblContactName: UILabel!
    
    
    @IBOutlet var lblCustomerOrientationValue: UILabel!
    
    @IBOutlet var lblLeadSourceValue: UILabel!
    
    
    @IBOutlet var lblOrderExpectedDateValue: UILabel!
    
    
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var tblCheckIn: UITableView!
    @IBOutlet weak var tblCheckinHeight: NSLayoutConstraint!
    @IBOutlet weak var lblContactPersonNo: UILabel!
    
    @IBOutlet weak var lblAssigneeName: UILabel!
    @IBOutlet weak var imgAssgineImg: UIImageView!
    
    
    @IBOutlet var vwSourcerDetail: UIView!
    
    
    @IBOutlet var vwInfluencerDetail: UIView!
    
    @IBOutlet var vwLeadQualifiedDetail: UIView!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    
    @IBOutlet var vwProductInfo: UIView!
    
    @IBOutlet var btnCreateProposal: UIButton!
    
    @IBOutlet var tblProduct: UITableView!
    
    @IBOutlet var lblScheduleTitle: UILabel!
    //@IBOutlet weak var btnCloseVisit: UIButton!
    
    @IBOutlet weak var btnCreateSalesOrder: UIButton!
    @IBOutlet var btnViewCustomerProfile: UIButton!
    
    @IBOutlet weak var btnEditCustomer: UIButton!
    
    @IBOutlet weak var btnEditAssignee: UIButton!
    
    @IBOutlet weak var vwContactPersonInfo: UIView!
    
    @IBOutlet weak var vwScheduleInfo: UIView!
    
    @IBOutlet weak var vwCustomerDetail: UIView!
    
    @IBOutlet weak var vwVisitAssignInfo: UIView!
    
    @IBOutlet weak var vwButtonDetail: UIView!
    
    @IBOutlet var lblContactValue: UILabel!
    
    @IBOutlet weak var vwDescription: UIView!
    
    
    @IBOutlet var vwLeadQualified: UIView!
    @IBOutlet var btnLeadQualified: UIButton!
    @IBOutlet var btnLeadProposalDone: UIButton!
    
    
    @IBOutlet var btnLeadFinalisation: UIButton!
    
    //Influencer view
    
    
    @IBOutlet var stkInfluencerContact: UIStackView!
    
    @IBOutlet var lblInfluencerName: UILabel!
    
    
    @IBOutlet var lblInfluenceAddress: UILabel!
    
    @IBOutlet var lblInfluencerContactName: UILabel!
    
    
    @IBOutlet var lblInfluencerContactNo: UILabel!
    
    //Source View
    
    @IBOutlet var lblSourceName: UILabel!
    
    @IBOutlet var stkSourceContact: UIStackView!
    @IBOutlet var lblSourceAddress: UILabel!
    
    @IBOutlet var lblSourceContactName: UILabel!
    
    @IBOutlet var lblSourceContactNo: UILabel!
    
    @IBOutlet var vwTrialDone: UIView!
    @IBOutlet var btnTrialDone: UIButton!
    // @IBOutlet var btnLeadDemoDone: UIButton!
    
    @IBOutlet var vwProposalSubmited: UIView!
    
    @IBOutlet var btnLeadProposalGiven: UIButton!
    
    
    @IBOutlet var vwLeadFinalisation: UIView!
    
    @IBOutlet var lblLeadQualifiedTitle: UILabel!
    
    @IBOutlet var lblTrialDoneTitle: UILabel!
    
    
    @IBOutlet var lblProposalSubmitedTitle: UILabel!
    
    
    @IBOutlet var lblLeadFinalisationTitle: UILabel!
    
    
    @IBOutlet weak var vwLead5Stage: UIView!
    
    @IBOutlet weak var vwLead6Stage: UIView!
    
    @IBOutlet weak var lblLead5Title: UILabel!
    
    @IBOutlet weak var btnLead5Stage: UIButton!
    
    @IBOutlet weak var lblLead6Title: UILabel!
    
    
    
    @IBOutlet weak var btnLead6Stage: UIButton!
    
    
    
    
    var arrOfAssignee:[NSNumber] = [NSNumber]()
    var selectedCustomer:CustomerDetails?
    var assignedUserId:NSNumber!
    var visitType:VisitType!
    var planVisit:PlannVisit?
    var popup:CustomerSelection? = nil
    var objLead:Lead!
    var tablecheckInViewHeight: CGFloat {
        
        tblCheckIn.layoutIfNeeded()
        print("height of table = \(tblCheckIn.contentSize.height)")
        return tblCheckIn.contentSize.height
    }
    var tableproductInViewHeight: CGFloat {
        
        tblProduct.layoutIfNeeded()
        print("height of table product = \(tblProduct.contentSize.height)")
        return tblProduct.contentSize.height
    }
    
    var unplanVisit:UnplannedVisit?
    var dateFormater:DateFormatter = DateFormatter()
    var arrOfExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    override func updateViewConstraints() {
        super.updateViewConstraints()
        tblProduct.layoutIfNeeded()
        tblCheckinHeight.constant = tablecheckInViewHeight

        cnstProductListHeight.constant =  tableproductInViewHeight
    

        
    }
    override func viewDidLoad() {
        DispatchQueue.main.async{
            super.viewDidLoad()
            self.setUI()
            DispatchQueue.global(qos: .background).async {
            self.fetchuser{
                (arrOfuser,error) in
                
            }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       
        NotificationCenter.default.addObserver(forName: Notification.Name("updateLeadcheckinInfo"), object: nil, queue: OperationQueue.main) { (notify) in
            
            print("count of Lead Checkin = \(self.objLead.leadCheckInOutList.count) on screen at notify")
            self.tblCheckIn.reloadData()
            
            self.updateViewConstraints()
            
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("updateLeadData"), object: nil, queue: OperationQueue.main) { (notify) in
            DispatchQueue.main.async{
                
                self.setUI()
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateLeadcheckinInfo"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateLeadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            super.viewDidAppear(true)
            self.setUI()
            if let customer  =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value:self.objLead.customerID)){}
            else{
                Utils().getCustomerDetail(cid: NSNumber.init(value:self.objLead.customerID)){
                    (rdferf) in
                }
            }
        }
    }
    
    // MARK: Method
    func setUI(){
        print("count of Lead Checkin = \(self.objLead.leadCheckInOutList.count ) on screen set ui and product count = \(objLead.productList.count)")
        btnCreateSalesOrder.backgroundColor = UIColor.Appthemegreencolor
        btnCreateProposal.backgroundColor = UIColor.Appthemegreencolor
        btnViewCustomerProfile.backgroundColor = UIColor.Appthemegreencolor
        
        objLead.leadCheckInOutList = NSOrderedSet(array: LeadCheckInOutList.getListOfCheckinOutList(leadID: NSNumber.init(value:objLead?.iD ?? 0)))
        print("count of Lead Checkin = \(self.objLead.leadCheckInOutList.count ) through Lead ID")
        tblCheckIn.delegate = self
        tblCheckIn.dataSource  = self
        tblCheckIn.separatorColor = UIColor.clear
        tblCheckIn.tableFooterView = UIView()
        tblCheckIn.reloadData()
        imgInteractionType.image = UIImage.init(named: "icon_placeholder")
        imgInteractionType.image = Utils.getImageFromForLead(interactionId: Int(objLead.nextActionID))
        self.updateViewConstraints()
       
        if(objLead.productList.count ?? 0 > 0 ){
            vwProductInfo.isHidden = false
            tblProduct.separatorColor = UIColor.clear
            tblProduct.delegate = self
            tblProduct.dataSource = self
            tblProduct.reloadData()
        }else{
            vwProductInfo.isHidden = true
        } 
        vwCustomerDetail.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        
        
        vwLeadQualifiedDetail.addBorders(edges: [.left,.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        
        
        vwSourcerDetail.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        
        vwInfluencerDetail.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        vwContactPersonInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        vwScheduleInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        vwVisitAssignInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        
        vwProductInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
        
       
        btnCreateProposal.setTitleColor(UIColor.white, for: .normal)
        btnCreateSalesOrder.setTitleColor(UIColor.white, for: .normal)
        
        tvDescription.isUserInteractionEnabled = false
        
        lblPlanDate.text = ""
        
        if(tvDescription.text.count == 0){
        if(objLead?.remarks?.count ?? 0 > 0){
            if let description = objLead?.remarks {
                print("description = \(description) ")
                tvDescription.text = description
                tvDescription.setFlexibleHeight()
            }
            
            vwDescription.isHidden = false
            
        }else{
            
            vwDescription.isHidden = true
        }
        }
        
        let gestureCall = UITapGestureRecognizer(target: self, action: #selector(self.handleTapContactno(_:)))
        let gestureCustomerCall = UITapGestureRecognizer(target: self, action: #selector(self.handleTapCustomerContactno(_:)))
        lblCustomerName.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(lblcustomertapped))
        lblCustomerName.addGestureRecognizer(gesture)
        let strContactNo = NSMutableAttributedString.init(string:"Contact No:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
        if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead?.customerID ?? 0)){
            let contactno = NSAttributedString.init(string: customer.mobileNo ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor , NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue])
            lblContactNo.attributedText = strContactNo
            lblContactValue.attributedText = contactno
            lblContactValue.isUserInteractionEnabled = true
            lblContactValue.addGestureRecognizer(gestureCustomerCall)
        }else{
            lblContactNo.text = ""
            lblContactValue.text = ""
        }
        
        var strAddress = ""
        if(objLead?.addressMasterID ?? 0 > 0){
            
          
            
            if   let address = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:(objLead?.addressMasterID ?? 0))) as? String{
                strAddress = address
            }else{
                strAddress = ""
            }
        }
        var mutstrAddress:NSMutableAttributedString? =  NSMutableAttributedString()
        mutstrAddress = mutstrAddress?.stratributed(bold:"Address: ",normal:strAddress)
        lblAddress.setMultilineLabel(lbl: lblAddress)
        
        lblAddress.attributedText = mutstrAddress
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let createplanvisitdate = dateFormater.date(from: objLead?.createdTime ?? "2020/01/22 12:12:12")
        dateFormater.dateFormat = "dd-MM-yyyy"
        lblCreatedDate.text  = dateFormater.string(from: createplanvisitdate ?? Date())
        let attributedcustomername = NSAttributedString.init(string: objLead?.customerName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
        lblCustomerName.attributedText = attributedcustomername
        if(objLead.contactID ?? 0 > 0){
            if  let contact = Contact.getContactFromID(contactID: NSNumber.init(value:objLead?.contactID ?? 0)){
                lblContactPersonNo.isUserInteractionEnabled = true
                lblContactPersonNo.addGestureRecognizer(gestureCall)
                let strfirstname = contact.firstName as? String ?? ""
                let strlastname = contact.lastName as? String ?? ""
                lblContactName.text = String.init(format:"\( strfirstname) \(strlastname)")
               let contactno =  NSAttributedString.init(string: contact.mobile ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor , NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue])
                
                lblContactPersonNo.attributedText = contactno
               
                lblContactPersonNo.isHidden = false
                
                // planVisit?.contactMobileNo
            }else{
                lblContactName.text = "No Contact"
                lblContactPersonNo.isHidden = true
            }
        }else{
            lblContactName.text = "No Contact"
            lblContactPersonNo.isHidden = true
        }
        tblCheckIn.reloadData()
        tvDescription.setFlexibleHeight()
        if   let user = CompanyUsers().getUser(userId:NSNumber.init(value:objLead?.reAssigned ?? 0)){
            assignedUserId = NSNumber.init(value:objLead?.reAssigned ??  0)
            if(assignedUserId.intValue > 0){
                self.arrOfSelectedExecutive.removeAll()
                self.arrOfSelectedExecutive = [user]
            }
            lblAssigneeName.text = String.init(format: "%@ %@", user.firstName,user.lastName)
        }else{
            lblAssigneeName.text = ""
        }
        
        if(objLead.secondInfluencerID > 0){
            var strInfluencerAddress = ""
            var mutstrsecondInfluenAddress:NSMutableAttributedString? =  NSMutableAttributedString()
            if let source = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID ?? 0)){
                lblSourceName.font = UIFont.boldSystemFont(ofSize: 16)
                //        if let sourcecontact = source.contactNo as?  String{
                //        if(source.contactNo.count > 0){
                //            lblSourceContactNo.text  = sourcecontact
                //        }else{
                //           stkSourceContact.isHidden = true
                //        }
                //        }else{
                //            stkSourceContact.isHidden = true
                //        }
                // lblSourceName.text = source.name
                lblInfluencerName.text = source.name
                if  let soadId = objLead.secondInfluencerAddressMasterID as? Int64{
                    print("sddress if of second address influencer id = \(soadId)")
                    if(soadId > 0){
                        
                        
                        if   let address = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:(soadId))) as? String{
                            strInfluencerAddress = address
                        }else{
                            strInfluencerAddress = ""
                        }
                    }
                }
                
                mutstrsecondInfluenAddress = mutstrsecondInfluenAddress?.stratributed(bold:"Address: ",normal:strInfluencerAddress)
                lblInfluenceAddress.attributedText = mutstrsecondInfluenAddress
                //lblSourceAddress.attributedText = mutstrsecondInfluenAddress
            }else{
                lblInfluencerName.text = "Influnecer not mapped"
            }
            lblInfluenceAddress.attributedText = mutstrsecondInfluenAddress
            //  lblSourceAddress.attributedText = mutstrsecondInfluenAddress
        }else{
            vwInfluencerDetail.isHidden = true
            // vwSourcerDetail.isHidden = true
        }
        
        if(objLead.influencerID > 0){
            var strInfluencerAddress = ""
            var mutstrfiAddress:NSMutableAttributedString? =  NSMutableAttributedString()
            if let influencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead?.influencerID ?? 0)){
                lblInfluencerName.font = UIFont.boldSystemFont(ofSize: 16)
                //lblInfluencerName.text = influencer.name
                lblSourceName.text = influencer.name
                if let inadId = objLead.influencerAddressMasterID as? Int64{
                    print("sddress if of influencer id = \(inadId)")
                    if(inadId > 0){
                        
                        if   let address = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:(inadId))) as? String{
                            strInfluencerAddress = address
                        }else{
                            strInfluencerAddress = ""
                        }
                    }
                }
                
                mutstrfiAddress = mutstrfiAddress?.stratributed(bold:"Address: ",normal:strInfluencerAddress)
                lblSourceAddress.attributedText = mutstrfiAddress
                //        if let influencontactno =  influencer.contactNo as? String{
                //        if(influencer.contactNo.count > 0){
                //            lblInfluencerContactNo.text  = influencontactno
                //        }else{
                //            lblInfluencerContactName.isHidden = true
                //            lblInfluencerContactNo.isHidden = true
                //            stkInfluencerContact.isHidden = true
                //        }
                //        }else{
                //            stkInfluencerContact.isHidden  = true
                //        }
                //lblInfluenceAddress.attributedText = mutstrfiAddr
                //  objLead.
                //lblSourceContactNo
                //lblInflunencerContactNo
            }else{
                lblSourceName.text =  "Influencer not mapped"
            }
            lblSourceAddress.attributedText = mutstrfiAddress
            // lblInfluenceAddress.attributedText = mutstrfiAddress
        }else{
            // vwInfluencerDetail.isHidden = true
            vwSourcerDetail.isHidden = true
        }
        stkInfluencerContact.isHidden  = true
        stkSourceContact.isHidden = true
        lblInfluenceAddress.setMultilineLabel(lbl: lblInfluenceAddress)
        
        lblSourceAddress.setMultilineLabel(lbl: lblSourceAddress)
        
        if(objLead.isLeadQualified == 1){
            btnLeadQualified.isSelected = true
        }else{
            btnLeadQualified.isSelected = false
        }
        
        if(objLead.isTrialDone == 1){
            btnTrialDone.isSelected = true
        }else{
            btnTrialDone.isSelected = false
        }
        if(objLead.leadstage5 == 1){
            btnLead5Stage.isSelected = true
        }else{
            btnLead5Stage.isSelected = false
        }
        if(objLead.leadstage6 == 1){
            btnLead6Stage.isSelected = true
        }else{
            btnLead6Stage.isSelected = false
        }
        if(objLead.isNegotiationDone == 1){
            btnLeadFinalisation.isSelected = true
        }else{
            btnLeadFinalisation.isSelected = false
        }
        if(objLead.proposalSubmitted == 1){
            btnLeadProposalDone.isSelected = true
        }else{
            btnLeadProposalDone.isSelected = false
        }
        print("oriend id = \(objLead.customerOrientationID) , source id  = \(objLead.leadSourceID)")
        lblCustomerOrientationValue.text = Utils.getStringCustomerOrintationFromCustomerOrintationID(oriID: Int(objLead.customerOrientationID))//objLead.customerOrientationID
        
        
        lblLeadSourceValue.text = LeadSource.getLeadSourceFromLeadSourceID(leadsourceID: NSNumber.init(value:objLead?.leadSourceID ?? 0))
        
        if let strorderexpDate = objLead.orderExpectedDate as? String {
            lblOrderExpectedDateValue.text = Utils.getDatestringWithGMT(gmtDateString: strorderexpDate, format: "dd-MM-yyyy")
        }
        
        if(objLead.leadStatusList.count > 0){
            
            //  if let lastoutcome = objLead.leadStatusList.lastObject as? LeadStatusList{
            for lastoutCome in  objLead.leadStatusList{
                if let lastoutcome =  lastoutCome as? LeadStatusList{
                    if(lastoutcome.isLeadQualified == 1){
                        btnLeadQualified.isSelected = true
                        btnLeadQualified.isUserInteractionEnabled = false
                    }
                    if(lastoutcome.isTrialDone == 1){
                        btnTrialDone.isSelected = true
                        btnTrialDone.isUserInteractionEnabled = false
                    }
                    
                    if(lastoutcome.leadstage5 == 1){
                      
                            btnLead5Stage.isSelected = true
                        btnLead5Stage.isUserInteractionEnabled = false
                        
                    }
                    
                    if(lastoutcome.leadstage6 == 1){
                      
                            btnLead6Stage.isSelected = true
                        btnLead6Stage.isUserInteractionEnabled = false
                        
                    }
                    
                    if(lastoutcome.proposalSubmitted == 1){
                        btnLeadProposalGiven.isSelected = true
                        btnLeadProposalGiven.isUserInteractionEnabled = false
                    }
                    if(lastoutcome.isNegotiationDone == 1){
                        btnLeadFinalisation.isSelected = true
                        btnLeadFinalisation.isUserInteractionEnabled = false
                    }
                   
                }
            }
            
            lblScheduleTitle.font = UIFont.boldSystemFont(ofSize: 16)
            
            lblScheduleTitle.text = "Next Action Date"
            
            if let  strcustomerprofile = self.activesetting.leadCustomerProfile as? NSNumber{
                if(strcustomerprofile == 1){
                    vwCustomerProfile.isHidden = false
                    btnViewCustomerProfile.isHidden = false
                }else{
                    vwCustomerProfile.isHidden = true
                    btnViewCustomerProfile.isHidden = true
                }
            }else{
                vwCustomerProfile.isHidden = true
                btnViewCustomerProfile.isHidden = true
            }
            // objLead.leadCheckInOutList = LeadCheckInOutList.getListOfCheckinOutList(leadID: NSNumber.init(value:objLead?.iD ?? 0))
            
            
           
            stkSourceContact.isHidden = true
            stkInfluencerContact.isHidden = true
           
            cnstProductListHeight.constant =  tableproductInViewHeight //tblProduct.contentSize.height
            //tblCheckIn.isScrollEnabled = false
            tblCheckinHeight.constant = tablecheckInViewHeight
            btnLeadProposalDone.isUserInteractionEnabled =  false
            
            btnTrialDone.isUserInteractionEnabled =  false
            
            btnLeadFinalisation.isUserInteractionEnabled =  false
            btnLeadQualified.isUserInteractionEnabled =  false
        
            if let laststatus = objLead.leadStatusList.firstObject as?  LeadStatusList{
            
            if let strorderexpDate = laststatus.orderExpectedDate as? String {
                lblOrderExpectedDateValue.text = Utils.getDatestringWithGMT(gmtDateString: strorderexpDate, format: "dd-MM-yyyy")
            }
                if(laststatus.remarks.count > 0){
                  
                    print("description = \(laststatus.remarks) ")
                    tvDescription.text = laststatus.remarks
                    tvDescription.setFlexibleHeight()
                  
                    vwDescription.isHidden = false
                    
                }else{
                    
                    vwDescription.isHidden = true
                }
            }
        
        }
        
        if(self.activesetting.showLeadQualifiedInLead == 1){
            vwLeadQualified.isHidden = false
            if(self.activesetting.leadQualifiedTextInLead?.count ?? 0 > 0){
                self.lblLeadQualifiedTitle.text = self.activesetting.leadQualifiedTextInLead
                
            }else{
                self.lblLeadQualifiedTitle.text = "Lead Qualified/Prospect"
                
            }
        }else{
            vwLeadQualified.isHidden = true
        }
        if(self.activesetting.showTrialDoneInLead == 1){
            vwTrialDone.isHidden = false
            
            if(self.activesetting.trialDoneTextInLead?.count ?? 0 > 0 ){
                self.lblTrialDoneTitle.text = self.activesetting.trialDoneTextInLead
            }else{
                
                self.lblTrialDoneTitle.text = "Demo/Trial Done"
            }
        }else{
            vwTrialDone.isHidden = true
        }
        if(self.activesetting.leadStage5 == 1){
            vwLead5Stage.isHidden = false
            
            if(self.activesetting.leadStage5Text?.count ?? 0 > 0 ){
                self.lblLead5Title.text = self.activesetting.leadStage5Text
            }else{
                
                self.lblLead5Title.text = "Lead stage 5"
            }
        }else{
            vwLead5Stage.isHidden = true
        }
        if(self.activesetting.leadStage6 == 1){
            vwLead6Stage.isHidden = false
            
            if(self.activesetting.leadStage6Text?.count ?? 0 > 0 ){
                self.lblLead6Title.text = self.activesetting.leadStage6Text
            }else{
                
                self.lblLead6Title.text = "Lead stage 6"
            }
        }else{
            vwLead6Stage.isHidden = true
        }
        if(self.activesetting.showNegotiationInLead == 1){
            vwLeadFinalisation.isHidden = false
            if(self.activesetting.negotiationTextInLead?.count ?? 0 > 0){
                self.lblLeadFinalisationTitle.text = self.activesetting.negotiationTextInLead
            }else{
                self.lblLeadFinalisationTitle.text = "Negotiation/Finalisation"
            }
        }else{
            vwLeadFinalisation.isHidden = true
        }
        if(self.activesetting.showProposalSubInLead == 1){
            vwProposalSubmited.isHidden = false
            if(self.activesetting.proposalSubTextInLead?.count ?? 0 > 0){
                self.lblProposalSubmitedTitle.text = self.activesetting.proposalSubTextInLead
            }else{
                self.lblProposalSubmitedTitle.text = "Proposal Given"
            }
        }else{
            vwProposalSubmited.isHidden = true
        }
        
        if(self.activesetting.showLeadQualifiedInLead == NSNumber.init(value: 1)){
            self.vwLeadQualified.isHidden = false
        }else{
            self.vwLeadQualified.isHidden = true
        }
        if(self.activesetting.showTrialDoneInLead == NSNumber.init(value: 1)){
            self.vwTrialDone.isHidden = false
        }else{
            self.vwTrialDone.isHidden = true
        }
        if(self.activesetting.showProposalSubInLead == NSNumber.init(value: 1)){
            self.vwProposalSubmited.isHidden = false
        }else{
            self.vwProposalSubmited.isHidden = true
        }
        if(self.activesetting.showNegotiationInLead == NSNumber.init(value: 1)){
            self.vwLeadFinalisation.isHidden = false
        }else{
            self.vwLeadFinalisation.isHidden = true
        }
        
        if(BaseViewController.staticlowerUser.count == 0){
            btnEditAssignee.isHidden = true
        }else{
            btnEditAssignee.isHidden = false
        }
        tblCheckinHeight.constant = tablecheckInViewHeight
        cnstProductListHeight.constant =  tableproductInViewHeight
    
        let mutableProductList = NSMutableOrderedSet.init(orderedSet:  objLead.productList)
        let uniqueProductSet =  NSMutableOrderedSet()
        if(mutableProductList.count ?? 0 > 1){
//        for i in 0...mutableProductList!.count-1 {
//            let product = mutableProductList![i]
//            if(!(uniqueProductSet.contains(product as! ProductsList))){
//                if(uniqueProductSet.count > 0){
//                    for pro in uniqueProductSet{
//                        if((pro as! ProductsList).productID == (product as! ProductsList).productID){
//
//                        }else{
//                            uniqueProductSet.add(product)
//                        }
//                    }
//                }else{
//                    uniqueProductSet.add(product)
//                }
//
//            }
//        }
            
            self.objLead.productList =  self.withoutDuplicates([mutableProductList]).first!
         //   self.objLead.productList = uniqueProductSet
        }
       
        print("count of product for lead  = \(objLead.productList.count)")
    }
  /*  @objc func handleTapContactno(_ sender: UITapGestureRecognizer) {
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            if let url = URL(string: "tel://\(unplanVisit?.tempCustomerObj?.ContactNo)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }else{
            
            if let url = URL(string: "tel://\(planVisit?.contactMobileNo)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
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
    @objc func lblcustomertapped(){
        if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
            customerhistory.customerName = lblCustomerName.text
            customerhistory.customerID =  NSNumber.init(value:objLead.customerID)
            self.navigationController?.pushViewController(customerhistory, animated: true)
            
        }
    }*/
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    internal func withoutDuplicates<T>(_ array: [T]) -> [T] {
        
        let orderedSet: NSMutableOrderedSet = []
        var modifiedArray = [T]()
        
        orderedSet.addObjects(from: array)
        
        for i in 0...(orderedSet.count - 1) {
            modifiedArray.append(orderedSet[i] as! T)
        }
        return modifiedArray
    }
    // MARK: IBAction
    @IBAction func btnCreateSalesOrderClicked(_ sender: UIButton) {
        guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: objLead?.customerID ?? 0)), cust.statusID == 2 else {
            Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view: self.view)
            return
        }
                
        if let objOutcome = Outcomes.isTrialSuccessful() {
            if (setting.mandatoryTrialSuccessfulStatusForOrderInLead == 1) {
                if let objTempLead = Lead.getLeadByID(Id: Int(objLead?.iD ?? 0)), let leadOutcomes = objTempLead.leadStatusList.value(forKey: "outcomeID") as? [Int64] {
                    if !leadOutcomes.contains(objOutcome.leadOutcomeIndexID) {
                        self.view.window?.makeToast("Please update lead status to 'Trial Successful to place order.")
                        return
                    }
                }
            }
        }
        
        if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
            vc.lead = objLead
            self.navigationController!.pushViewController(vc, animated: true)
        }
        print("count of lead product = \(objLead.productList.count)")
    }
    
    @objc func handleTapContactno(_ sender: UITapGestureRecognizer) {
        if  let contact = Contact.getContactFromID(contactID: NSNumber.init(value:objLead?.contactID ?? 0)){
            if let strcontactno = contact.mobile as? String{
            if let url = URL(string: "tel://\(strcontactno)"), UIApplication.shared.canOpenURL(url) {
                           if #available(iOS 10, *) {
                               UIApplication.shared.open(url)
                           } else {
                               UIApplication.shared.openURL(url)
                           }
            }
            }
        }
//           if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
//               if let url = URL(string: "tel://\(unplanVisit?.tempCustomerObj?.ContactNo)"), UIApplication.shared.canOpenURL(url) {
//               if #available(iOS 10, *) {
//                   UIApplication.shared.open(url)
//               } else {
//                   UIApplication.shared.openURL(url)
//               }
//           }
//           }else{
//
//            if let url = URL(string: "tel://\(objLead.)"), UIApplication.shared.canOpenURL(url) {
//                   if #available(iOS 10, *) {
//                       UIApplication.shared.open(url)
//                   } else {
//                       UIApplication.shared.openURL(url)
//                   }
//               }
//
//           }
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
       
      
    
       @objc func lblcustomertapped(){
           if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
               customerhistory.isEdit = false
               customerhistory.customerName = lblCustomerName.text
            if let customer = CustomerDetails.getCustomerByID(cid: NSNumber(value: objLead.customerID)) as? CustomerDetails{
               customerhistory.customerID =  NSNumber.init(value:objLead.customerID)
           self.navigationController?.pushViewController(customerhistory, animated: true)
            }else{
                Utils.toastmsg(message:"Customer is not mapped So you can't see customer History",view: self.view)
            }
           }
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
    
    
    // MARK: API Call
    func reassignVist(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        var assignvisitdic = [String:Any]()
        assignvisitdic["OriginalAssignee"] = assignedUserId
        assignvisitdic["CompanyID"] =  self.activeuser?.company?.iD
        assignvisitdic["CreatedBy"] =  self.activeuser?.userID
        assignvisitdic["AssignedBy"] = self.activeuser?.userID
        assignvisitdic["ID"] = objLead.iD
        //   assignvisitdic["VisitTypeID"] =   objLead.leadTypeID
        assignvisitdic["SeriesPostfix"] = objLead.seriesPostfix
        assignvisitdic["SeriesPrefix"] = objLead.seriesPrefix
        
        //        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
        //            assignvisitdic["ID"] = planVisit?.iD
        //            assignvisitdic["VisitTypeID"] =   1
        //            assignvisitdic["SeriesPostfix"] = planVisit?.seriesPostfix
        //        }else{
        //            assignvisitdic["ID"] = unplanVisit?.localID
        //            assignvisitdic["VisitTypeID"] =   2
        //            assignvisitdic["SeriesPostfix"] = unplanVisit?.seriesPostfix
        //        }
        
        var param = Common.returndefaultparameter()
        param["assignedleadjson"] =  Common.json(from:assignvisitdic)
        print("parameter of reassign lead = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAssignedlead, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            print(arr)
            print(responseType)
            
            SVProgressHUD.dismiss()
            if(error.code == 0){
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
                // UIApplication.shared.keyWindow?.inputViewController?.view.makeToast(message)
                self.objLead?.reAssigned = self.assignedUserId.int64Value
                //    self.objLead?. = String.init(format:"\(self.selectedexecutive.firstName) \(self.selectedexecutive.lastName)")
                self.objLead?.managedObjectContext?.mr_save({ (context) in
                    print("saving")
                }, completion: { (status, error) in
                    if(error == nil){
                        print("Its saved")
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                //                self.navigationController?.popViewController(animated: true)
                //                })
            }else{
                if(message.count > 0){
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                    }
                }else{
                    if let ermsg =    error.userInfo["localiseddescription"] as? String{
                        if(ermsg.count > 0){
                            Utils.toastmsg(message:ermsg,view: self.view)
                        }else{
                            Utils.toastmsg(message:error.localizedDescription,view: self.view)
                        }
                    }
                    
                }
                UIApplication.shared.keyWindow?.inputViewController?.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
            }
        }
    }
    
    func updateAssignee(completion: (() -> Void)? = nil) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["TaggedTo"] = self.activeuser?.userID
        param["CustomerID"] = self.selectedCustomer?.iD
        var taggedListDic = [[String:Any]]()
        
        if let selectedCustomer = selectedCustomer{
            arrOfAssignee.append(contentsOf: selectedCustomer.taggedToIDList.map(
            {
                //taggedUserID
                ($0 as! TaggedToIDList).taggedUserID as NSNumber
                
            }))
        }
        
        for assid in arrOfAssignee{
            taggedListDic.append(["TaggedUserID":assid])
        }
        param["TaggedUsersList"] = Common.json(from: taggedListDic)
        
        var strurl = ConstantURL.kWSUrlTagCustomer
        self.apihelper.getdeletejoinvisit(param: param, strurl: strurl, method: Apicallmethod.post) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                    completion?()
                }
               
            }else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                    completion?()
                }
                
            }
        }
    }
    //MARK: - IBAction
    @IBAction func btnEditCustomerClicked(_ sender: UIButton) {
        if let customer  =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID)){
            if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                addCustomer.isVendor = false
                addCustomer.isFromColdCallVisit = false
                addCustomer.isEditCustomer = true
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                if let leadCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID)) as? CustomerDetails{
                    addCustomer.selectedCustomer = leadCustomer
                    self.navigationController?.pushViewController(addCustomer, animated: true)
                }else{
                   
                    Utils.toastmsg(message:"Customer is not mapped , So you can't Edit Customer",view: self.view)
                }
                //            addCustomer.saveCustDelegate = self
              
            }
        }else{
            SVProgressHUD.show()
            Utils().getCustomerDetail(cid: NSNumber.init(value: objLead.customerID)){
                 (status) in
                if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                    addCustomer.isVendor = false
                    addCustomer.isFromColdCallVisit = false
                    addCustomer.isEditCustomer = true
                    AddCustomer.isFromInfluencer = 0
                    addCustomer.isForAddAddress = false
                    if let leadCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:self.objLead.customerID)) as? CustomerDetails{
                        addCustomer.selectedCustomer = leadCustomer
                        self.navigationController?.pushViewController(addCustomer, animated: true)
                    }else{
                       
                        Utils.toastmsg(message:"Customer is not mapped , So you can't Edit Customer",view: self.view)
                    }
                    //            addCustomer.saveCustDelegate = self
                  
                }
            }
        }
        
    }
    
    @IBAction func btnEditAssigneeClicked(_ sender: UIButton) {
        if((visitType == VisitType.planedvisit) && (self.activesetting.customTagging == NSNumber.init(value: 3)) && (Utils.isCustomerMapped(cid: NSNumber.init(value:(planVisit?.customerID)!)) == false)){
            Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_reassign_this_visit", comment: ""),view: self.view)
        }else{
            self.arrOfExecutive = BaseViewController.staticlowerUser
            if let cust  = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID))
                as? CustomerDetails
            {
                selectedCustomer = cust
//                self.changeAssigneeAsperCustomerSelection()
            }
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select User"
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfExecutive = self.arrOfExecutive
            self.popup?.parentViewOfPopup = self.view
            self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
            self.popup?.strLeftTitle = "OK"
            self.popup?.strRightTitle = "Cancel"
            self.popup?.selectionmode = SelectionMode.single
            self.popup?.isSearchBarRequire = false
            self.popup?.isFromSalesOrder =  false
            self.popup?.viewfor = ViewFor.companyuser
            self.popup?.isFilterRequire = false
            self.present(self.popup!, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnCreateProposalClicked(_ sender: UIButton) {
        
        if let addProposal = Common.returnclassviewcontroller(storybordname: Constant.StoryboardProposal, classname: Constant.AddProposal) as? AddProposal{
            self.navigationController?.pushViewController(addProposal, animated: true)
        }
    }
    
    @IBAction func viewCustomerClicked(_ sender: UIButton) {
        if let strcustomerprofile = self.activesetting.leadCustomerProfileURL as? String{
            if(strcustomerprofile.count > 0){
                UIApplication.shared.openURL(URL.init(string:  strcustomerprofile)!)
                //URL.init(string:""))
            }else{
                Utils.toastmsg(message:"Customer profile URL is not available",view: self.view)
            }
        }else{
            Utils.toastmsg(message:"Customer profile URL is not available",view: self.view)
        }
    }

}
    

extension LeadSubDetail:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if(tableView == tblCheckIn){
            print("count of Lead Checkin = \(self.objLead.leadCheckInOutList.count) on screen")
            return (objLead.leadCheckInOutList.count + 1)
        }else{
            return (objLead?.productList.count ?? 0) + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblCheckIn){
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CheckinDetailCell, for: indexPath) as? CheckInDetailCell{
                cell.selectionStyle  = UITableViewCell.SelectionStyle.none
                if(indexPath.row == 0){
                   // cell.lblTitle.text = "Created On"
                    cell.lblTitle.text = "Plan"
                    cell.lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.lblCheckinTime.font = UIFont.boldSystemFont(ofSize: 17)
                    dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    cell.lblCheckinTime.text = ""
                     if let strnextactiontime = objLead?.nextActionTime{
                        if let date = dateFormater.date(from: strnextactiontime){
                            dateFormater.dateFormat = "dd-MM-yyyy"
                            print(date)
                            cell.lblCheckinTime.text = dateFormater.string(from: date)
                        }else{
                            dateFormater.dateFormat = "yyyy-MM-dd, HH:mm a"
                            if let date1 = dateFormater.date(from: strnextactiontime){
                                dateFormater.dateFormat = "dd-MM-yyyy"
                                print(date1)
                                cell.lblCheckinTime.text = dateFormater.string(from: date1)
                            }else{
                                dateFormater.dateFormat = "dd-MM-yyyy, hh:mm a"
                                if let date1 = dateFormater.date(from: strnextactiontime){
                                    dateFormater.dateFormat = "dd-MM-yyyy"
                                    print(date1)
                                    cell.lblCheckinTime.text = dateFormater.string(from: date1)
                                }
                            }
                            if(cell.lblCheckinTime.text?.count == 0){
                                dateFormater.dateFormat = "dd-MM-yyyy HH:mm a"
                                if let date1 = dateFormater.date(from: strnextactiontime){
                                    dateFormater.dateFormat = "dd-MM-yyyy"
                                    print(date1)
                                    cell.lblCheckinTime.text = dateFormater.string(from: date1)
                                }
                            }
                        }
                    }
                    cell.lblTitle.isHidden = false
                    cell.lblCheckinTime.isHidden = false
                    
                    cell.lblINTitle.isHidden = true
                    cell.lblInTime.isHidden = true
                    cell.lblOutTitle.isHidden = true
                    cell.lblOutTime.isHidden = true
                }else{
                    cell.lblTitle.font =  UIFont.systemFont(ofSize: 17)
                    cell.lblInTime.font = UIFont.systemFont(ofSize: 17)
                    cell.lblOutTime.font = UIFont.systemFont(ofSize: 17)
                    cell.lblOutTitle.font = UIFont.systemFont(ofSize: 17)
                    
                    if let checkin = objLead?.leadCheckInOutList.object(at: indexPath.row - 1 ) as? LeadCheckInOutList{
                        
                        if(checkin.checkInFrom == "C"){
                            if let user = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:checkin.createdBy)){
                                
                                let strcheckinFrom = String.init(format:"%@",user.name)
                               
                                
                                cell.lblTitle.text = strcheckinFrom
                            }else{
                                let strfirst = self.activeuser?.firstName ?? ""
                                let strlast = self.activeuser?.lastName ?? ""
                                //    cell.lblTitle.text = String.init(format:"\(strfirst) \(strlast)") //self.activeuser?.firstName //checkin.createdByName
                                let strcheckinFrom = String.init(format:"\(strfirst) \(strlast)")
                              
                                
                                cell.lblTitle.text = strcheckinFrom
                            }
                        }else if(checkin.checkInFrom == "I" ){
                            if let user = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.influencerID)){
                                
                                let strcheckinFrom = String.init(format:"%@ \("[Influencer]")",user.name)
                              
                                cell.lblTitle.text = strcheckinFrom
                            }else{
                                let strfirst = self.activeuser?.firstName ?? ""
                                let strlast = self.activeuser?.lastName ?? ""
                                //    cell.lblTitle.text = String.init(format:"\(strfirst) \(strlast)") //self.activeuser?.firstName //checkin.createdByName
                                let strcheckinFrom = String.init(format:"\(strfirst) \(strlast) \("[Influencer]")")
                             
                                cell.lblTitle.text = strcheckinFrom
                            }
                        }else if(checkin.checkInFrom == "S" ){
                            if let user = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID)){
                                
                                let strcheckinFrom = String.init(format:"%@ \("[Influencer]")",user.name)
                              
                                
                                cell.lblTitle.text = strcheckinFrom
                            }else{
                                let strfirst = self.activeuser?.firstName ?? ""
                                let strlast = self.activeuser?.lastName ?? ""
                                //    cell.lblTitle.text = String.init(format:"\(strfirst) \(strlast)") //self.activeuser?.firstName //checkin.createdByName
                                let strcheckinFrom = String.init(format:"\(strfirst) \(strlast) \("[Influencer]")")
                            
                                
                                cell.lblTitle.text = strcheckinFrom
                            }
                        }
                        cell.lblCheckinTime.isHidden = true
                        dateFormater.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                        if(checkin.statusID == 3){
                            cell.lblINTitle.text = "In"
                            
                            if let checkintime = checkin.checkInTime as? String{
                                print("Checkin time \(checkintime)")
                                cell.lblTitle.text = "In"
                                if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                    
                                    if let strcht = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy") as? String{
                                        cell.lblInTime.text = strcht
                                    }
                                }else{
                                    cell.lblInTime.text = ""
                                }
                            }
                            
                        }else if let mchinst = checkin.manualCheckInStatusID as? Int16{
                            if(mchinst == 0){
                                cell.lblINTitle.text = "In"
                                if let checkintime = checkin.checkInTime as? String{
                                    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                        if let strcht = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy") as? String{
                                            cell.lblInTime.text = strcht
                                        }
                                    }else{
                                        cell.lblInTime.text = ""
                                    }
                                }
                            } else if (mchinst == 1 || mchinst == 2){
                                cell.lblINTitle.text = "In"
                                if let checkintime = checkin.checkInTime as? String{
                                    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                        if let strcht = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy") as? String{
                                            cell.lblInTime.text = strcht
                                        }
                                    }else{
                                        cell.lblInTime.text = ""
                                    }
                                }
                            }
                            
                            if let checkouttime = checkin.checkOutTime as? String{
                                
                                if(checkin.leadManualCheckOut > 0){
                                    cell.lblOutTitle.isHidden = false
                                    cell.lblOutTitle.text = "Out"
                                    if let checkouttime = checkin.checkOutTime as? String{
                                        if let strcho =   Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                            
                                            if let strchot = Utils.getDatestringWithGMT(gmtDateString: strcho, format: "hh:mm a  EEE,dd MMM yy") as? String{
                                                cell.lblOutTime.text = strchot
                                            }
                                        }else{
                                            cell.lblOutTime.text = ""
                                            cell.lblOutTitle.isHidden = true
                                        }
                                    }
                                }else if let manualCheckOutStatusID  =  checkin.manualCheckInStatusID as? Int16 {
                                    print("checkout status id = \(manualCheckOutStatusID)")
                                    if(manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
                                        cell.lblOutTitle.isHidden = false
                                        cell.lblOutTitle.text = "Out"
                                        if let checkouttime = checkin.checkOutTime as? String{
                                            if let strcho = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                if let  strchot = Utils.getDatestringWithGMT(gmtDateString: strcho, format: "hh:mm a  EEE,dd MMM yy") as? String{
                                                    cell.lblOutTime.text = strchot
                                                    if(strchot.count == 0){
                                                        cell.lblOutTitle.isHidden = true
                                                        cell.lblOutTime.isHidden = true
                                                    }
                                                }
                                            }else{
                                                cell.lblOutTime.text = ""
                                                cell.lblOutTitle.isHidden = true
                                            }
                                        }
                                    }else if(manualCheckOutStatusID == 0){
                                        
                                        cell.lblOutTitle.text = "Out"
                                        if let checkouttime = checkin.checkOutTime as? String{
                                            if(checkouttime.count > 0){
                                                cell.lblOutTitle.isHidden = false
                                                if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                                    if let strcht = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy") as? String{
                                                        cell.lblOutTime.text = strcht
                                                    }
                                                }else{
                                                    cell.lblOutTime.text = ""
                                                    cell.lblOutTitle.isHidden = true
                                                    
                                                }
                                            }else{
                                                cell.lblOutTime.text = ""
                                                cell.lblOutTitle.isHidden = true
                                            }
                                        }else{
                                            cell.lblOutTime.text = ""
                                            cell.lblOutTitle.isHidden = true
                                        }
                                    }else{
                                        
                                        cell.lblOutTime.text = ""
                                        
                                        cell.lblOutTitle.isHidden = true
                                    }
                                }
                            }else{
                                cell.lblOutTitle.isHidden = true
                                cell.lblOutTime.isHidden = true
                            }
                        }else{
                            cell.lblTitle.isHidden = true
                            cell.lblCheckinTime.isHidden = true
                            cell.lblINTitle.isHidden = true
                            cell.lblInTime.isHidden = true
                            cell.lblOutTitle.isHidden = true
                            cell.lblOutTime.isHidden = true
                        }
                        
                    }
                }
                return cell
                
            }else{
                return UITableViewCell()
            }
        }else{
            if  let cell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontal", for: indexPath) as? ThreeLblHorizontalCell{
                cell.lbl1.font = UIFont.systemFont(ofSize: 14)
                cell.lbl2.font = UIFont.systemFont(ofSize: 14)
                cell.lbl3.font = UIFont.systemFont(ofSize: 14)
                cell.lbl1.textAlignment = .left
                cell.lbl2.textAlignment = .left
                cell.lbl3.textAlignment = .left
                
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
                    
                    if  let product = objLead?.productList[indexPath.row - 1] as? ProductsList{
//                        print("product = \(product)")
                        let  strProductName = NSMutableAttributedString.init(string: "",attributes: [:])
                        
                        /*  if let productname = product.productName as? String{
                         if(productname.count > 0){
                         let productName = NSAttributedString.init(string:String.init(format:"\(productname) \n"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
                         strProductName.append(productName)
                         }else{
                         
                         if let subcatid = product.subCategoryID as? Int64 {
                         if(subcatid > 0){
                         let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                         if(prosubcat.count > 0){
                         strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(prosubcat) \n"), attributes: nil))
                         }
                         }
                         }else{
                         if let catid = product.categoryID as? Int64 {
                         let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                         if(procatname.count > 0){
                         strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(procatname) \n"), attributes: nil))
                         }
                         }
                         }
                         }
                         }else{
                         
                         if let catid = product.categoryID as? Int64 {
                         let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:product.categoryID))
                         if(procatname.count > 0){
                         strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(procatname) \n"), attributes: nil))
                         }
                         }
                         
                         }*/
                        let proname =  product.productName ?? ""
                        let subcatname = product.subCategoryName ?? ""
                        let catname = product.categoryName ?? ""
                        if(proname.count > 0){
                            
                            strProductName.append(NSAttributedString.init(string: String.init(format:"\(proname) \n"), attributes: nil))
                        }else if(subcatname.count > 0){
                            strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname) \n"), attributes: nil))
                        }else{
                            strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(catname) \n"), attributes: nil))
                        }
                        cell.lbl1.attributedText = strProductName
                        
                        
                        
                        //  cell.lbl1.text =  Product.getProductName(productID:  NSNumber.init(value:product.productID))
                        //cell.lbl1.text = Product.getProductName(productID: NSNumber.init(value:product.productID ?? 0))
                        cell.lbl2.text = String.init(format:"%d",product.quantity ?? "0")
                        
                        if  let price = product.budget{
                            cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", String(describing:price))
                        }else{
                            cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", "0")
                        }
                    }else{
                        print("not get product detail")
                    }
                    
                }
                return cell
            }else{
                return UITableViewCell()
            }
        }
    }
    /*if(checkin.visitManualCheckIn == 0 ){
     cell.lblINTitle.text = "In"
     if let checkintime = checkin.checkInTime{
     cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss"), format: "hh:mm a  EEE,dd MMM yy")
     }
     } else if let manualCheckInStatusID  =  checkin.manualCheckInStatusID as? Int16 {
     if (manualCheckInStatusID == 1 || manualCheckInStatusID == 2){
     cell.lblINTitle.text = "In"
     if let checkintime = checkin.checkInTime{
     cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss"), format: "hh:mm a  EEE,dd MMM yy")
     }
     
     }
     }
     if let checkouttime = checkin.checkOutTime as? String{
     
     if(checkin.visitManualCheckOut == 0){
     cell.lblOutTitle.text = "Out"
     if let checkouttime = checkin.checkOutTime{
     cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"), format: "hh:mm a  EEE,dd MMM yy")
     }
     }else if let manualCheckOutStatusID  =  checkin.manualCheckInStatusID as? Int16 {
     if(manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
     cell.lblOutTitle.text = "Out"
     if let checkouttime = checkin.checkOutTime{
     cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"), format: "hh:mm a  EEE,dd MMM yy")
     }
     }
     }
     }else{
     cell.lblOutTitle.isHidden = true
     cell.lblOutTime.isHidden = true
     }
     }else{
     cell.lblTitle.isHidden = true
     cell.lblCheckinTime.isHidden = true
     cell.lblINTitle.isHidden = true
     cell.lblInTime.isHidden = true
     cell.lblOutTitle.isHidden = true
     cell.lblOutTime.isHidden = true
     }
     }*/
}
extension  LeadSubDetail:PopUpDelegateNonMandatory{
    
    func completionSelectedExecutive(arr:[CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            self.arrOfSelectedExecutive = arr
            let selectedexecutive = arr.first
            
            if(assignedUserId == selectedexecutive?.entity_id) {
                Utils.toastmsg(message: String.init(format: "This is lead is already assigned to %@",selectedexecutive?.firstName ?? self.activeuser?.firstName ?? ""), view: self.view)
//                UIApplication.shared.keyWindow?.inputViewController?.view.makeToast(String.init(format: "This is lead is already assigned to %@",selectedexecutive?.firstName ?? self.activeuser?.firstName ?? ""))
            }else{
                assignedUserId = selectedexecutive?.entity_id
                arrOfAssignee.append(selectedexecutive?.entity_id ?? NSNumber.init(value: 0))
                self.updateAssignee() {
                    self.reassignVist()
                }
            }
            //        filterUser = selectedexecutive?.entity_id as! Int
            //        self.getPlannedVisit()
        }
    }
 
}
