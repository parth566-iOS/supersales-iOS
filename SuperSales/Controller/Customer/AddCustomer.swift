//
//  AddCustomer.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import LMGeocoder
import FastEasyMapping
import SDWebImage

@objc protocol AddCustomerDelegate {
    func saveCustomer(customerID:NSNumber,customerName:String,contactID:NSNumber)
   
    @objc optional func updateAddressType(address:AddressListModel,Record:Int)->()
    
}

class AddCustomer: BaseViewController, PopUpDelegateMandatory {
   
    
    
 // swiftlint:disable line_length
    var permenentAddressID = NSNumber.init(value:0)
    var companytypeID = NSNumber.init(value:0)
    var distributorId = NSNumber.init(value:0)
    var stockId = NSNumber.init(value:0)
  //  var originalAssignee = NSNumber.init(value:0)
    var saveCustDelegate:AddCustomerDelegate?
    var isEditCustomer:Bool!
    var isForAddAddress:Bool!
    var isFromColdCallVisit:Bool!
    var isFromContactList:Bool?
    static var isFromInfluencer:Int!
    var origiAssigneeFromCCVisit:NSNumber!
    var imgContact:UIImage = UIImage()
    var isVendor:Bool!
    var selectedVendor:Vendor!
    var selectedCustomer:CustomerDetails!
    var selectedCustomerForUnplan:TempCustomer!
    var selectedTerritory:[String:Any]! = [String:Any]()
    var customerSegmentIndex = NSNumber.init(value:0)
    var customerClassIndex = NSNumber.init(value:0)
    var isKeyCustomer:Bool!
    
    var popup:CustomerSelection? = nil
    var chooseCoTypeDropDown:DropDown! = DropDown()
    var chooseKYCTypeDropDown:DropDown! = DropDown()
    var chooseVatDropDown:DropDown! = DropDown()
    var datePicker : UIDatePicker!
    var aryContactType:[String]! = [String]()
    var arrOfSegment:[CustomerSegment]!
    public var arrOfterritory:[[String:Any]]!
    var taxType:String = "VAT"
    var isImageLogo:Bool! =  false
    var isVCard:Bool! = false
    var isCustomerImage1:Bool! = false
    var isCustomerImage2:Bool! = false
    var isCustomerImage3:Bool! = false
   
    var isCustomerKYCImage:Bool! = false
    var isCustomerKYCImage1:Bool! = false
    var isCustomerKYCImage2:Bool! = false
    var custImgLogo:UIImage = UIImage()
    var custVCard:UIImage = UIImage()
    var custExtraImg1:UIImage = UIImage()
    var custExtraImg2:UIImage = UIImage()
    var custExtraImg3:UIImage = UIImage()
   public static var custKYCImg:UIImage?
    public static  var custKYCImg2:UIImage?
    public static  var custKYCImg1:UIImage?
    var arrAddress:[AddressListModel] = [AddressListModel]()
    var arrAddress1:[AddressList] =  [AddressList]()
    var arrvatCode:[MetadataVATCodes] = [MetadataVATCodes]()
    var permenentAddress:AddressListModel!
    var permenentLocation:CLLocation!
    var arrOfExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfSelectedPrimaryAssignee:[CompanyUsers]! = [CompanyUsers]()
    var isForPrimaryAssignee:Bool!
    var primaryUserID:NSNumber = NSNumber.init(value:0)
    var townID:NSNumber = NSNumber.init(value:0)
    var arrOfAssignee:[NSNumber] = [NSNumber]()
    var custAddDic = [String:Any]()
    var strLat:CLLocationDegrees!
    var strLong:CLLocationDegrees!
//    var strLat:String!
//    var strLong:String!
    var arrOfDistributors = [CustomerDetails]()
    var arrOfStockist = [CustomerDetails]()
    var arrCustDetails = [[String:Any]]()
    
    var tempCustomer:TempCustomer?
    var firsttime =  false
    var vatCodeID:NSNumber! = NSNumber.init(value:0)
    var arrKYCType = [String]()
    var arrSelectedKYCType = [String]()
    var arrKYCDetails = [[String:Any]]()
    
    @IBOutlet weak var tblKYC: UITableView!
    
    @IBOutlet weak var vwKYC: UIView!
    
    @IBOutlet var vwCustomerSegment: UIView!
    @IBOutlet var vwCustomerCode: UIView!
    @IBOutlet weak var stkCustTown: UIStackView!
    
    @IBOutlet weak var vwFrequency: UIView!
    @IBOutlet weak var stkPrimaryAssignee: UIStackView!
    
    @IBOutlet weak var vwUpdateCutomerPotential: UIView!
   
    @IBOutlet weak var stkAssignee: UIStackView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tfCustName: UITextField!
    
    @IBOutlet weak var tfCustMobileNo: UITextField!
    
    @IBOutlet weak var tfLandLineNo: UITextField!
    
    @IBOutlet weak var tfBirthDate: UITextField!
    
    @IBOutlet weak var tfAnniversaryDate: UITextField!
    
    @IBOutlet weak var tfEmailId: UITextField!
    
    @IBOutlet weak var tfEmailOrderTo: UITextField!
    
    @IBOutlet weak var tfContactFirstName: UITextField!
    
    @IBOutlet weak var tfContactLastName: UITextField!
    
    @IBOutlet weak var tfContactMobile: UITextField!
    
    @IBOutlet weak var tfCustType: UITextField!
    
    @IBOutlet weak var tfSubCustType: UITextField!
    
    @IBOutlet weak var tvDesc: UITextView!
    
    @IBOutlet weak var GSTTitle: UILabel!
    
    @IBOutlet weak var tfGSTValue: UITextField!
    
    
    @IBOutlet var lblVatTitle: UILabel!
    @IBOutlet weak var customerCodeTitle: UILabel!
    
    
    @IBOutlet weak var tfCustomerCode: UITextField!
    
    @IBOutlet weak var stkExCustImg: UIStackView!
    
    @IBOutlet weak var custExImg1: UIImageView!
    
    @IBOutlet weak var custExImg2: UIImageView!
    
    @IBOutlet weak var custExImg3: UIImageView!
    
    @IBOutlet weak var btnVisitReminder: UIButton!
    
    @IBOutlet weak var stkVisitReminderTitle: UIStackView!
    
    @IBOutlet weak var lblVisitReminderTitle: UILabel!
    
    @IBOutlet weak var lblInDaysTitle: UILabel!
    
    @IBOutlet weak var tfVisitReminder: UITextField!
    
    @IBOutlet weak var tfCustomerClassfication: UITextField!
    
    @IBOutlet weak var tfCustomerSegment: UITextField!
    
    @IBOutlet weak var tfCustomerTerritory: UITextField!
    
    @IBOutlet weak var imgVCard: UIImageView!
    
    @IBOutlet weak var lblTaxAppliedTitle: UILabel!
    
    @IBOutlet weak var stkBtnTax: UIStackView!
    
    @IBOutlet weak var btnSGST: UIButton!
    
    @IBOutlet weak var btnIGST: UIButton!
    
    @IBOutlet weak var btnSelectAssign: UIButton!
    
    @IBOutlet weak var lblAssignToValue: UILabel!
    
    @IBOutlet weak var lblPrimaryAssignToValue: UILabel!
    
    @IBOutlet weak var tfAddressLine1: UITextField!
    
    @IBOutlet weak var tfAddressLine2: UITextField!
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var tfCity: UITextField!
    
    @IBOutlet weak var tfCountry: UITextField!
    
    @IBOutlet weak var tfPincode: UITextField!
    
    
    @IBOutlet weak var btnCustKeyCustomer: UIButton!
    
    @IBOutlet weak var stkKeyCustomer: UIView!
    
    @IBOutlet weak var vwVCard: UIView!
    
    //Contact detail
    
    @IBOutlet weak var lblContactFirstName: UILabel!
    
    @IBOutlet weak var lblContactLastName: UILabel!
    
    
    @IBOutlet weak var lblContactNumber: UILabel!
    
    
    @IBOutlet weak var btnMap: UIButton!
    
    @IBOutlet weak var tfTown: UITextField!
    
    @IBOutlet weak var stkAddress: UIStackView!
    @IBOutlet weak var vwAddNewAddress: UIView!
    
    @IBOutlet weak var tblTempAdd: UITableView!
    
    @IBOutlet weak var tblTempAddHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBOutlet var tfVatCode: UITextField!
    
    
    @IBOutlet weak var tfBeatPlan: UITextField!
    
    //MARK: View For visibilty as per web setting
    
    @IBOutlet weak var vwLandline: UIView!
    
    @IBOutlet weak var vwBirthday: UIView!
    
    
    @IBOutlet weak var vwAnnivaresary: UIView!
    
    @IBOutlet weak var vwEmailId: UIView!
    
    @IBOutlet weak var vwEmailOrderTo: UIView!
    
    @IBOutlet weak var vwContactFirstName: UIView!
    
    @IBOutlet weak var vwContactLastName: UIView!
    
    @IBOutlet weak var vwContactNo: UIView!
    
    @IBOutlet weak var vwCustomerType: UIView!
    
    @IBOutlet weak var vwDescription: UIView!
    
    
    @IBOutlet weak var vwTerritory: UIView!
    
    
    @IBOutlet weak var vwCustomerClass: UIView!
    
    @IBOutlet weak var vwBeatPlan: UIView!
    
    
    @IBOutlet weak var tblKYCHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwVat: UIView!
    
    
    var arrOfBeatPlan = [BeatPlan]()
    var arrOfSelectedBeatPlan = [BeatPlan]()
    var selectedBeatplanID = ""
    var arrOftownName = [String]()
    var arrOfSelectedTown = [String]()
    var arrTown = [[String:Any]]()
    var arrClass = [String]()
    //@IBOutlet weak var stkKeyCustomer: UIStackView!
    
    var noOfCustomer = 0
    var selectedRecord = 0
    var tblkycheightpro : CGFloat {
        tblKYC.layoutIfNeeded()
        return tblKYC.contentSize.height
    }
    
