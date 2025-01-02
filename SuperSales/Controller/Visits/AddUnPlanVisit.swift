//
//  AddUnPlanVisit.swift
//  SuperSales
//
//  Created by Apple on 25/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation
import SVProgressHUD
import LMGeocoder
import Toast


class AddUnPlanVisit: BaseViewController {
    // swiftlint:disable line_length
    
    var aryContactType:[String]! = [String]()
    var assigneeuserDropDown:DropDown! = DropDown()
    var chooseCoTypeDropDown:DropDown! = DropDown()
    var customerDropdown:DropDown! =  DropDown()
    var nextActionID:NSNumber! = NSNumber.init(value: 0)
    var originalAssignee:NSNumber = 0
    var isEdit:Bool! = false
    var objunplanvisit:UnplannedVisit?
    var currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate()
    var arrLowerLevelUser = [CompanyUsers]()
    var arrOfFilteredLowerLeverUser = [CompanyUsers]()
    var strNextActionTime = ""
    // var arrLowerLevelUser = [CompanyUsers]()
    var isFirstTime =  false
    
    var datePicker : UIDatePicker!
    
    var arrSelectedProduct:[SelectedProduct]! = [SelectedProduct]()
    //  var arrSelectedProduct:[Product] = [Product]()
    var selectedInteraction = InteractionType.metting
    var arrOfLowerLevelUserName:[NSString] = [NSString]()
    var arrOfFilteredLowerLevelUserName:[NSString] = [NSString]()
    var tableViewHeight: CGFloat {
        tblProduct.layoutIfNeeded()
        return tblProduct.contentSize.height
    }
    
    @IBOutlet weak var btnSearchAssignee: UIButton!
    @IBOutlet weak var tfCustomerName: UITextField!
    
    @IBOutlet weak var tfCustomerMobileNo: UITextField!
    
    
    @IBOutlet weak var tfCorporateSelection: UITextField!
    
    @IBOutlet weak var tfContactFirstName: UITextField!
    
    
    @IBOutlet weak var tfContactLastName: UITextField!
    
    @IBOutlet weak var tfContactMobileNo: UITextField!
    
    @IBOutlet weak var tfContactEmailId: UITextField!
    
    
    @IBOutlet weak var lblAddress1Title: UILabel!
    
    @IBOutlet weak var TfAddress1: UITextField!
    
    @IBOutlet weak var lblAddress2Title: UILabel!
    
    @IBOutlet weak var TfAddress2: UITextField!
    
    @IBOutlet weak var lblTownTitle: UILabel!
    
    @IBOutlet weak var TfTown: UITextField!
    
    @IBOutlet weak var lblStateTitle: UILabel!
    
    @IBOutlet weak var TfState: UITextField!
    
    @IBOutlet weak var lblPincodeTitle: UILabel!
    
    @IBOutlet weak var TfPincode: UITextField!
    
    @IBOutlet weak var lblCountryTitle: UILabel!
    
    @IBOutlet weak var TfCountry: UITextField!
    
    
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var lblLatitude: UILabel!
    
    @IBOutlet weak var searchAssignUser: UISearchBar!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var tfContactPerson: UITextField!
    
    
    @IBOutlet weak var lblProductInterestedIn: UILabel!
    @IBOutlet weak var btnAddProduct: UIButton!
    
    @IBOutlet weak var vwAddProduct: UIView!
    @IBOutlet weak var tblProduct: UITableView!
    
    //btn of interaction type
    
    
    @IBOutlet weak var btnInteractionMeeting: UIButton!
    
    @IBOutlet weak var btnInteractionCall: UIButton!
    
    
    @IBOutlet weak var btnInteractionMail: UIButton!
    
    
    @IBOutlet weak var btnInteractionMessage: UIButton!
    
    @IBOutlet weak var vwInteraction: UIView!
    
    @IBOutlet weak var tfDate: UITextField!
    
    @IBOutlet weak var tfTime: UITextField!
    
    @IBOutlet weak var tfAssignTo: UITextField!
    
    @IBOutlet weak var tblProductListHeight: NSLayoutConstraint!
    
   
    @IBOutlet weak var stcViewExe: UIStackView!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet weak var vwNextActionTime: UIView!
  
    @IBOutlet weak var vwCustTypeSelection: UIView!
    
    @IBOutlet weak var vwCustFirstName: UIView!
    
