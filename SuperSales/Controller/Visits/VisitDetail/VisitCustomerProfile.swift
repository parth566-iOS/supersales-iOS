//
//  VisitCustomerProfile.swift
//  SuperSales
//
//  Created by Apple on 19/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class VisitCustomerProfile: BaseViewController, UITextFieldDelegate {

   // var unplanvisitobj:Visit?
    var unplanvisitobj:UnplannedVisit!
    @IBOutlet weak var lblSellingLighting: UILabel!
    @IBOutlet weak var btnSellingLighting: UIButton!
    
    @IBOutlet weak var lblSellingPhilips: UILabel!
    @IBOutlet weak var btnSellingPhilips: UIButton!
    
    
    @IBOutlet weak var lblInterestedLighting: UILabel!
    @IBOutlet weak var btnInterestedLighting: UIButton!
    
    
    @IBOutlet weak var lblInterestedSellingPhilips: UILabel!
    
    @IBOutlet weak var btnInterestedSellingPhilips: UIButton!
    
    
    @IBOutlet weak var vwComDetTopComp: UIView!
    
    @IBOutlet weak var txtLightSalesValue: UITextField!
    
    
    @IBOutlet weak var txtPhilipsSalesValue: UITextField!
    
    @IBOutlet weak var txtCompetitorName1: UITextField!
    
    @IBOutlet weak var txtCompetitorName2: UITextField!
    
  //  @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblSubCatTotal: UILabel!
    
    
    @IBOutlet weak var btnOrderExpectedDate: UIButton!
    
    
    @IBOutlet weak var vwOrderEDateBottom: UIView!
    
    @IBOutlet weak var txtOrderExpectedDate: UITextField!
    
    // BOOL isSellingLightPro,isSellingPro,isInterestedLight,isInterestedPhilips,isDone;
    var isSellingLightPro:Bool! =  false
    var isSellingPro:Bool! =  false
    var isInterestedLight:Bool! =  false
    var isInterestedPhilips:Bool! =  false
    var isDone:Bool! =  false
    var datePicker:UIDatePicker!
    var isOpenSubCategory:Bool!
    @IBOutlet weak var btnSubmit: UIButton!
    var customerprofile : VisitTempCustomerProfile?
    var arrSubCategory:[[String:Any]] = [[String:Any]]()
    
    @IBOutlet var vwSellingLighting: UIView!
    
    
    @IBOutlet var vwSellingPhilips: UIView!
    
    
    @IBOutlet var vwInterestedLighting: UIView!
    
    
    @IBOutlet var vwSubCat: UIView!
    
    @IBOutlet var vwInterestedSellingPhillips: UIView!
    @IBOutlet var vwExpectedDate: UIView!
    
    @IBOutlet weak var cnstTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblSubCategory: UITableView!
    //var objVisitTempCustomerProfile:VisitTempCustomerProfile!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblSubCategory.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblSubCategory.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    // MARK: - Method

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){

            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.cnstTblHeight.constant = newsize.height
            }
        }
    }
    func setUI(){
        vwInterestedLighting.isHidden = false
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.title = NSLocalizedString("customer_profile", comment:"")
        txtLightSalesValue.placeholder = String.init(format:"%@ (%@)",NSLocalizedString("lighting_share_value", comment: ""),self.activeuser?.company?.currCode ?? "$")
        txtPhilipsSalesValue.placeholder = String.init(format:"%@ Sales Value (%@)",self.activeuser?.company?.brandName ?? "",self.activeuser?.company?.currCode ?? "$")
        txtCompetitorName1.placeholder = NSLocalizedString("top1_competitor_name", comment: "")
        
         txtCompetitorName2.placeholder = NSLocalizedString("top2_competitor_name", comment: "")
        
        txtPhilipsSalesValue.isHidden = true
        self.initialise()
        datePicker = UIDatePicker.init()
        datePicker.setCommonFeature()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtOrderExpectedDate.inputView = datePicker
        txtOrderExpectedDate.delegate = self
        
        txtLightSalesValue.setCommonFeature()
        txtPhilipsSalesValue.setCommonFeature()
        txtCompetitorName1.setCommonFeature()
        txtCompetitorName2.setCommonFeature()
        txtOrderExpectedDate.setCommonFeature()
        
        
        txtOrderExpectedDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: datePicker.date, format: "dd-MM-yyyy")
        
    }
    func initialise(){
        if let profile = unplanvisitobj.tempCustomerObj?.customerProfile as?  VisitTempCustomerProfile{
            customerprofile =  profile
            isSellingLightPro = profile.sellingCompanySegmentProduct
            isSellingPro = profile.sellingCompanyProduct
            isInterestedLight =  profile.interestedinCompanySegmentProduct
            isInterestedPhilips =  profile.interestedinCompanyProduct
            if(isSellingLightPro == true){
                btnSellingLighting.isSelected = true
                self.configureSellingLightProductBox(configure: true)
                if(isSellingPro == true){
                btnSellingPhilips.isSelected = true
                self.configureSellingPhilipsProductBox(configure: true)
                self.configureInterestedSellingPhilipsProductBox(configure: false)
                self.configureInterestedSellingLightProductBox(configure: false)
                }else{
                     btnSellingPhilips.isSelected = false
                    self.configureInterestedSellingPhilipsProductBox(configure: true)
                    if(isInterestedPhilips == true){
                        btnInterestedSellingPhilips.isSelected = true
                    }else{
                        btnInterestedSellingPhilips.isSelected = false
                    }
                    self.configureInterestedSellingLightProductBox(configure: false)
                    self.configureInterestedSellingPhilipsProductBox(configure: true)
                }
            }else{
                btnSellingLighting.isSelected = false
                btnSellingPhilips.isSelected = false
                self.configureSellingLightProductBox(configure: true)
                self.configureInterestedSellingLightProductBox(configure: true)
                self.configureInterestedSellingPhilipsProductBox(configure: false)
                if(isInterestedLight == true){
                    self.configureInterestedSellingPhilipsProductBox(configure: true)
                    btnInterestedLighting.isSelected = true
                    if(isInterestedPhilips == true){
                        btnInterestedSellingPhilips.isSelected = true
                    }else{
                        btnInterestedSellingPhilips.isSelected =  false
                    }
                }else{
                    btnInterestedLighting.isSelected = false
                    btnInterestedSellingPhilips.isSelected =  false
                    self.configureInterestedSellingPhilipsProductBox(configure: false)
                }
            }
        
            txtLightSalesValue.text = String.init(format: "%ld", unplanvisitobj.tempCustomerObj?.customerProfile?.companySegmentProductValue ?? 0)
            txtCompetitorName1.text =  unplanvisitobj.tempCustomerObj?.customerProfile?.competitor1
            txtCompetitorName2.text = unplanvisitobj.tempCustomerObj?.customerProfile?.competitor2
        var arrCat = ProdCategory.getAll()
        
        arrCat =  arrCat.filter({
            $0.productSubCategory.count > 0
        })
        
      //  arrSubCategory
        
        for cat in arrCat{
            var dicsubcat = [String:Any]()
            dicsubcat["Name"] = cat.name
            dicsubcat["ID"] = cat.iD
            var arrSubCat = [[String:Any]]()
            for subcat in 0...cat.productSubCategory.count-1{
                let subcategory = cat.productSubCategory[subcat] as? ProductSubCat
                var dict = [String:Any]()
                dict["Name"] = subcategory?.name
                dict["ID"] =  subcategory?.iD
                dict["Quantity"] = NSNumber.init(value:0)
                dict["Interested"] = NSNumber.init(value:0)
                arrSubCat.append(dict)
            }
            dicsubcat["subCategory"] = arrSubCat
            arrSubCategory.append(dicsubcat)
        }
         
            if let customerprofile = unplanvisitobj.tempCustomerObj?.customerProfile as?
            VisitTempCustomerProfile{
            if(customerprofile.subCategoryShareList?.count ?? 0 > 0 ){
            for subcatshare in 0...(customerprofile.subCategoryShareList?.count ?? 0) - 1{
                if let dicCat = customerprofile.subCategoryShareList?[subcatshare] as? SubCategoryShare{
                if(arrSubCategory.count  > 0){
                for scs in 0...arrSubCategory.count - 1{
                    var dicProdCat = arrSubCategory[scs]
                    if(NSNumber.init(value:dicProdCat["ID"] as? Int ?? 0) == dicCat.subCategoryID){
                        dicProdCat["Quantity"] = dicCat.categoryExpectedValue
                        dicProdCat["Interested"] = NSNumber.init(value:1)
                    }
                    arrSubCategory.remove(at: scs)
                    arrSubCategory.insert(dicProdCat, at: scs)
                }
                }
                customerprofile.subCategoryShareList?.remove(at: subcatshare)
                customerprofile.subCategoryShareList?.insert(dicCat, at: subcatshare)
                }
                }
            }
            self.shownSubCatProducts(isShow: true)
        }
        self.designAsPerAllFlag()
    }
        else{
            isSellingPro =  false
            isSellingLightPro = false
            isInterestedLight = false
            isInterestedPhilips =  false
            btnSellingLighting.isSelected = true
            
            vwComDetTopComp.isHidden = true
            self.commonMethodForAllQueSwitch(btnSellingLighting)
            self.view.layoutIfNeeded()
            txtPhilipsSalesValue.isHidden = false
            var arrCat = ProdCategory.getAll()
                   arrCat =  arrCat.filter({
                       $0.productSubCategory.count > 0
                   })
            arrSubCategory = [[String:Any]]()
            for pcat in  arrCat{
                var dicsubcat = [String:Any]()
                dicsubcat["Name"]  = pcat.name
                dicsubcat["ID"] = pcat.iD
            
            var arysubcat = [[String:Any]]()
                let tempprodsubcat = ProductSubCat.getSubProductFromCategoryID(categoryID: NSNumber.init(value:pcat.iD))
                for psc in tempprodsubcat{
                    var dict = [String:Any]()
                    dict["Name"] =  psc.name
                    dict["ID"] =  psc.iD
                    dict["Quantity"] = NSNumber.init(value:0)
                    arysubcat.append(dict)
                }
//                if(arysubcat.count > 0 ){
                    dicsubcat["subCategory"] = arysubcat
                    arrSubCategory.append(dicsubcat)
               // }
            }
           
        }
    }
    
    func designAsPerAllFlag(){
       
        self.cnstTblHeight.constant = tblSubCategory.contentSize.height
        
        tblSubCategory.isHidden  = true
         if((isSellingPro == true) && (isSellingLightPro == true)){
        vwComDetTopComp.isHidden = false
        
        txtPhilipsSalesValue.isHidden = true
            vwInterestedSellingPhillips.isHidden = true
            vwInterestedLighting.isHidden = true
            lblSubCatTotal.isHidden = false
            vwExpectedDate.isHidden = false
            vwSubCat.isHidden = false
            tblSubCategory.isHidden = false
            vwOrderEDateBottom.isHidden = true
       // txt
      //      Cnst Philips Sales Value Total Heigh
        self.shownSubCatProducts(isShow: true)
            if let customerprofile = unplanvisitobj.tempCustomerObj?.customerProfile as? VisitTempCustomerProfile{
              //  btnSubmit.setTitle(NSLocalizedString("create_new_customer", comment: ""), for: .normal)
                btnSubmit.setbtnFor(title:NSLocalizedString("submit", comment: ""), type: Constant.kPositive)
               
            }else{
                btnSubmit.setbtnFor(title:NSLocalizedString("create_new_customer", comment: ""), type: Constant.kPositive)
                // btnSubmit.setTitle(NSLocalizedString("create_new_customer", comment: ""), for: .normal)
             //   btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
            }
            
            self.fillOrderExpectedDateIfUpdated()
            isDone = true
            self.calSubCatTotal()
        }
         else if((isSellingPro == false) && (isSellingLightPro == true) && (isInterestedPhilips == true)){
            vwComDetTopComp.isHidden = false
            txtPhilipsSalesValue.isHidden = true
            vwOrderEDateBottom.isHidden = true
            vwExpectedDate.isHidden = false
            lblSubCatTotal.isHidden = false
            vwSubCat.isHidden = false
            tblSubCategory.isHidden = false
            self.shownSubCatProducts(isShow: true)
            if let customerprofile = unplanvisitobj.tempCustomerObj?.customerProfile as? VisitTempCustomerProfile{
                btnSubmit.setbtnFor(title:NSLocalizedString("submit", comment: ""), type: Constant.kPositive)
             //   btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
            }else{
                btnSubmit.setbtnFor(title:NSLocalizedString("create_new_customer", comment: ""), type: Constant.kPositive)
               //  btnSubmit.setTitle(NSLocalizedString("create_new_customer", comment: ""), for: .normal)
            }
           
            
            self.fillOrderExpectedDateIfUpdated()
            isDone = true
            self.calSubCatTotal()
            
            
        }
        else if((isInterestedLight == true) && (isSellingLightPro == false) && (isInterestedPhilips == true)){
            vwComDetTopComp.isHidden = true
            tblSubCategory.isHidden  = false
            txtPhilipsSalesValue.isHidden = true
            self.shownSubCatProducts(isShow: true)
            if let customerprofile = unplanvisitobj.tempCustomerObj?.customerProfile as? VisitTempCustomerProfile{
                btnSubmit.setbtnFor(title:NSLocalizedString("submit", comment: ""), type: Constant.kPositive)
              //  btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
            }else{
                btnSubmit.setbtnFor(title:NSLocalizedString("create_new_customer", comment: ""), type: Constant.kPositive)
                // btnSubmit.setTitle(NSLocalizedString("create_new_customer", comment: ""), for: .normal)
            }
            lblSubCatTotal.isHidden = false
            vwSubCat.isHidden = false
            vwExpectedDate.isHidden =  false
            vwOrderEDateBottom.isHidden = true
            self.fillOrderExpectedDateIfUpdated()
            isDone = true
            self.calSubCatTotal()
        }else{
            vwComDetTopComp.isHidden = true
            txtPhilipsSalesValue.isHidden = true
            if((isSellingPro == false) && (isSellingLightPro == false) && (isInterestedPhilips == false) && (isInterestedLight == false) ){
                vwInterestedLighting.isHidden = false
            vwInterestedSellingPhillips.isHidden = true
            }else if((isSellingPro == false) && (isSellingLightPro == false)){
                vwInterestedSellingPhillips.isHidden = false
               
                
            }
            vwSubCat.isHidden = true
            self.shownSubCatProducts(isShow: false)
            btnSubmit.setbtnFor(title:NSLocalizedString("submit", comment: ""), type: Constant.kPositive)

           //  btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
            lblSubCatTotal.isHidden = true
            vwExpectedDate.isHidden = true
            vwOrderEDateBottom.isHidden  = true
            isDone = false
            self.calSubCatTotal()
        }
    }
    
    func calSubCatTotal(){
        var total = 0
        for scat in arrSubCategory{
            if  let arrsubcat = scat["subCategory"] as? [[String:Any]]{
            for procat in arrsubcat{
                if(NSNumber.init(value:procat["Interested"] as? Int ?? 0)  == NSNumber.init(value: 1)){
                    //total += Int(procat["Quantity"])
                    if let subtotal = procat["Quantity"] as? Int{
                        total += subtotal
                    }else{
                       
                        let subt = Int(procat["Quantity"] as? String ?? "0")
                       
                        total += subt ?? 0
                    }
                }
            }
            }
        }
        lblSubCatTotal.text =  String.init(format:"Subcategory Total: %ld",total)
       
    }
    
    func fillOrderExpectedDateIfUpdated(){
    
        if let customerprofile = unplanvisitobj.tempCustomerObj?.customerProfile as? VisitTempCustomerProfile{
            if(customerprofile.orderExpectedDate?.count ?? 0 > 0){
            btnOrderExpectedDate.isSelected = true
            let edate = Utils.getDateFromStringWithFormat(gmtDateString: customerprofile.orderExpectedDate ?? "22-03-2004")
            datePicker.date =  edate
            txtOrderExpectedDate.text = Utils.getDateWithAppendingDay(day: 0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
            vwOrderEDateBottom.isHidden =  false
            }else{
                
                txtOrderExpectedDate.text = Utils.getDateWithAppendingDay(day: 0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
            }
            
        }
    }
    
    func shownSubCatProducts(isShow:Bool){
        if(isShow == true){
            isOpenSubCategory =  true
        }else{
            isOpenSubCategory = false
            
        }
        self.cnstTblHeight.constant = tblSubCategory.contentSize.height
        tblSubCategory.reloadData()
        self.cnstTblHeight.constant = tblSubCategory.contentSize.height
    }
    
    func configureSellingLightProductBox(configure:Bool){
        if(configure == true){
            lblSellingLighting.text = NSLocalizedString("is_selling_lighting_products", comment:"")
            lblSellingLighting.isHidden = false
            btnSellingLighting.isHidden = false
        }else{
            lblSellingLighting.text = ""
            lblSellingLighting.isHidden = true
            btnSellingLighting.isHidden = true
        }
    }
    //configureSellingPhilipsProductBox
    func configureSellingPhilipsProductBox(configure:Bool){
        if(configure == true){
            lblSellingPhilips.text = NSLocalizedString("is_selling_philips", comment:"")
            lblSellingPhilips.isHidden = false
            btnSellingPhilips.isHidden = false
        }else{
            lblSellingPhilips.text = ""
            lblSellingPhilips.isHidden = true
            btnSellingPhilips.isHidden = true
        }
    }
    
    func configureInterestedSellingLightProductBox(configure:Bool){
           if(configure == true){
               lblInterestedLighting.text = NSLocalizedString("is_interested_in_selling_light_products", comment:"")
            lblInterestedLighting.isHidden = false
            btnInterestedLighting.isHidden = false
           }else{
               lblInterestedLighting.text = ""
            lblInterestedLighting.isHidden = true
            btnInterestedLighting.isHidden = true
           }
       }
    
    func configureInterestedSellingPhilipsProductBox(configure:Bool){
              if(configure == true){
                            lblInterestedSellingPhilips.text = NSLocalizedString("is_interested_in_selling_philips", comment:"")
                lblInterestedSellingPhilips.isHidden = false
                btnInterestedSellingPhilips.isHidden = false
                        }else{
                            lblInterestedSellingPhilips.text = ""
                            lblInterestedSellingPhilips.isHidden = true
                            btnInterestedSellingPhilips.isHidden = true
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
    
    @IBAction func submit(_ sender: UIButton) {
      
        if(isDone == true){
            if(vwComDetTopComp.isHidden == false){
                if(txtLightSalesValue.text ==  "0" || txtLightSalesValue.text?.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_enter_lighting_share_value", comment: ""),view: self.view)
                    return
                }
                if(txtCompetitorName1.text?.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_enter_competitor_name", comment: ""),view: self.view)
                    return
                }
                if(txtCompetitorName2.text?.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_enter_competitor_name", comment: ""),view: self.view)
                    return
                }
            }else{
                txtCompetitorName1.text = ""
                txtCompetitorName2.text = ""
            }
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var total = 0
            for scat in arrSubCategory{
                if  let arrsubcat = scat["subCategory"] as? [[String:Any]]{
                for procat in arrsubcat{
                    if(NSNumber.init(value:procat["Interested"] as? Int ?? 0)  == NSNumber.init(value: 1)){
                        //total += Int(procat["Quantity"])
                        if let subtotal = procat["Quantity"] as? Int{
                            total += subtotal
                        }else{
                           
                            let subt = Int(procat["Quantity"] as? String ?? "0")
                           
                            total += subt ?? 0
                        }
                    }
                }
            }
        }
        
            var visitCustomerProfile = [String:Any]()
            if let custp = customerprofile as? VisitTempCustomerProfile{
                visitCustomerProfile["ID"] = custp.iD
            }
            var jsonarr = [[String:Any]]()
            if(arrSubCategory.count > 0){
                for subcat in arrSubCategory{
                    if let arrprodcat = subcat["subCategory"] as? [[String:Any]]{
                    for dicprodcat in arrprodcat{
                        if((Int(dicprodcat["Quantity"] as? String ?? "0") ?? 0 > 0)){
                            if let interested = dicprodcat["Interested"] as? Bool{
                                if(interested){
                            var jsonObj = [String:Any]()
                            jsonObj["subCategoryID"] = dicprodcat["ID"]
                            jsonObj["categoryExpectedValue"] = dicprodcat["Quantity"]
                                    if(interested == true){
                                        jsonObj["categoryInterested"] = NSNumber.init(value:1)
                                    }else{
                                        jsonObj["categoryInterested"] = NSNumber.init(value:0)
                                    }
                            jsonarr.append(jsonObj)
                                }
                            }
                        }
                    }
                    }
                }
              
                        visitCustomerProfile["createdBy"] = self.activeuser?.userID
                        visitCustomerProfile["visitID"] = self.unplanvisitobj.localID
                        visitCustomerProfile["tempCustomerID"] = self.unplanvisitobj.tempCustomerID
                        if(isSellingLightPro){
                            visitCustomerProfile["sellingCompanySegmentProduct"] = NSNumber.init(value: 1)
                        }else{
                            visitCustomerProfile["sellingCompanySegmentProduct"] = NSNumber.init(value: 0)
                        }
                        if(isSellingPro){
                            visitCustomerProfile["sellingCompanyProduct"] = NSNumber.init(value: 1)
                        }else{
                            visitCustomerProfile["sellingCompanyProduct"] = NSNumber.init(value: 0)
                        }
                        if(isInterestedLight){
                            visitCustomerProfile["interestedinCompanySegmentProduct"] = NSNumber.init(value: 1)
                        }else{
                            visitCustomerProfile["interestedinCompanySegmentProduct"] = NSNumber.init(value: 0)
                        }
                        if(isInterestedPhilips){
                            visitCustomerProfile["interestedinCompanyProduct"] = NSNumber.init(value: 1)
                        }else{
                            visitCustomerProfile["interestedinCompanyProduct"] = NSNumber.init(value: 0)
                        }
                visitCustomerProfile["companySegmentProductValue"] = NSNumber.init(value:Int(txtLightSalesValue.text ?? "0") ?? 0 )
                        visitCustomerProfile["companyProductValue"] = NSNumber.init(value: 0)
                        visitCustomerProfile["competitor1"] = txtCompetitorName1.text
                        visitCustomerProfile["competitor2"] = txtCompetitorName2.text
             
                        visitCustomerProfile["subCategoryShareList"] = jsonarr
               
                        if(btnOrderExpectedDate.isSelected){
                            visitCustomerProfile["orderExpectedDate"] = String.init(format:"\(Utils.getDateWithAppendingDayLang(day: 0, date: datePicker.date, format: "yyyy/MM/dd")) 00:00:00")
                        }
                        var mainDic = Common.returndefaultparameter()
                        var strurl = ""
                        if let custp = customerprofile{
                            mainDic["updateTempCustomerProfileJson"] = Common.returnjsonstring(dic: visitCustomerProfile)
                            strurl = ConstantURL.kWSUrlUpdateTempCustomerProfile
                        }else{
                            mainDic["addTempCustomerProfileJson"] = Common.returnjsonstring(dic: visitCustomerProfile)
                            strurl = ConstantURL.kWSUrlAddTempCustomerProfile
                        }
                       
                        self.apihelper.getdeletejoinvisit(param: mainDic, strurl: strurl, method: Apicallmethod.post)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            SVProgressHUD.dismiss()
                            print("arr = \(arr)")
                            print(error)
                            print(status)
                            let dic = arr as? [String:Any] ?? [String:Any]()
                            if(status.lowercased() == Constant.SucessResponseFromServer){
                               
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                if let custp = self.customerprofile  as? VisitTempCustomerProfile{
                                    self.unplanvisitobj.tempCustomerObj?.customerProfile = VisitTempCustomerProfile().initwithdic(dict: dic)
                                    self.navigationController?.popViewController(animated: true)
                                }else{
                                    self.unplanvisitobj.tempCustomerObj?.customerProfile = VisitTempCustomerProfile().initwithdic(dict: dic)
                                    if let addCustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                                        SVProgressHUD.show()
                                        AddCustomer.isFromInfluencer = 0
                                        addCustomer.isForAddAddress = false
                                    addCustomer.isVendor = false
                                    addCustomer.isFromColdCallVisit = true
                                    addCustomer.isEditCustomer = false

                              
                                    addCustomer.origiAssigneeFromCCVisit = self.unplanvisitobj.originalAssignee
                                    addCustomer.tempCustomer = self.unplanvisitobj.tempCustomerObj
                                    addCustomer.selectedCustomerForUnplan = self.unplanvisitobj.tempCustomerObj

                                    self.navigationController?.pushViewController(addCustomer, animated: true)
                                        SVProgressHUD.dismiss()
                                    }
                                    
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
            
            
        }
            else{
          //  SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            Utils.toastmsg(message:"Thank you",view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               

if(self.navigationController?.viewControllers.count ?? 0 > 0){
    SVProgressHUD.dismiss()
    if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                       if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                           self.navigationController?.popToViewController(controller,animated:true)
                       }
                   }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                    if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                        self.navigationController?.popToViewController(controller,animated:true)
                    }else{
   // self.navigationController?.popToViewController(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 2) - 2] ?? self.navigationController?.viewControllers.last ?? UIViewController(), animated: true)
    self.navigationController?.popViewController(animated:true)
                   }
                   }else if(self.activesetting.customerProfileInUnplannedVisit == NSNumber.init(value: 1)){
                      
                    self.navigationController?.popToViewController(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 2) - 3] ?? self.navigationController?.viewControllers.last ?? UIViewController(), animated: true)
                       
                   }else{
                    self.navigationController?.popViewController(animated:true)
                   }
        
}else{
    self.navigationController?.popViewController(animated:true)
}
    }
            }
    }
    @IBAction func commonMethodForAllQueSwitch(_ sender: UIButton) {
        
       
        
        sender.isSelected =  !sender.isSelected
        switch sender.tag {
        case 1:
         if(sender.isSelected){
                isSellingLightPro = true
               isSellingPro = true
                btnSellingPhilips.isSelected = true
                self.configureSellingPhilipsProductBox(configure: true)
                self.configureInterestedSellingLightProductBox(configure: false)
                self.configureInterestedSellingPhilipsProductBox(configure: false)
    vwSellingPhilips.isHidden = false
            }else{
                vwSellingPhilips.isHidden = true
                isSellingLightPro =  false
                isSellingPro = false
                isInterestedLight = false
                isInterestedPhilips = false
                self.configureSellingPhilipsProductBox(configure: false)
                self.configureInterestedSellingLightProductBox(configure: true)
                self.configureInterestedSellingPhilipsProductBox(configure: false)
                
            }
            break
            case 2:
                if(sender.isSelected){
                   isInterestedLight = false
                   isSellingPro = true
                   isInterestedPhilips = false
                    btnInterestedLighting.isSelected = false
                    btnInterestedSellingPhilips.isSelected = false
                    vwInterestedSellingPhillips.isHidden = false
                    self.configureInterestedSellingLightProductBox(configure: false)
                    self.configureInterestedSellingPhilipsProductBox(configure: false)
                }else{
               
                    isSellingPro = false
                    isInterestedLight = false
                    isInterestedPhilips = false
                    vwInterestedSellingPhillips.isHidden = false
                    btnInterestedLighting.isSelected = false
                    btnInterestedSellingPhilips.isSelected = false
                    self.configureInterestedSellingLightProductBox(configure: false)
                    self.configureInterestedSellingPhilipsProductBox(configure: true)
                    
                }
                break
            case 3:
            if(sender.isSelected){
            vwInterestedSellingPhillips.isHidden = false
            isInterestedLight = true
                             
            isInterestedPhilips = false
                              btnInterestedSellingPhilips.isSelected = false
                              
                              btnInterestedSellingPhilips.isSelected = false
                              
        self.configureInterestedSellingPhilipsProductBox(configure: true)
                              
                          }else{
                            vwInterestedSellingPhillips.isHidden = true
            isInterestedLight = false
            isInterestedPhilips = false
                             
                              
    self.configureInterestedSellingPhilipsProductBox(configure: false)
                              
                          }
                          break
        
        case 4:
            if(sender.isSelected){
                isInterestedPhilips = true
            }else{
                isInterestedPhilips = false
            }
        
            break
        default: break
            
        }
        btnOrderExpectedDate.isSelected = false
        self.designAsPerAllFlag()
    }
    
    @IBAction func orderExpectedDate(_ sender: UIButton) {
        sender.isSelected =  !sender.isSelected
        if(sender.isSelected){
            vwOrderEDateBottom.isHidden = false
        }else{
            vwOrderEDateBottom.isHidden = true
        }
    }
    
    @IBAction func selectFollowDate(_ sender: UIButton) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == txtOrderExpectedDate){
            textField.text = dateFormatter.string(from: datePicker.date)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == txtOrderExpectedDate){
        textField.text = dateFormatter.string(from: datePicker.date)
            self.fillOrderExpectedDateIfUpdated()
        }
        
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
        if(textField == txtPhilipsSalesValue || textField == txtLightSalesValue){
        if(updatedText.count < 13){
            if(textField == txtPhilipsSalesValue){
                if(Int(updatedText) ?? 0 > 0){
                    vwSubCat.isHidden = false
                  //  isEnteredCompShareValue = true
                }else{
                    vwSubCat.isHidden = true
                  //  isEnteredCompShareValue = false
                }
//                tblView.reloadData()
//                cnstTableViewHeight.constant = tableViewHeight
            }
        }else{
            return false
            }
        }
        }

        return true
    }
}