    let imagePicker = UIImagePickerController()
    // MARK: - Implementation
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        SVProgressHUD.show()
        self.setUI()
         
       
      
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        
        
       
        arrKYCType = [String]()
        if(self.activesetting.requireCustomerKYC == NSNumber.init(value: 1)){
            if(self.activesetting.requireCustomerPanKYC ==  NSNumber.init(value: 1)){
                arrKYCType.append("PAN Card")
            }
            
            //Aadhar Card
            if(self.activesetting.requireCustomerAadharKYC ==  NSNumber.init(value: 1)){
                arrKYCType.append("Aadhar Card")
            }
            if(self.activesetting.requireCustomerDrivingLicenceKYC ==  NSNumber.init(value: 1)){
                arrKYCType.append("Driving License")
            }
            if(self.activesetting.requireCustomerGstKYC ==  NSNumber.init(value: 1)){
                arrKYCType.append("GST Certificate")
            }
            // Shops Est License
             if(self.activesetting.requireCustomerShopEstKYC ==  NSNumber.init(value: 1)){
                 arrKYCType.append("Shops Est License")
             }
            
            if(self.activesetting.requireCustomerVoterKYC ==  NSNumber.init(value: 1)){
                arrKYCType.append("Voter Id")
            }
            //Driving License
           
            if(self.activesetting.requireCustomerOtherKYC ==  NSNumber.init(value: 1)){
                arrKYCType.append("Others")
            }
            arrKYCType.insert("Select KYC Type" , at: 0)
            vwKYC.isHidden = false
            //tblKYC.isHidden = false
            tblKYC.delegate = self
            tblKYC.dataSource = self
            tblKYC.reloadData()
            tblKYC.setCommonFeature()
            tblKYCHeight.constant =  tblkycheightpro
        }else{
            tblKYCHeight.constant = 0
            vwKYC.isHidden = true
           // tblKYC.isHidden = true
        }
        DispatchQueue.global(qos: .background).sync {
            if(BaseViewController.staticlowerUser?.count == 0){
                SVProgressHUD.show()
        self.fetchuser{
            (arrOfuser,error) in
            SVProgressHUD.dismiss()
            print("array of user  = \(arrOfuser)")
        }
            }
            
            if(self.activesetting.requiredBeatPlanDropDownInCustomer == NSNumber.init(value: 1)){
                        if(self.arrOfBeatPlan.count == 0){
                        self.loadBeatID(userId: self.activeuser?.userID ?? NSNumber.init(value: 0))
                        }else{
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
        }
        Location.sharedInsatnce.startLocationManager()
      

        if(BaseViewController.staticlowerUser.count == 0){
            arrOfAssignee = [NSNumber]()
            btnSelectAssign.isHidden = true
            var Name = ""
            if let fname = self.activeuser?.firstName{
                Name =  fname
            }
            if let lname = self.activeuser?.lastName{
                Name.append(" \(lname)")
            }
            arrOfAssignee.append(self.activeuser?.userID ?? NSNumber.init(value: 0))
            primaryUserID =  self.activeuser?.userID ?? NSNumber.init(value: 0)
            lblAssignToValue.text = String.init(format:"Assigned To:\(Name)")
            lblPrimaryAssignToValue.text = Name
        }else{
            btnSelectAssign.isHidden = false
        }
        if(isEditCustomer){
            btnSelectAssign.isHidden = true
        }
        if(self.activesetting.customerVisitReminder == NSNumber.init(value:1) && self.btnVisitReminder.isSelected == true){
            lblInDaysTitle.isHidden = false
            tfVisitReminder.isHidden = false
        }else{
            lblInDaysTitle.isHidden = true
            tfVisitReminder.isHidden = true
        }
//        if(self.activesetting.requiredBeatPlanDropDownInCustomer == NSNumber.init(value: 1)){
//            if(self.arrOfBeatPlan.count == 0){
//            self.loadBeatID(userId: self.activeuser?.userID ?? NSNumber.init(value: 0))
//            }else{
//                SVProgressHUD.dismiss()
//            }
//        }else{
//            SVProgressHUD.dismiss()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Location.sharedInsatnce.stopLocationManager()
        
    }
    //MARK: - Method
    
    func setUI(){
       
         imagePicker.delegate = self
        AddCustomer.custKYCImg = UIImage()
        AddCustomer.custKYCImg1 = UIImage()
        AddCustomer.custKYCImg2 = UIImage()
        arrClass = Utils().getCustomerClassification()
        tfTown.autocorrectionType = .no
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
      
        arrAddress =  [AddressListModel]()
        arrAddress1 =  [AddressList]()
        arrOfDistributors = CustomerDetails.getAllDistributors()
        arrOfStockist = CustomerDetails.getAllStockist()
        self.stkAddress.isHidden = false
        tfPincode.keyboardType  = .numberPad
        
        
        tfBeatPlan.text = "Select Beat Plan"
        arrOfterritory = [["territoryName":"Select Territory","territoryId":0,"territoryCode":""]]
            //["territoryName":"All"]
        for t in Territory.getAll(){
            arrOfterritory.append(t.toDictionary() as? [String:Any] ?? [String:Any]())
        }
       
    
        self.salesPlandelegateObject = self
        Location.sharedInsatnce.startLocationManager()
        Location.sharedInsatnce.locationUpdaterDelegate = self
        
       
        self.tfVatCode.delegate = self
        self.tfBeatPlan.delegate = self
        self.tfLandLineNo.delegate = self
        self.tfCustMobileNo.delegate = self
        self.tfContactMobile.delegate = self
        self.tfCustomerClassfication.delegate = self
        self.tfCustName.delegate = self
        self.tfCity.delegate = self
        self.tfState.delegate = self
        self.tfCountry.delegate = self
        self.tfBirthDate.delegate = self
        self.tfCustomerSegment.delegate = self
        self.tfCustType.delegate = self
        self.tfSubCustType.delegate = self
        self.tfVisitReminder.delegate = self
        self.tfCustomerTerritory.delegate = self
        self.tfAnniversaryDate.delegate = self
        self.tfTown.delegate = self
        
        
        self.tfBeatPlan.setCommonFeature()
        self.tfVatCode.setCommonFeature()
        self.tfLandLineNo.setCommonFeature()
        self.tfCustMobileNo.setCommonFeature()
        self.tfContactMobile.setCommonFeature()
        self.tfCustomerClassfication.setCommonFeature()
        self.tfCustName.setCommonFeature()
        self.tfCity.setCommonFeature()
        self.tfBirthDate.setCommonFeature()
        self.tfAnniversaryDate.setCommonFeature()
        self.tfEmailId.setCommonFeature()
        self.tfEmailOrderTo.setCommonFeature()
        self.tfContactFirstName.setCommonFeature()
        self.tfContactLastName.setCommonFeature()
        self.tfContactMobile.setCommonFeature()
        self.tfCustType.setCommonFeature()
        self.tfSubCustType.setCommonFeature()
        self.tfGSTValue.setCommonFeature()
        self.tfCustomerCode.setCommonFeature()
        self.tfCustomerSegment.setCommonFeature()
        self.tfAddressLine1.setCommonFeature()
        self.tfAddressLine2.setCommonFeature()
        self.tfState.setCommonFeature()
        self.tfCountry.setCommonFeature()
        
        
        //set border
       
        CustomeTextfield.setBottomBorder(tf: tfCustName)
        CustomeTextfield.setBottomBorder(tf: tfTown)
        CustomeTextfield.setBottomBorder(tf: tfCustMobileNo)
        CustomeTextfield.setBottomBorder(tf: tfLandLineNo)
        CustomeTextfield.setBottomBorder(tf: tfCustomerCode)
        CustomeTextfield.setBottomBorder(tf: tfAddressLine1)
        CustomeTextfield.setBottomBorder(tf: tfAddressLine2)
        CustomeTextfield.setBottomBorder(tf: tfContactMobile)
        CustomeTextfield.setBottomBorder(tf: tfBirthDate)
        CustomeTextfield.setBottomBorder(tf: tfAnniversaryDate)
        CustomeTextfield.setBottomBorder(tf: tfEmailId)
        CustomeTextfield.setBottomBorder(tf: tfEmailOrderTo)
        CustomeTextfield.setBottomBorder(tf: tfContactFirstName)
        CustomeTextfield.setBottomBorder(tf: tfContactLastName)
        CustomeTextfield.setBottomBorder(tf: tfGSTValue)
        CustomeTextfield.setBottomBorder(tf: tfVisitReminder)
      
        tfCustType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfSubCustType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfCustomerSegment.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfCustomerClassfication.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfCustomerTerritory.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfVatCode.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfBeatPlan.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfAddressLine1.setrightBtn(btn: btnMap)
        datePicker = UIDatePicker.init()
        datePicker.setCommonFeature()
        datePicker.maximumDate = Date()
        tfBirthDate.inputView =  datePicker
        tfAnniversaryDate.inputView =  datePicker

        arrOfSegment = CustomerSegment.getAll()
        self.initdropDown()
        self.isKeyCustomer = false
        self.tfVisitReminder.isHidden = true
        self.lblInDaysTitle.isHidden = true
        self.arrKYCDetails = [[String:Any]]()
        
        let kyc1Dic = ["KycType":"","KycNumber":"","KycUrl":""]
        let kyc2Dic = ["Kyc1Type":"","Kyc1Number":"","Kyc1Url":""]
        let kyc3Dic = ["Kyc2Type":"","Kyc2Number":"","Kyc2Url":""]
        self.arrKYCDetails.insert(kyc1Dic as [String : Any], at: 0)
        self.arrKYCDetails.insert(kyc2Dic as [String : Any], at: 1)
        self.arrKYCDetails.insert(kyc3Dic as [String : Any], at: 2)
        if(isEditCustomer){
          
            
            
            self.setrightbtn(btnType: BtnRight.edit, navigationItem: self.navigationItem)
            self.vwAddNewAddress.isHidden = false
            
            if(isVendor){
                self.title = "Edit Vendor"
            }else{
                self.title = "Edit Customer"
                if(!isFromColdCallVisit){
                self.townID =  NSNumber.init(value:selectedCustomer.townID)
                }
                self.arrKYCDetails = [[String:Any]]()
                let kyc1Dic = ["KycType":selectedCustomer.custKyc?.kyc1Type,"KycNumber":selectedCustomer.custKyc?.kyc1Number,"KycUrl":selectedCustomer.custKyc?.kyc1Url]
                let kyc2Dic = ["Kyc1Type":selectedCustomer.custKyc?.kyc2Type,"Kyc1Number":selectedCustomer.custKyc?.kyc2Number,"Kyc1Url":selectedCustomer.custKyc?.kyc2Url]
                let kyc3Dic = ["Kyc2Type":selectedCustomer.custKyc?.kyc3Type,"Kyc2Number":selectedCustomer.custKyc?.kyc3Number,"Kyc2Url":selectedCustomer.custKyc?.kyc3Url]
                self.arrKYCDetails.insert(kyc1Dic as [String : Any], at: 0)
                self.arrKYCDetails.insert(kyc2Dic as [String : Any], at: 1)
                self.arrKYCDetails.insert(kyc3Dic as [String : Any], at: 2)
                
                //self.arrKYCDetails =  [{"KycType":selectedCustomer.custKyc.kyc1type,""}]
            }
            self.tblKYC.reloadData()
            //hide contact detail
            vwContactNo.isHidden = true
            vwContactLastName.isHidden = true
            vwContactFirstName.isHidden = true
//            if let selectedbeatplan = arrOfSelectedBeatPlan.first{
//                var strbeatplan = ""
//                if let beatplanid = selectedbeatplan.BeatPlanID{
//                    strbeatplan.append(beatplanid)
//                }
//                if let beatplanname = selectedbeatplan.BeatPlanName{
//                    if(strbeatplan.count > 0){
//                        strbeatplan.append(" | \(beatplanname)")
//                    }else{
//                        strbeatplan.append(beatplanname)
//                    }
//                }
//                tfBeatPlan.text = strbeatplan
//                selectedBeatplanID = selectedbeatplan.BeatPlanID
//            }
//
            
    
            if(!isFromColdCallVisit){
                if(self.isVendor == false){
            if let custType = selectedCustomer.type as? String{
            
                vatCodeID = NSNumber.init(value:selectedCustomer.vATCode)
                if(vatCodeID.intValue > 0){
                    let selectedvatcode  = MetadataVATCodes.getVatPerFromID(ID: vatCodeID)
                    tfVatCode.text = selectedvatcode?.tAXName
                }else{
                    if(arrvatCode.count > 0){
                        let selectedvatcode  =  arrvatCode[0]
                        tfVatCode.text = selectedvatcode.tAXName
                        vatCodeID = NSNumber.init(value:selectedvatcode.iD)
                    }
                }
                if(selectedCustomer.townID > 0){
                    tfTown.text = selectedCustomer.townName
                }
                
                self.isVendor =  false
            
            }
                if(selectedCustomer.visitFrequency > 0){
                    self.btnVisitReminder.isSelected = true
                self.tfVisitReminder.text = String.init(format:"\(selectedCustomer.visitFrequency)")
                }
                self.tfCustName.text = selectedCustomer.name
                self.tfCustMobileNo.text = selectedCustomer.mobileNo
                self.tfLandLineNo.text = selectedCustomer.landlineNo
                self.tfBirthDate.text = selectedCustomer.birthDate
                self.tfAnniversaryDate.text = selectedCustomer.anniversaryDate
                self.tfEmailId.text = selectedCustomer.emailID
                self.tfEmailOrderTo.text = selectedCustomer.emailTo
                self.tfContactFirstName.text = selectedCustomer.contactName
                //self.tfContactLastName.text =  selectedCustomer.con
                self.tfContactMobile.text = selectedCustomer.contactNo
                self.tvDesc.text = selectedCustomer.desc
                //self.GSTTitle.text = selectedCustomer.customerGSTNo
                self.tfGSTValue.text = selectedCustomer.customerGSTNo
                self.tfCustomerCode.text = selectedCustomer.cCode
                if(selectedCustomer.keyCustomer == true){
                    btnCustKeyCustomer.isSelected = true
                }else{
                    btnCustKeyCustomer.isSelected = false
                }
                if(selectedCustomer.taxType == "CST"){
                    btnIGST.isSelected = true
                    btnSGST.isSelected = false
                }else{
                    btnSGST.isSelected = true
                    btnIGST.isSelected = false
                }
                if  let selectedClassTerritory = Territory.getTerritory(territotryID: NSNumber.init(value:Int(selectedCustomer.territoryID))){
                    selectedTerritory = selectedClassTerritory.toDictionary()
                    tfCustomerTerritory.text =  String.init(format: "%@ | %@", selectedClassTerritory.territoryName,selectedClassTerritory.territoryCode)
                }else{
                    selectedTerritory = arrOfterritory.first
                    tfCustomerTerritory.text =  selectedTerritory["territoryName"] as? String
                }
                if let selectedsegment = CustomerSegment.getSegmentById(segmentID: NSNumber.init(value:selectedCustomer.segmentID)){
                    self.customerSegmentIndex = NSNumber.init(value:selectedsegment.iD)
                    tfCustomerSegment.text = selectedsegment.customerSegmentValue
                }else{
                    tfCustomerSegment.text = "Select Customer Segment"
                    self.customerSegmentIndex =  NSNumber.init(value:0)
//                    self.customerSegmentIndex =   self.arrOfSegment.first?.iD as! NSNumber
//                    tfCustomerSegment.text = self.arrOfSegment.first?.customerSegmentValue
                }
                var taggeduser = ""
                    if(self.activesetting.customTagging == 3){
                        arrOfAssignee = [NSNumber]()
                        for user in selectedCustomer.taggedToIDList{
                            if  let taguser = user as? TaggedToIDList{
                                arrOfAssignee.append(NSNumber.init(value:taguser.taggedUserID))
                                if let taageduser  = CompanyUsers().getUser(userId: NSNumber.init(value:taguser.taggedUserID)){
                                    arrOfSelectedExecutive.append(taageduser)
                                }
                                taggeduser.append(String.init(format:"\(taguser.taggedUsersName)\n"))
                                if(selectedCustomer.taggedToIDList.count > 1){
                                    if(taguser.taggedUserID == selectedCustomer.taggedTo){
                                        primaryUserID = NSNumber.init(value:selectedCustomer.taggedTo)
                                        if let taageduser  = CompanyUsers().getUser(userId: NSNumber.init(value:taguser.taggedUserID)){
                                            arrOfSelectedPrimaryAssignee.append(taageduser)
                                        }
                                        lblPrimaryAssignToValue.text = String.init(format:"\(taguser.taggedUsersName)")
                                    }
                                }else{
                                    primaryUserID = NSNumber.init(value:selectedCustomer.taggedTo)
                                    if let taageduser  = CompanyUsers().getUser(userId: NSNumber.init(value:taguser.taggedUserID)){
                                        arrOfSelectedPrimaryAssignee.append(taageduser)
                                    }
                                    lblPrimaryAssignToValue.text = String.init(format:"\(taguser.taggedUsersName)")
                                }
                                
                            }
                        }
                        //   primaryUserID = NSNumber.init(value:selectedCustomer.taggedTo)
                        //                    if let taageduser  = CompanyUsers().getUser(userId: NSNumber.init(value:taguser.taggedUserID)){
                        //                    arrOfSelectedPrimaryAssignee.append(taageduser)
                        //                    }
                        //                lblPrimaryAssignToValue.text = String.init(format:"\(taguser.taggedUsersName)")
                        lblAssignToValue.text = String.init(format:"Assigned To:\(taggeduser)")
                        
                    }
               
           
                 
                        tfCustomerClassfication.text = arrClass[Int(selectedCustomer.customerClass) - 1]
                   
              
                imgLogo.sd_setImage(with: URL.init(string: selectedCustomer.logo), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    
                    if(err != nil){
                        self.imgLogo.image = UIImage.init(named: "icon_placeholder_user")
                       // Utils.toastmsg(message:"\(err?.localizedDescription) image Logo")
                    }else{
                        self.imgLogo.cornerRadius = Double(self.imgLogo.frame.width/2)
                    self.imgLogo.image = img
                        self.custImgLogo = img ?? UIImage()//custImgLogo
                    }
                print("image downloaded")
                }
                
                imgVCard.sd_setImage(with: URL.init(string: selectedCustomer.visitingCard), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                   
                    if(err != nil){
                        self.imgVCard.image = UIImage.init(named: "icon_placeholder")
                     //   Utils.toastmsg(message:"\(err?.localizedDescription) image visiting card")
                    }else{
                       // self.imgVCard.cornerRadius = Double(self.imgVCard.frame.width/2)
                        self.imgVCard.image = img
                        self.custVCard =  img ?? UIImage()
                    }
                print("image downloaded")
                }
                
                if let custimg1  = selectedCustomer.customerImage{
                custExImg1.sd_setImage(with: URL.init(string: custimg1), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    
                    if(err != nil){
                        self.custExImg1.image = UIImage.init(named: "icon_placeholder")
                      //  Utils.toastmsg(message:"\(err?.localizedDescription) image customer 1")
                        
                    }else{
                   // self.custExImg1.cornerRadius = Double(self.custExImg1.frame.width/2)
                        self.custExImg1.image = img
                        self.custExImg1.isUserInteractionEnabled = false
                        self.custExtraImg1 = img ?? UIImage()
                    }
                print("image downloaded")
                }
                }
                
                if let custimg2  = selectedCustomer.customerImage2{
                custExImg2.sd_setImage(with: URL.init(string: custimg2), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    
                    if(err != nil){
                        self.custExImg2.image = UIImage.init(named: "icon_placeholder")
                    //    Utils.toastmsg(message:"\(err?.localizedDescription) image customer 2")
                        
                    }else{
                   // self.custExImg1.cornerRadius = Double(self.custExImg1.frame.width/2)
                        self.custExImg2.image = img
                        self.custExImg2.isUserInteractionEnabled = false
                        self.custExtraImg2 = img ?? UIImage()
                    }
                print("image downloaded")
                }
                }
                
                if let custimg3  = selectedCustomer.customerImage3{
                custExImg3.sd_setImage(with: URL.init(string: custimg3), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    
                    if(err != nil){
                        self.custExImg3.image = UIImage.init(named: "icon_placeholder")
                    //    Utils.toastmsg(message:"\(err?.localizedDescription) image customer 3")
                    }else{
                   // self.custExImg1.cornerRadius = Double(self.custExImg1.frame.width/2)
                        self.custExImg3.image = img
                        self.custExImg3.isUserInteractionEnabled = false
                        self.custExtraImg3 = img ?? UIImage()
                    }
                print("image downloaded")
                }
                }
                
                if let  address = selectedCustomer.addressList.firstObject as? AddressList{
                   
                permenentAddress = AddressListModel().getaddressListModelWithDic(dict: address.toDictionary())
                        
                print("Model of address = \(address) , dic is  = \(address.toDictionary()) ,  lat = \(permenentAddress.lattitude) , longitude = \(permenentAddress.longitude)")
                        
                let doublelat = permenentAddress.lattitude.toDouble()
                let doublelng = permenentAddress.longitude.toDouble()
                        
                print(doublelat)
                        
                permenentLocation = CLLocation.init(latitude: CLLocationDegrees.init(doublelat), longitude: CLLocationDegrees.init(doublelng))
                self.tfAddressLine1.text = address.addressLine1
                self.tfAddressLine2.text = address.addressLine2
                self.tfCity.text = address.city
                self.tfState.text = address.state
                self.tfCountry.text = address.country
                        permenentAddressID =  NSNumber.init(value:address.addressID)
              //  self.tfPincode.text = String.init(format:"\(address.pincode)")
                
                        self.strLat = permenentLocation.coordinate.latitude as? CLLocationDegrees
                        self.strLong = permenentLocation.coordinate.longitude as? CLLocationDegrees
                      
                    }

                self.companytypeID = NSNumber.init(value:selectedCustomer.companyTypeID)
                print("customer type id =  \(selectedCustomer.companyTypeID)")
                if(selectedCustomer.companyTypeID == 1){
                    tfCustType.text = self.activesetting.displayCorporateInCustType
                    tfSubCustType.isHidden = true
                }else if(selectedCustomer.companyTypeID == 2){
                    tfCustType.text = self.activesetting.displayEndUserInCustType
                    tfSubCustType.isHidden = true
                }
                else if(selectedCustomer.companyTypeID == 3){
                    tfCustType.text = self.activesetting.displayInfluencerInCustType
                    tfSubCustType.isHidden = true
                }
                else if(selectedCustomer.companyTypeID == 4){
                    tfCustType.text = self.activesetting.displayRetailerInCustType
                    distributorId = NSNumber.init(value:selectedCustomer.distributorID)
                    if let distname = selectedCustomer.distributorName as? String{
                    if(distname.count > 0){
                    tfSubCustType.text = selectedCustomer.distributorName
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    tfSubCustType.isHidden = false

                   
                }else if(selectedCustomer.companyTypeID == 5){
                    tfCustType.text = self.activesetting.displayDistributorInCustType
                    stockId = NSNumber.init(value:selectedCustomer.distributorID)
                    tfSubCustType.isHidden = true
                    if let distname = selectedCustomer.distributorName as? String{
                    if(distname.count > 0){
                    tfSubCustType.text = selectedCustomer.distributorName
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    tfSubCustType.isHidden = false
                    if(isEditCustomer){
                        tfCustType.isUserInteractionEnabled = false
                        //tfCustType.setrightImage(img: UIImage.init(named: "")!)
                    }
                }else{
                    tfCustType.text = self.activesetting.displayStockistInCustType
                    tfSubCustType.isHidden = true
                }
                self.tfGSTValue.text = selectedCustomer.customerGSTNo
                self.tfCustomerCode.text = selectedCustomer.cCode
                self.tfContactFirstName.text = selectedCustomer.contactName
                self.tfContactLastName.text = selectedCustomer.contactLastName
                self.tfContactMobile.text = selectedCustomer.contactNo
                if(selectedCustomer.companyTypeID == 4){
                if let selectedDistributor =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: Int(selectedCustomer.distributorID))) {
                    self.tfSubCustType.text = selectedDistributor.name
                    self.distributorId = NSNumber.init(value: selectedCustomer.distributorID)
                }
                }
                if(selectedCustomer.companyTypeID == 5){
                if let selectedStock =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: Int(selectedCustomer.distributorID))) {
                    self.tfSubCustType.text = selectedStock.name
                    self.stockId = NSNumber.init(value: selectedCustomer.distributorID)
                }
                }
                }else{
//                    if let custType = selectedVendor.type as? String{
////                        if  let vatcode = selectedVendor.vATCode as? Int{
////                        vatCodeID = NSNumber.init(value:selectedVendor.vATCode)
////                        if(vatCodeID.intValue > 0){
////                            let selectedvatcode  = MetadataVATCodes.getVatPerFromID(ID: vatCodeID)
////                            tfVatCode.text = selectedvatcode?.tAXName
////                        }else{
////                            if(arrvatCode.count > 0){
////                                let selectedvatcode  =  arrvatCode[0]
////                                tfVatCode.text = selectedvatcode.tAXName
////                                vatCodeID = NSNumber.init(value:selectedvatcode.iD)
////                            }
////                        }
////                        }
////                        if(selectedVendor.townID > 0){
////                          //  tfTown.text = selectedVendor.townName
////                        }
//
//
//
//                    }
//                        if(selectedVendor.visitFrequency > 0){
//                            self.btnVisitReminder.isSelected = true
//                        self.tfVisitReminder.text = String.init(format:"\(selectedVendor.visitFrequency)")
//                        }
                        self.tfCustName.text = selectedVendor.name
                        self.tfCustMobileNo.text = selectedVendor.mobileNo
                        self.tfLandLineNo.text = selectedVendor.landlineNo
                        self.tfBirthDate.text =  ""//selectedVendor.birthDate
                        self.tfAnniversaryDate.text = "" //selectedVendor.anniversaryDate
                        self.tfEmailId.text = selectedVendor.emailID
                        self.tfEmailOrderTo.text = ""//selectedVendor.emailTo
                        self.tfContactFirstName.text = "" //selectedVendor.contactName
                        //self.tfContactLastName.text =  selectedCustomer.con
                        self.tfContactMobile.text = " " //selectedVendor.contactNo
                        self.tvDesc.text = " " //selectedVendor.desc
                        //self.GSTTitle.text = selectedCustomer.customerGSTNo
                        self.tfGSTValue.text = " " //selectedVendor.customerGSTNo
                        self.tfCustomerCode.text = " "//selectedVendor.cCode
                        if(selectedVendor.keyCustomer == true){
                            btnCustKeyCustomer.isSelected = true
                        }else{
                            btnCustKeyCustomer.isSelected = false
                        }
                        if(selectedVendor.taxType == "CST"){
                            btnIGST.isSelected = true
                            btnSGST.isSelected = false
                        }else{
                            btnSGST.isSelected = true
                            btnIGST.isSelected = false
                        }
//                        if  let selectedClassTerritory = Territory.getTerritory(territotryID: NSNumber.init(value:Int(selectedVendor.territoryID))){
//                            selectedTerritory = selectedClassTerritory.toDictionary()
//                            tfCustomerTerritory.text =  String.init(format: "%@ | %@", selectedClassTerritory.territoryName,selectedClassTerritory.territoryCode)
//                        }else{
//                            selectedTerritory = arrOfterritory.first
//                            tfCustomerTerritory.text =  selectedTerritory["territoryName"] as? String
//                        }
                        if let selectedsegment = CustomerSegment.getSegmentById(segmentID: NSNumber.init(value:selectedVendor.segmentID)){
                            self.customerSegmentIndex = NSNumber.init(value:selectedsegment.iD)
                            tfCustomerSegment.text = selectedsegment.customerSegmentValue
                        }else{
                            self.customerSegmentIndex =   self.arrOfSegment.first?.iD as! NSNumber
                            tfCustomerSegment.text = self.arrOfSegment.first?.customerSegmentValue
                        }
                        var taggeduser = ""
                        if(self.activesetting.customTagging == 3){
                            arrOfAssignee = [NSNumber]()
                           /* for user in selectedVendor.taggedToIDList{
                                if  let taguser = user as? TaggedToIDList{
                                    arrOfAssignee.append(NSNumber.init(value:taguser.taggedUserID))
                                    taggeduser.append(String.init(format:"\(taguser.taggedUsersName)\n"))
                                    if(taguser.taggedUserID == selectedVendor.taggedTo){
                                        primaryUserID = NSNumber.init(value:selectedCustomer.taggedTo)
                                    lblPrimaryAssignToValue.text = String.init(format:"\(taguser.taggedUsersName)")
                                }
                                }
                            }*/
                            lblAssignToValue.text = String.init(format:"Assigned To:\(taggeduser)")
                            
                        }
                      
                   
                    if(Int(selectedVendor.customerClass) > 0){
                       tfCustomerClassfication.text = arrClass[Int(selectedVendor.customerClass) - 1]
                    }
                       
                        imgLogo.sd_setImage(with: URL.init(string: selectedVendor.logo), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                            
                            if(err != nil){
                                self.imgLogo.image = UIImage.init(named: "icon_placeholder_user")
                               // Utils.toastmsg(message:"\(err?.localizedDescription) image Logo")
                            }else{
                                self.imgLogo.cornerRadius = Double(self.imgLogo.frame.width/2)
                            self.imgLogo.image = img
                                self.custImgLogo = img ?? UIImage()//custImgLogo
                            }
                        print("image downloaded")
                        }
                        
                        imgVCard.sd_setImage(with: URL.init(string: selectedVendor.visitingCard), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                           
                            if(err != nil){
                                self.imgVCard.image = UIImage.init(named: "icon_placeholder")
                             //   Utils.toastmsg(message:"\(err?.localizedDescription) image visiting card")
                            }else{
                               // self.imgVCard.cornerRadius = Double(self.imgVCard.frame.width/2)
                                self.imgVCard.image = img
                                self.custVCard =  img ?? UIImage()
                            }
                        print("image downloaded")
                        }
                        
                        if let custimg1  = selectedVendor.customerImage{
                        custExImg1.sd_setImage(with: URL.init(string: custimg1), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                            
                            if(err != nil){
                                self.custExImg1.image = UIImage.init(named: "icon_placeholder")
                              //  Utils.toastmsg(message:"\(err?.localizedDescription) image customer 1")
                                
                            }else{
                           // self.custExImg1.cornerRadius = Double(self.custExImg1.frame.width/2)
                                self.custExImg1.image = img
                                self.custExImg1.isUserInteractionEnabled = false
                                self.custExtraImg1 = img ?? UIImage()
                            }
                        print("image downloaded")
                        }
                        }
                        
                       /* if let custimg2  = selectedVendor.customerImage2{
                        custExImg2.sd_setImage(with: URL.init(string: custimg2), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                            
                            if(err != nil){
                                self.custExImg2.image = UIImage.init(named: "icon_placeholder")
                            //    Utils.toastmsg(message:"\(err?.localizedDescription) image customer 2")
                                
                            }else{
                           // self.custExImg1.cornerRadius = Double(self.custExImg1.frame.width/2)
                                self.custExImg2.image = img
                                self.custExImg2.isUserInteractionEnabled = false
                                self.custExtraImg2 = img ?? UIImage()
                            }
                        print("image downloaded")
                        }
                        }
                        
                        if let custimg3  = selectedVendor.customerImage3{
                        custExImg3.sd_setImage(with: URL.init(string: custimg3), placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                            
                            if(err != nil){
                                self.custExImg3.image = UIImage.init(named: "icon_placeholder")
                            //    Utils.toastmsg(message:"\(err?.localizedDescription) image customer 3")
                            }else{
                           // self.custExImg1.cornerRadius = Double(self.custExImg1.frame.width/2)
                                self.custExImg3.image = img
                                self.custExImg3.isUserInteractionEnabled = false
                                self.custExtraImg3 = img ?? UIImage()
                            }
                        print("image downloaded")
                        }
                        }*/
                        
                        let  address = selectedVendor.addressList.firstObject as! AddressList
                        permenentAddress = AddressListModel().getaddressListModelWithDic(dict: address.toDictionary())
                        let doublelat = permenentAddress.lattitude.toDouble()
                        let doublelng = permenentAddress.longitude.toDouble()
                        permenentLocation = CLLocation.init(latitude: CLLocationDegrees.init(doublelat), longitude: CLLocationDegrees.init(doublelng))
                        self.tfAddressLine1.text = address.addressLine1
                        self.tfAddressLine2.text = address.addressLine2
                        self.tfCity.text = address.city
                        self.tfState.text = address.state
                        self.tfCountry.text = address.country
                    if let strpincode = address.pincode as? String{
                        self.tfPincode.text = strpincode
                    }
                    self.strLat = permenentLocation.coordinate.latitude as? CLLocationDegrees
                        self.strLong = permenentLocation.coordinate.longitude as? CLLocationDegrees
//                        self.strLat = CLLocationDegrees(NSNumber.init(value: Int(address.lattitude ?? "0") ?? 0))
//                        self.strLong = CLLocationDegrees(NSNumber.init(value: Int(address.longitude ?? "0") ?? 0))
                       // self.lblPrimaryAssignToValue.text = selectedCustomer.
                        
                      //  self.tfCity.text = selectedCustomer.addressList
                        self.companytypeID = NSNumber.init(value:selectedVendor.companyTypeID)
                    print("customer type id =  \(self.companytypeID)")
                    if(self.companytypeID == 1){
                    tfCustType.text = self.activesetting.displayCorporateInCustType
                    tfSubCustType.isHidden = true
                }else if(self.companytypeID == 2){
                    tfCustType.text = self.activesetting.displayEndUserInCustType
                    tfSubCustType.isHidden = true
                }
                else if(self.companytypeID == 3){
                    tfCustType.text = self.activesetting.displayInfluencerInCustType
                    tfSubCustType.isHidden = true
                }
                else if(self.companytypeID == 4){
                    tfCustType.text = self.activesetting.displayRetailerInCustType
                    distributorId = NSNumber.init(value:selectedCustomer.distributorID)
                    if let distname = selectedCustomer.distributorName as? String{
                    if(distname.count > 0){
                    tfSubCustType.text = selectedCustomer.distributorName
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    tfSubCustType.isHidden = false

                   
                }else if(self.companytypeID == 5){
                    tfCustType.text = self.activesetting.displayDistributorInCustType
                    stockId = NSNumber.init(value:selectedCustomer.distributorID)
               
                    if let distname = selectedCustomer.distributorName as? String{
                    if(distname.count > 0){
                    tfSubCustType.text = selectedCustomer.distributorName
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    tfSubCustType.isHidden = false
                    if(isEditCustomer){
                        tfCustType.isUserInteractionEnabled = false
                        //tfCustType.setrightImage(img: UIImage.init(named: "")!)
                    }
                }else{
                    tfCustType.text = self.activesetting.displayStockistInCustType
                    tfSubCustType.isHidden = true
                }
//                        self.tfGSTValue.text = selectedVendor.customerGSTNo
//                        self.tfCustomerCode.text = selectedVendor.cCode
//                        self.tfContactFirstName.text = selectedVendor.contactName
//                        self.tfContactLastName.text = selectedVendor.contactLastName
//                        self.tfContactMobile.text = selectedVendor.contactNo
                        if(selectedVendor.companyTypeID == 4){
                        if let selectedDistributor =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: Int(selectedVendor.distributorID))) {
                            self.tfSubCustType.text = selectedDistributor.name
                            self.distributorId = NSNumber.init(value: selectedVendor.distributorID)
                        }
                        }
                        if(selectedVendor.companyTypeID == 5){
                        if let selectedStock =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: Int(selectedVendor.distributorID))) {
                            self.tfSubCustType.text = selectedStock.name
                            self.stockId = NSNumber.init(value: selectedVendor.distributorID)
                        }
                        }
                }
            }else{
                
                if let   primaryUserID1 = origiAssigneeFromCCVisit as? NSNumber{
                    primaryUserID = primaryUserID1
               // primaryUserID = NSNumber.init(value:selectedCustomer.taggedTo)
                if let taageduser  = CompanyUsers().getUser(userId: primaryUserID){
                    lblPrimaryAssignToValue.text = String.init(format:"\(taageduser.firstName) \(taageduser.lastName)")
                        lblAssignToValue.text = String.init(format:"Assigned To:\(taageduser.firstName) \(taageduser.lastName)")
                //arrOfSelectedPrimaryAssignee.append(taageduser)
                }
                }else{
                    primaryUserID = self.activeuser?.userID ?? NSNumber.init(value: 0)
                    lblPrimaryAssignToValue.text = String.init(format:"\(self.activeuser?.firstName) \(self.activeuser?.lastName)")
                    lblAssignToValue.text = String.init(format:"Assigned To:\(self.activeuser?.firstName) \(self.activeuser?.lastName)")
                }
           
                self.tfCustName.text = selectedCustomerForUnplan.CustomerName
                self.tfCustMobileNo.text = selectedCustomerForUnplan.MobileNo
              

                self.tfContactFirstName.text = selectedCustomerForUnplan.ContactFirstName
              
                self.tfContactMobile.text = selectedCustomerForUnplan.ContactNo
           
                self.tfAddressLine1.text = selectedCustomerForUnplan.AddressLine1
                self.tfAddressLine2.text = selectedCustomerForUnplan.AddressLine2
                self.tfCity.text = selectedCustomerForUnplan.City
                self.tfState.text = selectedCustomerForUnplan.State
                self.tfCountry.text = selectedCustomerForUnplan.Country
                if let postalcode = selectedCustomerForUnplan.Pincode as? String{
                self.tfPincode.text = postalcode
                }
                if(selectedCustomerForUnplan.CompanyTypeID == 1){
                    tfCustType.text = self.activesetting.displayCorporateInCustType
                    tfSubCustType.isHidden = true
                }else if(selectedCustomerForUnplan.CompanyTypeID == 2){
                    tfCustType.text = self.activesetting.displayEndUserInCustType
                    tfSubCustType.isHidden = true
                }
                else if(selectedCustomerForUnplan.CompanyTypeID == 3){
                    tfCustType.text = self.activesetting.displayInfluencerInCustType
                    tfSubCustType.isHidden = true
                }
                else if(selectedCustomerForUnplan.CompanyTypeID == 4){
                    tfCustType.text = self.activesetting.displayRetailerInCustType
                    distributorId = NSNumber.init(value:self.tempCustomer?.distributorID ?? 0)
                    if let distname = selectedCustomerForUnplan.distributorName as? String{
                    if(distname.count > 0){
                    tfSubCustType.text = self.tempCustomer?.distributorName
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    tfSubCustType.isHidden = false
  
                }else if(selectedCustomerForUnplan.CompanyTypeID == 5){
                    tfCustType.text = self.activesetting.displayDistributorInCustType
                    stockId = NSNumber.init(value:self.tempCustomer?.distributorID ?? 0)
                    if let distname = self.tempCustomer?.distributorName as? String{
                    if(distname.count > 0){
                        tfSubCustType.text = distname
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    tfSubCustType.isHidden = false

                }else{
                    tfCustType.text = self.activesetting.displayStockistInCustType
                    tfSubCustType.isHidden = true
                }
               
                tblTempAdd.reloadData()
                tblTempAddHeight.constant = tblTempAdd.contentSize.height
                if(isForAddAddress){
                    btnSubmit.isHidden = true
                }else{
                    btnSubmit.isHidden = false
                }
            }
           
            if(isEditCustomer == true && isVendor == false && !(aryContactType.contains(self.tfCustType.text ?? ""))) {
                tfCustType.isUserInteractionEnabled = false
                btnSubmit.isHidden = true
                tfCustType.setImageRight(image: UIImage.init(named: "") ?? UIImage())
            }
        
        }else{
            self.btnVisitReminder.isSelected  = true
            self.btnVisitReminderClicked(self.btnVisitReminder)
            permenentLocation = Location.sharedInsatnce.currentLocation
            self.vwAddNewAddress.isHidden = true
        
            self.tfSubCustType.isHidden = true
            self.title = "Add Customer"
            
           
            if(isFromColdCallVisit){
                //self.tempCustomer =  self.selectedCustomerForUnplan
               // self.selectedCustomerForUnplan
                
                btnSGST.isSelected = true
                btnIGST.isSelected = false
           
                tfCustName.text = selectedCustomerForUnplan.CustomerName
                tfCustMobileNo.text =  selectedCustomerForUnplan.MobileNo
               // let contactname = String.init(format: "%@ %@", self.tempCustomer?.ContactFirstName as! CVarArg ,self.tempCustomer?.ContactLastName as! CVarArg)
                tfContactFirstName.text = selectedCustomerForUnplan.ContactFirstName
                tfContactLastName.text = selectedCustomerForUnplan.ContactLastName
                tfContactMobile.text = selectedCustomerForUnplan.ContactNo
                tfEmailId.text = selectedCustomerForUnplan.EmailID
                if(selectedCustomerForUnplan.CompanyTypeID == 1){
                    tfCustType.text = self.activesetting.displayCorporateInCustType
                    tfSubCustType.isHidden = true
                }else if(selectedCustomerForUnplan.CompanyTypeID == 2){
                    tfCustType.text = self.activesetting.displayEndUserInCustType
                    tfSubCustType.isHidden = true
                }
                else if(selectedCustomerForUnplan.CompanyTypeID == 3){
                    tfCustType.text = self.activesetting.displayInfluencerInCustType
                    tfSubCustType.isHidden = true
                }
                else if(selectedCustomerForUnplan.CompanyTypeID == 4){
                    tfCustType.text = self.activesetting.displayRetailerInCustType
                    distributorId = NSNumber.init(value:self.tempCustomer?.distributorID ?? 0)
                    if let distname = selectedCustomerForUnplan.distributorName as? String{
                    if(distname.count > 0){
                    tfSubCustType.text = selectedCustomerForUnplan.distributorName
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    }else{
                        tfSubCustType.text = "Select Distributor"
                    }
                    tfSubCustType.isHidden = false

                }else if(selectedCustomerForUnplan.CompanyTypeID == 5){
                    tfCustType.text = self.activesetting.displayDistributorInCustType
                    stockId = NSNumber.init(value:selectedCustomerForUnplan.distributorID ?? 0)
                    if let distname = selectedCustomerForUnplan.distributorName as? String{
                    if(distname.count > 0){
                        tfSubCustType.text = distname
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    }else{
                        tfSubCustType.text = "Select Stockist"
                    }
                    tfSubCustType.isHidden = false

                }else{
                    tfCustType.text = self.activesetting.displayStockistInCustType
                    tfSubCustType.isHidden = true
                }
            }
            
            if(AddCustomer.isFromInfluencer > 0){
                tfCustType.text = "Influencer"
                companytypeID = NSNumber.init(value:3)
                tfCustType.isUserInteractionEnabled = false
            }
            if(isEditCustomer ==  false){
            if(self.activesetting.isCustomerClassEditable == NSNumber.init(value: 1)){
                self.tfCustomerClassfication.text = arrClass.last
                self.tfCustomerClassfication.isUserInteractionEnabled =  false
            }else{
                self.tfCustomerClassfication.text = arrClass.first
                self.tfCustomerClassfication.isUserInteractionEnabled =  true
            }
            }
            //self.tfCustomerSegment.text = self.arrOfSegment.first?.customerSegmentValue
        }
        
        
        
        
        
        
        
        
        
       //MARK: Visibility as per setting
        if(self.activesetting.requireTaxInCustomer == NSNumber.init(value: 1)){
            GSTTitle.isHidden = false
            tfGSTValue.isHidden = false
            if(self.activesetting.vatGst?.intValue == 2){

                vwVat.isHidden = false
                lblTaxAppliedTitle.isHidden = true
                stkBtnTax.isHidden = true
            }else{

                vwVat.isHidden = true
                lblTaxAppliedTitle.isHidden = false
                stkBtnTax.isHidden = false
            }
        }else{
            GSTTitle.isHidden = true
            tfGSTValue.isHidden = true
            vwVat.isHidden = true
            lblTaxAppliedTitle.isHidden = true
            stkBtnTax.isHidden = true
        }
        
        if(self.activesetting.customerVisitReminder == NSNumber.init(value: 1) ){
            self.stkVisitReminderTitle.isHidden = false
        }else{
            self.stkVisitReminderTitle.isHidden = true
        }
        
        if(self.activesetting.customerPotential == NSNumber.init(value: 1) && self.isEditCustomer){
            vwUpdateCutomerPotential.isHidden = false
        }else{
            vwUpdateCutomerPotential.isHidden = true
        }
        
        if(self.activesetting.requiredBeatPlanDropDownInCustomer == NSNumber.init(value: 1)){
           
            vwBeatPlan.isHidden = false
            
        }else{
            vwBeatPlan.isHidden = true
        }
        
        if(self.activesetting.requiVCardInCustomer == NSNumber.init(value: 1)){
            self.vwVCard.isHidden = false
        }else{
            self.vwVCard.isHidden = true
        }
        
        if(self.activesetting.requiLandLineNumInCustomer == NSNumber.init(value: 1)){
            self.vwLandline.isHidden = false
        }else{
            self.vwLandline.isHidden = true
        }
        
        if(self.activesetting.requiImagesInCustomer == NSNumber.init(value:1)){
            self.stkExCustImg.isHidden = false
        }else{
            self.stkExCustImg.isHidden = true
        }
        
        if(self.activesetting.requiBirthDateInCustomer == NSNumber.init(value: 1)){
            self.vwBirthday.isHidden = false
        }else{
            self.vwBirthday.isHidden = true
        }
        
        if(self.activesetting.requiAnniversaryDateInCustomer == NSNumber.init(value: 1)){
            self.vwAnnivaresary.isHidden = false
        }else{
            self.vwAnnivaresary.isHidden = true
        }
        
        if(self.activesetting.requiEmailIDInCustomer == NSNumber.init(value: 1)){
            self.vwEmailId.isHidden = false
        }else{
            self.vwEmailId.isHidden = true
        }
        
        if(self.activesetting.requiEmailOrderToInCustomer == NSNumber.init(value: 1)){
            self.vwEmailOrderTo.isHidden = false
        }else{
            self.vwEmailOrderTo.isHidden = true
        }
        
        if(self.activesetting.requiContactInCustomer == NSNumber.init(value: 1) && isEditCustomer == false){
            self.vwContactLastName.isHidden = false
            self.vwContactFirstName.isHidden = false
            self.vwContactNo.isHidden = false
        }else{
            self.vwContactLastName.isHidden = true
            self.vwContactFirstName.isHidden = true
            self.vwContactNo.isHidden = true
        }
        
        
        if(self.activesetting.requiDescriInCustomer == NSNumber.init(value: 1)){
            vwDescription.isHidden =  false
        }else{
            vwDescription.isHidden = true
        }
        
        
        
        
        if(self.activesetting.requireKeyCustInCustomer == NSNumber.init(value: 1)){
            stkKeyCustomer.isHidden =  false
        }else{
            stkKeyCustomer.isHidden = true
        }
        if(self.activesetting.requireCustCodeInCustomer == NSNumber.init(value:1)){
            vwCustomerCode.isHidden = false
        }else{
            vwCustomerCode.isHidden = true
        }
        
        if(self.activesetting.requiredSegmentInCustomer == NSNumber.init(value:1)){
            vwCustomerSegment.isHidden = false
        }else{
            vwCustomerSegment.isHidden = true
        }
        
        if(self.activesetting.territoryInCustomer == NSNumber.init(value:1)){
            self.vwTerritory.isHidden = false
        }else{
            self.vwTerritory.isHidden = true
        }
        if(self.activesetting.requireTaxInCustomer == NSNumber.init(value:1))
        {
            lblTaxAppliedTitle.isHidden = false
            stkBtnTax.isHidden = false
            
        }else{
            lblTaxAppliedTitle.isHidden = true
            stkBtnTax.isHidden = true
        }
       
        if(self.activesetting.visitReminder == NSNumber.init(value: 1)){
            stkVisitReminderTitle.isHidden = false
        }else{
            stkVisitReminderTitle.isHidden = true
        }
        
        if(self.activesetting.requiredClassInCustomer == NSNumber.init(value:1)){
            self.vwCustomerClass.isHidden = false
        }else{
            self.vwCustomerClass.isHidden = true
        }
        
        
        
        
        
        selectedTerritory = arrOfterritory.first
        tfCustomerTerritory.text = selectedTerritory["territoryName"] as? String
        
        // set action for extra image capture
        custExImg1.isUserInteractionEnabled = true
        custExImg2.isUserInteractionEnabled = true
        custExImg3.isUserInteractionEnabled =  true
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.extracustImage1Clicked(_:)))
        gesture1.numberOfTapsRequired = 1
        custExImg1.addGestureRecognizer(gesture1)
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.extracustImage2Clicked(_:)))
        gesture2.numberOfTapsRequired = 1
        custExImg2.addGestureRecognizer(gesture2)
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.extracustImage3Clicked(_:)))
        gesture3.numberOfTapsRequired = 1
        custExImg3.addGestureRecognizer(gesture3)
        btnSGST.isSelected = true
        lblAssignToValue.setMultilineLabel(lbl: lblAssignToValue)
        if(isVendor){
            stkCustTown.isHidden = true
            if(isEditCustomer){
                self.title = "Edit Vendor"
                if(self.activesetting.isCustomerClassEditable == NSNumber.init(value: 1)){
                    self.tfCustomerClassfication.isUserInteractionEnabled = true
                }else{
                    self.tfCustomerClassfication.isUserInteractionEnabled = false
                }
                for add in selectedVendor.addressList{
                   
                    if  let address =  add as? AddressList{
                    print("address type = \(address.type)")
                    if(address.type == "1"){
                        arrAddress1.append(address)
                        permenentAddress = AddressListModel().getaddressListModelWithDic(dict: address.toDictionary())
                        let doublelat = permenentAddress.lattitude.toDouble()
                        let doublelng = permenentAddress.longitude.toDouble()
                        permenentLocation = CLLocation.init(latitude: CLLocationDegrees.init(doublelat), longitude: CLLocationDegrees.init(doublelng))
                     //   self.tfAddressLine1.text =
                       // let  address = selectedCustomer.addressList.firstObject as! AddressList
                        self.tfAddressLine1.text = address.addressLine1
                        self.tfAddressLine2.text = address.addressLine2
                        self.tfCity.text = address.city
                        self.tfState.text = address.state
                        self.tfCountry.text = address.country
                      //  self.tfPincode.text = String.init(format:"\(address.pincode)")
                        if let strpincode = address.pincode as? String{
                            self.tfPincode.text = strpincode
                        }
                        
                    }else{
                        let addmodel = AddressListModel().getaddressListModelWithDic(dict: address.toDictionary())
                        print("address type = \(address.type)")
                        arrAddress.append(addmodel)
                        print("address type = \(address.type) , count  = \(arrAddress.count)")
                        
                    }
                    }
                }
            }else{
                self.title = "Add Vendor" 
            }
            customerCodeTitle.text  = "Vendor Code"
            stkAssignee.isHidden = true
            stkPrimaryAssignee.isHidden = true
            vwVat.isHidden = true
            lblTaxAppliedTitle.isHidden = false
            stkBtnTax.isHidden = false
            
        }else{
            customerCodeTitle.text  = "Customer Code"
            stkAssignee.isHidden = false
            stkPrimaryAssignee.isHidden = false
            if(self.activesetting.requireTownInCustomer == 1){
                stkCustTown.isHidden = false
            }else{
                stkCustTown.isHidden = true
            }
            if(isFromColdCallVisit && self.isEditCustomer == false){
                primaryUserID = origiAssigneeFromCCVisit
            }else{
                if(isEditCustomer){
                    if(self.activesetting.isCustomerClassEditable?.intValue == 1){
                        self.tfCustomerClassfication.isUserInteractionEnabled = true
                    }else{
                        self.tfCustomerClassfication.isUserInteractionEnabled = false
                    }
            if (!isFromColdCallVisit){
            for add in selectedCustomer.addressList{
                if  let address =  add as? AddressList{
                    print("type of address = \(address.type)")
                if(address.type == "1"){
                    arrAddress1.append(address)
                    permenentAddress = AddressListModel().getaddressListModelWithDic(dict: address.toDictionary())
                    let doublelat = permenentAddress.lattitude.toDouble()
                    let doublelng = permenentAddress.longitude.toDouble()
                    permenentLocation = CLLocation.init(latitude: CLLocationDegrees.init(doublelat), longitude: CLLocationDegrees.init(doublelng))
                    
               
                    self.tfAddressLine1.text = address.addressLine1
                    self.tfAddressLine2.text = address.addressLine2
                    self.tfCity.text = address.city
                    self.tfState.text = address.state
                    self.tfCountry.text = address.country
                    //self.tfPincode.text = String.init(format:"\(address.pincode)")
                    if let strpincode = address.pincode as? String{
                        self.tfPincode.text = strpincode
                    }
                }else{
                    let addmodel = AddressListModel().getaddressListModelWithDic(dict: address.toDictionary())
                //    print(addmodel.lattitude)
                    arrAddress.append(addmodel)
                   
                    
                }
                    print("address type = \(address.type) , count  = \(arrAddress.count)")
                }
            }
                    }
                }
            }
        }
       
        self.tblTempAddHeight.constant = self.tblTempAdd.contentSize.height
        self.tblTempAdd.isScrollEnabled = false
        self.tblTempAdd.delegate = self
        
        self.tblTempAdd.dataSource = self
        self.tblTempAdd.rowHeight = UITableView.automaticDimension
        self.tblTempAdd.estimatedRowHeight = 300
        self.tblTempAdd.separatorColor = .clear
       
        self.tblKYC.isScrollEnabled = false
        self.filterSegmentAccordingtoCustType()
    }
    
    @objc func extracustImage1Clicked(_ sender: UITapGestureRecognizer? = nil){
        isCustomerImage1 =  true
        self.cameraTapped()
    }
    @objc func extracustImage2Clicked(_ sender: UITapGestureRecognizer? = nil){
        isCustomerImage2 =  true
        self.cameraTapped()
    }
    @objc func extracustImage3Clicked(_ sender: UITapGestureRecognizer? = nil){
        isCustomerImage3 =  true
        self.cameraTapped()
    }
    
    
    func filterSegmentAccordingtoCustType(){
        arrOfSegment =  CustomerSegment.getAll()
      arrOfSegment =  arrOfSegment.filter({ (segment) -> Bool in
            let arrOfCustType = segment.customerType.components(separatedBy: ",")
        print(" \(arrOfCustType) value = \(segment.customerSegmentValue) and selected is = \(companytypeID)")
            if(arrOfCustType.contains(companytypeID.stringValue) || arrOfCustType.contains("0")){
                return true
            }else{
                return false
            }
        })
       
        print("arr of segment = \(arrOfSegment) and count = \(arrOfSegment.count)")
        self.chooseCoTypeDropDown.reloadAllComponents()
        if(isEditCustomer ==  false){
        self.tfCustomerSegment.text =  self.arrOfSegment.first?.customerSegmentValue
            
        customerSegmentIndex = NSNumber.init(value:self.arrOfSegment.first?.customerSegmentIndexID ?? 0)
        }
    }
    
    func initdropDown(){
       
    
        self.chooseCoTypeDropDown.anchorView = tfCustType
        self.chooseCoTypeDropDown.bottomOffset = CGPoint.init(x:0.0, y:self.tfCustType.bounds.size.height)
        
        
        self.chooseVatDropDown.anchorView = tfVatCode
        self.chooseVatDropDown.bottomOffset = CGPoint.init(x:0.0, y:self.tfVatCode.bounds.size.height)
        arrvatCode =  MetadataVATCodes.getAll()
        
      
            if(activesetting.allowCorporateInCustType == NSNumber.init(value: 1)){
              //  if(self.activesetting.updatedByCorporateInCustType )
                switch activesetting.updatedByCorporateInCustType {
                case 1:
                    //All
                    aryContactType.append(activesetting.displayCorporateInCustType?.count ?? 0  > 0 ? (activesetting.displayCorporateInCustType as! String):NSLocalizedString("corporate", comment:""))
                break
                case 2:
                    //Only admin & manager
                    if(self.activeuser?.role?.id == NSNumber.init(value: 7) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayCorporateInCustType?.count ?? 0  > 0 ? (activesetting.displayCorporateInCustType as! String):NSLocalizedString("corporate", comment:""))
                    }else if(isEditCustomer == true && isVendor == false)
                    {
                        if(selectedCustomer.companyTypeID == 1){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    }
                break
                case 3:
                    //Only admin
                    if(self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayCorporateInCustType?.count ?? 0  > 0 ? (activesetting.displayCorporateInCustType as! String):NSLocalizedString("corporate", comment:""))
                    }else if(isEditCustomer == true && isVendor == false){
                        if(selectedCustomer.companyTypeID == 1){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }}
                break
                default:
                    aryContactType.append(activesetting.displayCorporateInCustType?.count ?? 0  > 0 ? (activesetting.displayCorporateInCustType as! String):NSLocalizedString("corporate", comment:""))
                    print("nothing")
                }
           
            }
        
            if(activesetting.allowEndUserInCustType == NSNumber.init(value: 1)){
                switch activesetting.updatedByEndUserInCustType {
                case 1:
                    //All
                    aryContactType.append(activesetting.displayEndUserInCustType?.count ?? 0  > 0 ?(activesetting.displayEndUserInCustType as! String):NSLocalizedString("end_user", comment:""))

                break
                case 2:
                    //Only admin & manager
                    if(self.activeuser?.role?.id == NSNumber.init(value: 7) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayEndUserInCustType?.count ?? 0  > 0 ?(activesetting.displayEndUserInCustType as! String):NSLocalizedString("end_user", comment:""))

                    }else if(isEditCustomer == true && isVendor == false){
                        if(selectedCustomer.companyTypeID == 2){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }}
                break
                case 3:
                    //Only admin
                    if(self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayEndUserInCustType?.count ?? 0  > 0 ?(activesetting.displayEndUserInCustType as! String):NSLocalizedString("end_user", comment:""))

                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 2){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }}
                break
                default:
                    aryContactType.append(activesetting.displayEndUserInCustType?.count ?? 0  > 0 ?(activesetting.displayEndUserInCustType as! String):NSLocalizedString("end_user", comment:""))