    @IBOutlet weak var vwCustLatsName: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("add_visit", comment:"");
        // Do any additional setup after loading the view.
        self.setUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isFirstTime = false
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.init("updatecheckinInfo"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Common.skipVisitSelection = true
        Location.sharedInsatnce.startLocationManager()
        if(self.activesetting.displayNextMeetingTimeInColdCall == NSNumber.init(value: 1)){
            vwNextActionTime.isHidden = false
        }else{
            vwNextActionTime.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updatecheckinInfo"), object: nil)
    }
    // MARK: Method
    @objc func onDidReceiveData(_ notification:Notification) {
        if(self.navigationController?.viewControllers.count ?? 0 > 0){
            if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                    self.navigationController?.popToViewController(controller,animated:true)
                    SVProgressHUD.dismiss()
                }
            }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                    self.navigationController?.popToViewController(controller,animated:true)
                    SVProgressHUD.dismiss()
                }
            }else{
                self.navigationController?.popViewController(animated:true)
                SVProgressHUD.dismiss()
                
            }
            
        }
    }
    
    func setUI(){
      
        self.btnAddProduct.contentHorizontalAlignment = .left
        self.btnAddProduct.setrightImage()
        tfCustomerName.becomeFirstResponder()
    //    DispatchQueue.global(qos: .background).async {
        self.fetchuser{
            (arrOfuser,error) in
           print(" arr of user = \(arrOfuser) , error is = \(error)")
        }
     //   }
        if BaseViewController.staticlowerUser.count > 0 {
            self.stcViewExe.isHidden = false
        }else {
            self.stcViewExe.isHidden = true
        }
        btnSearchAssignee.isHidden = true
        tfCorporateSelection.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        
        //set delegate
        tfCorporateSelection.delegate = self
        tfCustomerName.delegate = self
        tfCustomerMobileNo.delegate = self
        tfCorporateSelection.delegate = self
        tfContactMobileNo.delegate = self
        tfContactLastName.delegate = self
        tfContactFirstName.delegate = self
        tfTime.delegate = self
        tfDate.delegate = self
        tblProduct.delegate = self
        tblProduct.dataSource = self
        searchAssignUser.delegate = self
        tfAssignTo.delegate = self
        tfDate.delegate = self
        tfTime.delegate = self

        tfCorporateSelection.setCommonFeature()
        tfCustomerName.setCommonFeature()
        tfCustomerMobileNo.setCommonFeature()
        tfCorporateSelection.setCommonFeature()
        tfContactMobileNo.setCommonFeature()
        tfContactLastName.setCommonFeature()
        tfContactFirstName.setCommonFeature()
        tfTime.setCommonFeature()
        tfDate.setCommonFeature()
        tfAssignTo.setCommonFeature()
        tfDate.setCommonFeature()
        tfTime.setCommonFeature()
        TfAddress1.setCommonFeature()
        TfAddress2.setCommonFeature()
        TfTown.setCommonFeature()
        TfState.setCommonFeature()
        TfPincode.setCommonFeature()
        TfCountry.setCommonFeature()
       // tfContactPerson.setCommonFeature()
        


        Location.sharedInsatnce.startLocationManager()
        Location.sharedInsatnce.locationUpdaterDelegate = self
        selectedInteraction =  InteractionType.metting
        btnInteractionMeeting.isSelected = true
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        if(activesetting.customerProfileInUnplannedVisit == false){
          
            self.btnSubmit.setbtnFor(title: "CHECK-IN", type: Constant.kPositive)
        }else{
            self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
       
        }
        
        if(isEdit){
           
            self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        }
        
     
        
       
        if let originalAssignee = self.activeuser?.userID
        {
            self.originalAssignee = originalAssignee
        }
        else{
            self.originalAssignee = NSNumber.init(value: 0)
        }
        datePicker = UIDatePicker.init()
        datePicker.setCommonFeature()
        datePicker.minimumDate = Date()
        tfTime.inputView =  datePicker
        tfDate.inputView = datePicker
       
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfDate.text = self.dateFormatter.string(from: datePicker.date)
        self.dateFormatter.dateFormat = "hh:mm a"
        tfTime.text = self.dateFormatter.string(from: datePicker.date)
        
       
        //CGFloat(arrSelectedProduct.count * 60)
        
        
        if(activesetting.productInterestedInUnplannedVisit == 0){
            lblProductInterestedIn.isHidden = true
            vwAddProduct.isHidden = true
            tblProduct.isHidden = true
        }else{
            lblProductInterestedIn.isHidden = false
            vwAddProduct.isHidden = false
            tblProduct.isHidden = false
        }
        
        arrLowerLevelUser = BaseViewController.staticlowerUser ?? [CompanyUsers]()
        arrOfLowerLevelUserName = arrLowerLevelUser.map{
            String.init(format: "%@ %@", $0.firstName , $0.lastName)
        } as [NSString] as [NSString]
        self.initdropDown()
        tfCorporateSelection.delegate = self
        
    
        if(isEdit == true){
//            if  let arrOfvisitproduct = objunplanvisit?.productList as? [VisitProduct]{
//            for pro in arrOfvisitproduct{
//                let selectedpro = SelectedProduct().initwithdic(dict: pro.toDictionary())
//                arrSelectedProduct.append(selectedpro)
//            }
//            }
            arrSelectedProduct = objunplanvisit?.productList
            tblProduct.reloadData()
            self.tblProductListHeight.constant = self.tblProduct.contentSize.height
           
            tblProduct.layoutIfNeeded()
            tblProduct.reloadData()
            self.title = String.init(format: "%@ %@",NSLocalizedString("visit_no", comment:""),(objunplanvisit?.seriesPostfix ?? 0))
            self.tfCustomerName.text = objunplanvisit?.customerName
            self.tfCustomerMobileNo.text = objunplanvisit?.tempCustomerObj?.MobileNo
            
            if (objunplanvisit?.tempCustomerObj?.CompanyTypeID == 1)
            {
                self.tfCorporateSelection.text = activesetting.displayCorporateInCustType ?? NSLocalizedString("corporate", comment:"")//NSLocalizedString("corporate", comment: "")
                
            }else if(objunplanvisit?.tempCustomerObj?.CompanyTypeID == 2) {
                
                self.tfCorporateSelection.text = activesetting.displayEndUserInCustType ?? NSLocalizedString("end_user", comment:"")//NSLocalizedString("end_user", comment: "")
            }
            else if(objunplanvisit?.tempCustomerObj?.CompanyTypeID == 3) {
                self.tfCorporateSelection.text =   activesetting.displayInfluencerInCustType ?? NSLocalizedString("influencer", comment:"") //NSLocalizedString("influencer", comment: "")
                
                
            }else if(objunplanvisit?.tempCustomerObj?.CompanyTypeID == 4) {
                tfCorporateSelection.text = activesetting.displayRetailerInCustType ?? NSLocalizedString("retailer", comment:"")// NSLocalizedString("retailer", comment: "")
            }
            else{
                
                tfCorporateSelection.text = activesetting.displayStockistInCustType ?? NSLocalizedString("stockist", comment:"")//NSLocalizedString("distributor", comment: "")
            }
            tfContactFirstName.text = objunplanvisit?.tempCustomerObj?.ContactFirstName
            tfContactLastName.text =  objunplanvisit?.tempCustomerObj?.ContactLastName
            tfContactMobileNo.text =  objunplanvisit?.tempCustomerObj?.ContactNo
            tfContactEmailId.text =   objunplanvisit?.tempCustomerObj?.EmailID
            TfAddress1.text =         objunplanvisit?.tempCustomerObj?.AddressLine1
            TfAddress2.text =         objunplanvisit?.tempCustomerObj?.AddressLine2
            TfTown.text =             objunplanvisit?.tempCustomerObj?.City
            TfState.text =            objunplanvisit?.tempCustomerObj?.State
            TfPincode.text =          objunplanvisit?.tempCustomerObj?.Pincode
            TfCountry.text =          objunplanvisit?.tempCustomerObj?.Country
            
            lblLongitude.text = String.init(format: "%.7f",objunplanvisit?.tempCustomerObj?.Longitude?.floatValue as! CVarArg)
            lblLatitude.text =  String.init(format: "%.7f",objunplanvisit?.tempCustomerObj?.Lattitude?.floatValue as! CVarArg)
            
            originalAssignee = objunplanvisit?.originalAssignee ?? self.activeuser?.userID ?? 0
            
            tvDescription.text = objunplanvisit?.conclusion
            //tvDescription.setFlexibleHeight()
            
        }
        //tvDescription.setFlexibleHeight()
        if(self.activesetting.requireCustomerTypeInUnplannedVisit == NSNumber.init(value:1)){
            vwCustTypeSelection.isHidden = false
        }else{
            vwCustTypeSelection.isHidden = true
        }
        if(self.activesetting.contactBecomeCustomerInColdCall == NSNumber.init(value: 1)){
            vwCustFirstName.isHidden = true
            vwCustLatsName.isHidden = true
        }else{
            vwCustFirstName.isHidden = false
            vwCustLatsName.isHidden = false
        }
        tblProductListHeight.constant = tableViewHeight
    }
    
    func initdropDown(){
        
        self.chooseCoTypeDropDown.anchorView = tfCorporateSelection
        self.chooseCoTypeDropDown.bottomOffset = CGPoint.init(x:0.0, y:self.tfCorporateSelection.bounds.size.height)
        
        // Action triggered on selection
//        aryContactType = [NSLocalizedString("corporate", comment:""),NSLocalizedString("end_user", comment:""),NSLocalizedString("influencer", comment:""),NSLocalizedString("retailer", comment:""),NSLocalizedString("distributor", comment:"")]
        aryContactType.append(activesetting.displayCorporateInCustType ?? NSLocalizedString("corporate", comment:""))
        aryContactType.append(activesetting.displayEndUserInCustType ?? NSLocalizedString("end_user", comment:""))
        aryContactType.append(activesetting.displayInfluencerInCustType ?? NSLocalizedString("influencer", comment:""))
        aryContactType.append(activesetting.displayRetailerInCustType ?? NSLocalizedString("retailer", comment:""))
        aryContactType.append(activesetting.displayDistributorInCustType ?? NSLocalizedString("distributor", comment:""))
        aryContactType.append(activesetting.displayStockistInCustType ?? NSLocalizedString("stockist", comment:""))
       
        //[NSMutableArray arrayWithObjects:NSLocalizedString(@"corporate", @""),NSLocalizedString(@"end_user", @""),NSLocalizedString(@"influencer", @""),NSLocalizedString(@"retailer", @""),NSLocalizedString(@"distributor", @""), nil];
        self.chooseCoTypeDropDown.dataSource = aryContactType;
        self.chooseCoTypeDropDown.reloadAllComponents()
        if(aryContactType.count > 0){
        tfCorporateSelection.text = aryContactType[0];
        }
        tfCorporateSelection.delegate = self
        self.chooseCoTypeDropDown.selectionAction = {(index,item)
            in
            self.tfCorporateSelection.text = self.aryContactType[index];
        }
        
        assigneeuserDropDown.anchorView = tfAssignTo //searchAssignUser
        assigneeuserDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchAssignUser.text = item
            self.tfAssignTo.text = item
            let assignee =
                self.arrLowerLevelUser[index]
            self.originalAssignee = assignee.entity_id
        }
        assigneeuserDropDown.reloadAllComponents()
        assigneeuserDropDown.bottomOffset = CGPoint.init(x:0.0, y:self.tfAssignTo.bounds.size.height)
    }
    
    func fillupdatedatainUI(dic:[String:Any]){
        TfAddress1.text = dic["address1"] as? String
        TfAddress2.text = dic["address2"] as? String
        TfTown.text = dic["city"] as? String
        TfState.text = dic["state"] as? String
        TfCountry.text = dic["country"] as? String
        TfPincode.text = dic["postalcode"] as? String
        
//        lblLongitude.text = String.init(format: "%.7f",(dic["longitude"] as? String)?.floatValue ?? 0.0000 as CVarArg)
//        lblLatitude.text =  String.init(format: "%.7f",(dic["latitude"] as? String)?.floatValue ?? 0.0000 as CVarArg)
        lblLongitude.text = String.init(format: "%.7f", (dic["longitude"] as? NSNumber)?.floatValue as! CVarArg)
        lblLatitude.text = String.init(format: "%.7f", (dic["latitude"] as? NSNumber)?.floatValue as! CVarArg)
    }
    
    // MARK: - (IBAction)
    
    @IBAction func btnAddProductClicked(_ sender: UIButton) {
        if(activesetting.visitProductPermission == 2){
            // multiple product selection
            if   let multipleproductselection = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MultipleProductSelection) as? MultipleProductSelection{
                //  multipleproductselection.customerId =
                multipleproductselection.issalesorder = false
                multipleproductselection.multipleproductselectiondelegate = self
                self.navigationController?.pushViewController(multipleproductselection, animated: true)
            }
            
        }else{
            if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
                addproductobj.productselectiondelegate = self
                addproductobj.isFromProductStock = false
                addproductobj.isVisit = true
                addproductobj.isFromSalesOrder =  false
                addproductobj.modalPresentationStyle = .overCurrentContext
                addproductobj.parentviewforpopup = self.view
                Utils.addShadow(view: self.view)
                self.present(addproductobj, animated: true, completion: nil)
            }
            // AddProductPopup().displayPopup(parentView: self.view)
        }
    }
    
    @IBAction func btnInteractionSelectionClicked(_ sender: UIButton) {
        nextActionID = NSNumber.init(value: sender.tag)
        switch sender.tag {
        case 1:
            
            sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = true
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.metting
            break
            
        case 2:
            sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = true
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.call
            break
            
        case 3:
            sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = true
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.mail
            break
            
        case 4:
            sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = true
            selectedInteraction = InteractionType.message
            break
            
        default:
            print("Its default case")
        }
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        //validation
        let strcontactname = String.init(format: "%@ %@", tfContactFirstName.text ?? "",tfContactLastName.text ?? "")
        if(strcontactname.trimmingCharacters(in: .whitespaces).count > 0){
            if(tfContactMobileNo.text?.trimmingCharacters(in: .whitespaces).count == 0){
                Utils.toastmsg(message:NSLocalizedString("contact_number_is_required_to_add_contact", comment:""),view:self.view)
                return
            }
        }
        if(tfContactMobileNo.text?.trimmingCharacters(in: .whitespaces).count ?? 0 > 0){
            if(strcontactname.trimmingCharacters(in: .whitespaces).count == 0){
                Utils.toastmsg(message:NSLocalizedString("contact_name_is_required_to_add_contact", comment:""),view:self.view)
                return
            }else  if(tfContactMobileNo.text?.count ?? 0 < 6){
                self.tfContactMobileNo.becomeFirstResponder()
                Utils.toastmsg(message:"Please enter valid mobile no",view:self.view)
                return
                }
        }
        if(tfCustomerMobileNo.text?.count ?? 0  > 0){
            if((tfCustomerMobileNo.text?.count ?? 0 < 6)||(tfCustomerMobileNo.text?.count ?? 0 > 15)){
                Utils.toastmsg(message:"Please enter valid mobile number",view:self.view)
                return
            }
        }
        var msg = ""
        if(self.activesetting.contactBecomeCustomerInColdCall == NSNumber.init(value: 1)){
            if(tfContactFirstName.text?.count  ?? 0 == 0){
                msg=NSLocalizedString("please_enter_customer_first_name",comment:"")
            }else if(tfContactLastName.text?.count  ?? 0 == 0){
                msg=NSLocalizedString("please_enter_customer_last_name",comment:"")
            }else if(tfContactMobileNo.text?.count == 0){
                msg=NSLocalizedString("please_enter_number",comment:"")
            }
        }else{
        if(tfCustomerName.text?.count  ?? 0 == 0){
            msg=NSLocalizedString("please_enter_customer_name",comment:"")
        }else if(tfCustomerMobileNo.text?.count ?? 0 == 0){
            msg = NSLocalizedString("please_enter_customer_contact_number",comment:"")
        }
        }
        if(msg.count > 0){
            Common.showalert(msg: msg,view:self)
            return
        }else{
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var visitdict = ["CompanyID":activeuser?.company?.iD! ?? NSNumber.init(value:0),"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0) ,"VisitTypeID":NSNumber.init(value: 2),"SeriesPrefix":"","Conclusion":tvDescription.text,"NextActionID":nextActionID,"OriginalAssignee": originalAssignee,"NextActionTime":Utils.getDate(date: self.datePicker.date as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")] as [String : Any]//:Utils.getDateinstrwithaspectedFormat(givendate: self.datePicker.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
            if(isEdit == true){
                visitdict["ID"] = objunplanvisit?.localID
                visitdict["SeriesPostfix"] = objunplanvisit?.seriesPostfix
                visitdict["SeriesPrefix"] = objunplanvisit?.sereiesPrefix
                visitdict["TempCustomerID"] = objunplanvisit?.tempCustomerID
            }
            var contactdict = [String:Any]()
            if(self.activesetting.contactBecomeCustomerInColdCall == NSNumber.init(value: 1)){
                var strcustname = ""
                if let firstname = tfContactFirstName.text as? String{
                    strcustname.append(firstname)
                }
                if let lastname =  tfContactLastName.text as? String{
                    if(strcustname.count > 0){
                        strcustname.append(" ")
                    }
                    strcustname.append(lastname)
                }
                contactdict["CustomerName"] = strcustname
                contactdict["MobileNo"] = tfContactMobileNo.text
                contactdict["ContactFirstName"] = tfContactFirstName.text ?? ""
                contactdict["ContactLastName"] = tfContactLastName.text
                contactdict["ContactNo"] = tfContactMobileNo.text
            }else{
                contactdict["CustomerName"] = tfCustomerName.text ?? ""
                contactdict["MobileNo"] = tfCustomerMobileNo.text ?? ""
                contactdict["ContactFirstName"] = tfContactFirstName.text ?? ""
                contactdict["ContactLastName"] = tfContactLastName.text
                contactdict["ContactNo"] = tfContactMobileNo.text
            }
            //    ["CustomerName":tfCustomerName.text ?? "","MobileNo":tfCustomerMobileNo.text ?? "","ContactFirstName":tfContactFirstName.text ?? "" ] as [String : Any]
            if ((tfCorporateSelection.text == NSLocalizedString("corporate", comment: "")) || (tfCorporateSelection.text == activesetting.displayCorporateInCustType))
            {
                contactdict ["CompanyTypeID"] = NSNumber.init(value: 1)
            }else if((tfCorporateSelection.text == NSLocalizedString("end_user", comment: "")) || (tfCorporateSelection.text == activesetting.displayEndUserInCustType)) {
                contactdict ["CompanyTypeID"] = NSNumber.init(value: 2)
                
            }
            else if((tfCorporateSelection.text == NSLocalizedString("influencer", comment: "")) || (tfCorporateSelection.text == activesetting.displayInfluencerInCustType)) {
                contactdict ["CompanyTypeID"] = NSNumber.init(value: 3)
                
            }else if((tfCorporateSelection.text == NSLocalizedString("retailer", comment: "")) || (tfCorporateSelection.text == activesetting.displayRetailerInCustType)) { contactdict ["CompanyTypeID"] = NSNumber.init(value: 4)
                
            }
            else{
                contactdict ["CompanyTypeID"] = NSNumber.init(value: 5)
            }
            
          
            contactdict["EmailID"] = tfContactEmailId.text
            contactdict["AddressLine1"] = TfAddress1.text
            contactdict["AddressLine2"] = TfAddress2.text
            contactdict["City"] = TfTown.text
            contactdict["Country"] = TfCountry.text
            contactdict["State"] = TfState.text
            contactdict["Pincode"] = TfPincode.text
            contactdict["Lattitude"] =  lblLatitude.text
            //NSNumber.init(value: Double(lblLatitude.text) ?? 0.00)
            contactdict["Longitude"] =  lblLongitude.text
            
            
            param["addTempCustomerJson"] = Common.json(from:contactdict)
            param["addUpdateVisitJson"] = Common.json(from:visitdict)
            var arrproduct = [[String:Any]]()
            for pro in arrSelectedProduct{
                pro.productName = ""
                let dic = pro.toDictionary()
                arrproduct.append(dic)
            }
            if let arr = arrSelectedProduct as? NSMutableArray {
            
            if(arr.count > 0){
                param["addUpdateVisitProductJson"] = Common.json(from: arr)
                
            }else{
                param["addUpdateVisitProductJson"] = "[\n\n]"
            }
            }else{
                if(arrproduct.count > 0){
                    param["addUpdateVisitProductJson"] = Common.json(from: arrproduct)
                }else{
                param["addUpdateVisitProductJson"] = "[\n\n]"
                }
            }
            print("parameter of cold call = \(param)")
            self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlAddEditPlannedVisit
                                                               , img: UIImage.init(), imgparamname: "", param: param){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    print("response of coldcall = \(arr)")
//                    NotificationCenter.default.post(name: Notification.Name("updateColdCallData"), object: nil, userInfo: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       
                        
                        if(!self.isEdit){
                        if(self.activesetting.customerProfileInUnplannedVisit == 1){
                            
                            if let custProfile =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitCustomerProfile) as? VisitCustomerProfile{
                                if(responseType ==  ResponseType.dic){
                                    let dic = arr as? [String:Any] ?? [String:Any]()
                                    let unplanobj = UnplannedVisit().initwithdic(dict: dic)
                                    let  tempcustomer =  TempCustomer.init()
                                    if(self.activesetting.contactBecomeCustomerInColdCall == NSNumber.init(value: 1)){
                                        tempcustomer.CustomerName = String.init(format:"\(self.tfContactFirstName.text) \(self.tfContactLastName.text)")
                                            tempcustomer.MobileNo = self.tfContactMobileNo.text
                                    }else{
                                        tempcustomer.CustomerName = self.tfCustomerName.text
                                        tempcustomer.MobileNo = self.tfCustomerMobileNo.text
                                        tempcustomer.ContactFirstName = self.tfContactFirstName.text
                                        tempcustomer.ContactLastName =  self.tfContactLastName.text
                                        tempcustomer.ContactNo = self.tfContactMobileNo.text
                                    }
                                 
                                   
                                    if ((self.tfCorporateSelection.text == NSLocalizedString("corporate", comment: "")) || (self.tfCorporateSelection.text == self.activesetting.displayCorporateInCustType))
                                    {
                                        tempcustomer.CompanyTypeID =  1
                                    }else if((self.tfCorporateSelection.text == NSLocalizedString("end_user", comment: "")) || (self.tfCorporateSelection.text == self.activesetting.displayEndUserInCustType)) {
                                        tempcustomer.CompanyTypeID =  2
                                        
                                    }
                                    else if((self.tfCorporateSelection.text == NSLocalizedString("influencer", comment: "")) || (self.tfCorporateSelection.text == self.activesetting.displayInfluencerInCustType)) {
                                        tempcustomer.CompanyTypeID =  3
                                        
                                    }else if((self.tfCorporateSelection.text == NSLocalizedString("retailer", comment: "")) || (self.tfCorporateSelection.text == self.activesetting.displayRetailerInCustType)) { tempcustomer.CompanyTypeID = 4
                                        
                                    }
                                    else{
                                        tempcustomer.CompanyTypeID =  5
                                    }
                                       // tempcustomer.CompanyTypeID = 5
                                   // }
                                    tempcustomer.AddressLine1 =  self.TfAddress1.text
                                    tempcustomer.AddressLine2 = self.TfAddress2.text
                                    tempcustomer.City =  self.TfTown.text
                                    tempcustomer.Country =  self.TfCountry.text
                                    tempcustomer.State = self.TfState.text
                                    tempcustomer.Pincode = self.TfPincode.text
                                    tempcustomer.Lattitude = self.lblLatitude.text
                                    tempcustomer.Longitude = self.lblLongitude.text
                                    unplanobj.tempCustomerObj =  tempcustomer
                                    // unplanobj. = tempcustomer
                                    //  tempcustomer.CompanyTypeID =customerProfile
                                    
                                    custProfile.unplanvisitobj =  unplanobj
                                }
                                self.navigationController?.pushViewController(custProfile, animated: true)
                            }
                        }else{
                            let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate()
                            let dicresponse = arr as? [String:Any] ?? [String:Any]()
                            let coldcallvisit = UnplannedVisit().initwithdic(dict: dicresponse)
                            if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                            if((CLLocationCoordinate2DIsValid(currentCoordinate)) && currentCoordinate.latitude != 0.0 && currentCoordinate.longitude != 0.0){
                                VisitCheckinCheckout.verifyAddress = false
                                VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisitwithdicheckin, objplannedVisit:  PlannVisit() ,objunplannedVisit:coldcallvisit, visitid: NSNumber.init(value:coldcallvisit.localID ?? 0),viewcontroller:self, addressID: NSNumber.init(value:0))
                            }
                            }else{
                                let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                                }
                                Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                                
                            }
                        }
                        }else{
                            let  dicacoldcall  = arr as? [String:Any] ?? [String:Any]()
                            let  coldcallvisit  =  UnplannedVisit().initwithdic(dict: dicacoldcall)
                            print("parameter  = \(param)")
                            NotificationCenter.default.post(name: Notification.Name("updateColdCallData"), object: param, userInfo: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else if(error.code == 0){
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                }else{
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
    
    
    // MARK: UITEXTFIELD DELEGATE
    
}
extension AddUnPlanVisit:ProductSelectionDelegate{
    func addProduct1(product: SelectedProduct) {
        Utils.removeShadow(view: self.view)
        
        
        for prod in arrSelectedProduct{
            if(prod.productID == product.productID){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view:self.view)
                return
            }
        }
        arrSelectedProduct.append(product)
        self.tblProductListHeight.constant = self.tblProduct.contentSize.height
       
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
        self.tblProductListHeight.constant = self.tblProduct.contentSize.height
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
       
        
    }
}
// MARK: UITABLE
extension AddUnPlanVisit:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("no of product = \(arrSelectedProduct.count)")
        return arrSelectedProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell{
            let product = arrSelectedProduct[indexPath.row]
            
            cell.lblProductName.text = product.productName
            cell.tfQty.text = String.init(format:"%@",product.quantity ?? 0)
            if(activesetting.visitProductPermission == 2){
                cell.tfBudget.text = String.init(format:"%@",product.price ?? 0)
                if(cell.tfBudget.text?.count == 0){
                    cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
                }
            }else{
                cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
            }
           // cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
            cell.setProductInfo(pro: product, record: indexPath.row)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteProduct), for: UIControl.Event.touchUpInside)
            cell.contentView.layoutIfNeeded()
            return cell
        }else{
            return UITableViewCell()
        }
    }
    @objc func deleteProduct(sender:UIButton)->(){
        if let localpoint = tblProduct.convert(CGPoint.zero, to: sender) as? CGPoint{
   
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
            self.arrSelectedProduct.remove(at: self.tblProduct.indexPathForRow(at: localpoint)?.row ?? 0)
        
           self.tblProduct.beginUpdates()
         
           self.tblProduct.deleteRows(at: [(self.tblProduct.indexPathForRow(at: localpoint) ?? IndexPath.init(row: 0, section: 0))], with: UITableView.RowAnimation.top)
           self.tblProduct.endUpdates()
              
         /*   self.arrOfProduct.remove(at: sender.tag)
          
             self.tblProduct.beginUpdates()
           
            self.tblProduct.deleteRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: UITableView.RowAnimation.top)
           //  self.tblProduct.deleteRows(at: [self.tblProduct.indexPathForRow(at: sender.tag) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
             self.tblProduct.endUpdates()*/
            if(self.arrSelectedProduct.count == 0){
                
            }
            self.tblProductListHeight.constant = self.tableViewHeight
        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        
    }
    }
