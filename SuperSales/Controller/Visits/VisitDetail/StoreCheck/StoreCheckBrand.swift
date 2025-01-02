//
//  StoreCheckBrand.swift
//  SuperSales
//
//  Created by Apple on 19/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import CoreLocation

class StoreCheckBrand: BaseViewController {
    var parentBrandActivityList:[StoreCheckBrandActivity]!
    static var mutActivityList:[StoreCheckBrandActivity] = [StoreCheckBrandActivity]()
    var obj:StoreCheckContainer!
    var choosecondition:DropDown =  DropDown()
    var chooseJustification:DropDown = DropDown()
    var browser:IDMPhotoBrowser! = IDMPhotoBrowser()
    var selectedIndex:IndexPath!
//    var justificationID:NSNumber = 0
//    var justificationName:String = ""
    
    @IBOutlet weak var tblStoreCheckBrand: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    var arrOfImg:[IDMPhoto] = [IDMPhoto]()
    
    override func viewDidLoad() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3,execute: {
        super.viewDidLoad()
            StoreCheckContainer().containerDelegate = self
            self.setUI()
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name?.init(NSNotification.Name(rawValue: "StoreDataUpdate")), object: nil)
      //  mutActivityList = StoreCheckContainer.storeCheckBrandActivityList
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name?.init(NSNotification.Name(rawValue: "StoreDataUpdate")), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
         