                    print("nothing")
                }
                            }
            
            if(activesetting.allowInfluencerInCustType == NSNumber.init(value: 1)){
                switch activesetting.updatedByInfluencerInCustType {
                case 1:
                    //All
                    aryContactType.append(activesetting.displayInfluencerInCustType?.count ?? 0  > 0 ?(activesetting.displayInfluencerInCustType as! String):NSLocalizedString("influencer", comment:""))

                break
                case 2:
                    //Only admin & manager
                    if(self.activeuser?.role?.id == NSNumber.init(value: 7) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayInfluencerInCustType?.count ?? 0  > 0 ?(activesetting.displayInfluencerInCustType as! String):NSLocalizedString("influencer", comment:""))

                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 3){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }}
                break
                case 3:
                    //Only admin
                    if(self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayInfluencerInCustType?.count ?? 0  > 0 ?(activesetting.displayInfluencerInCustType as! String):NSLocalizedString("influencer", comment:""))

                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 3){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }}
                break
                default:
                    aryContactType.append(activesetting.displayInfluencerInCustType?.count ?? 0  > 0 ?(activesetting.displayInfluencerInCustType as! String):NSLocalizedString("influencer", comment:""))

                    print("nothing")
                }
                
            }
            
            if(activesetting.allowRetailerInCustType == NSNumber.init(value: 1)){
              
                switch activesetting.updatedByRetailerInCustType {
                case 1:
                    //All
                    aryContactType.append(activesetting.displayRetailerInCustType?.count ?? 0  > 0 ?(activesetting.displayRetailerInCustType as! String): NSLocalizedString("retailer", comment:""))

                break
                case 2:
                    //Only admin & manager
                    if(self.activeuser?.role?.id == NSNumber.init(value: 7) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayRetailerInCustType?.count ?? 0  > 0 ?(activesetting.displayRetailerInCustType as! String): NSLocalizedString("retailer", comment:""))

                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 4){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    }
                break
                case 3:
                    //Only admin
                    if(self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayRetailerInCustType?.count ?? 0  > 0 ?(activesetting.displayRetailerInCustType as! String): NSLocalizedString("retailer", comment:""))
                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 4){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    
                    }
                break
                default:
                    aryContactType.append(activesetting.displayRetailerInCustType?.count ?? 0  > 0 ?(activesetting.displayRetailerInCustType as! String): NSLocalizedString("retailer", comment:""))

                    print("nothing")
                }
                
            }
            
            if(activesetting.allowDistributorInCustType == NSNumber.init(value: 1)){
                switch activesetting.updatedByDistributorInCustType {
                case 1:
                    //All
                    aryContactType.append(activesetting.displayDistributorInCustType?.count ?? 0  > 0 ?(activesetting.displayDistributorInCustType as! String): NSLocalizedString("distributor", comment:""))

                break
                case 2:
                    //Only admin & manager
                    if(self.activeuser?.role?.id == NSNumber.init(value: 7) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayDistributorInCustType?.count ?? 0  > 0 ?(activesetting.displayDistributorInCustType as! String): NSLocalizedString("distributor", comment:""))
                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 5){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    }
                break
                case 3:
                    //Only admin
                    if(self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayDistributorInCustType?.count ?? 0  > 0 ?(activesetting.displayDistributorInCustType as! String): NSLocalizedString("distributor", comment:""))
                    }else if(isEditCustomer == true && isVendor == false){
                        if(selectedCustomer.companyTypeID == 5){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    }
                break
                default:
                    aryContactType.append(activesetting.displayDistributorInCustType?.count ?? 0  > 0 ?(activesetting.displayDistributorInCustType as! String): NSLocalizedString("distributor", comment:""))

                    print("nothing")
                }
             //
            }
           
            if(activesetting.allowStockistInCustType == NSNumber.init(value: 1)){
                switch activesetting.updatedByStockistInCustType {
                case 1:
                    //All
                    aryContactType.append(activesetting.displayStockistInCustType?.count ?? 0  > 0 ?(activesetting.displayStockistInCustType as! String):NSLocalizedString("stockist", comment:""))

                break
                case 2:
                    //Only admin & manager
                    if(self.activeuser?.role?.id == NSNumber.init(value: 7) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayStockistInCustType?.count ?? 0  > 0 ?(activesetting.displayStockistInCustType as! String):NSLocalizedString("stockist", comment:""))
                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 6){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    }
                break
                case 3:
                    //Only admin
                    if(self.activeuser?.role?.id == NSNumber.init(value: 6)){
                        aryContactType.append(activesetting.displayStockistInCustType?.count ?? 0  > 0 ?(activesetting.displayStockistInCustType as! String):NSLocalizedString("stockist", comment:""))
                    }else if(isEditCustomer == true && isVendor == false){if(selectedCustomer.companyTypeID == 6){
                        tfCustType.isUserInteractionEnabled = false
                        btnSubmit.isHidden = true
                    }
                    
                    }
                break
                default:
                    aryContactType.append(activesetting.displayStockistInCustType?.count ?? 0  > 0 ?(activesetting.displayStockistInCustType as! String):NSLocalizedString("stockist", comment:""))

                    print("nothing")
                }
              //
            }
        
       // }
        self.chooseCoTypeDropDown.dataSource = aryContactType;
        self.chooseCoTypeDropDown.reloadAllComponents()
        if(aryContactType.count > 0){
            let selectedcustType = aryContactType[0]
            tfCustType.text = selectedcustType
            if((tfCustType.text == activesetting.displayCorporateInCustType) || (tfCustType.text ==  NSLocalizedString("corporate", comment:""))){
                self.companytypeID = 1
            }else if((tfCustType.text == activesetting.displayEndUserInCustType) || (tfCustType.text ==  NSLocalizedString("end_user", comment:""))){
                self.companytypeID = 2
            }else if((tfCustType.text == activesetting.displayInfluencerInCustType) || (tfCustType.text ==  NSLocalizedString("influencer", comment:""))){
                self.companytypeID = 3
            }else if((tfCustType.text == activesetting.displayRetailerInCustType) || (tfCustType.text ==  NSLocalizedString("retailer", comment:""))){
                self.companytypeID = 4
            }else if((tfCustType.text == activesetting.displayDistributorInCustType) || (tfCustType.text ==  NSLocalizedString("distributor", comment:""))){
                self.companytypeID = 5
            }else{
                self.companytypeID = 6
            }
           
            let selectedVat  = self.arrvatCode[0]
            self.vatCodeID =  NSNumber.init(value:selectedVat.iD)
        }
        
        
        self.chooseCoTypeDropDown.selectionAction = {(index,item)
            in
            
            self.tfCustType.text =  item
            if((self.tfCustType.text == self.activesetting.displayCorporateInCustType) || (self.tfCustType.text ==  NSLocalizedString("corporate", comment:""))){
                self.companytypeID = 1
            }else if((self.tfCustType.text == self.activesetting.displayEndUserInCustType) || (self.tfCustType.text ==  NSLocalizedString("end_user", comment:""))){
                self.companytypeID = 2
            }else if((self.tfCustType.text == self.activesetting.displayInfluencerInCustType) || (self.tfCustType.text ==  NSLocalizedString("influencer", comment:""))){
                self.companytypeID = 3
            }else if((self.tfCustType.text == self.activesetting.displayRetailerInCustType) || (self.tfCustType.text ==  NSLocalizedString("retailer", comment:""))){
                self.companytypeID = 4
                self.tfSubCustType.placeholder = "Select Distributor"
                if(self.distributorId.intValue > 0){
                    if let selectedDistributor =  CustomerDetails.getCustomerByID(cid: self.distributorId) {
                        self.tfSubCustType.text = selectedDistributor.name
               
                    }
                }else{
                    self.tfSubCustType.text = "Select Distributor"
                }
                self.tfSubCustType.isHidden = false
            }else if((self.tfCustType.text == self.activesetting.displayDistributorInCustType) || (self.tfCustType.text ==  NSLocalizedString("distributor", comment:""))){
                self.companytypeID = 5
                self.tfSubCustType.placeholder = "Select Stockist"
                if(self.stockId.intValue > 0){
                    if let selectedDistributor =  CustomerDetails.getCustomerByID(cid: self.stockId) {
                        self.tfSubCustType.text = selectedDistributor.name
                       // self.distributorId = NSNumber.init(value: selectedCustomer.distributorID)
                    }
                }else{
                self.tfSubCustType.text = "Select Stockist"
                }
               
            }else{
                self.companytypeID = 6
                
            }
            
            
          
          
            if(self.companytypeID == NSNumber.init(value:4) || self.companytypeID == NSNumber.init(value:5)){
               
                self.tfSubCustType.isHidden = false
            }else{
                self.tfSubCustType.isHidden = true
                
            }
            
        
            let nameOfVat  = self.arrvatCode.map {
            $0.tAXName
        }
        
        self.chooseVatDropDown.dataSource = nameOfVat
            if(!self.isEditCustomer){
            self.tfVatCode.text = self.chooseVatDropDown.dataSource.first
        }
            self.filterSegmentAccordingtoCustType()
        }
        self.chooseVatDropDown.selectionAction = {(index,item)
            in
            self.tfVatCode.text  =  item
            let selectedVat  = self.arrvatCode[index]
            self.vatCodeID =  NSNumber.init(value:selectedVat.iD)
            
           // let selectedvatcode = ar
        }
        
        
    