//    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
//        return tableView.contentSize.height
//    }
    
}

extension AddUnPlanVisit:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfCorporateSelection){
            chooseCoTypeDropDown.show()
            return false
        }else if(textField == tfDate){
            self.self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datePicker.datePickerMode = .date
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datePicker.date = dateNextActionTime ?? Date()
            return true
        }
        else if(textField == tfTime){
            self.self.dateFormatter.dateFormat = "hh:mm a"
            datePicker.datePickerMode = .time
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datePicker.date = dateNextActionTime ?? Date()
            return true
        }else if(textField == tfAssignTo){
           arrLowerLevelUser = [CompanyUsers]()
            print(BaseViewController.staticlowerUser ?? [CompanyUsers]())
            if(BaseViewController.staticlowerUser.count == 0){
                if let active = CompanyUsers().getUser(userId: self.activeuser?.userID ?? 0) as? CompanyUsers{
                    BaseViewController.staticlowerUser.append(active)
                }
               
            }
            
            
            
            return true
            
           
        }else{
            print(textField)
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == tfContactMobileNo || textField == tfCustomerMobileNo){
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if(textField ==  tfAssignTo){
            let trimmedstring = textField.text?.trimmingCharacters(in: .whitespaces).lowercased()
            if(trimmedstring?.count ?? 0 > 0){
                arrLowerLevelUser = BaseViewController.staticlowerUser
                arrOfLowerLevelUserName =   arrLowerLevelUser.map{
                    String.init(format: "%@ %@", $0.firstName , $0.lastName)
                } as [NSString] as [NSString]
                arrOfFilteredLowerLevelUserName =
                arrOfLowerLevelUserName.filter({(item: NSString) -> Bool in
                    let checkedstr = (textField.text?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                    let stringMatch1 = item.localizedCaseInsensitiveContains(checkedstr)
                    print(item)
                    print(textField.text?.trimmingCharacters(in: .whitespaces) ?? "rege")
                    print(stringMatch1)
                    return stringMatch1
                })
                
                
                arrOfFilteredLowerLeverUser =
                arrLowerLevelUser.compactMap { (temp) -> CompanyUsers in
                    print(temp.firstName)
                    return temp
                }.filter { (aUser) -> Bool in
                    print(aUser.firstName)
                    
                    return aUser.firstName.localizedCaseInsensitiveContains(trimmedstring!) == true
                    //||(aUser.lastName?.localizedCaseInsensitiveContains(trimmedstring ?? "" ) == true)
                }
                // arrOfFilteredLowerLeverUser =
                
                assigneeuserDropDown.dataSource = arrOfFilteredLowerLevelUserName as [String]
                assigneeuserDropDown.reloadAllComponents()
                
                assigneeuserDropDown.show()
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfDate){
            self.self.dateFormatter.dateFormat = "dd-MM-yyyy"
            tfDate.text = self.self.dateFormatter.string(from: datePicker.date)
             strNextActionTime = ""
            if let strdate = tfDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfTime.text{
                strNextActionTime.append("  \(strtime)")
            }
           
            print(strNextActionTime)
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datePicker.date = dateNextActionTime ?? Date()
        }else if(textField == tfTime){
            self.self.dateFormatter.dateFormat = "hh:mm a"
            tfTime.text = self.self.dateFormatter.string(from: datePicker.date)
             strNextActionTime = ""
            if let strdate = tfDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfTime.text{
                strNextActionTime.append("  \(strtime)")
            }
           
            print(strNextActionTime)
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datePicker.date = dateNextActionTime ?? Date()
        }
    }
    
}
extension AddUnPlanVisit:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
        // }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        if(searchBar == searchCustomer){
        //            searchCustomer.endEditing(true)
        //        }else{
        searchAssignUser.endEditing(true)
        //  }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        if(searchBar == searchCustomer){
        //            searchCustomer.endEditing(true)
        //        }else{
        searchAssignUser.endEditing(true)
        // }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        if(searchBar == searchCustomer){
        //            searchCustomer.endEditing(true)
        //        }else{
        searchAssignUser.endEditing(true)
        //  }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedstring = searchBar.text?.trimmingCharacters(in: .whitespaces).lowercased()
        if(searchBar == searchAssignUser){
            arrLowerLevelUser = BaseViewController.staticlowerUser
            arrOfLowerLevelUserName =   arrLowerLevelUser.map{
                String.init(format: "%@ %@", $0.firstName , $0.lastName)
            } as [NSString] as [NSString]
            arrOfFilteredLowerLevelUserName =
                arrOfLowerLevelUserName.filter({(item: NSString) -> Bool in
                    let checkedstr = (searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                    let stringMatch1 = item.localizedCaseInsensitiveContains(checkedstr)
                    print(item)
                    print(searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "rege")
                    print(stringMatch1)
                    return stringMatch1
                })
            
            
            arrOfFilteredLowerLeverUser =
                arrLowerLevelUser.compactMap { (temp) -> CompanyUsers in
                    print(temp.firstName)
                    return temp
                }.filter { (aUser) -> Bool in
                    print(aUser.firstName)
                    
                    return aUser.firstName.localizedCaseInsensitiveContains(trimmedstring!) == true
                    //||(aUser.lastName?.localizedCaseInsensitiveContains(trimmedstring ?? "" ) == true)
                }
            // arrOfFilteredLowerLeverUser =
            
            assigneeuserDropDown.dataSource = arrOfFilteredLowerLevelUserName as [String]
            assigneeuserDropDown.reloadAllComponents()
            
            assigneeuserDropDown.show()
        }
        
        //self.tblCustomer.reloadData()
        // }
    }
}
extension AddUnPlanVisit:locationUpdater{
    func updatecurrentlocation(location: CLLocation,distance:CLLocationDistance){
        if(isEdit == true){
            
        }else{
            if(isFirstTime == false){
                isFirstTime = true
                
                let lastlocation = location
                let coordinate = lastlocation.coordinate
                
              /*  LMGeocoder.sharedInstance().cancelGeocode()
                LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceApple, alternativeService: LMGeocoderServiceApple) { (results, error) in
                    if((results?.count ?? 0 > 0) && (error == nil) ){
                        let address =  results?.first
                        
                        if(address?.formattedAddress?.count ?? 0 > 0){
                            print(address)
                            print("formated  address = \(address?.formattedAddress) ")
                            print("address lines = \(address?.lines) , neighbourhood = \(address?.neighborhood) , raw source = \(address?.rawSource)")
                            print("route = \(address?.route) , administritative area = \(address?.administrativeArea) , sub administrative area = \(address?.subAdministrativeArea) , sublocality = \(address?.subLocality) , locality = \(address?.locality) , street number = \(address?.streetNumber)")
                            
                            var address1 = [String:Any]()
                            var stradd1 = ""
                            if let  strno = address?.streetNumber as? String{
                                stradd1.append(strno)
                            }
                            if let  subadm = address?.subAdministrativeArea as? String{
                                stradd1.append(subadm)
                            }
                            if let adm = address?.administrativeArea as? String{
                                stradd1.append(adm)
                            }
                            if let neighbour = address?.neighborhood as? String{
                                stradd1.append(neighbour)
                            }
                            //address1["AddressLine1"] = String.init(format: "%@  , %@", address?.streetNumber ,address?.route)
                            //String.init(format:"%@ , %@", address?.streetNumber as? CVarArg,address?.route as? CVarArg)
                            address1["AddressLine1"] =  stradd1
                            address1["address2"] = address?.subLocality
                            address1["state"] = address?.administrativeArea
                            address1["city"] = address?.locality
                            address1["country"] = address?.country
                            address1["postalcode"] = address?.postalCode
                            var strlatitude = ""
                            if let strlat = address?.coordinate.latitude as? Double{
                                strlatitude = String(strlat)
                            }
                            address1["latitude"] =  strlatitude
                            var strlongitude = ""
                            if let strlong =  address?.coordinate.longitude as? Double{
                                strlongitude = String(strlong)
                            }
                            address1["longitude"] = strlongitude
                            self.fillupdatedatainUI(dic: address1)
                        }
                        
                    }
                    else{*/
                        self.getAddressFromCurrentLocation { (address,error) in
                            if(error.code == 0 && address.keys.count > 0){
                                self.fillupdatedatainUI(dic: address)
                            }else{
                                Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
                            }
                        }
                   // }
               // }
            }else if(distance > 5){
                let lastlocation = location
            //    let coordinate = lastlocation.coordinate
                
             /*   LMGeocoder.sharedInstance().cancelGeocode()
                LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceApple, alternativeService: LMGeocoderServiceApple) { (results, error) in
                    if((results?.count ?? 0 > 0) && (error == nil) ){
                        let address =  results?.first
                        
                        if(address?.formattedAddress?.count ?? 0 > 0){
                            print(address)
                            print("formated  address = \(address?.formattedAddress) ")
                            print("address lines = \(address?.lines) , neighbourhood = \(address?.neighborhood) , raw source = \(address?.rawSource)")
                            print("route = \(address?.route) , administritative area = \(address?.administrativeArea) , sub administrative area = \(address?.subAdministrativeArea) , sublocality = \(address?.subLocality) , locality = \(address?.locality) , street number = \(address?.streetNumber)")
                            
                            var address1 = [String:Any]()
                            var stradd1 = ""
                            if let  strno = address?.streetNumber as? String{
                                stradd1.append(strno)
                            }
                            if let  subadm = address?.subAdministrativeArea as? String{
                                stradd1.append(subadm)
                            }
                            if let adm = address?.administrativeArea as? String{
                                stradd1.append(adm)
                            }
                            if let neighbour = address?.neighborhood as? String{
                                stradd1.append(neighbour)
                            }
                            //address1["AddressLine1"] = String.init(format: "%@  , %@", address?.streetNumber ,address?.route)
                            //String.init(format:"%@ , %@", address?.streetNumber as? CVarArg,address?.route as? CVarArg)
                            address1["address1"] =  stradd1
                            address1["address2"] = address?.subLocality
                            address1["state"] = address?.locality
                            address1["country"] = address?.country
                            address1["postalcode"] = address?.postalCode
                            var strlatitude = ""
                            if let strlat = address?.coordinate.latitude as? Double{
                                strlatitude = String(strlat)
                            }
                            address1["latitude"] =  strlatitude
                            var strlongitude = ""
                            if let strlong =  address?.coordinate.longitude as? Double{
                                strlongitude = String(strlong)
                            }
                            address1["longitude"] = strlongitude
                            self.fillupdatedatainUI(dic: address1)
                        }
                        // self.lblAddress.text =  address?.formattedAddress
                    }
                    
                    else{*/
                        self.getAddressFromCurrentLocation { (address,error) in
                            if(error.code == 0 && address.keys.count > 0){
                                self.fillupdatedatainUI(dic: address)
                            }else{
                                Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
                            }
                        }
                        //            self.getAddressFromCurrentLocation(address,error){
                        //                if(error.code == 0 && address.allkey.count > 0){
                        //
                        //                }else{
                        //                    common.showalert(error.localizeddescription)
                        //                }
                        //            }
                        
                   // }
                    
               // }
            }
        }
    }
}
extension AddUnPlanVisit:BaseViewControllerDelegate{
    
    func editiconTapped() {
        
    }
    
    func menuitemTouched(item: UPStackMenuItem) {
        
    }
    
    func datepickerSelectionDone() {
        if(datePicker.tag == 0){
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            tfDate.text = Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:self.datePicker.date)
            //self.dateFormatter.string(from: datePicker.date)
        }else if(datePicker.tag == 1){
            self.dateFormatter.dateFormat = "hh:mm a"
            tfTime.text =  self.dateFormatter.string(from: self.datePicker.date)
        }
    }
    
    
}
extension AddUnPlanVisit:MultipleProductSelectionDelegate{
    func addProductFromMultipleSelection(product: SelectedProduct) {
        print("Selected Multiple products \(product)")
        for prod in arrSelectedProduct{
            
            if(prod.productID == product.productID){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view:self.view)
                return
            }
        }
        arrSelectedProduct.append(product)
        tblProductListHeight.constant = tableViewHeight
        print("height of table = \(tableViewHeight)")
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
        tblProductListHeight.constant = tableViewHeight
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
        
    }
}