        super.viewDidAppear(true)
        if(StoreCheckContainer.visitBrandActivityExists == true){
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.isHidden = true
        }else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
        if(StoreCheckContainer.visitType == VisitType.planedvisitHistory || StoreCheckContainer.visitType  == VisitType.coldcallvisitHistory){
            btnSubmit.isHidden = true
            
            btnSubmit.isUserInteractionEnabled = false
        }
        tblStoreCheckBrand.reloadData()
        
    }
    
    
    @objc func refreshData(){
        if(StoreCheckContainer.visitType == VisitType.planedvisitHistory || StoreCheckContainer.visitType  == VisitType.coldcallvisitHistory){
            btnSubmit.isHidden = true
            
            btnSubmit.isUserInteractionEnabled = false
        }
        tblStoreCheckBrand.reloadData()
    }
    
    func setUI(){
   //     obj = AppDelegate.shared.navigationController.viewControllers.last as? StoreCheckContainer
   //     parentBrandActivityList =  obj.storeCheckBrandActivityList
        SVProgressHUD.show()
        tblStoreCheckBrand.rowHeight = UITableView.automaticDimension
        tblStoreCheckBrand.estimatedRowHeight =  80
        tblStoreCheckBrand.delegate = self
        tblStoreCheckBrand.dataSource = self
        tblStoreCheckBrand.separatorColor = .clear
        tblStoreCheckBrand.tableFooterView = UIView()
        tblStoreCheckBrand.reloadData()
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        
        if(StoreCheckBrand.mutActivityList.count > 0){
            SVProgressHUD.dismiss()
            tblStoreCheckBrand.reloadData()
        

        }else{
            SVProgressHUD.dismiss()
        }
        
       
        print(StoreCheckContainer.storeCheckBrandActivityList)
        
         
        if(StoreCheckContainer.visitBrandActivityExists ==  false){
            
            self.choosecondition.dataSource =  StoreCheckContainer.storeConditionList.map{
//                if(StoreCheckContainer.storeConditionList.count > 0)
                return ($0.storeCondition ?? "")
            }
            print(self.choosecondition.dataSource.count)
            self.choosecondition.reloadAllComponents()
            
            self.chooseJustification.dataSource =  StoreCheckContainer.storeJustificationList.map{
                return ($0.storeJustification ?? "")
            }
            self.chooseJustification.reloadAllComponents()
            for obj in StoreCheckBrand.mutActivityList{
                if (obj.storeJustificationIDList?.count ?? 0 > 0) {
                    let objJust = obj.storeJustificationIDList?[0];
                    obj.justificationID = obj.iD//@(objJust.id);
                 
                    obj.justificationName = objJust?.storeJustification
                }else{
                    obj.justificationID =  NSNumber.init(value:0)
                    obj.justificationName = ""
                }
            }
        }
        if(StoreCheckContainer.visitBrandActivityExists == true){
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.isHidden = true
        }else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
    }

    
    // MARK: - IBAction
    
    @IBAction func submitClicked(_ sender: UIButton) {
     
        var arr = [[String:Any]]()
        var row = 0
        for activity in StoreCheckBrand.mutActivityList{
            var dictProposal = [String:Any]()
            
            dictProposal["storeActivityAssignID"] = activity.iD
            dictProposal["storeConditionID"] = activity.storeConditionID
            dictProposal["storeJustificationID"] =  activity.justificationID
            if(activity.activitydescription?.count ?? 0 > 0){
                dictProposal["description"] = activity.activitydescription
            }else{
                 dictProposal["description"] = ""
            }
            if(Int(activity.userQuantity ?? "0") ?? 0 > 0){
                dictProposal["targetQuantity"] = NSNumber.init(value: Int(activity.userQuantity ?? "0") ?? 0)
            }
            let cell = tblStoreCheckBrand.cellForRow(at: IndexPath.init(row: row, section: 0))
                    
                  
                row += 1
            dictProposal["visitID"] = StoreCheckContainer.visitID
            dictProposal["companyID"] = self.activeuser?.company?.iD
                   
            if(activity.activityImage?.count ?? 0 > 0){
                dictProposal["activityImage"] = activity.activityImage
                dictProposal["imageLatitude"] =  NSNumber.init(value:0.0)
                dictProposal["imageLongitude"] = NSNumber.init(value:0.0)
            }
            arr.append(dictProposal)
                
        }
        var param = Common.returndefaultparameter()
        
        param["storeBrandActivityListJson"] = Common.json(from: arr)
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()

        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlSaveBrandActivity, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
          
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            if(status.lowercased() == Constant.SucessResponseFromServer){
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                //self.navigationController?.popViewController(animated: true)
                    StoreCheckContainer.visitBrandActivityExists = true
                    let (status,message) = self.apihelper.getstorecheckdata()
                    SVProgressHUD.dismiss()
                    VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
                }
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                    SVProgressHUD.dismiss()
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                SVProgressHUD.dismiss()
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

}
extension StoreCheckBrand:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(StoreCheckContainer.visitBrandActivityExists == true){
            print("exist brand activity count = \(StoreCheckContainer.storeCheckVisitBrandActivityList.count)")
            return StoreCheckContainer.storeCheckVisitBrandActivityList.count
        }else{
            print("brand activity count = \(StoreCheckBrand.mutActivityList.count)")
            return StoreCheckBrand.mutActivityList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(StoreCheckContainer.visitBrandActivityExists == true){
        if let cell = tableView.dequeueReusableCell(withIdentifier: "storecheckvisitcell", for: indexPath) as? StoreCheckVisitCell{
            if(self.activesetting.requiStoreCheckJustificationInVisit == NSNumber.init(value: 1)){
                cell.stkJustification.isHidden = false
                
            }else{
                cell.stkJustification.isHidden = true
            }
            if(self.activesetting.requiStoreCheckConditionInVisit == NSNumber.init(value: 1)){
                cell.stkCondition.isHidden = false
            }else{
                cell.stkCondition.isHidden = true
            }
            cell.tfQuantity.isUserInteractionEnabled = false
            cell.tvDescription.isUserInteractionEnabled = false
             cell.btnAddImage.tag = indexPath.row
            let brandactivity = StoreCheckContainer.storeCheckVisitBrandActivityList[indexPath.row]
            cell.storecheckvisitdelegate =  self
            cell.setactivitydata(brandactivity: brandactivity)
         //   cell.btnAddImage.addTarget(self, action: #selector(addPictureClicked), for: UIControl.Event.touchUpInside)
                 //  [cell.btnActivityImg addTarget:self action:@selector(activityImageClicked:) forControlEvents:UIControlEventTouchUpInside];
//           cell.contentView.setNeedsLayout()
//           cell.contentView.layoutIfNeeded()
//            cell.layoutIfNeeded()
            return cell
        }else{
            return UITableViewCell()
        }
        }else{
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "storecheckcell", for: indexPath) as? StoreCheckCell{
                if(self.activesetting.requiStoreCheckJustificationInVisit == NSNumber.init(value: 1)){
                    cell.stkJustification.isHidden = false
                    
                }else{
                    cell.stkJustification.isHidden = true
                }
                if(self.activesetting.requiStoreCheckConditionInVisit == NSNumber.init(value: 1)){
                    cell.stkCondition.isHidden = false
                }else{
                    cell.stkCondition.isHidden = true
                }
                let storeCheckbrandactivity =  StoreCheckBrand.mutActivityList[indexPath.row]
               // cell.contentView.backgroundColor = UIColor.green
                cell.storecheckdelegate =  self
//                if(storeCheckbrandactivity.activityImage?.count ?? 0 > 0 ){
//                    cell.btnAddIma
//                }else{
//                    self.btnAddImage.isHidden = true
//                }
                let brandactivity = StoreCheckBrand.mutActivityList[indexPath.section]
                let arrcondition = brandactivity.storeConditionIDList
                if(!(choosecondition.dataSource.contains(storeCheckbrandactivity.storeConditionName ?? ""))){
                    if let firstcondition = arrcondition?[0] as?  StoreCondition{
                    storeCheckbrandactivity.storeConditionName = firstcondition.storeCondition
                    storeCheckbrandactivity.storeConditionID = firstcondition.iD
                    }
                }
                if(storeCheckbrandactivity.justificationName?.count == 0 || storeCheckbrandactivity.justificationID == 0){
                    if let firstjustification =  brandactivity.storeJustificationIDList?.first as? StoreJustification{
                        storeCheckbrandactivity.justificationName = firstjustification.storeJustification
                        storeCheckbrandactivity.justificationID = firstjustification.iD
                    }
                }
               // if(storeCheckbrandactivity.store)
                cell.setactivitydata(storeCheckbrandactivity:storeCheckbrandactivity){(Cell) in
                    if(StoreCheckBrand.mutActivityList.count > 0){
                        let activity = StoreCheckBrand.mutActivityList[indexPath.row]
                        activity.userQuantity =  cell.tfQuantity.text
                        activity.activitydescription = cell.tvDescription.text
                        activity.justificationName = cell.btnJustification.currentTitle
                        activity.storeConditionName = cell.btnCondition.currentTitle
                        
                       
                        StoreCheckBrand.mutActivityList.remove(at: indexPath.row)
                        StoreCheckBrand.mutActivityList.insert(activity, at: indexPath.row)
                        print(StoreCheckBrand.mutActivityList)
                    }
                
                            }
               
       
                
  //cell.btnCondition.addTarget(self, action: #selector(btnConditionClicked), for: .touchUpInside)
 //cell.contentView.setNeedsLayout()
//cell.contentView.layoutIfNeeded()
//                cell.layoutIfNeeded()
                return cell
            }else{
                return UITableViewCell()
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
 /*   @objc func btnConditionClicked(sender:UIButton){
//        let indexPath =  IndexPath.init(row: sender.tag , section: 0)
//        if  let cell = tblStoreCheckBrand.cellForRow(at: indexPath) as? StoreCheckCell{
//            let brandactivity = mutActivityList[indexPath.row]
//            let arrcondition = brandactivity.storeConditionIDList
//
//
//             var arrconditionTitle = [String]()
//             if(arrcondition?.count ?? 0 > 0){
//             for jus in arrcondition!{
//                arrconditionTitle.append(jus.storeCondition ?? "")
//
//             }
//
//             }
//
//              choosecondition.dataSource = arrconditionTitle
//            choosecondition.selectionAction = {(index,item) in
//                          sender.setTitle(item, for: .normal)
//                                 }
//            choosecondition.bottomOffset =  CGPoint.init(x: 0.0, y: cell.btnCondition.bounds.size.height)
//                       choosecondition.reloadAllComponents()
//                       choosecondition.show()
//
//        }
    }
    
    @objc func btnJustificationClicked(sender:UIButton){
//        let indexPath =  IndexPath.init(row: sender.tag , section: 0)
//        if  let cell = tblStoreCheckBrand.cellForRow(at: indexPath) as? StoreCheckCell{
//            let brandactivity = mutActivityList[indexPath.row]
//            let arrjustification = brandactivity.storeJustificationIDList
//
//            var arrconditionTitle = [String]()
//             if(arrjustification?.count ?? 0 > 0){
//             for jus in arrjustification!{
//                arrconditionTitle.append(jus.storeJustification ?? "")
//
//             }
//
//             }
//
//              chooseJustification.dataSource = arrconditionTitle
//            chooseJustification.selectionAction = {(index,item) in
//                          sender.setTitle(item, for: .normal)
//                                 }
//            chooseJustification.bottomOffset =  CGPoint.init(x: 0.0, y: cell.btnCondition.bounds.size.height)
//                       chooseJustification.reloadAllComponents()
//                       chooseJustification.show()
//
//            }
//
    }*/
}
extension StoreCheckBrand:IDMPhotoBrowserDelegate{
    
}

extension StoreCheckBrand :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
            , completion:   nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       
        //        activityIndicator.startAnimating()
       if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
       
        if let currentlocation = Location.sharedInsatnce.getCurrentCoordinate(){
                   if((CLLocationCoordinate2DIsValid(currentlocation)) && currentlocation.latitude != 0.0 && currentlocation.longitude != 0.0){
                    param["lattitude"] = currentlocation.latitude
                    param["longitude"] =  currentlocation.longitude
                   }else{
                    SVProgressHUD.dismiss()
                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                    let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                    }
                Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                   }
        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadImage, img: chosenImage, imgparamname: "Image", param: param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if let dic = arr as? [String:Any]{
            
            let image = dic["filePath"] as? String
            let actitivity = StoreCheckBrand.mutActivityList[self.selectedIndex.row]
            actitivity.activityImage = image
            StoreCheckBrand.mutActivityList.remove(at: self.selectedIndex.row)
            StoreCheckBrand.mutActivityList.insert(actitivity, at: self.selectedIndex.row)
                print(actitivity.activityImage)
                DispatchQueue.main.async {
                self.tblStoreCheckBrand.reloadData()
                }
            }
            
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            print("fdsgsdfsgd")
        }
                   }else{
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message:"Not getting proper location",view:self.view)
        }
       }else{
        Utils.toastmsg(message:"Not getting proper image",view:self.view)
       }
        // self.imgUploadByUser.contentMode = .scaleAspectFit
        
        
        //  self.imgUploadByUser.image = Common.createImage(withImage: chosenImage, forSize: CGSize.init(width: chosenImage.size.width > 200 ? 200 : chosenImage.size.width , height: chosenImage.size.height > 200 ? 200 :  chosenImage.size.height))
        //  self.UploadRequest()
        
        dismiss(animated:true, completion: nil)
        
    }
}