//     assigneeuserDropDown.anchorView = searchAssignUser
//        assigneeuserDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.searchAssignUser.text = item
//            let assignee =
//                self.arrLowerLevelUser[index]
//            self.originalAssignee = assignee.entity_id
//        }
//        assigneeuserDropDown.reloadAllComponents()
//       assigneeuserDropDown.bottomOffset = CGPoint.init(x:0.0, y:self.searchAssignUser.bounds.size.height)
           
    
        
        
    }
    func fillupdatedatainUI(dic:[String:Any]){
        
//        custAddDic["AddressLine1"] = dic["address1"]
//        custAddDic["AddressLine2"] = dic["address2"]
//        custAddDic["City"] = dic["city"]
//        custAddDic["Pincode"] = dic["postalcode"] ?? ""
//        self.custAddDic["Lattitude"] = dic["latitude"]
//        self.custAddDic["Longitude"] = dic["longitude"]
        if(dic.keys.count > 0){
            self.strLat = dic["latitude"] as? CLLocationDegrees ?? 0.0000
        self.strLong = dic["longitude"] as? CLLocationDegrees ?? 0.0000
      
//        custAddDic["Country"] = dic["country"]
//        custAddDic["State"] = dic["state"]
//        custAddDic["Type"] = NSNumber.init(value: 1)
        
        
        tfAddressLine1.text = dic["address1"] as? String
        tfAddressLine2.text = dic["address2"] as? String
        tfCity.text = dic["city"] as? String
        tfState.text = dic["state"] as? String
        tfCountry.text = dic["country"] as? String
        tfPincode.text = dic["postalcode"] as? String
            var dic1 = dic as [String:Any]
            dic1["Lattitude"] = (dic["latitude"] as? NSNumber)?.stringValue
            dic1["Longitude"]  = (dic["longitude"] as? NSNumber)?.stringValue
            
            permenentAddress =  AddressListModel().getaddressListModelWithDic(dict: dic1)
            let doublelat = permenentAddress.lattitude.toDouble()
            let doublelng = permenentAddress.longitude.toDouble()
            permenentLocation = CLLocation.init(latitude: CLLocationDegrees.init(doublelat), longitude: CLLocationDegrees.init(doublelng))
            
        }
//        lblLatitude.text = String.init(format: "%@", dic["latitude"] as? CVarArg ?? 0.0000)
//        lblLongitude.text = String.init(format: "%@", dic["longitude"] as? CVarArg ?? 0.0000)
    }
    func validationAsperTypeAndSegment(completion:@escaping(_ territorystatus:Bool)->()){
        print("came in type and segment validation ")
        var display = 0
    let group = DispatchGroup()
        let dicOFValidationAsperTypeandSegment = Utils.getDefaultDicValue(key: Constant.kSettingTypeAndSegment)
        var status = true
        if(self.activesetting.requiLandLineNumInCustomer == NSNumber.init(value: 1)){
        group.enter()
        if let landlineType = dicOFValidationAsperTypeandSegment["landlineNoType"] as? String{
            if let landlineSegment = dicOFValidationAsperTypeandSegment["landlineNoSegment"] as? String{
                if(landlineType.lowercased() == "off" || landlineSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = landlineType.components(separatedBy: ",")
                let arrOfKYCSegment = landlineSegment.components(separatedBy: ",")
              //  if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                if(arrOfKYCType.contains(self.companytypeID.stringValue) && arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue)){
                   
                    if let landlineSegment = dicOFValidationAsperTypeandSegment["landlineNoSegment"] as? String{
                        if(landlineSegment.lowercased() == "off"){
                            group.leave()
                        }else{
                            let arrOfKYCType = landlineSegment.components(separatedBy: ",")
                            if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                                if(tfLandLineNo.text?.count == 0){
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please enter Landline Number",view: self.view)
                                    }
                                    status = false
                                    group.leave()
                                }else{
                                    group.leave()
                                }
                            }else{
                                group.leave()
                            }
                        }
                    }else{
                        group.leave()
                }
                }else{
                    group.leave()
                }
            }
            }else{
                group.leave()
            }
       
        }else{
            group.leave()
        }
        /* group.enter()
        if let landlineSegment = dicOFValidationAsperTypeandSegment["landlineNoSegment"] as? String{
            if(landlineSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = landlineSegment.components(separatedBy: ",")
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                    if(tfLandLineNo.text?.count == 0){
                       
                        Utils.toastmsg(message:"Please enter Landline",view: self.view)
                        status = false
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        }*/
        }
        
      
        
        
        if(self.activesetting.requiEmailIDInCustomer == NSNumber.init(value: 1)){
        //emailIDSegment
        group.enter()
        if let emailSegment = dicOFValidationAsperTypeandSegment["emailIDSegment"] as? String{
            if let emailType = dicOFValidationAsperTypeandSegment["emailIDType"] as? String{
                if(emailSegment.lowercased() == "off" || emailType.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCSegment = emailSegment.components(separatedBy: ",")
                let arrOfKYCType = emailType.components(separatedBy: ",")
              //  if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                if(arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue) && arrOfKYCType.contains(self.companytypeID.stringValue)){
                    
                    if(tfEmailId?.text?.count ?? 0 == 0){
                         group.leave()
                        if(display == 0){
                            display += 1
                         Utils.toastmsg(message:"Please enter email id",view: self.view)
                        }
                         status = false
                     }else{
                         group.leave()
                     }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        //emailIDType
        /* group.enter()
         if let emailType = dicOFValidationAsperTypeandSegment["emailIDType"] as? String{
             if(emailType.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = emailType.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if(tfEmailId?.text?.count ?? 0 == 0){
                         group.leave()
                         Utils.toastmsg(message:"Please enter email id",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }
        */
        
        }
        
        if(self.activesetting.requiImagesInCustomer == NSNumber.init(value: 1)){
            
            
            
            //PictureOneSegment
            group.enter()
            if let custpic1Segment = dicOFValidationAsperTypeandSegment["PictureOneSegment"] as? String{
                if let custpic1Type = dicOFValidationAsperTypeandSegment["PictureOneType"] as? String{
                    if(custpic1Segment.lowercased() == "off" || custpic1Type.lowercased() == "off"){
                    group.leave()
                }else{
                    let arrOfKYCType = custpic1Segment.components(separatedBy: ",")
                    let arrOfKYCSegmenet = custpic1Type.components(separatedBy: ",")
                  //  if(arrOfKYCSegmenet.contains(self.companytypeID.stringValue)){
                    if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue) && arrOfKYCSegmenet.contains(self.companytypeID.stringValue)){
                        if let custdata = custExtraImg1 as? UIImage{
                            if(custExtraImg1.pngData()?.count ?? 0 >  0){
                            group.leave()
                          
                        }else{
                            group.leave()
                            if(display == 0){
                                display += 1
                            Utils.toastmsg(message:"Please add first customer image",view: self.view)
                            }
                            status = false
                        }
                        }else{
                            group.leave()
                            if(display == 0){
                                display += 1
                            Utils.toastmsg(message:"Please add first customer image",view: self.view)
                            }
                            status = false
                        }
                    }else{
                        group.leave()
                    }
                }
            }else{
                group.leave()
            }
            }else{
                group.leave()
            
            }
            
        //PictureTwoSegment
        group.enter()
        if let custpic2Segment = dicOFValidationAsperTypeandSegment["PictureTwoSegment"] as? String{
            if let custpic2Type = dicOFValidationAsperTypeandSegment["PictureTwoType"] as? String{
                if(custpic2Segment.lowercased() == "off" || custpic2Type.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = custpic2Segment.components(separatedBy: ",")
                let arrOfKYCSegment = custpic2Type.components(separatedBy: ",")
              //  if(arrOfKYCSegment.contains(self.companytypeID.stringValue)){
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue) && arrOfKYCSegment.contains(self.companytypeID.stringValue)){
                    if let custdata = custExtraImg2 as? UIImage{
                        if(custExtraImg2.pngData()?.count ?? 0 >  0){
                        group.leave()
                      
                    }else{
                        group.leave()
                        if(display == 0){
                            display += 1
                        Utils.toastmsg(message:"Please add second customer image",view: self.view)
                        }
                        status = false
                    }
                    }else{
                        group.leave()
                        if(display == 0){
                            display += 1
                        Utils.toastmsg(message:"Please add second customer image",view: self.view)
                        }
                        status = false
                    }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        // PictureTwoType
        /* group.enter()
         if let custpic2Type = dicOFValidationAsperTypeandSegment["PictureTwoType"] as? String{
             if(custpic2Type.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = custpic2Type.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                     if(custExtraImg2.pngData()?.count ==  0){
                         group.leave()
                         Utils.toastmsg(message:"Please enter customer image 2",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }*/
        
        
       
        
        
        // PictureOneType
       /*  group.enter()
         if let custpic1Type = dicOFValidationAsperTypeandSegment["PictureOneType"] as? String{
             if(custpic1Type.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = custpic1Type.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                     if(custExtraImg1.pngData()?.count ==  0){
                         group.leave()
                         Utils.toastmsg(message:"Please enter customer image 1",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }*/
        }
        if(self.activesetting.requiDescriInCustomer == NSNumber.init(value: 1)){
        //descriptionSegment
        group.enter()
        if let descriptionSegment = dicOFValidationAsperTypeandSegment["descriptionSegment"] as? String{
            if let descriptionType = dicOFValidationAsperTypeandSegment["descriptionType"] as? String{
                if(descriptionSegment.lowercased() == "off" || descriptionType.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCSegment = descriptionSegment.components(separatedBy: ",")
                let arrOfKYCType = descriptionType.components(separatedBy: ",")
               // if(arrOfKYCType.contains(self.companytypeID.stringValue))
                if(arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue) && arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if(tvDesc.text.count == 0){
                         group.leave()
                        if(display == 0){
                            display += 1
                         Utils.toastmsg(message:"Please enter decription",view: self.view)
                        }
                         status = false
                     }else{
                         group.leave()
                     }
                }else{
                    group.leave()
                }
            }
            }else{
                group.leave()
            }
        }else{
            group.leave()
        }
        //descriptionType
         /*group.enter()
         if let descriptionType = dicOFValidationAsperTypeandSegment["descriptionType"] as? String{
             if(descriptionType.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = descriptionType.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if(tvDesc.text.count == 0){
                         group.leave()
                         Utils.toastmsg(message:"Please enter decription",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }
        */
        }
        
        if(self.activesetting.requiredBeatPlanDropDownInCustomer == NSNumber.init(value: 1)){
        
        //BeatPlanSegment
        group.enter()
        if let beatPlanSegment = dicOFValidationAsperTypeandSegment["BeatPlanSegment"] as? String{
            if let beatPlanType = dicOFValidationAsperTypeandSegment["BeatPlanType"] as? String{
                if(beatPlanSegment.lowercased() == "off" || beatPlanType.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCSegment = beatPlanSegment.components(separatedBy: ",")
                let arrOfKYCType = beatPlanType.components(separatedBy: ",")
                //if(arrOfKYCType.contains(self.companytypeID.stringValue))
                if(arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue) && arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if(selectedBeatplanID.count == 0){
                         group.leave()
                        if(display == 0){
                            display += 1
                         Utils.toastmsg(message:"Please select beat plan",view: self.view)
                        }
                         status = false
                     }else{
                         group.leave()
                     }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        //BeatPlanType
       /*  group.enter()
         if let beatPlanType = dicOFValidationAsperTypeandSegment["BeatPlanType"] as? String{
             if(beatPlanType.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = beatPlanType.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if(selectedBeatplanID.count == 0 ){
                         group.leave()
                         Utils.toastmsg(message:"Please select beat plan",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }*/
        
        }
        
        
        if(self.activesetting.requiVCardInCustomer == NSNumber.init(value: 1)){
        //VisitingCardType
        group.enter()
        if let visitcardType = dicOFValidationAsperTypeandSegment["VisitingCardType"] as? String{
            if let visitcardSegment = dicOFValidationAsperTypeandSegment["VisitingCardSegment"] as? String{
                if(visitcardType.lowercased() == "off" || visitcardSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = visitcardType.components(separatedBy: ",")
                let arrOfKYCSegment = visitcardSegment.components(separatedBy: ",")
//                if(arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue)){
                if(arrOfKYCType.contains(self.companytypeID.stringValue) && arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue)){
                    if let custdata = custVCard as? UIImage{
                        if(custVCard.pngData()?.count ?? 0 >  0){
                        group.leave()
                      
                    }else{
                        group.leave()
                        if(display == 0){
                            display += 1
                        Utils.toastmsg(message:"Please enter Visiting Card",view: self.view)
                        }
                        status = false
                    }
                    }else{
                        group.leave()
                        if(display == 0){
                            display += 1
                        Utils.toastmsg(message:"Please enter Visiting Card",view: self.view)
                        }
                        status = false
                    }
                    
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        
        //VisitingCardSegment
          
        /*group.enter()
        if let visitcardSegment = dicOFValidationAsperTypeandSegment["VisitingCardSegment"] as? String{
            if(visitcardSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = visitcardSegment.components(separatedBy: ",")
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                    if(custVCard.pngData()?.count == 0){
                        group.leave()
                        Utils.toastmsg(message:"Please enter Visiting Card",view: self.view)
                        status = false
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        }
        
        */
        
        }
        
        
        
        
        
        
        
        if(self.activesetting.requireCustCodeInCustomer == NSNumber.init(value: 1)){
        group.enter()
        if let customercodeType = dicOFValidationAsperTypeandSegment["customerCodeType"] as? String{
            if let customercodeSegment = dicOFValidationAsperTypeandSegment["customerCodeSegment"] as? String{
                if(customercodeType.lowercased() == "off" || customercodeSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = customercodeType.components(separatedBy: ",")
                let arrOfKYCSegment = customercodeSegment.components(separatedBy: ",")
               // if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                if(arrOfKYCType.contains(self.companytypeID.stringValue) && arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue) ){
                    if(tfCustomerCode.text?.count == 0){
                        group.leave()
                        if(display == 0){
                            display += 1
                        Utils.toastmsg(message:"Please enter customer code",view: self.view)
                        }
                        status = false
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        
        /*group.enter()
        if let customercodeSegment = dicOFValidationAsperTypeandSegment["customerCodeSegment"] as? String{
            if(customercodeSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = customercodeSegment.components(separatedBy: ",")
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                    if(tfCustomerCode.text?.count == 0){
                       
                        Utils.toastmsg(message:"Please enter Customer code",view: self.view)
                        status = false
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        }
       
        */
        
        }
        
        if(self.activesetting.requireTaxInCustomer == NSNumber.init(value: 1)){
       // CustomerGSTVATINType
        group.enter()
        if let custGSTVatType = dicOFValidationAsperTypeandSegment["CustomerGSTVATINType"] as? String{
            if let custGSTSegment = dicOFValidationAsperTypeandSegment["CustomerGSTVATINSegment"] as? String{
                if(custGSTVatType.lowercased() == "off" || custGSTSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = custGSTVatType.components(separatedBy: ",")
                let arrOfKYCSegment = custGSTSegment.components(separatedBy: ",")
               // if(arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue)){
                if(arrOfKYCType.contains(self.companytypeID.stringValue) && arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue)){
                    if(tfGSTValue.text?.count == 0){
                        group.leave()
                        if(display == 0){
                            display += 1
                        Utils.toastmsg(message:"Please enter GST/Vat No",view: self.view)
                        }
                        status = false
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        //VisitingCardSegment
        
      /*  group.enter()
        if let custGSTSegment = dicOFValidationAsperTypeandSegment["CustomerGSTVATINSegment"] as? String{
            if(custGSTSegment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = custGSTSegment.components(separatedBy: ",")
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                    if(vatCodeID.intValue == 0){
                        group.leave()
                        Utils.toastmsg(message:"Please enter GST/Vat",view: self.view)
                        status = false
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        }*/
        }
        
        if(self.activesetting.territoryInCustomer == NSNumber.init(value: 1)){
        //territoryCodeSegment
        group.enter()
        if let territorycodeSegment = dicOFValidationAsperTypeandSegment["territoryCodeSegment"] as? String{
            if let territorycodeType = dicOFValidationAsperTypeandSegment["territoryCodeType"] as? String{
                if(territorycodeSegment.lowercased() == "off" || territorycodeType.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = territorycodeSegment.components(separatedBy: ",")
                let arrOfKYCSegment = territorycodeType.components(separatedBy: ",")
                //if(arrOfKYCSegment.contains(self.companytypeID.stringValue)){
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue) && arrOfKYCSegment.contains(self.companytypeID.stringValue)){
                    if(tfCustomerTerritory.text?.count ==  0 || (tfCustomerTerritory.text?.lowercased() == "select territory")){
                         group.leave()
                        if(display == 0){
                            display += 1
                         Utils.toastmsg(message:"Please Select Territory",view: self.view)
                        }
                         status = false
                     }else{
                         group.leave()
                     }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        // territoryCodeType
      /*   group.enter()
         if let territorycodeType = dicOFValidationAsperTypeandSegment["territoryCodeType"] as? String{
             if(territorycodeType.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = territorycodeType.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if(selectedTerritory.keys.count ==  0){
                         group.leave()
                         Utils.toastmsg(message:"Please Select Territory",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }
       */
        
        
        }
   
        //customerCodeType
    
 
     
     
       
       
        
        if(self.activesetting.requiContactInCustomer == NSNumber.init(value: 1)  && isEditCustomer == false){
        //ContactSegment
        group.enter()
        if let contactSegment = dicOFValidationAsperTypeandSegment["ContactSegment"] as? String{
            if let contactType = dicOFValidationAsperTypeandSegment["ContactType"] as? String{
                if(contactSegment.lowercased() == "off" || contactType.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = contactSegment.components(separatedBy: ",")
                let arrOfKYCSegment = contactType.components(separatedBy: ",")
           //     if(arrOfKYCSegment.contains(self.companytypeID.stringValue))
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)  && arrOfKYCSegment.contains(self.companytypeID.stringValue) && self.activesetting.requiContactInCustomer == NSNumber.init(value: 1)){
                    if((tfContactFirstName.text?.count ==  0 || tfContactMobile.text?.count == 0 || tfContactLastName.text?.count == 0)){
                         group.leave()
                        if(display == 0){
                            display += 1
                            if(tfContactFirstName.text?.count ==  0){
                         Utils.toastmsg(message:"Contact First Name is required to add Contact",view: self.view)
                            }else if(tfContactLastName.text?.count ==  0){
                                Utils.toastmsg(message:"Contact Last Name is required to add Contact",view: self.view)
                                   }else if(tfContactMobile.text?.count ==  0){
                                    Utils.toastmsg(message:"Contact  Number is required to add Contact",view: self.view)
                                       }
                        }
                         status = false
                     }else{
                         group.leave()
                     }
                }else{
                    group.leave()
                }
            }
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        
        //ContactType
        /* group.enter()
         if let contactType = dicOFValidationAsperTypeandSegment["ContactType"] as? String{
             if(contactType.lowercased() == "off"){
                 group.leave()
             }else{
                 let arrOfKYCType = contactType.components(separatedBy: ",")
                 if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                    if((tfContactFirstName.text?.count ==  0 || tfContactMobile.text?.count == 0) ){
                         group.leave()
                         Utils.toastmsg(message:"Please add contact detail",view: self.view)
                         status = false
                     }else{
                         group.leave()
                     }
                 }else{
                    group.leave()
                }
             }
         }
        */
        }
        
        
       
       
     
        if(self.activesetting.requireCustomerKYC == NSNumber.init(value: 1)){
        group.enter()
            if let kyc1Type = dicOFValidationAsperTypeandSegment["KYC1Type"] as? String{
                if let kyc1Segment = dicOFValidationAsperTypeandSegment["KYC1Segment"] as? String{
                    if(kyc1Type.lowercased() == "off" || kyc1Segment.lowercased() == "off"){
                    group.leave()
                }else{
                    let arrOfKYCType = kyc1Type.components(separatedBy: ",")
                    let arrOfKYCSegment = kyc1Segment.components(separatedBy: ",")
                    if(arrOfKYCType.contains(self.companytypeID.stringValue) && arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue)){
                      
                     
                           
                             
                                    var KYCType = ""
                                    var KYCNumber = ""
                                    var KYCImage:UIImage?
                                    if(arrKYCDetails.count > 0){
                            
                                    let selectedKYC = arrKYCDetails[0]
                                     
                                    if let kyctype = selectedKYC["KycType"] as? String{
                                        KYCType = kyctype
                                    }
                                        if let kycnumber = selectedKYC["KycNumber"] as? String{
                                            KYCNumber = kycnumber
                                        }
                                        if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                            KYCImage = AddCustomer.custKYCImg
                                        }
                                        if(KYCType.count == 0 || KYCType.lowercased() == "select kyc type"){
                                        if(display == 0){
                                            display += 1
                                           
                                        Utils.toastmsg(message:"Please select KYC 1 Type",view: self.view)
                                           
                                        }
                                            status = false
                                            group.leave()
                                        }else if(KYCNumber.count == 0){
                                            if(display == 0){
                                                display += 1
                                               
                                            Utils.toastmsg(message:"Please add KYC 1 Number u",view: self.view)
                                              
                                            }
                                            status = false
                                            group.leave()
                                        }
                                        else
                                        
                                   
                                        if (KYCImage?.pngData()?.count ?? 0 > 0){
                                            group.leave()
                                        }else{
                                           
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add KYC 1 Image",view: self.view)
                                            }
                                            status = false
                                            group.leave()
                                        }
                                    
                                    }else{
                                        
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add KYC 1 Details",view: self.view)
                                        }
                                        status = false
                                        group.leave()
                                    }
                    }
                            
                        else{
                        
                    group.leave()
                }
            }
                }else{
                    group.leave()
    
               
                }
            }else{
                group.leave()
//            group.enter()
//            if let kyc1Segment = dicOFValidationAsperTypeandSegment["KYC1Segment"] as? String{
//                if(kyc1Segment.lowercased() == "off"){
//                    group.leave()
//                }else{
//                    let arrOfKYCType = kyc1Segment.components(separatedBy: ",")
//                    if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
//                        var KYCType = ""
//                        var KYCNumber = ""
//                        var KYCImage:UIImage?
//                        if(arrKYCDetails.count > 2){
//                        let selectedKYC = arrKYCDetails[2]
//                        if let kyctype = selectedKYC["KYC2Type"] as? String{
//                            KYCType = kyctype
//                        }
//                            if let kycnumber = selectedKYC["KYC2Number"] as? String{
//                                KYCNumber = kycnumber
//                            }
//                            if(custKYCImg1?.pngData()?.count ?? 0 > 0){
//                                KYCImage = custKYCImg1
//                            }
//                        if(KYCType.count > 0 && KYCNumber.count > 0){
//                            if let img = KYCImage as? UIImage{
//        group.leave()
//                            }else{
//        group.leave()
//                                Utils.toastmsg(message:"Please add KYC 2",view: self.view)
//                                status = false
//                            }
//                        }else{
//        group.leave()
//                            Utils.toastmsg(message:"Please add KYC 2",view: self.view)
//                            status = false
//                        }
//                        }else{
//                            group.leave()
//                            Utils.toastmsg(message:"Please add KYC 2",view: self.view)
//                            status = false
//                        }
//                    }else{
//                        group.leave()
//                    }
//                }
//            }
           
            }
        
    group.enter()
        if let kyc2Type = dicOFValidationAsperTypeandSegment["KYC2Type"] as? String{
            if let kyc2Segment = dicOFValidationAsperTypeandSegment["KYC2Segment"] as? String{
                if(kyc2Segment.lowercased() == "off" || kyc2Segment.lowercased() == "off"){
                    group.leave()
                }else{
                    let arrOfKYCType = kyc2Segment.components(separatedBy: ",")
                    let arrOFKYCSegment  = kyc2Type.components(separatedBy: ",")
                    if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue) && arrOFKYCSegment.contains(self.companytypeID.stringValue) && self.activesetting.numberOfKYC?.intValue ?? 0 > 1){
                        var KYCType = ""
                        var KYCNumber = ""
                        var KYCImage:UIImage? = UIImage()
                        if(arrKYCDetails.count > 1){
                        let selectedKYC = arrKYCDetails[1]
                        if let kyctype = selectedKYC["Kyc1Type"] as? String{
                            KYCType = kyctype
                        }
                            if let kycnumber = selectedKYC["Kyc1Number"] as? String{
                                KYCNumber = kycnumber
                            }
                            if(AddCustomer.custKYCImg1?.pngData()?.count ?? 0 > 0){
                                KYCImage = AddCustomer.custKYCImg1
                            }
                            if(KYCType.count == 0 || KYCType.lowercased() == "select kyc type"){
                                status = false
                            if(display == 0){
                                display += 1
                               
                            Utils.toastmsg(message:"Please select KYC 2 Type",view: self.view)
                                
                            }
                                
                                group.leave()
                            }else if(KYCNumber.count == 0){
                                if(display == 0){
                                    display += 1
                                   
                                Utils.toastmsg(message:"Please add KYC 2 Number",view: self.view)
                                 
                                }
                                status = false
                                group.leave()
                            }
                            else
                            
                       
                            if (KYCImage?.pngData()?.count ?? 0 > 0){
                                group.leave()
                            }else{
                               
                                if(display == 0){
                                    display += 1
                                Utils.toastmsg(message:"Please add KYC 2 Image",view: self.view)
                                }
                                status = false
                                group.leave()
                            }
                        
                        }else{
                            
                            if(display == 0){
                                display += 1
                            Utils.toastmsg(message:"Please add KYC 2 Details",view: self.view)
                            }
                            status = false
                            group.leave()
                        }
                       
                    }else{
                        group.leave()
                    }
                }
            
            
            
            /*if(kyc2Type.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = kyc2Type.components(separatedBy: ",")
                if(arrOfKYCType.contains(self.companytypeID.stringValue)){
                    group.enter()
                    if let kyc2Segment = dicOFValidationAsperTypeandSegment["KYC2Segment"] as? String{
                        if(kyc2Segment.lowercased() == "off"){
                            group.leave()
                        }else{
                            let arrOfKYCType = kyc2Segment.components(separatedBy: ",")
                            if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                                var KYCType = ""
                                var KYCNumber = ""
                                var KYCImage:UIImage?
                                if(arrKYCDetails.count > 2){
                                let selectedKYC = arrKYCDetails[2]
                                if let kyctype = selectedKYC["KYC2Type"] as? String{
                                    KYCType = kyctype
                                }
                                    if let kycnumber = selectedKYC["KYC2Number"] as? String{
                                        KYCNumber = kycnumber
                                    }
                                    if(custKYCImg1?.pngData()?.count ?? 0 > 0){
                                        KYCImage = custKYCImg1
                                    }
                                if(KYCType.count > 0 && KYCNumber.count > 0){
                                    if let img = KYCImage as? UIImage{
                group.leave()
                                    }else{
                group.leave()
                                        Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                                        status = false
                                    }
                                }else{
                group.leave()
                                    Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                                    status = false
                                }
                                }else{
                                    group.leave()
                                    Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                                    status = false
                                }
                            }else{
                                group.leave()
                            }
                        }
                    }else{
                    var KYCType = ""
                    var KYCNumber = ""
                    var KYCImage:UIImage?
                    if(arrKYCDetails.count > 2){
                    let selectedKYC = arrKYCDetails[2]
                    if let kyctype = selectedKYC["KYC2Type"] as? String{
                        KYCType = kyctype
                    }
                        if let kycnumber = selectedKYC["KYC2Number"] as? String{
                            KYCNumber = kycnumber
                        }
                        if(custKYCImg1?.pngData()?.count ?? 0 > 0){
                            KYCImage = custKYCImg1
                        }
                    if(KYCType.count > 0 && KYCNumber.count > 0){
                        if let img = KYCImage as? UIImage{
    group.leave()
                        }else{
    group.leave()
                            Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                            status = false
                        }
                    }else{
    group.leave()
                        Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                        status = false
                    }
                    }else{
                        group.leave()
                        Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                        status = false
                    }
                }
            }else{
                group.leave()
            }
        }*/
        }else{
            group.leave()
        }
        }else{
            group.leave()
        }
        
        /*group.enter()
        if let kyc2Segment = dicOFValidationAsperTypeandSegment["KYC2Segment"] as? String{
            if(kyc2Segment.lowercased() == "off"){
                group.leave()
            }else{
                let arrOfKYCType = kyc2Segment.components(separatedBy: ",")
                if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                    var KYCType = ""
                    var KYCNumber = ""
                    var KYCImage:UIImage?
                    if(arrKYCDetails.count > 2){
                    let selectedKYC = arrKYCDetails[2]
                    if let kyctype = selectedKYC["KYC2Type"] as? String{
                        KYCType = kyctype
                    }
                        if let kycnumber = selectedKYC["KYC2Number"] as? String{
                            KYCNumber = kycnumber
                        }
                        if(custKYCImg1?.pngData()?.count ?? 0 > 0){
                            KYCImage = custKYCImg1
                        }
                    if(KYCType.count > 0 && KYCNumber.count > 0){
                        if let img = KYCImage as? UIImage{
    group.leave()
                        }else{
    group.leave()
                            Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                            status = false
                        }
                    }else{
    group.leave()
                        Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                        status = false
                    }
                    }else{
                        group.leave()
                        Utils.toastmsg(message:"Please add KYC 2",view: self.view)
                        status = false
                    }
                }else{
                    group.leave()
                }
            }
        }
        */
        group.enter()
            if let kyc3Type = dicOFValidationAsperTypeandSegment["KYC3Type"] as? String{
                if let kyc3Segment = dicOFValidationAsperTypeandSegment["KYC3Segment"] as? String{
                    if(kyc3Type.lowercased() == "off" || kyc3Segment.lowercased() == "off"){
                    group.leave()
                }else{
                    let arrOfKYCType = kyc3Type.components(separatedBy: ",")
                    let arrOfKYCSegment = kyc3Segment.components(separatedBy: ",")
                   // if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                    if(arrOfKYCType.contains(self.companytypeID.stringValue) && arrOfKYCSegment.contains(self.customerSegmentIndex.stringValue) && self.activesetting.numberOfKYC?.intValue ?? 0 > 2){
                       
                 
                                    var KYCType = ""
                                    var KYCNumber = ""
                                    var KYCImage:UIImage? = UIImage()
                                    if(arrKYCDetails.count > 2){
                                    let selectedKYC = arrKYCDetails[2]
                                    if let kyctype = selectedKYC["Kyc2Type"] as? String{
                                        KYCType = kyctype
                                    }
                                        if let kycnumber = selectedKYC["Kyc2Number"] as? String{
                                            KYCNumber = kycnumber
                                        }
                                        if(AddCustomer.custKYCImg2?.pngData()?.count ?? 0 > 0){
                                            KYCImage = AddCustomer.custKYCImg2
                                        }
                                        if(KYCType.count == 0 || KYCType.lowercased() == "select kyc type"){
                                        if(display == 0){
                                            display += 1
                                           
                                        Utils.toastmsg(message:"Please select KYC 3 Type",view: self.view)
                                        }
                                            status = false
                                            group.leave()
                                        }else if(KYCNumber.count == 0){
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add KYC 3 Number",view: self.view)
                                            }
                                            status = false
                                                
                                            group.leave()
                                        }
                                        else
                                        
                                   
                                        if (KYCImage?.pngData()?.count ?? 0 > 0){
                                            
                                            group.leave()
                                        }else{
                                           
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add KYC 3 Image",view: self.view)
                                            }
                                            status = false
                                            group.leave()
                                        }
                                    
                                    }else{
                                       
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add KYC 3 Details",view: self.view)
                                        }
                                        status = false
                                        group.leave()
                                    }
                                }else{
                                    group.leave()
                                }
                            }
                        }else{
                            group.leave()
                        }
            }else{
                group.leave()
            }
                       
          /*  group.enter()
            if let kyc3Segment = dicOFValidationAsperTypeandSegment["KYC3Segment"] as? String{
                if(kyc3Segment.lowercased() == "off"){
                    group.leave()
                }else{
                    let arrOfKYCType = kyc3Segment.components(separatedBy: ",")
                    if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                        var KYCType = ""
                        var KYCNumber = ""
                        var KYCImage:UIImage?
                        if(arrKYCDetails.count > 2){
                        let selectedKYC = arrKYCDetails[2]
                        if let kyctype = selectedKYC["KYC3Type"] as? String{
                            KYCType = kyctype
                        }
                            if let kycnumber = selectedKYC["KYC3Number"] as? String{
                                KYCNumber = kycnumber
                            }
                            if(custKYCImg1?.pngData()?.count ?? 0 > 0){
                                KYCImage = custKYCImg1
                            }
                        if(KYCType.count > 0 && KYCNumber.count > 0){
                            if let img = KYCImage as? UIImage{
        group.leave()
                            }else{
        group.leave()
                                Utils.toastmsg(message:"Please add KYC 3",view: self.view)
                                status = false
                            }
                        }else{
        group.leave()
                            Utils.toastmsg(message:"Please add KYC 3",view: self.view)
                            status = false
                        }
                        }else{
                            group.leave()
                            Utils.toastmsg(message:"Please add KYC 3",view: self.view)
                            status = false
                        }
                    }else{
                        group.leave()
                    }
                }
            }*/
        }
        
        
        group.notify(queue: .main) {
            print("completion = \(status)")
        completion(status)
        }
    }
    func checkValidation(completionstatus:@escaping (_ vaildationstatus:Bool)->()){
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
        if(tfCustName.text?.count == 0){
//            tfCustName.becomeFirstResponder()
            if(isVendor ==  true){
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:"Please enter vendor name",view: self.view)
            }else{
                SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Please enter customer name",view: self.view)
            }
            completionstatus(false)
        }else if(tfCustMobileNo.text?.count == 0){
//            tfCustMobileNo.becomeFirstResponder()
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Please enter mobile no",view: self.view)
            completionstatus(false)
        }else if(self.activesetting.mandatoryCustomerContact == NSNumber.init(value: 1) && tfContactFirstName.text?.count == 0 && self.activesetting.requiContactInCustomer == NSNumber.init(value: 1)  && isEditCustomer == false){
//            tfContactFirstName.becomeFirstResponder()
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Contact first name is require to add contact",view: self.view)
    completionstatus(false)
        }else if(self.activesetting.mandatoryCustomerContact == NSNumber.init(value: 1) && tfContactLastName.text?.count == 0 && self.activesetting.requiContactInCustomer == NSNumber.init(value: 1)  && isEditCustomer == false){
//            tfContactLastName.becomeFirstResponder()
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Contact last name is require to add contact",view: self.view)
    completionstatus(false)
        }else if(tfContactFirstName.text?.count == 0 && self.activesetting.mandatoryCustomerContact == NSNumber.init(value: 1) && self.activesetting.requiContactInCustomer == NSNumber.init(value: 1)  && isEditCustomer == false){
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Contact  number is required to add contact",view: self.view)
            completionstatus(false)
        }
        else if(self.activesetting.requiredSegmentInCustomer == NSNumber.init(value:1) && self.activesetting.mandatoryCustomerSegment == NSNumber.init(value:1) && self.customerSegmentIndex == NSNumber.init(value:0)){
//            tfCustomerSegment.becomeFirstResponder()
            self.view.makeToast("Please Select Segment")
            completionstatus(false)
        }
        else
            if(self.activesetting.requireTownInCustomer == true && isVendor == false && townID == 0){
              
                    Utils.toastmsg(message:"Please select town",view: self.view)
                    completionstatus(false)
                
            }
            else if(primaryUserID == NSNumber.init(value: 0) || lblPrimaryAssignToValue.text?.count == 0){
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:"Select Sales person to assign",view: self.view)
                completionstatus(false)
            }else if(self.activesetting.mandatoryPictureInCreateCustomer == NSNumber.init(value:1) && self.activesetting.requiImagesInCustomer == NSNumber.init(value:1)){
            var iscustomerimgexist = false
                
            if(self.custExtraImg1.pngData()?.count ?? 0 > 0){
            if let extimg = self.custExtraImg1 as? UIImage{
                iscustomerimgexist = true
               
            }
            }
            if(self.custExtraImg2.pngData()?.count ?? 0 > 0){
            if let extimg1 = self.custExtraImg2 as? UIImage{
                
                iscustomerimgexist = true
            }
            }
            if(self.custExtraImg3.pngData()?.count ?? 0 > 0){
            if let extimg2 = self.custExtraImg3 as? UIImage{
                
                iscustomerimgexist = true
            }
            }
            if( iscustomerimgexist == false){
                SVProgressHUD.dismiss()
                self.view.makeToast("Please add customer image")
                completionstatus(false)
            }else{
             
                if(tfContactFirstName.text?.count ?? 0 > 0 && tfContactMobile.text?.count == 0){
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message:"Contact Number is required to add Contact",view: self.view)
                    completionstatus(false)
                }
                else if(tfContactMobile.text?.count ?? 0 > 0 && tfContactFirstName.text?.count == 0){
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message:"Contact Name is required to add Contact",view: self.view)
                    completionstatus(false)
                }else if(primaryUserID == NSNumber.init(value: 0) && BaseViewController.staticlowerUser.count > 0){
                    Utils.toastmsg(message:"Select user to assign",view: self.view)
                    SVProgressHUD.dismiss()
                    completionstatus(false)
                }else if(tfAddressLine1.text?.count == 0){
        //            tfAddressLine1.becomeFirstResponder()
                    Utils.toastmsg(message:"Please enter address Line 1",view: self.view)
                    SVProgressHUD.dismiss()
                    completionstatus(false)
                }else if(tfCity.text?.count == 0){
        //            tfCity.becomeFirstResponder()
                    Utils.toastmsg(message:"Please enter city",view: self.view)
                    SVProgressHUD.dismiss()
                    completionstatus(false)
                }else if(tfState.text?.count == 0){
        //            tfState.becomeFirstResponder()
                    Utils.toastmsg(message:"Please enter state",view: self.view)
                    SVProgressHUD.dismiss()
                    completionstatus(false)
                }
                
                    else if((self.activesetting.mandatoryDistributorRetailerMapping == NSNumber.init(value: 1)) && (distributorId == NSNumber.init(value: 0)) && (self.companytypeID == NSNumber.init(value: 4) )){
                        Utils.toastmsg(message:"Please select \(activesetting.displayDistributorInCustType ?? NSLocalizedString("distributor", comment:""))",view: self.view)
                        SVProgressHUD.dismiss()
                        completionstatus(false)
                        
                    }else if((self.activesetting.mandatoryDistributorToStockiestMapping == NSNumber.init(value: 1)) && (stockId == NSNumber.init(value: 0)) && (self.companytypeID == NSNumber.init(value: 5))){
                        Utils.toastmsg(message:"Please select \(activesetting.displayStockistInCustType ?? NSLocalizedString("stockist", comment:""))",view: self.view)
                        SVProgressHUD.dismiss()
                        completionstatus(false)
                    }else if((self.activesetting.vatGst == 2) && (vatCodeID == NSNumber.init(value: 0))){
                        Utils.toastmsg(message:"Please Select Vat Code",view: self.view)
                        SVProgressHUD.dismiss()
                        completionstatus(false)
                    }else
                    if(self.activesetting.customerMobileValidation == NSNumber.init(value: 1) &&  ((tfCustMobileNo.text?.count ?? 0 < self.activesetting.custMobileNoLength?.intValue ?? 6) || (tfCustMobileNo.text?.count ?? 0 > self.activesetting.custMobileNoLength?.intValue ?? 6))){
            //             tfCustMobileNo.becomeFirstResponder()
                         Utils.toastmsg(message:"mobile number should be \(self.activesetting.custMobileNoLength?.intValue ?? 6) digit ",view: self.view)
                        SVProgressHUD.dismiss()
                     completionstatus(false)
                     }else if(tfCustMobileNo.text?.count ?? 0 < 6){
            //            tfCustMobileNo.becomeFirstResponder()
                        SVProgressHUD.dismiss()
                        Utils.toastmsg(message:"Please enter valid contact no",view: self.view)
                    completionstatus(false)
                     }
        //             else if((tfContactMobile.text?.count ?? 0 < 6) && (tfContactFirstName.text?.count ?? 0  > 0) && self.activesetting.requiContactInCustomer == NSNumber.init(value: 1) && isEditCustomer ==  false){
        //    //                    tfContactMobile.becomeFirstResponder()
        //                SVProgressHUD.dismiss()
        //            Utils.toastmsg(message:"Please enter valid mobile no of contact atleast 6 digit",view: self.view)
        //                completionstatus(false)
        //            }
                else if(((tfEmailId.text?.count ?? 0 > 0) && (!tfEmailId.emailValidation(email: tfEmailId.text ?? ""))) || (tfEmailOrderTo.text?.count ?? 0 > 0 && (!tfEmailOrderTo.emailValidation(email: tfEmailOrderTo.text ?? "")))){
                    if(tfEmailId.text?.count ?? 0 > 0){
        //                tfEmailId.becomeFirstResponder()
                    }else{
        //                tfEmailOrderTo.becomeFirstResponder()
                        }
                    SVProgressHUD.dismiss()
                Utils.toastmsg(message:"Enter vaild mail Id",view: self.view)
                    completionstatus(false)

                }
                    
        //                else if(tfCustMobileNo.text?.count ?? 0 < 6){
        //                    tfCustMobileNo.becomeFirstResponder()
        //                    Utils.toastmsg(message:"Please enter valid contact no",view: self.view)
        //                    completionstatus(false)
        //                }
        //            else if(self.arrKYCDetails.count == 0 && self.activesetting.requireCustomerKYC == NSNumber.init(value: 1)){
        //                Utils.toastmsg(message:"Please enter KYC Details",view: self.view)
        //                completionstatus(false)
        //            }
                        else{
                            if(self.arrKYCDetails.count > 0){
                                var status = true
                                var display = 0
                                for i in 0...self.arrKYCDetails.count - 1{
                                    let selectedKYC = arrKYCDetails[i]
                                   
                                    var KYCType = ""
                                    var KYCNumber = ""
                                    var KYCImage = UIImage()
                                    if(i == 0){
                                    
                                    if let kyctype = selectedKYC["KycType"] as? String{
                                        KYCType = kyctype
                                    }
                                        if let kycnumber = selectedKYC["KycNumber"] as? String{
                                            KYCNumber = kycnumber
                                        }
                                        if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                            if let kycimg = AddCustomer.custKYCImg as? UIImage{
                                            KYCImage = kycimg
                                            }
                                        }
                                        if((KYCType.count > 0 && KYCType.lowercased() != "select kyc type")){
                                            if(KYCNumber.count == 0){
                                                if(display == 0){
                                                    display += 1
                                               Utils.toastmsg(message:"Please add KYC 1  Number",view: self.view)
                                                }
                                               status =  false
                                            }else if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                            

                                        }else{
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please Add KYC 1 Image",view: self.view)
                                            }
                                                status =  false
                                        }
                                        }
                                        else if(KYCNumber.count > 0){
                                           
                                            if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type" || KYCType.count  == 0){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Select KYC 1 Type",view: self.view)
                                                }
                                                status =  false
                                            }else if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                                     

                                            }else{
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Add KYC 1 Image",view: self.view)
                                                }
                                                status =  false
                                            }
                                        }else if (KYCImage.pngData()?.count ?? 0 > 0){
                                            if((KYCType.count > 0 && KYCType.lowercased() == "select kyc type")||(KYCType.count == 0)){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Select KYC 1 Type",view: self.view)
                                                }
                                                status =  false
                                            }else if(KYCNumber.count == 0){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please add KYC 1  Number",view: self.view)
                                                }
                                                status =  false
                                            }else{

                                            }
                                        }
                                        /*else if(self.activesetting.requireCustomerKYC == NSNumber.init(value:1) && (KYCType.count == 0 || KYCNumber.count == 0 || KYCImage.pngData()?.count  == 0)){
                                            Utils.toastmsg(message:"Please Enter KYC 1 Detail ",view: self.view)
                                            status =  false
                                        }*/
                                    }else if(i == 1) {
                                        if let kyctype = selectedKYC["Kyc1Type"] as? String{
                                            KYCType = kyctype
                                        }
                                            if let kycnumber = selectedKYC["Kyc1Number"] as? String{
                                                KYCNumber = kycnumber
                                            }
                                        if(AddCustomer.custKYCImg1?.pngData()?.count ?? 0 > 0){
                                            if let kycimg = AddCustomer.custKYCImg1 as? UIImage{
                                                KYCImage = kycimg
                                            }
                                        }
                                    
                                    if((KYCType.count > 0 && KYCType.lowercased() != "select kyc type")){
                                        if(KYCNumber.count == 0){
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add KYC 2 Number",view: self.view)
                                            status =  false
                                            }
                                        }
                                        else if (KYCImage.pngData()?.count ?? 0 > 0){
                                           

                                        }else{
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please Add KYC  2  Image",view: self.view)
                                            }
                                                status =  false
                                        }
                                    }
                                        else if(KYCNumber.count > 0){
                                           if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"  || (KYCType.count  == 0)){
                                            if(display == 0){
                                                display += 1
                                                Utils.toastmsg(message:"Please Select KYC 2 Type",view: self.view)
                                            }
                                                status =  false
                                            }else  if (KYCImage.pngData()?.count ?? 0 > 0){
                                                
                                              

                                            }else{
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Add KYC  2  Image",view: self.view)
                                                }
                                                status =  false
                                            }
                                        }else if (KYCImage.pngData()?.count ?? 0 > 0){
                                            if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Select KYC 2 Type",view: self.view)
                                                }
                                                status =  false
                                            }else if(KYCNumber.count == 0){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please add KYC 2 Number",view: self.view)
                                                }
                                                status =  false
                                            }else{

                                            }
                                        
                                    }
                                    }else{
                                        if let kyctype = selectedKYC["Kyc2Type"] as? String{
                                            KYCType = kyctype
                                        }
                                            if let kycnumber = selectedKYC["Kyc2Number"] as? String{
                                                KYCNumber = kycnumber
                                            }
                                        if(AddCustomer.custKYCImg2?.pngData()?.count ?? 0 > 0){
                                            if let kycimg = AddCustomer.custKYCImg2 as? UIImage{
                                                KYCImage = kycimg
                                            }
                                        }
                                    
                                    if((KYCType.count > 0 && KYCType.lowercased() != "select kyc type")){
                                        if(KYCNumber.count == 0){
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add KYC 3 Number",view: self.view)
                                            
                                            }
                                            status =  false
                                        }
                                        else if (KYCImage.pngData()?.count ?? 0 > 0){
                                           

                                        }else{
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please Add KYC  3  Image",view: self.view)
                                            
                                            }
                                            status =  false
                                        }
                                    }
                                    else if(KYCNumber.count > 0){
                                           if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type" || (KYCType.count  == 0)){
                                            if(display == 0){
                                                display += 1
                                                Utils.toastmsg(message:"Please Select KYC 3 Type",view: self.view)
                                            }
                                                status =  false
                                            }else  if (KYCImage.pngData()?.count ?? 0 > 0){
                                                
                                              
                                           

                                            }else{
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Add KYC  3  Image",view: self.view)
                                                }
                                                status =  false
                                            }
                                    }else if(KYCImage.pngData()?.count ?? 0 > 0){
                                            if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Select KYC 3 Type",view: self.view)
                                                }
                                                status =  false
                                            }else if(KYCNumber.count == 0){
                                                print("selected kyc = \(selectedKYC) &  arr = \(arrKYCDetails) record = \(i)")
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please add KYC 3 Number y",view: self.view)
                                                }
                                                status =  false
                                            }else{

                                            }
                                        
                                    }else{
                                        if let kyctype = selectedKYC["Kyc2Type"] as? String{
                                            KYCType = kyctype
                                        }
                                            if let kycnumber = selectedKYC["Kyc2Number"] as? String{
                                                KYCNumber = kycnumber
                                            }
                                        if(AddCustomer.custKYCImg2?.pngData()?.count ?? 0 > 0){
                                            if let kycimg = AddCustomer.custKYCImg2 as? UIImage{
                                                KYCImage = kycimg
                                            }
                                        }
                                        if(KYCType.count > 0 && KYCType.lowercased() != "select kyc type"){
                                            if(KYCNumber.count == 0){
                                                Utils.toastmsg(message:"Please enter KYC2 number",view: self.view)
                                                status =  false
                                            }
                                            else if (KYCImage.pngData()?.count ?? 0 > 0){
                                               

                                            }else{
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Add KYC 2 Image",view: self.view)
                                                }
                                            status =  false
                                            }
                                        }
                                        else if(KYCNumber.count > 0){
                                           if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                                Utils.toastmsg(message:"Please Select KYC2 Type",view: self.view)
                                                status =  false
                                            }else  if (KYCImage.pngData()?.count ?? 0 > 0){
                                              

                                            }else{
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Add KYC 2 Image",view: self.view)
                                                }
                                            status =  false
                                            }
                                        }else if (KYCImage.pngData()?.count ?? 0 > 0){
                                            if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Select KYC2 Type",view: self.view)
                                                }
                                                status =  false
                                            }else if(KYCNumber.count == 0){
                                                if(display == 0){
                                                    display += 1
                                                Utils.toastmsg(message:"Please Select KYC2 Number",view: self.view)
                                                }
                                                status =  false
                                            }else{

                                            }
                                        }
                                    }
                                    }
                                    
                                }
                                if(status ==  false){
                                    SVProgressHUD.dismiss()
                                    completionstatus(status)
                                }else{
                                    var status:Bool!
                                    let group = DispatchGroup()
                                    group.enter()
                                    self.validationAsperTypeAndSegment{ (territorystatus) in
                                       
                                       status = territorystatus
                                        group.leave()
                                      
                                    }
                                    
                                    
                                    group.notify(queue: .main) {
                                        if(status ==  false){
                                            SVProgressHUD.dismiss()
                                        }
                                    completionstatus(status)
                                    }
                                }
                                
                             
                            }else{
                                var status:Bool!
                                let group = DispatchGroup()
                                group.enter()
                                self.validationAsperTypeAndSegment{ (territorystatus) in
                                   
                                   status = territorystatus
                                    group.leave()
                                  
                                }
                                
                                
                                group.notify(queue: .main) {
                                    if(status ==  false){
                                        SVProgressHUD.dismiss()
                                    }
                                completionstatus(status)
                                }
                
                
                
                
            }
        }
        
            }
            }
        else if(tfContactFirstName.text?.count ?? 0 > 0 && tfContactMobile.text?.count == 0){
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Contact Number is required to add Contact",view: self.view)
            completionstatus(false)
        }
        else if(tfContactMobile.text?.count ?? 0 > 0 && tfContactFirstName.text?.count == 0){
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"Contact Name is required to add Contact",view: self.view)
            completionstatus(false)
        }else if(primaryUserID == NSNumber.init(value: 0) && BaseViewController.staticlowerUser.count > 0){
            Utils.toastmsg(message:"Select user to assign",view: self.view)
            SVProgressHUD.dismiss()
            completionstatus(false)
        }else if(tfAddressLine1.text?.count == 0){
//            tfAddressLine1.becomeFirstResponder()
            Utils.toastmsg(message:"Please enter address Line 1",view: self.view)
            SVProgressHUD.dismiss()
            completionstatus(false)
        }else if(tfCity.text?.count == 0){
//            tfCity.becomeFirstResponder()
            Utils.toastmsg(message:"Please enter city",view: self.view)
            SVProgressHUD.dismiss()
            completionstatus(false)
        }else if(tfState.text?.count == 0){
//            tfState.becomeFirstResponder()
            Utils.toastmsg(message:"Please enter state",view: self.view)
            SVProgressHUD.dismiss()
            completionstatus(false)
        }
        
            else if((self.activesetting.mandatoryDistributorRetailerMapping == NSNumber.init(value: 1)) && (distributorId == NSNumber.init(value: 0)) && (self.companytypeID == NSNumber.init(value: 4) )){
                Utils.toastmsg(message:"Please select \(activesetting.displayDistributorInCustType ?? NSLocalizedString("distributor", comment:""))",view: self.view)
                SVProgressHUD.dismiss()
                completionstatus(false)
                
            }else if((self.activesetting.mandatoryDistributorToStockiestMapping == NSNumber.init(value: 1)) && (stockId == NSNumber.init(value: 0)) && (self.companytypeID == NSNumber.init(value: 5))){
                Utils.toastmsg(message:"Please select \(activesetting.displayStockistInCustType ?? NSLocalizedString("stockist", comment:""))",view: self.view)
                SVProgressHUD.dismiss()
                completionstatus(false)
            }else if((self.activesetting.vatGst == 2) && (vatCodeID == NSNumber.init(value: 0))){
                Utils.toastmsg(message:"Please Select Vat Code",view: self.view)
                SVProgressHUD.dismiss()
                completionstatus(false)
            }else
            if(self.activesetting.customerMobileValidation == NSNumber.init(value: 1) &&  ((tfCustMobileNo.text?.count ?? 0 < self.activesetting.custMobileNoLength?.intValue ?? 6) || (tfCustMobileNo.text?.count ?? 0 > self.activesetting.custMobileNoLength?.intValue ?? 6))){
    //             tfCustMobileNo.becomeFirstResponder()
                 Utils.toastmsg(message:"mobile number should be \(self.activesetting.custMobileNoLength?.intValue ?? 6) digit ",view: self.view)
                SVProgressHUD.dismiss()
             completionstatus(false)
             }else if(tfCustMobileNo.text?.count ?? 0 < 6){
    //            tfCustMobileNo.becomeFirstResponder()
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:"Please enter valid contact no",view: self.view)
            completionstatus(false)
             }