extension VisitCustomerProfile: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(isOpenSubCategory){
            print(arrSubCategory.count)
            return arrSubCategory.count
        }else{
            return 0
        }
    }
        
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let dic = arrSubCategory[section]
//        let dicSubCategory = dic["subCategory"]
//        print(dicSubCategory)
//        if(isOpenSubCategory){
//            return 1
//        }else{
//            return 0
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isOpenSubCategory == true){
            let dicsubCat  = arrSubCategory[section]
            if  let arrsubcattbl = dicsubCat["subCategory"] as? [[String:Any]]{
               
            return arrsubcattbl.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "countersharesubcatcell") as? CountershareSubcatCell{
          
            cell.selectionStyle = .none
            cell.delegate = self
            if  let arrSubCat =  arrSubCategory[indexPath.section] as? [String:Any]{
                if(arrSubCat.keys.contains("subCategory")){
                    var arrsubcat = arrSubCat
                    if    let arrcatdic = arrSubCat["subCategory"] as? [[String:Any]]{
                        var arrOfSubCat = arrcatdic
                        var dict = arrcatdic[indexPath.row]
                        if(isInterestedPhilips){
                            cell.lblSubCatName.text =  String.init(format:"Interested \(dict["Name"] as? String ?? "")")
                        }else{
                            cell.lblSubCatName.text =  String.init(format:"Selling \(dict["Name"] as? String ?? "")")
                        }
                        cell.lblSubCatName.textColor = UIColor.gray
                        cell.cellCompeletion(dic: dict) { (Cell) in
                            
                            dict["Quantity"] = cell.txtQty.text
                            print(arrOfSubCat)
                            arrOfSubCat.remove(at: indexPath.row)
                            arrOfSubCat.insert(dict, at: indexPath.row)
                            print(arrOfSubCat)
                            arrsubcat["subCategory"] = arrOfSubCat
                            self.arrSubCategory.remove(at: indexPath.section)
                            print(self.arrSubCategory)
                            self.arrSubCategory.insert(arrsubcat, at: indexPath.section)
                            print(self.arrSubCategory)
                            self.tblSubCategory.reloadData()
                            self.calSubCatTotal()
                        }
                    }
                }
          //  cell.lblCatName.text = cat["Name"] as? String ??  "catname"
            }
            
            if(cell.btnSwitch.isSelected){
                cell.txtQty.isHidden = false
            }else{
            cell.txtQty.isHidden = true
            }
            cell.btnSwitch.tag = indexPath.row
            cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
            cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.selected)
           // cell.btnSwitch.addTarget(self, action: #selector(isProductCategoryInterested), for: UIControl.Event.touchUpInside)
           
            
        return cell
        }else{
          return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width
            
            
            , height: 20))
        let lblcatname = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: tableView.frame.size.width,height: 18))
        lblcatname.font = UIFont.systemFont(ofSize: 18)
        lblcatname.textColor =    UIColor().colorFromHexCode(rgbValue:(0x2196F3))
        //Common().UIColorFromRGB(rgbValue: 0x464646)
        let dic = arrSubCategory[section]
      
        lblcatname.text = dic["Name"] as? String
        view.addSubview(lblcatname)
        view.backgroundColor =  UIColor.clear
        
        return view
    }
    
   /* @objc func isProductCategoryInterested(sender:UIButton,cell:CountershareSubcatCell){
//        NSMutableDictionary *dict = [[arySubCategories objectAtIndex:localPoint.section][@"subCategory"] objectAtIndex:localPoint.row];
//        [dict setObject:[btnSwitch isSelected]?@1:@0 forKey:@"Quantity"];
       /*  UIButton *btnSwitch = (UIButton *)sender;
          btnSwitch.selected = !btnSwitch.isSelected;
          NSIndexPath *localPoint = [tblView indexPathForRowAtPoint:[tblView convertPoint:CGPointZero fromView:sender]];*/
        let btnSwitch = sender
        btnSwitch.isSelected =  !btnSwitch.isSelected
        let indexPath = tblSubCategory.indexPathForRow(at: tblSubCategory.convert(CGPoint.zero, to: sender))