extension StoreCheckBrand:StoreCheckCellDelegate,StoreCheckVisitCellDelegate{
    func addPictureClicked(cell: StoreCheckVisitCell) {
        if let indexpath =  tblStoreCheckBrand.indexPath(for: cell){
            selectedIndex = indexpath
            arrOfImg = [IDMPhoto]()
            if(StoreCheckContainer.visitBrandActivityExists){
                let competitionactivity = StoreCheckContainer.storeCheckVisitBrandActivityList[selectedIndex.row]
                if let idmphoto = IDMPhoto.init(url: URL.init(string: competitionactivity.activityImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")){
                idmphoto.caption = ""
                arrOfImg.append(idmphoto)
                self.browser = IDMPhotoBrowser.init(photos: arrOfImg)
                self.browser?.delegate = self
                                           self.browser?.displayCounterLabel = true
                                           self.browser?.displayActionButton = false
                                           self.browser?.autoHideInterface = false
                                           self.browser?.dismissOnTouch = false
                                           self.browser?.displayArrowButton = false
                                            self.browser?.displayActionButton = false
                self.browser?.disableVerticalSwipe = true
                    DispatchQueue.main.async {
                    self.present(self.browser, animated: true, completion: nil)
                    }
                }
            }else{
            let activity = StoreCheckBrand.mutActivityList[indexpath.row]
        if  let sender = cell.btnAddImage as? UIButton{
            if(activity.activityImage?.count == 0){
                if let currentlocation = Location.sharedInsatnce.getCurrentCoordinate(){
         if((CLLocationCoordinate2DIsValid(currentlocation)) && currentlocation.latitude != 0.0 && currentlocation.longitude != 0.0){
             let imagePicker = UIImagePickerController()
                                   imagePicker.delegate = self
                                  if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                                      imagePicker.sourceType = .camera

                                      self.present(imagePicker, animated: true, completion: nil)
                                  }
                                  else{
                                     Utils.toastmsg(message:"Camera is not present",view:self.view)
                                  }
         }
                    
                }else{
         let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                                }
             Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
         }

        }else{
            arrOfImg = [IDMPhoto]()
         let competitionactivity = StoreCheckContainer.storeCheckVisitCompetitionActivityList[sender.tag]
           
         if let idmphoto = IDMPhoto.init(url: URL.init(string: competitionactivity.activityImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")){
         idmphoto.caption = ""
             arrOfImg.append(idmphoto)
             self.browser = IDMPhotoBrowser.init(photos: arrOfImg)
         self.browser?.delegate = self
         self.browser?.displayCounterLabel = true
         self.browser?.displayActionButton = false
         self.browser?.autoHideInterface = false
        self.browser?.dismissOnTouch = false
                                    self.browser?.displayArrowButton = false
                                     self.browser?.displayActionButton = false
         self.browser?.disableVerticalSwipe = true
            DispatchQueue.main.async {
             self.present(self.browser, animated: true, completion: nil)
            }

         }
        }
            
        }
            }
        }
    }
    