//             else if((tfContactMobile.text?.count ?? 0 < 6) && (tfContactFirstName.text?.count ?? 0  > 0) && self.activesetting.requiContactInCustomer == NSNumber.init(value: 1) && isEditCustomer ==  false){
//    //                    tfContactMobile.becomeFirstResponder()
//                SVProgressHUD.dismiss()
//            Utils.toastmsg(message:"Please enter valid mobile no of contact atleast 6 digit",view: self.view)
//                completionstatus(false)
//            }
        else if(((tfEmailId.text?.count ?? 0 > 0) && (!tfEmailId.emailValidation(email: tfEmailId.text ?? ""))) || (tfEmailOrderTo.text?.count ?? 0 > 0 && (!tfEmailOrderTo.emailValidation(email: tfEmailOrderTo.text ?? "")))){
            if(tfEmailId.text?.count ?? 0 > 0){
//                tfEmailId.becomeFirstResponder()
            }else{
//                tfEmailOrderTo.becomeFirstResponder()
                }
            SVProgressHUD.dismiss()
        Utils.toastmsg(message:"Enter vaild mail Id",view: self.view)
            completionstatus(false)

        }
            
//                else if(tfCustMobileNo.text?.count ?? 0 < 6){
//                    tfCustMobileNo.becomeFirstResponder()
//                    Utils.toastmsg(message:"Please enter valid contact no",view: self.view)
//                    completionstatus(false)
//                }
//            else if(self.arrKYCDetails.count == 0 && self.activesetting.requireCustomerKYC == NSNumber.init(value: 1)){
//                Utils.toastmsg(message:"Please enter KYC Details",view: self.view)
//                completionstatus(false)
//            }
                else{
                    if(self.arrKYCDetails.count > 0){
                        var status = true
                        var display = 0
                        for i in 0...self.arrKYCDetails.count - 1{
                            let selectedKYC = arrKYCDetails[i]
                           
                            var KYCType = ""
                            var KYCNumber = ""
                            var KYCImage = UIImage()
                            if(i == 0){
                            
                            if let kyctype = selectedKYC["KycType"] as? String{
                                KYCType = kyctype
                            }
                                if let kycnumber = selectedKYC["KycNumber"] as? String{
                                    KYCNumber = kycnumber
                                }
                                if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                    if let kycimg = AddCustomer.custKYCImg as? UIImage{
                                    KYCImage = kycimg
                                    }
                                }
                                if((KYCType.count > 0 && KYCType.lowercased() != "select kyc type")){
                                    if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)){
                                        if(display == 0){
                                            display += 1
                                       Utils.toastmsg(message:"Please add KYC 1  Number",view: self.view)
                                        }
                                       status =  false
                                    }else if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                    

                                }else{
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please Add KYC 1 Image",view: self.view)
                                    }
                                        status =  false
                                }
                                }
                                else if(KYCNumber.count > 0){
                                   
                                    if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type" || (KYCType.count  == 0  )){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Select KYC 1 Type",view: self.view)
                                        }
                                        status =  false
                                    }else if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                                             

                                    }else{
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Add KYC 1 Image",view: self.view)
                                        }
                                        status =  false
                                    }
                                }else if (KYCImage.pngData()?.count ?? 0 > 0){
                                    if((KYCType.count > 0 && KYCType.lowercased() == "select kyc type")||(KYCType.count == 0 || KYCType.isBlank(KYCType))){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Select KYC 1 Type",view: self.view)
                                        }
                                        status =  false
                                    }else if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add KYC 1  Number",view: self.view)
                                        }
                                        status =  false
                                    }else{

                                    }
                                }
                                /*else if(self.activesetting.requireCustomerKYC == NSNumber.init(value:1) && (KYCType.count == 0 || KYCNumber.count == 0 || KYCImage.pngData()?.count  == 0)){
                                    Utils.toastmsg(message:"Please Enter KYC 1 Detail ",view: self.view)
                                    status =  false
                                }*/
                            }else if(i == 1) {
                                if let kyctype = selectedKYC["Kyc1Type"] as? String{
                                    KYCType = kyctype
                                }
                                    if let kycnumber = selectedKYC["Kyc1Number"] as? String{
                                        KYCNumber = kycnumber
                                    }
                                if(AddCustomer.custKYCImg1?.pngData()?.count ?? 0 > 0){
                                    if let kycimg = AddCustomer.custKYCImg1 as? UIImage{
                                        KYCImage = kycimg
                                    }
                                }
                            
                            if((KYCType.count > 0 && KYCType.lowercased() != "select kyc type")){
                                if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber) ){
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please add KYC 2 Number",view: self.view)
                                    status =  false
                                    }
                                }
                                else if (KYCImage.pngData()?.count ?? 0 > 0){
                                   

                                }else{
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please Add KYC  2  Image",view: self.view)
                                    }
                                        status =  false
                                }
                            }
                                else if(KYCNumber.count > 0){
                                   if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"  || (KYCType.count  == 0)){
                                    if(display == 0){
                                        display += 1
                                        Utils.toastmsg(message:"Please Select KYC 2 Type",view: self.view)
                                    }
                                        status =  false
                                    }else  if (KYCImage.pngData()?.count ?? 0 > 0){
                                        
                                      

                                    }else{
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Add KYC  2  Image",view: self.view)
                                        }
                                        status =  false
                                    }
                                }else if (KYCImage.pngData()?.count ?? 0 > 0){
                                    if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Select KYC 2 Type",view: self.view)
                                        }
                                        status =  false
                                    }else if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add KYC 2 Number",view: self.view)
                                        }
                                        status =  false
                                    }else{

                                    }
                                
                            }
                            }else{
                                if let kyctype = selectedKYC["Kyc2Type"] as? String{
                                    KYCType = kyctype
                                }
                                    if let kycnumber = selectedKYC["Kyc2Number"] as? String{
                                        KYCNumber = kycnumber
                                    }
                                if(AddCustomer.custKYCImg2?.pngData()?.count ?? 0 > 0){
                                    if let kycimg = AddCustomer.custKYCImg2 as? UIImage{
                                        KYCImage = kycimg
                                    }
                                }
                            
                            if((KYCType.count > 0 && KYCType.lowercased() != "select kyc type")){
                                if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)){
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please add KYC 3 Number",view: self.view)
                                    
                                    }
                                    status =  false
                                }
                                else if (KYCImage.pngData()?.count ?? 0 > 0){
                                   

                                }else{
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please Add KYC  3  Image",view: self.view)
                                    
                                    }
                                    status =  false
                                }
                            }
                            else if(KYCNumber.count > 0){
                                   if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type" || (KYCType.count  == 0)){
                                    if(display == 0){
                                        display += 1
                                        Utils.toastmsg(message:"Please Select KYC 3 Type",view: self.view)
                                    }
                                        status =  false
                                    }else  if (KYCImage.pngData()?.count ?? 0 > 0){
                                        
                                      
                                   

                                    }else{
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Add KYC  3  Image",view: self.view)
                                        }
                                        status =  false
                                    }
                            }else if(KYCImage.pngData()?.count ?? 0 > 0){
                                    if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Select KYC 3 Type",view: self.view)
                                        }
                                        status =  false
                                    }else if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)){
                                        print("selected kyc = \(selectedKYC) &  arr = \(arrKYCDetails) record = \(i)")
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add KYC 3 Number y",view: self.view)
                                        }
                                        status =  false
                                    }else{

                                    }
                                
                            }else{
                                if let kyctype = selectedKYC["Kyc2Type"] as? String{
                                    KYCType = kyctype
                                }
                                    if let kycnumber = selectedKYC["Kyc2Number"] as? String{
                                        KYCNumber = kycnumber
                                    }
                                if(AddCustomer.custKYCImg2?.pngData()?.count ?? 0 > 0){
                                    if let kycimg = AddCustomer.custKYCImg2 as? UIImage{
                                        KYCImage = kycimg
                                    }
                                }
                                if(KYCType.count > 0 && KYCType.lowercased() != "select kyc type"){
                                    if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)) {
                                        Utils.toastmsg(message:"Please enter KYC2 number",view: self.view)
                                        status =  false
                                    }
                                    else if (KYCImage.pngData()?.count ?? 0 > 0){
                                       

                                    }else{
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Add KYC 2 Image",view: self.view)
                                        }
                                    status =  false
                                    }
                                }
                                else if(KYCNumber.count > 0){
                                   if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                        Utils.toastmsg(message:"Please Select KYC2 Type",view: self.view)
                                        status =  false
                                    }else  if (KYCImage.pngData()?.count ?? 0 > 0){
                                      

                                    }else{
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Add KYC 2 Image",view: self.view)
                                        }
                                    status =  false
                                    }
                                }else if (KYCImage.pngData()?.count ?? 0 > 0){
                                    if(KYCType.count > 0 && KYCType.lowercased() == "select kyc type"){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Select KYC2 Type",view: self.view)
                                        }
                                        status =  false
                                    }else if(KYCNumber.count == 0 || KYCNumber.isBlank(KYCNumber)){
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please Select KYC2 Number",view: self.view)
                                        }
                                        status =  false
                                    }else{

                                    }
                                }
                            }
                            }
                            
                        }
                        if(status ==  false){
                            SVProgressHUD.dismiss()
                            completionstatus(status)
                        }else{
                            var status:Bool!
                            let group = DispatchGroup()
                            group.enter()
                            self.validationAsperTypeAndSegment{ (territorystatus) in
                               
                               status = territorystatus
                                group.leave()
                              
                            }
                            
                            
                            group.notify(queue: .main) {
                                if(status ==  false){
                                    SVProgressHUD.dismiss()
                                }
                            completionstatus(status)
                            }
                        }
                        
                     
                    }else{
                        var status:Bool!
                        let group = DispatchGroup()
                        group.enter()
                        self.validationAsperTypeAndSegment{ (territorystatus) in
                           
                           status = territorystatus
                            group.leave()
                          
                        }
                        
                        
                        group.notify(queue: .main) {
                            if(status ==  false){
                                SVProgressHUD.dismiss()
                            }
                        completionstatus(status)
                        }
                    }
                }
            
           
        }
    
    
    //MARK: - APICall