//        var cell =  tblSubCategory.cellForRow(at: indexPath ?? IndexPath.init(row: sender.tag, section: )) as? CountershareSubcatCell
            if(sender.isSelected){
                cell.txtQty.isHidden  = false
            }else{
                cell.txtQty.isHidden  = true
            }
        
        let arrSubCat = arrSubCategory[indexPath?.section ?? 0]
        
        if var dic = arrSubCat["subCategory"] as? [[String:Any]]{
//            var catdic = dic[indexPath?.row ?? 0]
//            if(btnSwitch.isSelected ==  true){
//                catdic["Quantity"] = NSNumber.init(value:1)
//            }else{
//                   catdic["Quantity"] = NSNumber.init(value:0)
//            }
            
            for i in 0..<dic.count {
                var dicsubcat = dic[i]
               // dic.remove(at: i)
                if(i == indexPath?.row){
                     if(btnSwitch.isSelected ==  true){
                        dicsubcat["Quantity"] = NSNumber.init(value:1)
                                }else{
                        dicsubcat["Quantity"] = NSNumber.init(value:0)
                    }
                    dic.remove(at: i)
                    dic.insert(dicsubcat, at: i)
                    
                }
            }
//        let dicsubcat = dic?[indexPath?.row ?? 0]

//        }
        
        }
    }*/
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return  10
    }
    
    
}
extension VisitCustomerProfile:CountershareSubcatCellDelegate{
    func switchClicked(sender: UIButton, cell: CountershareSubcatCell) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            cell.txtQty.isHidden  = false
        }else{
            cell.txtQty.isHidden  = true
        }
        cell.txtQty.setCommonFeature()
    
        cell.txtQty.delegate = self
        cell.txtQty.keyboardType = .numberPad
        let indexPath = self.tblSubCategory.indexPath(for: cell)
        var arrSubCat = arrSubCategory[indexPath?.section ?? 0]
        
        if var dic = arrSubCat["subCategory"] as? [[String:Any]]{

            for i in 0..<dic.count {
                var dicsubcat = dic[i]
               // dic.remove(at: i)
                if(i == indexPath?.row){
                     if(sender.isSelected ==  true){
                        dicsubcat["Interested"] = NSNumber.init(value:1)
                                }else{
                        dicsubcat["Interested"] = NSNumber.init(value:0)
                    }
                    
                    dic.remove(at: i)
                    dic.insert(dicsubcat, at: i)
                   
                }
            }
            arrSubCat["subCategory"] = dic
         
            arrSubCategory.remove(at: indexPath?.section ?? 0)
            arrSubCategory.insert(arrSubCat, at: indexPath?.section ?? 0)
    }
        self.tblSubCategory.reloadData()
      
        self.cnstTblHeight.constant =  self.tblSubCategory.contentSize.height
    }
}

//extension VisitCustomerProfile:UITextFieldDelegate{
//
//}