     func addPictureClicked(cell: StoreCheckCell) {
        if let indexpath =  tblStoreCheckBrand.indexPath(for: cell){
            selectedIndex = indexpath
            arrOfImg = [IDMPhoto]()
            if(StoreCheckContainer.visitBrandActivityExists){
                let competitionactivity = StoreCheckContainer.storeCheckVisitBrandActivityList[selectedIndex.row]
                if let idmphoto = IDMPhoto.init(url: URL.init(string: competitionactivity.activityImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")){
                idmphoto.caption = ""
                arrOfImg.append(idmphoto)
                self.browser = IDMPhotoBrowser.init(photos: arrOfImg)
                self.browser?.delegate = self
                                           self.browser?.displayCounterLabel = true
                                           self.browser?.displayActionButton = false
                                           self.browser?.autoHideInterface = false
                                           self.browser?.dismissOnTouch = false
                                           self.browser?.displayArrowButton = false
                                            self.browser?.displayActionButton = false
                self.browser?.disableVerticalSwipe = true
                    DispatchQueue.main.async {
                    self.present(self.browser, animated: true, completion: nil)
                    }
                }
            }else{
            let activity = StoreCheckBrand.mutActivityList[indexpath.row]
                if  let sender = cell.btnAddImage{
            if(activity.activityImage?.count == 0){
                if let currentlocation = Location.sharedInsatnce.getCurrentCoordinate(){
         if((CLLocationCoordinate2DIsValid(currentlocation)) && currentlocation.latitude != 0.0 && currentlocation.longitude != 0.0){
             let imagePicker = UIImagePickerController()
                                   imagePicker.delegate = self
                                  if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                                      imagePicker.sourceType = .camera

                                      self.present(imagePicker, animated: true, completion: nil)
                                  }
                                  else{
                                     Utils.toastmsg(message:"Camera is not present",view:self.view)
                                  }
         }
                    
                }else{
         let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                                }
             Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
         }

        }else{
            arrOfImg = [IDMPhoto]()
       //  let competitionactivity = StoreCheckContainer.storeCheckVisitCompetitionActivityList[sender.tag]
//            if let selectedstatus = objLead.leadStatusList[sender.tag] as? LeadStatusList{
              
         if let idmphoto = IDMPhoto.init(url: URL.init(string: activity.activityImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")){
         idmphoto.caption = ""
             self.arrOfImg.append(idmphoto)
             self.browser = IDMPhotoBrowser.init(photos: self.arrOfImg)
         self.browser?.delegate = self
         self.browser?.displayCounterLabel = true
         self.browser?.displayActionButton = false
         self.browser?.autoHideInterface = false
        self.browser?.dismissOnTouch = false
                                    self.browser?.displayArrowButton = false
                                     self.browser?.displayActionButton = false
         self.browser?.disableVerticalSwipe = true
             DispatchQueue.main.async {
             self.present(self.browser, animated: true, completion: nil)
             }
         }
         }
       
            
        }
            }
        }
    }
    