//    func getTaagedCustomer(pageno:Int,trimmedstring:String){
//      
//        var param = Common.returndefaultparameter()
//        param["Filter"] = trimmedstring
//        param["PageNo"] = pageno
//        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAllTaggedCustomer, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
//           
//            if(status.lowercased() == Constant.SucessResponseFromServer){
//                
//                let arrOfTaggedCustomer = arr as? [[String:Any]] ?? [[String:Any]]()
//                
//                
//                print("array of customer = \(arrOfTaggedCustomer.count) for page no  = \(pageno) , \(pagesavailable),\(totalpages)")
//            if(arrOfTaggedCustomer.count > 0){
//            MagicalRecord.save({ (localcontext) in
//                if(pageno == 1){
//            CustomerDetails.mr_truncateAll(in: localcontext)
//                }
//    
//                
//            
//            FEMDeserializer.collection(fromRepresentation: arrOfTaggedCustomer, mapping: CustomerDetails.defaultmapping(), context: localcontext)
//              
//                
//                           localcontext.mr_save({ (localcontext) in
//                               //print("saving")
//                           }, completion: { (status, error) in
//                               //print("saved")
//                           })
//                            
//                                
//
//                       }, completion: { (status, error) in
//                          
//                        if(error?.localizedDescription == ""){
//                            print("tagged customer saved sucessfully total customer = \(CustomerDetails.getAllCustomers().count)")
//                            
//                        }else{
//                            //print(error?.localizedDescription ?? "")
//                        }
//
//                        })
//           
//                if(pageno < totalpages){
//                    print("page is available for tagged customer api \(pagesavailable)")
//                    self.getTaagedCustomer(pageno: pageno + 1 ,trimmedstring: trimmedstring)
//                    
//                }else{
//                    SVProgressHUD.dismiss()
//                    self.arrOfCustomers = CustomerDetails.getAllCustomers()
//                   
//                        self.arrAllCustomer = self.arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
//                    
//                        self.filteredCustomer =
//                            self.arrAllCustomer.filter({(item: NSString) -> Bool in
//                            return item.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
//                        })
//                   
//                        self.arrOffilteredCustomer =
//                            self.arrOfCustomers.compactMap { (temp) -> CustomerDetails in
//                            return temp
//                            }.filter { (aUser) -> Bool in
//                                return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
//                    }
//                        
//                        self.customerDropdown.dataSource = self.filteredCustomer as [String]
//                        self.customerDropdown.reloadAllComponents()
//                        self.customerDropdown.show()
//                
//        }
//            }else{
//                SVProgressHUD.dismiss()
//                 Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String ?? "" ?? message, view: self.view)
//            }
//            }else{
//                SVProgressHUD.dismiss()
//                 Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String ?? "" ?? message, view: self.view)
//                
//            }
//    }
//    }
    
    // get beat data
    
    func loadBeatID(userId:NSNumber)->(){
      //  SVProgressHUD.show()
        let beatplandic = ["CompanyID":self.activeuser?.company?.iD,"UserID":userId]
        var param = Common.returndefaultparameter()
        param["getUploadBeatPlanDetailsJson"] = Common.json(from: beatplandic)
        self.apihelper.getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlGetUploadBeatPlanDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                print(arr)
                if(responseType == ResponseType.arr){
                  //  self.arrOfTableBeatPlan = [BeatPlanAssign]()
                    let   arrofbeat = arr as? [Any] ?? [Any]()
                    self.arrOfBeatPlan = [BeatPlan]()
                for beat in arrofbeat{
                    let dicBeat = beat as? [String : Any] ?? [String:Any]()
                    let instancebeatplan = BeatPlan.init(dicBeat)
                  
                    self.arrOfBeatPlan.append(instancebeatplan)
                }
                    
                    //rejected beat plan
                    let rejectedBeatPlan = self.arrOfBeatPlan.filter{
                        $0.StatusID != 3
                    }
                    
                    //pendinf beat plan
                    let pendingBeatPlan = self.arrOfBeatPlan.filter{
                        $0.StatusID != 1
                    }
                    
                    if(rejectedBeatPlan.count > 0){
                        // var temport = self.arrOfBeatPlan
                        if(self.arrOfBeatPlan.count > 0){
                            self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
                                $0.StatusID != 3
                            }
           
                        }
                       // self.arrOfBeatPlan = temport
                        }
                    
                    if(pendingBeatPlan.count > 0){
                        // var temport = self.arrOfBeatPlan
                        if(self.arrOfBeatPlan.count > 0){
                            self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
                                $0.StatusID != 1
                            }
           
                        }
                       // self.arrOfBeatPlan = temport
                        }
                    }
                    /*if(self.arrOfBeatPlan.count > 0){
                       
                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
                        let sd = self.dateFormatter.date(from: self.tfStartDate.text ?? "")
                        let ld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                        let strstartdate = self.dateFormatter.string(from: sd ?? Date())
                        let strenddate = self.dateFormatter.string(from: ld ?? Date())
                        let startDate = self.dateFormatter.date(from: strstartdate)
                        let endDate = self.dateFormatter.date(from: strenddate)
                        let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
                        var dic = [String:Any]()
                        let daycomponents = calender.dateComponents([.day], from: startDate ?? Date(), to: endDate ?? Date())
//                        if((self.beatForSelectedBeatPlan.count > 0) && (self.isBeatsFiltered == true)){
//                            dic["selectedBeatPlan"] = self.beatForSelectedBeatPlan.first
//                        }else if((self.isBeatsFiltered == false) &&  (self.arrOfBeatPlan.count > 0 )){
//                            dic["selectedBeatPlan"] = self.arrOfBeatPlan.first
//                        }else{
                           
                            var dicForSelectedBeatPlan = [String:Any]()
                            dicForSelectedBeatPlan["BeatPlanName"] = "Select Beat ID"
                            dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
                            dicForSelectedBeatPlan["selectedBeatPlan"] = dicForSelectedBeatPlan
                            dicForSelectedBeatPlan["CompanyID"] = self.activeuser?.company?.iD
                            dicForSelectedBeatPlan["AssigneeID"] = self.selectedUser.entity_id
                            dicForSelectedBeatPlan["ID"] = 0
                        dic["selectedBeatPlan"] =  BeatPlan.init(dicForSelectedBeatPlan)
                      //  }
                  //  if(self.activesetting.territoryMandatoryInBeatPlan ==  true  && self.arrTerriotaryFromAPI.count > 0){
                        if(self.arrTerriotaryFromAPI.count > 0){
                        dic["selectedTerritory"] =  self.arrTerriotaryFromAPI.first
                        }
                        dic["CreatedBy"] = self.activeuser?.userID
                        dic["AssigneeID"] = self.selectedUserID
                        dic["CompanyID"] = self.activeuser?.company?.iD
                        dic["isSelected"] =  false
//                        daycomponents
                        if(daycomponents.day ?? 0 > 0){
                            for day in 0...daycomponents.day! - 1{
                            var newcomponents = DateComponents()
                            newcomponents.day = day
                            let date = calender.date(byAdding: newcomponents, to: startDate!)
                            dic["BeatPlanDate"] =  self.dateFormatter.string(from: date!)
                                var beatplanassignobj =  BeatPlanAssign.init(dic)
                                self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
                                beatplanassignobj.BeatPlanDate =  self.dateFormatter.string(from: date!)
                                if(self.arrTerriotaryFromAPI.count > 0){
                                    dic["selectedTerritory"] = self.arrTerriotaryFromAPI.first
                                             }
                                self.arrOfTableBeatPlan.append(beatplanassignobj)
                                
                            //let obj =
                            }
                           
                           
                        }
                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
                        let lld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                        //"yyyy\/MM\/dd hh:mm:ss"
                        self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
                        dic["BeatPlanDate"] = self.dateFormatter.string(from:lld ?? Date())
                        let obj = BeatPlanAssign.init(dic)
                        if(self.arrTerriotaryFromAPI.count > 0){
                            dic["selectedTerritory"] = self.arrTerriotaryFromAPI.first
                        }
                        self.arrOfTableBeatPlan.append(obj)
                       
                       
                        if(self.arrOfBeatPlan.count > 0 ){
                          
                           // self.heightTblBeatPlan.constant = self.tableViewHeight
                            self.tblBeatPlan.translatesAutoresizingMaskIntoConstraints = false
                            self.tblBeatPlan.isScrollEnabled = false
                            
                        }else{
                            Utils.toastmsg(message:"You have not BeatIds",view: self.view)
                        }
                      //  print(self.heightTblBeatPlan.constant)
                        self.isBeatsFiltered  = false
                        
                        self.beatIDPicker.dataSource = self.arrOfBeatPlan.map{
                            String.init(format:"%@ | %@", $0.BeatPlanID , $0.BeatPlanName)
                        }
                        if(self.beatIDPicker.dataSource.count > 0){
                            self.selectedBeatID =  self.arrOfBeatPlan.first?.ID ?? 0
                        }else{
                            self.selectedBeatID = 0
                        }
                        self.tblBeatPlan.reloadData()
                    }else{
                        Utils.toastmsg(message:"You have not BeatIds",view: self.view)
                        self.tblBeatPlan.reloadData()
                    }*/
                    
                
            }else if(error.code == 0){
                SVProgressHUD.dismiss()
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
            Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
            }
        }
    }
    
    func callAPIForVerifyOTP(OTP:String)  {
        var param = Common.returndefaultparameter()
        param["UserID"] = self.activeuser?.userID
        param["CompanyID"] =  self.activeuser?.company?.iD
        param["CustomerMobileNo"] =  self.tfCustMobileNo.text
        param["Otp"] = OTP
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlVerifyCustomerMobileNo, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if(message.count == 0){
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    UIApplication.shared.keyWindow?.makeToast(message)
                    
                }
            }else{
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }
        }
    }
    func getAllContactDetail(custID:NSNumber)->(){
        var param = Common.returndefaultparameter()
        param["CustomerID"] = custID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlContactDetailOfUser, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                let arrOfContact = arr as? [[String:Any]] ?? [[String:Any]]()
              /*  FEMDeserializer.object(fromRepresentation: dicResponse ?? [String:Any](), mapping: Contact.defaultMapping(), context: localcontext)
                localcontext.mr_save { (localcontext) in
                    print("saving")
                } completion: { (status, error) in
                        print("saved")
                    print(error?.localizedDescription ?? "no error")
                    if let lastContact =  Contact.mr_findAll()?.last as? Contact{
                      
                        self.saveContDelegate?.saveContact(customerID: nsnumContactID, customerName: self.tfCutomerName.text  ?? "", contactName: String.init(format: "\(lastContact.firstName) \(lastContact.lastName)"), contactID: NSNumber.init(value:lastContact.iD))
                    }
  
                }*/
                print("\(arrOfContact.count) ")
                MagicalRecord.save { (localcontext) in
                FEMDeserializer.collection(fromRepresentation: arrOfContact, mapping: Contact.defaultMapping(), context: localcontext)
                localcontext.mr_save { (localcontext) in
                    print("saving")
                } completion: { (status, error) in
                        print("saved")
                    print(error?.localizedDescription ?? "no error")
                   
                 
  
                }
                }completion: { (status , error) in
                    print("\(arrOfContact.count) , \(Contact.getContactsUsingCustomerID(customerId: custID).count)")
                    NotificationCenter.default.post(name: Notification.Name("updateContactDetail"), object: nil)
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
            
        }
    }
    func callApiForTownSearch(townname:String){
        var param = Common.returndefaultparameter()
        param["filter"] = townname
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlSearchTown, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                let arrTownFromResponse = arr as? [[String:Any]] ?? [[String:Any]]()
                self.arrTown = [[String:Any]]()
                for town in arrTownFromResponse{
                    var dictown = town
                    print(town)
                    var strfulltown = ""
                    if let strtowncode = town["townCode"] as? String{
                        strfulltown.append(strtowncode)
                    }
                    if let strtownname = town["townName"] as? String{
                        strfulltown.append(String.init(format: ", \(strtownname)"))
                    }
                    if let strdistrictname =  town["districtName"] as? String{
                        if(strfulltown.count > 0){
                            strfulltown.append(String.init(format: ", \(strdistrictname)"))
                        }else{
                            strfulltown.append(strdistrictname)
                        }
                    }
                    if let strdistrictname =  town["stateName"] as? String{
                        if(strfulltown.count > 0){
                            strfulltown.append(String.init(format: ", \(strdistrictname)"))
                        }else{
                            strfulltown.append(strdistrictname)
                        }
                    }
                    dictown["townFullName"] = strfulltown
                    self.arrTown.append(dictown)
                }
                self.arrOftownName = self.arrTown.map{
                    $0["townFullName"] as! String
                }
                if(self.arrTown.count > 0){
                    self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                    self.popup?.modalPresentationStyle = .overCurrentContext
                    self.popup?.strTitle = ""
                    self.popup?.isFromSalesOrder =  false
                    self.popup?.nonmandatorydelegate = self
                    self.popup?.arrOfCustomerClass = self.arrOftownName
                    self.popup?.strLeftTitle = ""
                    self.popup?.strRightTitle = ""
                    self.popup?.tag =  1
                    self.popup?.selectionmode = SelectionMode.none
                    self.popup?.arrOfSelectedClass = self.arrOfSelectedTown
                    self.popup?.isSearchBarRequire = true
                    self.popup?.viewfor = ViewFor.customerClass
                    self.popup?.isFilterRequire = false
                                // popup?.showAnimate()
                    self.popup?.parentViewOfPopup =  self.view
                    Utils.addShadow(view: self.view)
                    self.present(self.popup!, animated: false, completion: nil)
                }else{
                    Utils.toastmsg(message:message,view: self.view)
                   //  Utils.toastmsg(message:message,view: self.view)
                }
                
            }else if(error.code == 0){
               
                         if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                     }else{
                
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                     }
              }
        
    }
    
    func uploadImage(img:UIImage,type:String){
        SVProgressHUD.show()
        var param = [String:Any]()// Common.returndefaultparameter()
        //param["CompanyID"] = customer // self.activeuser?.company?.iD
        if(isEditCustomer){
            if(isFromColdCallVisit){
                param["CompanyID"] = selectedCustomerForUnplan.TempCustomerID
            }else{
            param["CompanyID"] = selectedCustomer.iD
            }
        }
        param["UserID"] = self.activeuser?.userID?.stringValue
        param["TokenID"] = self.activeuser?.securityToken ?? "ds"
        param["Application"] = ConstantURL.APPLICATIONSUPERSALESPRO
        if(type == "VLogo"){
            param["Type"] = "VC"
        }else{
            if(self.isVendor){
            param["Type"] = "V"
                
            }else{
                param["Type"] = "U"
            }
        }
       // let imgage = UIImage.init(named: "tgthr.png")
            
        self.apihelper.addCustomerWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadImageEditCustomer , arrimg: [img], arrimgparamname:["File"] , param: param){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
       // self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadImage, img: img, imgparamname: "Image", param: param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
         //    Utils.toastmsg(message:message,view: self.view)
        }
    }
    
    func updateAssignee(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["TaggedTo"] = primaryUserID
        param["CustomerID"] = selectedCustomer.iD
        var taggedListDic = [[String:Any]]()
        
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
                }
            }else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
            }
        }
    }
    
    func saveCustomerVendor(){
        var strurl = ""
        
//                param["SegmentID"] = self.customerSegmentIndex
//                param["CustomerClass"] = self.customerClassIndex
            var param = Common.returndefaultparameter()
            var custDic = [String:Any]()
        if(isEditCustomer ){
            if(isFromColdCallVisit){
                strurl = ConstantURL.kWSUrlAddCustomerVendor
            }else{
            strurl = ConstantURL.kWSUrlUpdateCustomerVendor
            }
            if(isVendor){
                custDic["ID"] = selectedVendor.iD
            }else{
                if(!isFromColdCallVisit){
                custDic["ID"] = selectedCustomer.iD
                }
            }
            
        }else{
            strurl = ConstantURL.kWSUrlAddCustomerVendor
        }
            custDic["SegmentID"] = self.customerSegmentIndex
            custDic["CustomerClass"] = self.customerClassIndex
            custDic["Key_Customer"] = self.isKeyCustomer
            custDic["Name"] = self.tfCustName.text
            custDic["MobileNo"] = self.tfCustMobileNo.text
            custDic["LandlineNo"] = self.tfLandLineNo.text
            custDic["EmailID"] = self.tfEmailId.text
            custDic["OwnerID"] = self.activeuser?.userID
            custDic["CreatedBy"] = self.activeuser?.userID
            custDic["EmailTo"] = self.tfEmailOrderTo.text
            custDic["CompanyID"] = self.activeuser?.company?.iD
            if(self.isVendor){
            custDic["Type"] = "V"
            }else{
                custDic["Type"] = "U"
            }
            custDic["Description"] = self.tvDesc.text
        custDic["CustomerGSTNo"] = self.tfGSTValue.text
        custDic["TaggedToID"] = self.activeuser?.userID
        if(self.companytypeID == NSNumber.init(value: 4)){
        custDic["DistributorID"] = self.distributorId
        }else{
            custDic["DistributorID"] = self.stockId
        }
        //custDic["st"]
        if(self.activesetting.vatGst == 2){
            custDic["VATCode"] = vatCodeID
        }
            //custDic["VATCode"] =  1
            custDic["CustomerGSTNo"] = self.tfGSTValue.text
            custDic["CustomerCode"] = self.tfCustomerCode.text
            custDic["ContactLastName"] = self.tfContactLastName.text
            custDic["ContactName"] = self.tfContactFirstName.text
            custDic["ContactNo"] = self.tfContactMobile.text
            custDic["AnniversaryDate"] =  self.tfAnniversaryDate.text
//        if(tfCustType.text?.lowercased() == "corporate"){
//            custDic["CompanyTypeID"] = NSNumber.init(value:1)
//        }else if(tfCustType.text?.lowercased() == "end-user"){
//            custDic["CompanyTypeID"] = NSNumber.init(value:2)
//        }
//        else if(tfCustType.text?.lowercased() == "influencer"){
//            custDic["CompanyTypeID"] = NSNumber.init(value:3)
//        }
//        else if(tfCustType.text?.lowercased() == "retailer"){
//            custDic["CompanyTypeID"] = NSNumber.init(value:4)
//        }else if(tfCustType.text?.lowercased() == distributer"){{
//            custDic["CompanyTypeID"] = NSNumber.init(value:5)
//        }
        custDic["CompanyTypeID"] = self.companytypeID
            custDic["SegmentID"] = self.customerSegmentIndex
            custDic["CustomerClass"] = self.customerClassIndex
            custDic["OwnerID"] = self.activeuser?.userID
            custDic["VisitFrequency"] = 0
            custDic["Tax_Type"] = taxType//"CST"
            custDic["PrimaryUserID"] = primaryUserID//self.activeuser?.userID
            custDic["ContactName"] = self.tfContactFirstName.text
            custDic["ContactNo"] = self.tfContactMobile.text
            custDic["BirthDate"] = self.tfBirthDate.text
            custDic["BeatplanID"] =  selectedBeatplanID
        if(self.activesetting.territoryInCustomer == 1){
            custDic["territoryID"] = selectedTerritory["territoryId"]//NSNumber.init(value:0)
            custDic["territoryCode"] = selectedTerritory["territoryName"]//"Select Territory"
        }
        if(isVendor == false){
            if(self.activesetting.requireTownInCustomer?.intValue == 1){
                custDic["TownID"] = townID//NSNumber.init(value:0)
                custDic["TownName"] = tfTown.text
                //"Select Territory"[customerdict setObject:@(townID) forKey:@"TownID"];
               // [customerdict setObject:[txtTownSearch.text escapeUnicodeString] forKey:@"TownName"];
            }
        }
            if(self.isEditCustomer){
                if(isFromColdCallVisit){
                    param["CustVendorDetails"] = Common.json(from: custDic)
                }else{
                param["CustomerDetails"] = Common.json(from: custDic)
                }
            }else{
                param["CustVendorDetails"] = Common.json(from: custDic)
                
            }
            var taggedListDic = [[String:Any]]()
        
        for assid in arrOfAssignee{
            taggedListDic.append(["TaggedUserID":assid])
        }
        
     
        var arrAllAddress = [[String:Any]]()
        print("lat = \(self.strLat), long = \(self.strLong) ,and address id = \(permenentAddressID) ")
        arrAllAddress.append(["AddressLine1":tfAddressLine1.text,"AddressLine2":tfAddressLine2.text,"City":tfCity.text,"State":tfState.text,"Pincode":tfPincode.text,"Type":NSNumber.init(value: 1),"Country":self.tfCountry.text,"Longitude":self.strLong,"Lattitude":self.strLat,"AddressID":permenentAddressID
                             ])//,"AddressID":permenentAddressID
 //       arrAllAddress.append(arrAddress1)
//        for add in arrAddress1
//        {
//            arrAllAddress.append(["AddressLine1":add.addressLine1,"AddressLine2":add.addressLine2,"City":add.city,"State":add.state,"Pincode":add.pincode,"Type":add.type,"Country":add.country,"Longitude":add.lattitude,"Lattitude":add.longitude])
//        }
        for add in arrAddress{
           
            print("lat = \(add.lattitude), long = \(add.longitude),and address id = \(add.addressId) , type of add = \(add.type) ")
            arrAllAddress.append(["AddressLine1":add.addressLine1,"AddressLine2":add.addressLine2,"City":add.city,"State":add.state,"Pincode":add.pincode,"Type":add.type,"Country":add.country,"Longitude":add.longitude,"Lattitude":add.lattitude,"AddressID":add.addressId])//,"AddressID":add.addressId
        }
        print("array of address = \(arrAllAddress) ")
        param["AddressDetails"] = Common.json(from: arrAllAddress) //Common.json(from:[self.custAddDic])
            param["UserID"] = self.activeuser?.userID
            param["TaggedUsersList"] = Common.json(from: taggedListDic)
        param["TaggedTo"] = primaryUserID
        //self.arrKYCDetails = [[String:Any]]()
       
        var dicKYC = [String:Any]()
        if(self.arrKYCDetails.count > 0){
            for i in 0...self.arrKYCDetails.count - 1{
                let selectedkyc = self.arrKYCDetails[i]
                if(i == 0){
                    dicKYC["Kyc1Type"] = selectedkyc["KycType"]
                    dicKYC["Kyc1Number"] = selectedkyc["KycNumber"]
                    
                }else if(i == 1){
                    dicKYC["Kyc2Type"] = selectedkyc["Kyc1Type"]
                    dicKYC["Kyc2Number"] = selectedkyc["Kyc1Number"]
                }else{
                    dicKYC["Kyc3Type"] = selectedkyc["Kyc2Type"]
                    dicKYC["Kyc3Number"] = selectedkyc["Kyc2Number"]
                }
//                if  let indexpath = tblKYC.indexPath(for: cell){
//                    if(indexpath.row == 0){
//
//                        dicKYC["Kyc1Type"] = kyccell.tfKYCType.text
//                        dicKYC["KYC1Number"] = kyccell.tfKYCNumber.text
//
//                                    }else if(indexpath.row  == 1){
//                                        dicKYC["Kyc2Type"] = kyccell.tfKYCType.text
//                                        dicKYC["KYC2Number"] =  kyccell.tfKYCNumber.text
//                                    }else{
//                                        dicKYC["Kyc3Type"] = kyccell.tfKYCType.text
//                                        dicKYC["KYC3Number"] =  kyccell.tfKYCNumber.text
//                                    }
//
//
//
//
//            }
            }
        }
        param["kycDetails"] = Common.json(from: dicKYC)
        var arrParamName = [String]()
        var arrImage = [UIImage]()
        if let logoimage = custImgLogo as? UIImage{
            arrParamName.append("File")
            arrImage.append(logoimage)
        }
        if let visitcImage = custVCard as? UIImage{
            arrParamName.append("VisitingCard")
            arrImage.append(visitcImage)
        }
        
        if let extimg = custExtraImg1 as? UIImage{
            
            arrParamName.append("CustomerImage")
            arrImage.append(extimg)
        }
        
        if let extimg1 = custExtraImg2 as? UIImage{
            
            arrParamName.append("CustomerImage1")
            arrImage.append(extimg1)
        }
        
        if let extimg2 = custExtraImg3 as? UIImage{
            
            arrParamName.append("CustomerImage2")
            arrImage.append(extimg2)
        }
        
        
        if let custkycimg = AddCustomer.custKYCImg as? UIImage{
            
            arrParamName.append("kyc1")
            arrImage.append(custkycimg)
        }
        if let custkycimg = AddCustomer.custKYCImg1 as? UIImage{
            
            arrParamName.append("kyc2")
            arrImage.append(custkycimg)
        }
        if let custkycimg = AddCustomer.custKYCImg2 as? UIImage{
            
            arrParamName.append("kyc3")
            arrImage.append(custkycimg)
        }
        
        print("url is = \(strurl) ,parameter for add customer \(param) , name of imagaes array = \(arrParamName) , arr of images = \(arrImage)")
        
        self.apihelper.addCustomerWithMultipartBody(fullUrl: strurl, arrimg: arrImage, arrimgparamname: arrParamName, param: param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        
            SVProgressHUD.dismiss()
        
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            
            let dicResponse = arr as? [String:Any] ?? [String:Any]()
            print("response of add / edit customer  = \(dicResponse)")
            let customerID = dicResponse["ID"] as? Int
            let type = dicResponse["Type"] as? String
            var nsnumCustomerID = NSNumber.init(value: customerID ?? 0)
            var nsnumContactID = NSNumber.init(value:  0)
            if(status.lowercased() == Constant.SucessResponseFromServer){
                AddCustomer.custKYCImg = UIImage()
                AddCustomer.custKYCImg1 = UIImage()
                AddCustomer.custKYCImg2 = UIImage()
                
                /**
                 MagicalRecord.save({ (localContext) in
                 let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                     print(arrvisit)

                 }, completion: { (contextdidsave, error) in
                 AddressID = 1776736;
                 AddressLine1 = "Unnamed Road";
                 AddressLine2 = Shiholi;
                 City = Gandhinagar;
                 Country = India;
                 CustVenID = 1668273;
                 LastModifiedBy = 8832;
                 Lattitude = "23.24380878120009";
                 Longitude = "72.72901710122824";
                 Pincode = 382355;
                 State = Gujarat;
                 Type = 1;
                 Verified = 1;*/
                let arrOfAdd = dicResponse["AddressList"] as? [[String:Any]] ?? [[String:Any]]()
                let dicOfAdd = arrOfAdd.first as? [String:Any] ?? [String:Any]()
                if((type == "U") && (nsnumCustomerID.intValue > 0)){
                MagicalRecord.save { (localcontext) in
               // FEMDeserializer.object(fromRepresentation: dicResponse , mapping:CustomerDetails.defaultmapping())
                    FEMDeserializer.object(fromRepresentation: dicResponse, mapping: CustomerDetails.defaultmapping(), context: localcontext)
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
        if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                                                print(lastContact.name)
                                                print(lastContact.iD)
            self.getAllContactDetail(custID: NSNumber.init(value:lastContact.iD))
            
                                            }
                                        }

                                    } completion: { (status , error) in
                                   let strAdd =      AddressList().getAddressStringByAddressId(aId:NSNumber.init(value:dicOfAdd["AddressID"] as? Int ?? 0))
                                    //    print("string address = \(strAdd) ,  dic of address = \(dicOfAdd)")
                                        let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                                        if(arrOFContact.count > 0){
                                            nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                                        }
                                        self.saveCustDelegate?.saveCustomer(customerID: nsnumCustomerID, customerName: self.tfCustName.text ?? "", contactID:nsnumContactID )
                                        if(self.isFromColdCallVisit && self.tempCustomer?.customerProfile?.orderExpectedDate?.count ?? 0 > 0){
                                            var dicparam = Common.returndefaultparameter()
                                            var visitdic = [String:Any]()
                                            visitdic["CompanyID"] = self.activeuser?.company?.iD
                                            visitdic["CustomerID"] = dicResponse["ID"]
                                            visitdic["CreatedBy"] = self.activeuser?.userID
                                            visitdic["ContactID"] = NSNumber.init(value: 0)
                                            visitdic["VisitTypeID"] = NSNumber.init(value: 1)
                                            visitdic["SeriesPrefix"] = ""
                                            visitdic["Conclusion"] = ""
                                            let arrAddress = dicResponse["AddressList"] as? [[String:Any]]
                                            visitdic["AddressMasterID"] = arrAddress?.first?["AddressID"]
                                            visitdic["NextActionID"] = NSNumber.init(value: 6)
                                            visitdic["OriginalAssignee"] = self.primaryUserID
                                            let strDate = self.tempCustomer?.customerProfile?.orderExpectedDate
                                            let calender = Calendar.current
                                            var dayComponent = DateComponents.init()
                                            dayComponent.timeZone = NSTimeZone.init(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
                                            let dtf = DateFormatter.init()
                                            dtf.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                            let d = dtf.date(from: strDate ?? "")
                                            let nextdate = calender.date(byAdding: dayComponent, to: d ?? Date())
                                            let date = calender.date(bySettingHour: 10, minute: 00, second: 00, of: nextdate ?? Date())
                                            
                                            visitdic["NextActionTime"] = Utils.getDateUTCWithAppendingDay(day: 0, date: date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)//Utils.getDateWithAppendingDay(day: 0, date: date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
                                            dicparam["addUpdateVisitJson"] =  Common.returnjsonstring(dic: visitdic)
                                           // dicparam["addUpdateVisitProductJson"] = Common.json(from: [[String:Any]]())
                                            dicparam["addUpdateVisitProductJson"] = "[\n\n]"
//                                            if let arr = arrSelectedProduct as? NSMutableArray {
//
//                                            if(arr.count > 0){
//                                                dicparam["addUpdateVisitProductJson"] = Common.json(from: arr)
//
//                                            }else{
//                                                dicparam["addUpdateVisitProductJson"] = "[\n\n]"
//                                            }
//                                            }
                                          print("parameter of Add visit while adding visit = \(dicparam)")
                                            self.apihelper.getdeletejoinvisit(param: dicparam, strurl: ConstantURL.kWSUrlAddEditPlannedVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                SVProgressHUD.dismiss()
                                                if(status.lowercased() == Constant.SucessResponseFromServer){
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                    if(self.navigationController?.viewControllers.count ?? 0 > 0){
                                                                                    
                                                                                    if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is VisitCustomerProfile }){
                                        if let controller = self.navigationController?.viewControllers[controllerIndex - 2]{
                                            if(controller is Leadselection){
                                                if let controller = self.navigationController?.viewControllers[controllerIndex - 3]{
                                                    self.navigationController?.popToViewController(controller,animated:true)
                                                }else{
                                                    self.navigationController?.popViewController(animated:true)
                                                }
                                            }else{
                                            self.navigationController?.popToViewController(controller,animated:true)
                                            }
                                                                                        }
                                                                                    }else{
                                                                            self.navigationController?.popViewController(animated:true)
                                                                                    }
                                                                            }
                                                    }
                                                }else if(error.code == 0){
                                                    
                                                }else{
                                                    
                                                }
                                            }
                                        }
                                      
                                      
              
            if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                if(arrOFContact.count > 0){
                    nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                }
                self.saveCustDelegate?.saveCustomer(customerID: nsnumCustomerID, customerName: self.tfCustName.text ?? "", contactID: nsnumContactID)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if(self.navigationController?.viewControllers.count ?? 0 > 0){
                                            
                                            if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is VisitCustomerProfile }){
                                                if let controller = self.navigationController?.viewControllers[controllerIndex - 2]{
                                                    if(controller is Leadselection){
                                                        if let controller = self.navigationController?.viewControllers[controllerIndex - 3]{
                                                            self.navigationController?.popToViewController(controller,animated:true)
                                                        }else{
                                                            self.navigationController?.popViewController(animated:true)
                                                        }
                                                    }else{
                                                    self.navigationController?.popToViewController(controller,animated:true)
                                                    }
                                                }
                                            }else{
                                    self.navigationController?.popViewController(animated:true)
                                            }
                                    }
            }
                                        }
                                    }
                }
                else if((type == "V") && (nsnumCustomerID.intValue > 0)){
                    MagicalRecord.save { (localcontext) in
                   // FEMDeserializer.object(fromRepresentation: dicResponse , mapping:CustomerDetails.defaultmapping())
                        FEMDeserializer.object(fromRepresentation: dicResponse, mapping: Vendor.defaultmapping(), context: localcontext)
                        FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                        localcontext.mr_saveToPersistentStore { (status, error
                                            ) in
                                                print(error?.localizedDescription ?? "gbdfgdfgb")
                                                print("after saving persistant")
                                                if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                                                   
                                                    self.getAllContactDetail(custID: NSNumber.init(value:lastContact.iD))
                                                    let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                                                    if(arrOFContact.count > 0){
                                                        nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                                                    }
                                                    self.saveCustDelegate?.saveCustomer(customerID: nsnumCustomerID, customerName: self.tfCustName.text ?? "", contactID: nsnumContactID)
                                                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            }

                    } completion: { (status , error) in
                        
                    }
                }else{
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                }
               // self.navigationController?.popViewController(animated: true)
            }else{
                Utils.toastmsg(message:error.localizedDescription,view: self.view)
            }
        }
      }
    
     //MARK: - IBAction
     
    
    @IBAction func btnUpdateCustomerPotentialClicked(_ sender: UIButton) {
        if let customerpotential = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.UpdateCustomerPotential) as? UpdateCustomerPotential{
            customerpotential.selectedCustomer = self.selectedCustomer
            self.navigationController?.pushViewController(customerpotential, animated: true)
        }
    }
    
    @IBAction func btnSGSTTaxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(!sender.isSelected){
            btnIGST.isSelected = true
            btnSGST.isSelected = false
            taxType = "CST"
        }else{
            btnSGST.isSelected = true
            btnIGST.isSelected = false
            taxType = "VAT"
        }
    }
    
    
    @IBAction func btnIGSTClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(!sender.isSelected){
            btnIGST.isSelected = false
            btnSGST.isSelected = true
            taxType = "VAT"
        }else{
            btnIGST.isSelected = true
            btnSGST.isSelected = false
            taxType = "CST"
        }
        
    }
    
    
    @IBAction func btnSearchTownClicked(_ sender: UIButton) {
        tfTown.resignFirstResponder()
        if let strTown = tfTown.text as? String{
        if((strTown.count ?? 0 < 3) || (strTown.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0 < 2)){
        //    Utils.toastmsg(message:"Minimun 3 character require to search for town")
            Utils.toastmsg(message:"Minimun 3 character require to search for town", view: self.view)
        }else{
            if(strTown.contains(",")){
                self.callApiForTownSearch(townname: strTown.components(separatedBy: ",").first ?? "")
            }else{
                self.callApiForTownSearch(townname: strTown.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        }
        }
    }
    
    
    
    @IBAction func btnAddAddressClicked(_ sender: UIButton) {
        let currentaddress = AddressListModel()
        self.getAddressFromCurrentLocation { (address,error) in
            if(error.code == 0 && address.keys.count > 0){
         //       print(address)
                currentaddress.type = "2"
            
                currentaddress.addressLine1 = address["address1"] as? String ?? ""
                currentaddress.addressLine2 = address["address2"] as? String ?? ""
                currentaddress.city = address["city"] as? String ?? ""
                currentaddress.state = address["state"] as? String ?? ""
                currentaddress.country = address["country"] as? String ?? ""
                currentaddress.pincode = NSNumber.init(value: Int64(address["postalcode"] as? String ?? "0") ?? Int64(truncating: NSNumber.init(value: 0)))
                let nsnumberlat = NSNumber.init(value: address["latitude"] as? Double ?? 0.0)
                let nsnumberlong = NSNumber.init(value: address["longitude"] as? Double ?? 0.0 )
                currentaddress.lattitude = nsnumberlat.stringValue//String.init(format:address["Lattitude"] as? String ?? "0")
                currentaddress.longitude =  nsnumberlong.stringValue//String.init(format:address["Longitude"]  as? String ?? "0")
               // currentaddress.pincode = address["postalcode"] as? NSNumber ?? NSNumber.init(value: 0)
                print(currentaddress.lattitude)
                self.arrAddress.append(currentaddress)
        
                DispatchQueue.main.async {
                    self.tblTempAdd.layoutIfNeeded()
                    self.tblTempAdd.reloadData()
                    self.tblTempAddHeight.constant = self.tblTempAdd.contentSize.height
                }
            }
        }
        
    }
    
    
    
    @IBAction func btnSelectAssignClicked(_ sender: UIButton) {
        

      
        if(BaseViewController.staticlowerUser.count > 0){
            
            isForPrimaryAssignee = false
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.parentViewOfPopup = self.view
            self.popup?.strTitle = "Select Sales Person"
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfExecutive = BaseViewController.staticlowerUser//self.arrOfExecutive
            self.popup?.arrOfSelectedExecutive = arrOfSelectedExecutive//[String]()
            self.popup?.strLeftTitle = "Ok"
            self.popup?.strRightTitle = "Cancel"
            self.popup?.selectionmode = SelectionMode.multiple
           
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.viewForTageCustomer
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
           
           
            Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
        }else{
            Utils.toastmsg(message:"No user to assign",view: self.view)
        }
    }
    
    @IBAction func btnKeyCustomerClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isKeyCustomer = sender.isSelected
    }
    @IBAction func btnChangeLogoClicked(_ sender: UIButton) {
        isImageLogo = true
        self.openGallery()
    }
    
    @IBAction func btnVisitReminderClicked(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            tfVisitReminder.isHidden = false
            lblInDaysTitle.isHidden = false
        }else{
            tfVisitReminder.isHidden =  true
            lblInDaysTitle.isHidden = true
        }
    }
    
    @IBAction func btnUploadVcardClicked(_ sender: UIButton) {
        isVCard = true
        self.cameraTapped()
    }

    @IBAction func btnMapClicked(_ sender: UIButton) {
        
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            Common.skipVisitSelection = false
            map.isFromDashboard = false
            if let permenentLocation1 = permenentLocation as? CLLocation{
              
            map.lattitude = NSNumber.init(value: permenentLocation1.coordinate.latitude)
            map.longitude = NSNumber.init(value: permenentLocation1.coordinate.longitude)
            }else{
                if let location = Location.sharedInsatnce.currentLocation{
                map.lattitude = NSNumber.init(value: Location.sharedInsatnce.currentLocation.coordinate.latitude ?? 0)
                map.longitude = NSNumber.init(value: Location.sharedInsatnce.currentLocation.coordinate.longitude ?? 0)
                }else{
                    map.lattitude = NSNumber.init(value: 0)
                    map.longitude = NSNumber.init(value: 0)
                }
            }
            map.delegate = self
            map.isFromCustomer = true
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()

        self.checkValidation { (statusofvalidation) in
            print("status is = \(statusofvalidation)")
            SVProgressHUD.dismiss()
            if(statusofvalidation == true){
                SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
           // if let address =  AddressList.g
            
            
                if(self.activesetting.customerOTPVerification ==  true && self.isEditCustomer == false && self.isVendor == false){
                var param = Common.returndefaultparameter()
                    param["CustomerMobileNo"] = self.tfCustMobileNo.text
                
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGenerateCustomerOTP , method: Apicallmethod.post)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
               
                let AlertForGetOTP = UIAlertController.init(title: "OTP Verification", message: "" , preferredStyle: UIAlertController.Style.alert)
                        //  let text = UITextField.init()
                        // text.placeholder = "AddOTP"
                        
                        AlertForGetOTP.addTextField { (textField : UITextField!) -> Void in
                            textField.setCommonFeature()
                            textField.placeholder = "Please enter OTP"
                        }
                        
        let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (action) in
       // self.navigationController?.popViewController(animated: true)
                        })
                        
let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
if((AlertForGetOTP.textFields!.first?.text?.isEmpty)!){
        Utils.toastmsg(message:"Please Enter OTP",view: self.view)
}else if(AlertForGetOTP.textFields!.first?.text?.count ?? 0 < 6 || AlertForGetOTP.textFields!.first?.text?.count ?? 0 > 6){
    Utils.toastmsg(message:"Please enter valid OTP",view: self.view)
}
else{
   self.callAPIForVerifyOTP(OTP: (AlertForGetOTP.textFields!.first?.text)!)
     }
   })
                AlertForGetOTP.addAction(okAction)
                AlertForGetOTP.addAction(cancelAction)
    self.present(AlertForGetOTP, animated: true, completion: nil)
                    }
                }
         }else{
            
            self.saveCustomerVendor()
        }
            }else{
                print("status is = \(statusofvalidation)")
                SVProgressHUD.dismiss()
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
        
    

extension AddCustomer:AddCustomerDelegate{
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        
    }
    
    func saveCustomer(customerID: NSNumber, customerName: String) {
        
    }
    
    func updateAddressType(address:AddressListModel,Record:Int){
        arrAddress.remove(at: Record)
        print("address type = \(address.type)")
        arrAddress.insert(address, at: Record)
    }
}

extension AddCustomer:GoogleMapDelegate{
    func updateAddress(dic: [String : Any]) {
        self.fillupdatedatainUI(dic: dic)
    }
    func updateAddress(dic:[String:Any],TempaddNo:NSNumber){
        var typeOfAdd = "1"
        if(TempaddNo.intValue == -10){
            self.fillupdatedatainUI(dic: dic)
        }else{
        if(arrAddress.count  > 0){
            if   let addressatSelectedRecord = arrAddress[TempaddNo.intValue] as? AddressListModel{
            typeOfAdd = addressatSelectedRecord.type
            }
        arrAddress.remove(at: TempaddNo.intValue)
        }
            let doublelat = dic["latitude"] as? Double ?? 00000
            let nsnumberlng = NSNumber.init(value: dic["longitude"] as? Double ?? 0000)
            let nsnumberlat  = NSNumber.init(value: doublelat)
            let dicaddress = ["AddressID":dic["AddressID"],"AddressLine1":dic["address1"],"AddressLine2":dic["address2"],"City":dic["city"],"Country":dic["country"],"Pincode":NSNumber.init(value:Int(dic["postalcode"] as? String ?? "0") ?? 0),"State":dic["state"],"Lattitude":nsnumberlat.stringValue,"Longitude":nsnumberlng.stringValue,"Type":typeOfAdd]
        arrAddress.insert(AddressListModel().getaddressListModelWithDic(dict: dicaddress as [String : Any]), at: TempaddNo.intValue)
        tblTempAdd.reloadData()
        tblTempAddHeight.constant = tblTempAdd.contentSize.height
        }
    }
}
    
extension AddCustomer:BaseViewControllerDelegate{
    
    func editiconTapped(sender:UIBarButtonItem) {
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared
        
        ftconfig.backgoundTintColor =  UIColor.white
        var arrOfTitle = [String]()
        if(!isVendor){
            arrOfTitle.append("Tag Customer")
        }
        if let isfromCustomerList = isFromContactList as? Bool{
            if(isfromCustomerList){
                arrOfTitle.append("View Contact")
            }
        }
        if(self.activesetting.exportCustomerEnableDisable == NSNumber.init(value: 1)){
            arrOfTitle.append("Export Customer")
        }
        
        
        FTPopOverMenu.showForSender(sender: sender.plainView
                                    , with: arrOfTitle , popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { [self] (index) in
            
            let selectedAction = arrOfTitle[index]
            
            if(selectedAction == "Tag Customer"){
                print("selectedAction is  = \(selectedAction) in tag customer , \(arrOfTitle),\(index)")
                //tag Customer
                if(self.isVendor){
                    if let contactlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.ContactList) as? ContactList{
                        contactlist.selectedCustomerID =  NSNumber.init(value:self.selectedVendor.iD)
                        self.navigationController?.pushViewController(contactlist, animated: true)
                    }
                }else{
                    if(BaseViewController.staticlowerUser.count > 0){
                        
                        self.isForPrimaryAssignee = false
                        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                        self.popup?.modalPresentationStyle = .overCurrentContext
                        self.popup?.parentViewOfPopup = self.view
                        self.popup?.strTitle = "Select Sales Person"
                        self.popup?.isFromSalesOrder =  false
                        self.popup?.nonmandatorydelegate = self
                        self.popup?.arrOfExecutive = BaseViewController.staticlowerUser//self.arrOfExecutive
                        self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive//[String]()
                        self.popup?.strLeftTitle = "OK"
                        self.popup?.strRightTitle = "CANCEL"
                        self.popup?.selectionmode = SelectionMode.multiple
                        //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                        self.popup?.isSearchBarRequire = false
                        self.popup?.viewfor = ViewFor.companyuser
                        self.popup?.isFilterRequire = false
                        // popup?.showAnimate()
                        
                        
                        Utils.addShadow(view: self.view)
                        self.present(self.popup!, animated: false, completion: nil)
                    }else{
                        Utils.toastmsg(message:"No user to assign",view: self.view)
                    }
                }
            }else if(selectedAction == "View Contact"){
                print("selectedAction is  = \(selectedAction) in view contact")
                if let contactlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.ContactList) as? ContactList{
                    contactlist.selectedCustomerID =  NSNumber.init(value:self.selectedCustomer.iD)
                    contactlist.isVendor = self.isVendor
                    self.navigationController?.pushViewController(contactlist, animated: true)
                }
            }else{
                print("selectedAction is  = \(selectedAction) in export customer")
                self.ExportCustomer()
            }
            //        switch selectedAction{
            //        case "Tag Customer":
            //            //tag Customer
            //            if(self.isVendor){
            //                if let contactlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.ContactList) as? ContactList{
            //                    contactlist.selectedCustomerID =  NSNumber.init(value:self.selectedVendor.iD)
            //                    self.navigationController?.pushViewController(contactlist, animated: true)
            //                }
            //            }else{
            //            if(BaseViewController.staticlowerUser.count > 0){
            //
            //                self.isForPrimaryAssignee = false
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.parentViewOfPopup = self.view
            //                self.popup?.strTitle = "Select Sales Person"
            //                self.popup?.isFromSalesOrder =  false
            //                self.popup?.nonmandatorydelegate = self
            //                self.popup?.arrOfExecutive = BaseViewController.staticlowerUser//self.arrOfExecutive
            //                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive//[String]()
            //                self.popup?.strLeftTitle = "OK"
            //                self.popup?.strRightTitle = "CANCEL"
            //                self.popup?.selectionmode = SelectionMode.multiple
            //                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = false
            //                self.popup?.viewfor = ViewFor.companyuser
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //
            //
            //                Utils.addShadow(view: self.view)
            //                self.present(self.popup!, animated: false, completion: nil)
            //            }else{
            //                Utils.toastmsg(message:"No user to assign",view: self.view)
            //            }
            //            }
            //            break
            //        case 1:
            //            //View Contact
            //            if let contactlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.ContactList) as? ContactList{
            //                contactlist.selectedCustomerID =  NSNumber.init(value:self.selectedCustomer.iD)
            //                contactlist.isVendor = self.isVendor
            //                self.navigationController?.pushViewController(contactlist, animated: true)
            //            }
            //            break
            //
            //
            //        case 2:
            //            //Export Customer
            //            self.ExportCustomer()
            ////            }
            //            break
            //        default:
            //            print("nothing")
            //        }
        }, cancel: {
            print("cancel tapped")
        })
    }
        
   
    func ExportCustomer(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if(self.isVendor == false){
        param["ID"] = NSNumber.init(value: selectedCustomer.iD)
        }else{
            param["ID"] = NSNumber.init(value: selectedVendor.iD)
        }
        param["ApplicationID"] = NSNumber.init(value: 2)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlExportCustomerVendor, method: Apicallmethod.post)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
         
        SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                self.view.makeToast(message)
            }else{
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    func cameraTapped(){
      
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
           Utils.toastmsg(message:"Camera is not present",view: self.view)
        }
    }
    
    func openGallery(){
        let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
        //if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
//        }
//        else{
//           Utils.toastmsg(message:"Camera is not present")
//        }
    }
}

extension AddCustomer :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
            , completion:   nil)
        if(isImageLogo){
            isImageLogo = false
        }
        if(isVCard){
            isVCard = false
        }
        if(isCustomerImage1){
            isCustomerImage1 = false
        }
        if(isCustomerImage2){
            isCustomerImage2 = false
        }
        if(isCustomerImage3){
            isCustomerImage3 = false
        }
        if(isCustomerKYCImage){
            isCustomerKYCImage = false
        }
        if(isCustomerKYCImage1){
            isCustomerKYCImage1 = false
        }
        if(isCustomerKYCImage2){
            isCustomerKYCImage2 = false
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       // SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    
       if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       {
        if(isImageLogo){
            imgLogo.image = chosenImage
            custImgLogo = chosenImage
            if(isEditCustomer){
            self.uploadImage(img: custImgLogo,type:"Logo")
            }
          //  imgLogo.cornerRadius = Double(imgLogo.frame.size.height/2)
        }
        if(isVCard){
           imgVCard.image = chosenImage
            custVCard =  chosenImage
            if(isEditCustomer){
            self.uploadImage(img: custVCard,type:"VLogo")
            }
          //  imgLogo.cornerRadius = Double(imgLogo.frame.size.height/2)
        }
        if(isCustomerImage1){
            custExImg1.image  = chosenImage
            custExtraImg1 = chosenImage
        }
        if(isCustomerImage2){
            custExImg2.image  = chosenImage
            custExtraImg2 = chosenImage
        }
        if(isCustomerImage3){
            custExImg3.image  = chosenImage
            custExtraImg3 = chosenImage
        }
        if(isCustomerKYCImage){
            AddCustomer.custKYCImg = chosenImage
            
        }
        if(isCustomerKYCImage1){
            AddCustomer.custKYCImg1 = chosenImage
            
        }
        if(isCustomerKYCImage2){
            AddCustomer.custKYCImg2 = chosenImage
          
        }
        isImageLogo = false
        isVCard = false
        isCustomerImage1 = false
        isCustomerImage2 = false
        isCustomerImage3 = false
        isCustomerKYCImage = false
        isCustomerKYCImage1 = false
        isCustomerKYCImage2 = false
        tblKYC.reloadData()
//        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadVisitImage, img: chosenImage, imgparamname: "img", param: [String:Any]()) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
//            print("fdsgsdfsgd")
//        }
        }
        // self.imgUploadByUser.contentMode = .scaleAspectFit
        
        
        //        self.imgUploadByUser.image = Common.createImage(withImage: chosenImage, forSize: CGSize.init(width: chosenImage.size.width > 200 ? 200 : chosenImage.size.width , height: chosenImage.size.height > 200 ? 200 :  chosenImage.size.height))
        //        self.UploadRequest()
        
        dismiss(animated:true, completion: nil)
        SVProgressHUD.dismiss()
    }
}