    func addJustificationClicked(cell: StoreCheckCell) {
        if let indexPath =  tblStoreCheckBrand.indexPath(for: cell) {
            if let sender = cell.btnJustification as? UIButton{
        //IndexPath.init(row: sender.tag , section: 0)
       // if  let cell = tblStoreCheckBrand.cellForRow(at: indexPath) as? StoreCheckCell{
                let brandactivity = StoreCheckBrand.mutActivityList[indexPath.row]
            let arrjustification = brandactivity.storeJustificationIDList
            
            var arrconditionTitle = [String]()
             if(arrjustification?.count ?? 0 > 0){
             for jus in arrjustification!{
                arrconditionTitle.append(jus.storeJustification ?? "")
               
             }
                 
             }
    chooseJustification.anchorView =  cell.btnJustification
    chooseJustification.dataSource = arrconditionTitle
    chooseJustification.selectionAction = {(index,item) in
                          sender.setTitle(item, for: .normal)
                                 }
    chooseJustification.bottomOffset =  CGPoint.init(x: 0.0, y: cell.btnJustification.bounds.size.height)
    chooseJustification.reloadAllComponents()
    chooseJustification.show()
            }
            
            }
    
    
    }
    
    func addConditionClicked(cell:StoreCheckCell){
        if  let indexPath = tblStoreCheckBrand.indexPath(for: cell) as? IndexPath{
        
            // IndexPath.init(row: sender.tag , section: 0)
      //  if  let cell = tblStoreCheckBrand.cellForRow(at: indexPath) as? StoreCheckCell{
            let brandactivity = StoreCheckBrand.mutActivityList[indexPath.section]
            let arrcondition = brandactivity.storeConditionIDList
             
            
             var arrconditionTitle = [String]()
             if(arrcondition?.count ?? 0 > 0){
             for jus in arrcondition!{
                arrconditionTitle.append(jus.storeCondition ?? "")
               
             }
                 
             }
            choosecondition.anchorView = cell.btnCondition
            choosecondition.dataSource = arrconditionTitle
            choosecondition.selectionAction = {(index,item) in
                cell.btnCondition.setTitle(item, for: .normal)
                                 }
            choosecondition.bottomOffset =  CGPoint.init(x: 0.0, y: cell.btnCondition.bounds.size.height)
            choosecondition.reloadAllComponents()
            choosecondition.show()
             
        }
    }
}
extension StoreCheckBrand:StoreCheckContainerDelegate{
    func updateBrandData(){
        self.tblStoreCheckBrand.reloadData()
        if(StoreCheckContainer.visitBrandActivityExists ==  false){
            
            self.choosecondition.dataSource =  StoreCheckContainer.storeConditionList.map{
//                if(StoreCheckContainer.storeConditionList.count > 0)
                return ($0.storeCondition ?? "")
            }
            print(self.choosecondition.dataSource.count)
            self.choosecondition.reloadAllComponents()
            
            self.chooseJustification.dataSource =  StoreCheckContainer.storeJustificationList.map{
                return ($0.storeJustification ?? "")
            }
            self.chooseJustification.reloadAllComponents()
            for obj in StoreCheckBrand.mutActivityList{
                if (obj.storeJustificationIDList?.count ?? 0 > 0) {
                    let objJust = obj.storeJustificationIDList?[0];
                    obj.justificationID = obj.iD//@(objJust.id);
                 
                    obj.justificationName = objJust?.storeJustification
                }else{
                    obj.justificationID =  NSNumber.init(value:0)
                    obj.justificationName = ""
                }
            }
        }
        self.tblStoreCheckBrand.reloadData()
    }
    func updateCompetitonData() {
        print("btrvjenck dv rtjf dcjk")
    }
}