extension AddCustomer:locationUpdater{
    func updatecurrentlocation(location: CLLocation,distance:CLLocationDistance){
        if(isEditCustomer == true){
            
        }else{
            if(firsttime ==  false){
                firsttime = true
            
          //  if (locations.count > 0){
      /*      let lastlocation = location
            let coordinate = lastlocation.coordinate
            
            LMGeocoder.sharedInstance().cancelGeocode()
            LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceApple, alternativeService: LMGeocoderServiceApple) { (results, error) in
    if((results?.count ?? 0 > 0) && (error == nil) ){
                    let address =  results?.first
                    
    if(address?.formattedAddress?.count ?? 0 > 0){
       
        print("formated  address = \(address?.formattedAddress ?? "address") ")
      
        
        var address1 = [String:Any]()
        var stradd1 = ""
        if let  strno = address?.streetNumber{
            stradd1.append(strno)
        }
        if let  subadm = address?.subAdministrativeArea{
            stradd1.append(subadm)
        }
        if let adm = address?.administrativeArea{
            stradd1.append(adm)
        }
        if let neighbour = address?.neighborhood{
            stradd1.append(neighbour)
        }
        
        address1["address1"] =  stradd1
        address1["address2"] = address?.subLocality
        address1["city"] = address?.locality
        address1["state"] = address?.administrativeArea
        address1["country"] = address?.country
        address1["postalcode"] = address?.postalCode
//        self.custAddDic = [String:Any]()
//        self.custAddDic["Longitude"] = address?.coordinate.longitude
//        self.custAddDic["Lattitude"] = address?.coordinate.latitude
        self.strLat = address?.coordinate.latitude ?? 0.0000
        self.strLong = address?.coordinate.longitude ?? 0.0000
        address1["latitude"] = self.strLat
        address1["longitude"] = self.strLong
        print("lat = \(self.strLat ?? 0.0000) , Long = \(self.strLong ?? 0.0000)")
        self.fillupdatedatainUI(dic: address1)
   // self.lblAddress.text =  address?.formattedAddress
    }
            }else{*/
//        self.lblAddress.text = "-"
//        if let lastLocation = locations.last as? CLLocation{
//         let  address = self.getAddressFromLocation(location:lastLocation)
//        var strAddress =  ""
//            if let strad1 = address["address1"] as? String{
//                if(strad1.count > 0){
                //                    strAddress.append(String.init(format:"\(str ?? <#default value#>ad1),"))
//                }
//            }
//            if let strad2 = address["address2"] as? String{
//                if(strad2.count > 0){
//                    strAddress.append(String.init(format:"\(strad2),"))
//                }
//            }
//
//            if let strcity = address["city"] as? String{
//                if(strcity.count > 0){
//                    strAddress.append(String.init(format:"\(strcity),"))
//                }
//            }
//
//
//            if let strstate = address["state"] as? String{
//                       if(strstate.count > 0){
//                           strAddress.append(String.init(format:"\(strstate),"))
//                       }
//                   }
//
//            if let strcountry = address["country"] as? String{
//                       if(strcountry.count > 0){
//                           strAddress.append(String.init(format:"\(strcountry),"))
//                       }
//                   }
//
//            if let strpincode = address["pincode"] as? String{
//                       if(strpincode.count > 0){
//                           strAddress.append(String.init(format:"\(strpincode),"))
//                       }
//                   }
//
//            if(strAddress.count > 0){
//            self.lblAddress.text = strAddress
//            }else{
//              self.lblAddress.text =  "current address"
//            }
//
//                    }
//
//                }
//            }
//            }
//            }
//
self.getAddressFromCurrentLocation { (address,error) in
if(error.code == 0 && address.keys.count > 0){
self.fillupdatedatainUI(dic: address)
}else{
    Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
                }
//            }
//}
//            self.getAddressFromCurrentLocation(address,error){
//                if(error.code == 0 && address.allkey.count > 0){
//
//                }else{
//                    common.showalert(error.localizeddescription)
//                }
//            }
            
        }
    
    
            }else if(distance > 5){
          /*      let lastlocation = location
                let coordinate = lastlocation.coordinate
                
                LMGeocoder.sharedInstance().cancelGeocode()
                LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceApple, alternativeService: LMGeocoderServiceApple) { (results, error) in
        if((results?.count ?? 0 > 0) && (error == nil) ){
                        let address =  results?.first
                        
        if(address?.formattedAddress?.count ?? 0 > 0){
           
            print("formated  address = \(address?.formattedAddress ?? "address") ")
          
            
            var address1 = [String:Any]()
            var stradd1 = ""
            if let  strno = address?.streetNumber{
                stradd1.append(strno)
            }
            if let  subadm = address?.subAdministrativeArea{
                stradd1.append(subadm)
            }
            if let adm = address?.administrativeArea{
                stradd1.append(adm)
            }
            if let neighbour = address?.neighborhood{
                stradd1.append(neighbour)
            }
            
            address1["address1"] =  stradd1
            address1["address2"] = address?.subLocality
            address1["city"] = address?.locality
            address1["state"] = address?.administrativeArea
            address1["country"] = address?.country
            address1["postalcode"] = address?.postalCode
    //        self.custAddDic = [String:Any]()
    //        self.custAddDic["Longitude"] = address?.coordinate.longitude
    //        self.custAddDic["Lattitude"] = address?.coordinate.latitude
            self.strLat = address?.coordinate.latitude ?? 0.0000
            self.strLong = address?.coordinate.longitude ?? 0.0000
            address1["latitude"] = self.strLat
            address1["longitude"] = self.strLong
            print("lat = \(self.strLat ?? 0.0000) , Long = \(self.strLong ?? 0.0000)")
            self.fillupdatedatainUI(dic: address1)
       // self.lblAddress.text =  address?.formattedAddress
        }
                }else{*/
    //        self.lblAddress.text = "-"
    //        if let lastLocation = locations.last as? CLLocation{
    //         let  address = self.getAddressFromLocation(location:lastLocation)
    //        var strAddress =  ""
    //            if let strad1 = address["address1"] as? String{
    //                if(strad1.count > 0){
                    //                    strAddress.append(String.init(format:"\(str ?? <#default value#>ad1),"))
    //                }
    //            }
    //            if let strad2 = address["address2"] as? String{
    //                if(strad2.count > 0){
    //                    strAddress.append(String.init(format:"\(strad2),"))
    //                }
    //            }
    //
    //            if let strcity = address["city"] as? String{
    //                if(strcity.count > 0){
    //                    strAddress.append(String.init(format:"\(strcity),"))
    //                }
    //            }
    //
    //
    //            if let strstate = address["state"] as? String{
    //                       if(strstate.count > 0){
    //                           strAddress.append(String.init(format:"\(strstate),"))
    //                       }
    //                   }
    //
    //            if let strcountry = address["country"] as? String{
    //                       if(strcountry.count > 0){
    //                           strAddress.append(String.init(format:"\(strcountry),"))
    //                       }
    //                   }
    //
    //            if let strpincode = address["pincode"] as? String{
    //                       if(strpincode.count > 0){
    //                           strAddress.append(String.init(format:"\(strpincode),"))
    //                       }
    //                   }
    //
    //            if(strAddress.count > 0){
    //            self.lblAddress.text = strAddress
    //            }else{
    //              self.lblAddress.text =  "current address"
    //            }
    //
    //                    }
    //
    //                }
    //            }
    //            }
    //            }
    //
    self.getAddressFromCurrentLocation { (address,error) in
    if(error.code == 0 && address.keys.count > 0){
    self.fillupdatedatainUI(dic: address)
    }else{
        Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
                    }
//                }
//    }
    //            self.getAddressFromCurrentLocation(address,error){
    //                if(error.code == 0 && address.allkey.count > 0){
    //
    //                }else{
    //                    common.showalert(error.localizeddescription)
    //                }
    //            }
                
            }
            }
    }
}
}
extension AddCustomer:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfCustomerClassfication){
         
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Customer Class"
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfCustomerClass = arrClass
            self.popup?.arrOfSelectedClass = [String]()
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.tag =  0
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.customerClass
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
            
            Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
            
            return false
        }else if(textField == tfBeatPlan){
            popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
             popup?.modalPresentationStyle = .overCurrentContext
             popup?.mandatorydelegate = self
             popup?.isFromSalesOrder =  false
             popup?.strTitle = ""
             popup?.isSearchBarRequire = true
             popup?.viewfor = ViewFor.beatplan
             popup?.arrOfBeatPlan = self.arrOfBeatPlan
             popup?.strLeftTitle = ""
             popup?.strRightTitle = ""
             popup?.selectionmode = SelectionMode.none
             popup?.arrOfSelectedBeatPlan = [BeatPlan]()
             popup?.isFilterRequire = false
             popup?.isSearchBarRequire = true
             // popup?.showAnimate()
             popup?.parentViewOfPopup = self.view
             Utils.addShadow(view: self.view)
             self.present(popup!, animated: false, completion: nil)
            return false
        }
        else  if(textField == tfCustType){
          
            chooseCoTypeDropDown.show()
            
            return false
        }else if(textField == tfVatCode){
            chooseVatDropDown.show()
            return false
        }else if(textField ==  tfSubCustType){
            
           
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = ""
            self.popup?.nonmandatorydelegate = self
            self.popup?.isFromSalesOrder =  false
            if(tfCustType.text == "Retailer"){
            self.popup?.arrOfList = self.arrOfDistributors
            self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
            }else{
                self.popup?.arrOfList = self.arrOfStockist
                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
            }
            self.popup?.strLeftTitle = "REFRESH"
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = true
            self.popup?.viewfor = ViewFor.customer
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
            let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
            let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
          
           
             if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
            if(self.presentedViewController == self.popup){
                popup?.dismiss(animated: true)
            }
                Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
                return false
             }else{
                tfSubCustType.text = ""
                return true
             }
            
        }else if(textField == tfBirthDate){
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datePicker.datePickerMode = .date
            datePicker.date = Date()
         //   datePicker.date = self.self.dateFormatter.date(from: tfBirthDate.text!)!
            return true
        }else if(textField == tfAnniversaryDate){
            self.self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datePicker.datePickerMode = .date
          //  datePicker.date = Date()
         //   datePicker.date = self.self.dateFormatter.date(from: tfBirthDate.text!)!
            return true
        }else if(textField == tfCustType){
            chooseCoTypeDropDown.show()
            return false
        }else if(textField == tfCustomerSegment){
            Utils.addShadow(view: self.view)
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Customer Segment"
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
            
            self.popup?.arrOfselectedCustomerSegment = [CustomerSegment]()
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.isFromSalesOrder =  false
            self.popup?.viewfor = ViewFor.customersegment
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
            
            self.present(self.popup!, animated: false, completion: nil)
            return false
        }else if(textField == tfCustomerTerritory){
            //by  Territory
//            var arrOfTerritory = Territory.getAll()
//
//            print(arrOfTerritory)
            
            
         
         /*   if    let classpopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.MiddlePopup) as? ProductNameList{
            
            classpopup.modalPresentationStyle = .overCurrentContext
           
            //  classpopup.delegate = self
            classpopup.arrOfCustomerClass = Utils().getCustomerClassification()
            classpopup.arrOfSelectedClass = [String]()
            classpopup.strLeftTitle = ""
            classpopup.strRightTitle = ""
            classpopup.selectionmode = SelectionMode.none
            classpopup.strTitle = "Select Customer Territory"
            classpopup.arrOfTerritory = arrOfterritory
            classpopup.arrOfSelectedTerritory = [[String:String]]()
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            classpopup.isSearchRequire = false
            classpopup.viewfor = ViewFor.territory
            classpopup.isFilterRequire = false
            // popup?.showAnimate()
            self.present(classpopup, animated: false, completion: nil)
            }*/
            Utils.addShadow(view: self.view)
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Customer Territory"
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfTerritory = arrOfterritory//arrOfTerritory
            self.popup?.arrOfSelectedTerritory = [[String:Any]]()
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.isFromSalesOrder =  false
            self.popup?.viewfor = ViewFor.territory
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
         
            self.present(self.popup!, animated: false, completion: nil)
        
            
            return false
        }else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if( textField == tfContactMobile || textField == tfCustMobileNo || textField == tfLandLineNo){
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
         }else  if(textField == tfVisitReminder){
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            }else{
                    return true
                }
            /*
             else if(string == ". "){
                     return false
                 }else if(string == " ."){
                     return false
                 }
             
             **/
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         self.dateFormatter.dateFormat = "dd-MM-yyyy"
        if(textField == tfBirthDate){
            textField.text = self.dateFormatter.string(from: datePicker.date)
        }
        else if(textField == tfAnniversaryDate){
            textField.text = self.dateFormatter.string(from: datePicker.date)
            
        }
    }
    
}

extension AddCustomer:PopUpDelegateNonMandatory{
    func completionSelectedBeatPlan(arr: [BeatPlan]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedBeatPlan = arr
        if let selectedbeatplan = arrOfSelectedBeatPlan.first{
            var strbeatplan = ""
            if let beatplanid = selectedbeatplan.BeatPlanID{
                strbeatplan.append(beatplanid)
            }
            if let beatplanname = selectedbeatplan.BeatPlanName{
                if(strbeatplan.count > 0){
                    strbeatplan.append(" | \(beatplanname)")
                }else{
                    strbeatplan.append(beatplanname)
                }
            }
            tfBeatPlan.text = strbeatplan
            selectedBeatplanID = selectedbeatplan.BeatPlanID
        }
    }
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        if(self.companytypeID == NSNumber.init(value: 4)){
        if let distributorname = arr.first?.name{
        tfSubCustType.text = distributorname
        }
        if let selectedDistributorId = arr.first?.iD{
            self.distributorId  = NSNumber.init(value:(Int(selectedDistributorId)))
        }
        }else{
            if let distributorname = arr.first?.name{
            tfSubCustType.text = distributorname
            }
            if let selectedDistributorId = arr.first?.iD{
                self.stockId  = NSNumber.init(value:(Int(selectedDistributorId)))
            }
        }
    }
 
    func completionSelectedTerritory(arr: [[String:Any]]) {
        Utils.removeShadow(view: self.view)
         let teriName   =  String.init(format: "%@ | %@", arr.first?["territoryName"] as! String ,arr.first?["territoryCode"] as! String)
        // arr.first?["territoryName"]  as? String{
            tfCustomerTerritory.text = teriName
         //String.init(format: "%@ | %@", customerTerritory?["territoryCode"] as! String ,customerTerritory?["territoryName"] as! String)
      //  let customerTerritory =
        selectedTerritory = arr.first
    }

    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        if(isForPrimaryAssignee == false){
             arrOfSelectedExecutive =  arr
        }else{
            if(isEditCustomer){
            self.updateAssignee()
            }
            arrOfSelectedPrimaryAssignee =  arr
        }
        if(isForPrimaryAssignee == false){
        if(arr.count > 1){
            if(arrOfSelectedPrimaryAssignee.count == 0){
                arrOfSelectedPrimaryAssignee = [arr[0]]
                primaryUserID = self.arrOfSelectedPrimaryAssignee.first?.entity_id ?? self.activeuser?.userID as! NSNumber
            }
            isForPrimaryAssignee =  true
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Primary Assign"
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfExecutive = arr
            self.popup?.arrOfSelectedExecutive = arrOfSelectedPrimaryAssignee//[String]()
            self.popup?.strLeftTitle = "OK"
            self.popup?.strRightTitle = "CANCEL"
            self.popup?.selectionmode = SelectionMode.single
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.isFromSalesOrder =  false
            self.popup?.viewfor = ViewFor.companyuser
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
            Utils.addShadowOnSahdow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
            var name = "Assigned To:"
            arrOfAssignee = [NSNumber]()
            if(self.arrOfSelectedExecutive.count > 0){
                for assignee in self.arrOfSelectedExecutive{
                    arrOfAssignee.append(assignee.entity_id)
                    if let fpname = assignee.firstName as? String{
                        name.append(" \(fpname)")
                    }
                    if let lpname = assignee.lastName as? String{
                        name.append(" \(lpname) ")
                    }
                }
                self.lblAssignToValue.text = name
            }
            
        }else{
            arrOfAssignee = [NSNumber]()
            if(arr.count == 1){
            let selectedExcecutive =  arr.first
            var Name = ""
            if let fname = selectedExcecutive?.firstName{
                Name =  fname
            }
            if let lname = selectedExcecutive?.lastName{
                Name.append(" \(lname)")
            }
            arrOfAssignee.append(selectedExcecutive?.entity_id ?? NSNumber.init(value: 0))
                lblAssignToValue.text = String.init(format:"Assigned To:\(Name)")
            print("Assigned value = \(Name)")
                primaryUserID = selectedExcecutive?.entity_id ?? NSNumber.init(value: 0)
            lblPrimaryAssignToValue.text = Name
                if(isEditCustomer){
                self.updateAssignee()
                }
            }
        }
        }
            else{

                var primaryName = ""
                if(self.arrOfSelectedPrimaryAssignee.count > 0){
                    for assignee in self.arrOfSelectedPrimaryAssignee{
                       
                        if let fpname = assignee.firstName as? String{
                            primaryName =  fpname
                        }
                        if let lpname = assignee.lastName as? String{
                            primaryName.append(" \(lpname) ")
                        }
                    }
                    primaryUserID = self.arrOfSelectedPrimaryAssignee.first?.entity_id ?? self.activeuser?.userID as! NSNumber
                    self.lblPrimaryAssignToValue.text = primaryName
                    if(isEditCustomer){
                    self.updateAssignee()
                    }
                }else{
                    
                }
            }
        }
    
   
    func completionSelectedVendor(arr:[Vendor]){}
 //   func completionData(arr:[CustomerDetails]){}
    func completionfirstInfluencer(arr:[CustomerDetails]){}
    func completionsecondInfluencer(arr:[CustomerDetails]){}
    func completionProductData(arr:[Product]){}
  //  func completionSelectedTerritory(arr:[[String:Any]]){}
    func completionProductCategory(arr:[ProdCategory]){}
    func completionProductSubCategory(arr:[ProductSubCat]){}
    func completionSelectedVisitOutCome(arr:[VisitOutcomes]){}
    func completionSelectedLeadOutCome(arr:[Outcomes]){}
//    func completionSelectedSegment(arr:[CustomerSegment]){}
  
    func completionSelectedVisitStep(arr:[StepVisitList]){}
    func completionSelectedDocument(arr:[Document]){}

    func completionSelectedSegment(arr: [CustomerSegment]) {
        Utils.removeShadow(view: self.view)
        self.tfCustomerSegment.text =  arr.first?.customerSegmentValue
        self.customerSegmentIndex =  arr.first?.iD as! NSNumber
    }
    
    func completionSelectedClass(arr: [String],recordno:Int , strTitle:String) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
           // self.arrOfSelectedClass =  arr
            if( self.popup?.tag ==  0){
            tfCustomerClassfication.text = arr.first
                customerClassIndex = NSNumber.init(value:recordno + 1)
            }else{
                tfTown.text = arr.first
                if let town = arrTown[recordno] as? [String:Any]{
                    townID = town["id"] as? NSNumber ?? NSNumber.init(value: 0)
                }
            }
        }
    }
}

extension AddCustomer: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblKYC){
            
            return self.activesetting.numberOfKYC?.intValue ?? 0
        }else{
        return arrAddress.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblKYC){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "kyccell", for: indexPath) as? KYCCell{
                cell.selectionStyle = .none
                if(self.arrKYCDetails.count > indexPath.row){
                let selectedkyc = self.arrKYCDetails[indexPath.row]
                   
                cell.setKYCData(indexpath:indexPath,dic:selectedkyc)
                }else{
                    cell.setKYCData(indexpath:indexPath,dic:[String:Any]())
                }
                
                self.chooseKYCTypeDropDown.dataSource = arrKYCType
                self.chooseKYCTypeDropDown.reloadAllComponents()
                if(indexPath.row == 0){
                    if(AddCustomer.custKYCImg?.pngData()?.count ?? 0 > 0){
                       
                        cell.imgKYC.image = AddCustomer.custKYCImg
                    }else{
                        cell.imgKYC.image = UIImage.init(named: "icon_placeholder")
                    }
                }else if(indexPath.row == 1){
                    if(AddCustomer.custKYCImg1?.pngData()?.count ?? 0 > 0){
                      
                        cell.imgKYC.image = AddCustomer.custKYCImg1
                    }else{
                        cell.imgKYC.image = UIImage.init(named: "icon_placeholder")
                    }
                }else{
                    if(AddCustomer.custKYCImg2?.pngData()?.count ?? 0 > 0){
                        cell.imgKYC.image = AddCustomer.custKYCImg2
                    }else{
                        cell.imgKYC.image = UIImage.init(named: "icon_placeholder")
                    }
                }
                cell.kycdelegate = self
                
                return cell
        }else{
            return UITableViewCell()
        }
        }else{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tempaddresscell", for: indexPath) as? TempAddressCell{
            cell.selectionStyle = .none
            cell.tfTempPincode.keyboardType = .numberPad
        cell.setDashboardVisitData(address: arrAddress[indexPath.row], indexpath: indexPath)
           
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteAddressClicked), for: UIControl.Event.touchUpInside)
            cell.btnMap.tag = indexPath.row
            cell.btnMap.addTarget(self, action: #selector(mapAddressClicked), for: UIControl.Event.touchUpInside)
            
            return cell
        }else{
            return UITableViewCell()
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func deleteAddressClicked(sender:UIButton){
        Common.showalert(title: "SuperSales", msg: "Are you sure you want to delete Address?", yesAction: UIAlertAction.init(title: "YES", style: .destructive, handler: { (action) in
            self.arrAddress.remove(at: sender.tag)
//            self.tblTempAddHeight.constant = self.tblTempAdd.contentSize.height
//            self.tblTempAdd.layoutIfNeeded()
//            self.tblTempAdd.reloadData()
            DispatchQueue.main.async {
                self.tblTempAdd.layoutIfNeeded()
                self.tblTempAdd.reloadData()
                self.tblTempAddHeight.constant = self.tblTempAdd.contentSize.height
            }
        }), noAction: UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: { (action) in
            
        }), view: self)
    }
    
    
    
    @objc func mapAddressClicked(sender:UIButton){
        
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            Common.skipVisitSelection = false
            let address = arrAddress[sender.tag]
 //          let currentlocation = Location.sharedInsatnce.getCurrentCoordinate()
//            map.lattitude = NSNumber.init(value:currentlocation.latitude)
//            map.longitude =  NSNumber.init(value:currentlocation.longitude)
            
            
         /*   let nsnumberlat = NSNumber.init(value: address.lattitude as? Double ?? 0.0)
            let nsnumberlong = NSNumber.init(value: address.longitude as? Double ?? 0.0 )
            map.lattitude = nsnumberlat
            map.longitude = nsnumberlong*/
//            map.lattitude =  NSNumber.init(value:Double(([address.lattitude] as? NSString)?.doubleValue ?? 000000))
//            map.longitude = NSNumber.init(value:Double(([address.longitude] as? NSString)?.doubleValue ?? 000000))
            
            let doublelat = address.lattitude.toDouble()
            let doublelng = address.longitude.toDouble()
            map.lattitude = NSNumber.init(value: doublelat)
            map.longitude = NSNumber.init(value: doublelng)
            
        
//            currentaddress.lattitude = nsnumberlat.stringValue//String.init(format:address["Lattitude"] as? String ?? "0")
//            currentaddress.longitude =  nsnumberlong.stringValue
//            map.lattitude = address.dlattitude

//            map.longitude = address.dlongitude  //NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.00)
            map.delegate = self
            map.isFromCustomer = true
            map.tempAddNo = NSNumber.init(value: sender.tag)
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
}
extension AddCustomer:KYCCellDelegate{
  
    
    func textfieldKYCTYPEEditing(textfield:UITextField) {
        selectedRecord = textfield.tag
        self.chooseKYCTypeDropDown.anchorView = textfield//cell.tfKYCType
        self.chooseKYCTypeDropDown.bottomOffset = CGPoint.init(x:0.0, y:self.tfCustType.bounds.size.height)
        self.chooseKYCTypeDropDown.selectionAction =  {(index,item)
            in
//            let arrOfTypeKYC = self.arrKYCType.map{
//                $["KycType"]
//            }
//            if()
            var arrOfKYCType = [String]()
            if(self.arrKYCDetails.count > 0){
            for i in 0...self.arrKYCDetails.count - 1{
                let kycselected = self.arrKYCDetails[i]
                if(i == 0){
                    arrOfKYCType.append(kycselected["KycType"] as? String ?? "")
                }else{
                    arrOfKYCType.append(kycselected["Kyc\(i)Type"] as? String ?? "")
                }
            }
            }
            if(!arrOfKYCType.contains(item) || item.lowercased() == "select kyc type"){
            textfield.text = item
            var selectedCustKYC = [String:Any]()
            if(self.arrKYCDetails.count > textfield.tag){
            if let dic = self.arrKYCDetails[textfield.tag] as? [String:Any]{
                selectedCustKYC = dic
            }
            }
            if(textfield.tag == 0){
                selectedCustKYC["KycType"] = item
            }else{
            selectedCustKYC["Kyc\(textfield.tag)Type"] = item
            }
            if(self.arrKYCDetails.count > textfield.tag){
            if let dic = self.arrKYCDetails[textfield.tag] as? [String:Any]{
                self.arrKYCDetails.remove(at: textfield.tag)
            }
            }
            
       
            if(self.selectedRecord > self.arrKYCDetails.count){
                print("tag of text field \(textfield.tag) ,arr =  \(self.arrKYCDetails.count) , \(self.arrKYCDetails)")
                self.arrKYCDetails.insert(selectedCustKYC, at: textfield.tag)
            }else{
                print("tag of text field \(textfield.tag) ,arr =  \(self.arrKYCDetails.count) , \(self.arrKYCDetails)")
            self.arrKYCDetails.insert(selectedCustKYC, at: self.selectedRecord)
            }
            print("tag of text field \(textfield.tag) ,arr =  \(self.arrKYCDetails.count) , \(self.arrKYCDetails)")
            }else{
                self.view.makeToast("\(item) is already selected")
            }
        }
        chooseKYCTypeDropDown.show()

    }
    
    func textfieldKYCNumberEditDone(textfield:UITextField) {
        selectedRecord = textfield.tag
        var selectedCustKYC = [String:Any]()
        if(self.arrKYCDetails.count > textfield.tag){
        if let dic = self.arrKYCDetails[textfield.tag] as? [String:Any]{
            selectedCustKYC = dic
        }
        }
        if(textfield.tag == 0){
            selectedCustKYC["KycNumber"] = textfield.text
        }else{
        selectedCustKYC["Kyc\(textfield.tag)Number"] = textfield.text
        }
        if(self.arrKYCDetails.count > textfield.tag){
        if let dic = self.arrKYCDetails[textfield.tag] as? [String:Any]{
            self.arrKYCDetails.remove(at: textfield.tag)
        }
        }
      
        if(self.selectedRecord > self.arrKYCDetails.count){
            print("tag of text field \(textfield.tag) ,arr =  \(self.arrKYCDetails.count) , \(self.arrKYCDetails)")
            self.arrKYCDetails.insert(selectedCustKYC, at: textfield.tag)
        }else{
            print("tag of text field \(textfield.tag) ,arr =  \(self.arrKYCDetails.count) , \(self.arrKYCDetails)")
        self.arrKYCDetails.insert(selectedCustKYC, at: self.selectedRecord)
        }
       
    }
    
    func imgkycClicked(img:UIImageView){
        self.cameraTapped()
        switch img.tag {
        case 0:
            isCustomerKYCImage = true
            break
            
        case 1:
            isCustomerKYCImage1 = true
            break
            
        case 2:
            isCustomerKYCImage2 = true
            break
        default:
            break
        }
       
        
    }
    
    
}
