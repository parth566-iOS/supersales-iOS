//
//  StoreCheckCompetition.swift
//  SuperSales
//
//  Created by Apple on 19/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import CoreLocation

class StoreCheckCompetition: BaseViewController {

   // @IBOutlet weak var tblStoreCheckCompetition: UITableView!
    static var mutCompetitionList:[StoreCompetition] = [StoreCompetition]()
    @IBOutlet weak var btnSubmit: UIButton!
    var choosecondition:DropDown =  DropDown()
    var chooseJustification:DropDown = DropDown()
    var browser:IDMPhotoBrowser! = IDMPhotoBrowser()
    var arrOfImg:[IDMPhoto] = [IDMPhoto]()
    var selectedIndex:IndexPath!
    @IBOutlet weak var tblCompetition: UITableView!
    
    
    override func viewDidLoad() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3,execute: {
        super.viewDidLoad()
            StoreCheckContainer().containerDelegate = self
           self.setUI()
         });
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
        tblCompetition.reloadData()
        if (StoreCheckContainer.visitCompetitionExists == true) {
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.isHidden =  true
        }else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
        if(StoreCheckContainer.visitCompetitionExists == true){
             btnSubmit.isHidden =  true
        }
        if(StoreCheckContainer.visitType == VisitType.planedvisitHistory || StoreCheckContainer.visitType  == VisitType.coldcallvisitHistory){
            btnSubmit.isHidden = true
            
            btnSubmit.isUserInteractionEnabled = false
        }
    }
    // MARK: - Method
    
    
    @objc func refreshData(){
        if (StoreCheckContainer.visitCompetitionExists == true) {
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.isHidden =  true
        }else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
        if(StoreCheckContainer.visitCompetitionExists == true){
             btnSubmit.isHidden =  true
        }
        if(StoreCheckContainer.visitType == VisitType.planedvisitHistory || StoreCheckContainer.visitType  == VisitType.coldcallvisitHistory){
            btnSubmit.isHidden = true
            
            btnSubmit.isUserInteractionEnabled = false
        }
        tblCompetition.reloadData()
    }
    func setUI(){
       // mutCompetitionList = StoreCheckContainer.storeCompetitionList
        
        
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        StoreCheckCompetition.mutCompetitionList = StoreCheckContainer.storeCompetitionList.filter{
            return  $0.storeJustificationIDList?.count ?? 0 > 0
        }
        if(StoreCheckCompetition.mutCompetitionList.count == 0){
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.isHidden =  true
        }else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
        if(StoreCheckContainer.visitCompetitionExists == true){
             btnSubmit.isHidden =  true
        }
        if(StoreCheckContainer.visitCompetitionExists == false){
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
            for storecompetition in StoreCheckCompetition.mutCompetitionList{
                if(storecompetition.aryAssignedActivities?.count ?? 0  > 0){
                for oba in storecompetition.aryAssignedActivities!{
                    if(StoreCheckCompetition.mutCompetitionList.count > 0){
                        let objjust = storecompetition.storeJustificationIDList?[0]
                        oba.justificationID = objjust?.iD
                        oba.justificationName = objjust?.storeJustification
                        oba.isYES = NSNumber.init(value: 1)
                    }else{
                        oba.justificationID = NSNumber.init(value: 0)
                        oba.justificationName = ""
                        oba.isYES = NSNumber.init(value: 1)
                    }
                }
                }
            }
        }
        tblCompetition.delegate = self
        tblCompetition.dataSource = self
        tblCompetition.tableFooterView = UIView()
        tblCompetition.reloadData()
        tblCompetition.separatorColor = .clear
    }
    
    // MARK: - IBAction
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        var section = 0
        var arr = [[String:Any]]()
        for compt in StoreCheckCompetition.mutCompetitionList{
            var row = 0
            if(compt.aryAssignedActivities?.count ?? 0 > 0 ){
            for asact in compt.aryAssignedActivities!{
                var obj = [String:Any]()
                obj["storeCompetitionActivityID"] = asact.iD
                if(asact.quantity?.intValue ?? 0 > 0){
                    obj["targetQuantity"] = asact.quantity
                    row +=  1
                    obj["visitID"] = StoreCheckContainer.visitID
                    obj["companyID"] =  self.activeuser!.company!.iD
                }
                if(asact.activitydescription?.count ?? 0 > 0){
                    obj["description"] = asact.activitydescription
                }else{
                    obj["description"] = ""
                }
                if(asact.isYES?.isEqual(to: NSNumber.init(value:1)) ?? false){
                    obj["checkAvailability"] = true
                    obj["storeJustificationID"] = asact.justificationID
                }else{
                      obj["checkAvailability"] = false
                }
                if(asact.activityImage?.count ?? 0 > 0){
                    obj["activityImage"] = asact.activityImage
                    obj["imageLatitude"] = NSNumber.init(value: 00.00)
                    obj["imageLongitude"] = NSNumber.init(value: 00.00)
                }
                arr.append(obj)
            }
            }
             section += 1
        }
        var param = Common.returndefaultparameter()
        param["assignActivityCompetitionListJson"] =  Common.json(from: arr)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlSaveAssignActivityCompetition, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            if(status.lowercased() == Constant.SucessResponseFromServer){
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    StoreCheckContainer.visitCompetitionExists =  true
                    let (status,message) = self.apihelper.getstorecheckdata()
                    SVProgressHUD.dismiss()
                    VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
              //  self.navigationController?.popViewController(animated: true)
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
extension StoreCheckCompetition:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (StoreCheckContainer.visitCompetitionExists == true) {
            return 1
        }else{
          print("new competetion count = \(StoreCheckCompetition.mutCompetitionList.count)")
            return StoreCheckCompetition.mutCompetitionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (StoreCheckContainer.visitCompetitionExists == true) {
               return StoreCheckContainer.storeCheckVisitCompetitionActivityList.count
           }else{
           //    StoreCompetition *objStoreCompetition = obj.storeCompetitionList[section];
            
            if(StoreCheckCompetition.mutCompetitionList.count > 0){
                let objStoreCompetition = StoreCheckCompetition.mutCompetitionList[section]
            return objStoreCompetition.aryAssignedActivities?.count ?? 0
                
            }else{
                self.view.makeToast("No activity found for competition")
                return 0
            }
           }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    if   let cell = tableView.dequeueReusableCell(withIdentifier: "storecompactivitycell", for: indexPath) as? StoreCompActivityCell{
        cell.compdelegate = self
       
    if(StoreCheckContainer.visitCompetitionExists == true){
    cell.stkbtn.isHidden = true
    let competitionactivity = StoreCheckContainer.storeCheckVisitCompetitionActivityList[indexPath.row]
    cell.tvDescription.isUserInteractionEnabled = false
    cell.setexistCompetitionData(competetiondata:competitionactivity,indxpath:indexPath)
    cell.btnAddPicture.tag = indexPath.row
                    
                    // cell.btnJustifiction.tag = indexPath.row
    cell.btnAddPicture.addTarget(self, action: #selector(btnAddImageClicked), for: .touchUpInside)
                    
                    
                     //cell.setcompetitiondata(objStoreCompetition:objStoreCompetition,indexpath:indexPath)
                }else{
//         if   let cell = tableView.dequeueReusableCell(withIdentifier: "storecompactivitycell", for: indexPath) as? StoreCompActivityCell{
            
                    let objStoreCompetition = StoreCheckCompetition.mutCompetitionList[indexPath.section]
        cell.lblCompetitionName.isHidden = true
        cell.btnJustifiction.tag = indexPath.row
                   
        cell.setcompetitiondata(objStoreCompetition:objStoreCompetition,indexpath:indexPath){(Cell)in
            
            
            if(objStoreCompetition.aryAssignedActivities?.count ?? 0 > 0){
                if  let activity = objStoreCompetition.aryAssignedActivities?[indexPath.row] as? AssignedActivity{
                    activity.justificationName =  Cell.lblJustification.text
                    activity.quantity = NSNumber.init(value: Int(Cell.tfQuantity.text as? String ?? "0")as? Int ?? 0)
                //activity?.quantity = NSNumber.init(value: Int(Cell.tfQuantity.text as? String ?? "0")as? Int ?? 0)
                //if(activity.quantity?.intValue ?? 0 > 0){
                activity.activitydescription = Cell.tvDescription.text
               // }
                    print(activity.activitydescription)
                    print(StoreCheckCompetition.mutCompetitionList)
                objStoreCompetition.aryAssignedActivities?.remove(at: indexPath.row)
                objStoreCompetition.aryAssignedActivities?.insert(activity, at: indexPath.row)
                    print(activity.activitydescription)
                    StoreCheckCompetition.mutCompetitionList.remove(at: indexPath.section)
                    StoreCheckCompetition.mutCompetitionList.insert(objStoreCompetition, at: indexPath.section)
                   
                    print(StoreCheckCompetition.mutCompetitionList)
                }
                
            }
                    }
                    
//    cell.btnJustifiction.addTarget(self, action: #selector(btnJustificationClicked), for: .touchUpInside)
//    cell.btnAddPicture.addTarget(self, action: #selector(btnAddImageClicked), for: .touchUpInside)
        }
       
        if(self.activesetting.requiStoreCheckJustificationInVisitInCompetitor == NSNumber.init(value: 1) && (self.activesetting.requiStoreCheckJustificationInVisit == NSNumber.init(value: 1))){
            cell.stkJustification.isHidden = false
        }else{
        cell.stkJustification.isHidden = true
        }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width
            
            
            , height: 20))
        let lblcatname = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: tableView.frame.size.width,height: 18))
        lblcatname.font = UIFont.boldSystemFont(ofSize: 18)
        lblcatname.textColor = UIColor.Appthemecolor
        //Common().UIColorFromRGB(rgbValue: 0x464646)
        if(StoreCheckCompetition.mutCompetitionList.count > 0){
            let objStoreCompetition = StoreCheckCompetition.mutCompetitionList[section]
       // let dic = arrSubCategory[section]
      
        lblcatname.text = objStoreCompetition.storeCompetition
        }
        view.addSubview(lblcatname)
        view.backgroundColor =  UIColor.clear
        
        return view
    }
    
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(StoreCheckContainer.visitCompetitionExists == true){
            return 0
        }else{
        return 40
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc func btnAddImageClicked(sender:UIButton){
           if(sender.currentTitle == "Add Pictue"){
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
   /* @objc func btnJustificationClicked(sender:UIButton){
//        print(sender.tag)
//        let indexPath =  IndexPath.init(row: sender.tag , section: 0)
//        if  let cell = tblCompetition.cellForRow(at: indexPath) as? StoreCompActivityCell{
//            let storecompetition =  mutCompetitionList[indexPath.row]
//
//        if(storecompetition.storeJustificationIDList?.count ?? 0 > 0){
//                        let arrjustification = storecompetition.storeJustificationIDList
//                        print(arrjustification?.count ?? 0)
//
//                        var arrjustificationTitle = [String]()
//                        if(arrjustification?.count ?? 0 > 0){
//                        for jus in arrjustification!{
//                            arrjustificationTitle.append(jus.storeJustification)
//
//                        }
//
//                        }
//
//                         chooseJustification.dataSource = arrjustificationTitle
//
//                        chooseJustification.reloadAllComponents()
//                    }
//                    chooseJustification.anchorView =  sender
//
//
//            chooseJustification.bottomOffset =  CGPoint.init(x: 0.0, y: cell.btnJustifiction.bounds.size.height)
//            chooseJustification.reloadAllComponents()
//            chooseJustification.show()
//            chooseJustification.selectionAction = {(index,item) in
//                sender.setTitle(item, for: .normal)
//                       }
//        }
                
    }*/
    
}

extension StoreCheckCompetition:StoreCompActivityCellDelegate{
    
    
    func addPictureClicked(cell: StoreCompActivityCell) {
        let indexPath  = tblCompetition.indexPath(for: cell)
        selectedIndex = indexPath
        arrOfImg = [IDMPhoto]()
        if(StoreCheckContainer.visitCompetitionExists == true){
            
            let competitionactivity = StoreCheckContainer.storeCheckVisitCompetitionActivityList[selectedIndex.row]
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
        if let arrcompetition = StoreCheckCompetition.mutCompetitionList[selectedIndex.section] as? StoreCompetition{
            if let  competition =  arrcompetition.aryAssignedActivities?[selectedIndex.row] as? AssignedActivity{
            //[selectedIndex.row] as? AssignedActivity{
        
       
        
                if(competition.activityImage?.count == 0){
                    if         let currentlocation = Location.sharedInsatnce.getCurrentCoordinate(){
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
          //  let competitionactivity = StoreCheckContainer.storeCheckVisitCompetitionActivityList[indexPath?.row ?? 0]
         if let idmphoto = IDMPhoto.init(url: URL.init(string: competition.activityImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")){
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

    func addJustificationClicked(cell: StoreCompActivityCell) {
        let indexPath  = tblCompetition.indexPath(for: cell)
        let sender =  cell.btnJustifiction
       // if  let cell = tblCompetition.cellForRow(at: indexPath) as? StoreCompActivityCell{
        let storecompetition =  StoreCheckCompetition.mutCompetitionList[indexPath!.section]
            
        if(storecompetition.storeJustificationIDList?.count ?? 0 > 0){
                        let arrjustification = storecompetition.storeJustificationIDList
                        print(arrjustification?.count ?? 0)
                       
                        var arrjustificationTitle = [String]()
                        if(arrjustification?.count ?? 0 > 0){
                        for jus in arrjustification!{
                            arrjustificationTitle.append(jus.storeJustification)
                          
                        }
                            
                        }
           
        chooseJustification.dataSource = arrjustificationTitle
        chooseJustification.reloadAllComponents()
                    }
        chooseJustification.anchorView =  cell.btnJustifiction
        chooseJustification.selectionAction = {(index,item) in
                sender?.setTitle(item, for: .normal)
                       //}
            }
        chooseJustification.bottomOffset =  CGPoint.init(x: 0.0, y: cell.btnJustifiction.bounds.size.height)
        chooseJustification.reloadAllComponents()
        chooseJustification.show()
    }
    
    func checkAvailability(cell: StoreCompActivityCell) {
        let indexPath  = tblCompetition.indexPath(for: cell)
        let storecompetition =  StoreCheckContainer.storeCompetitionList[indexPath?.section ?? 0]
        let assignedActivity = storecompetition.aryAssignedActivities?[indexPath?.row ?? 0]
      
        if(cell.btnYes.isSelected){
            cell.stkJustification.isHidden = false
           
            assignedActivity?.isYES = NSNumber.init(value: 1)
        }else{
            cell.stkJustification.isHidden = true
            assignedActivity?.isYES = NSNumber.init(value: 0)
        }
        cell.contentView.layoutIfNeeded()
        tblCompetition.beginUpdates()
        tblCompetition.endUpdates()
    }

}

extension StoreCheckCompetition:IDMPhotoBrowserDelegate{
    
}

extension StoreCheckCompetition :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
            , completion:   nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
       
        //        activityIndicator.startAnimating()
       if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       {
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
        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadImage, img: chosenImage, imgparamname: "Image", param: param) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if let dic = arr as? [String:Any]{
            
            let image = dic["filePath"] as? String
                if let arrcompetition = StoreCheckCompetition.mutCompetitionList[self.selectedIndex.section] as? StoreCompetition{
                    if let  competition =  arrcompetition.aryAssignedActivities?[self.selectedIndex.row] as? AssignedActivity{
                competition.activityImage = image
                        arrcompetition.aryAssignedActivities?.remove(at: self.selectedIndex.row)
                        arrcompetition.aryAssignedActivities?.insert(competition, at: self.selectedIndex.row)
                    }
                   
                    StoreCheckCompetition.mutCompetitionList.remove(at: self.selectedIndex.section)
                    StoreCheckCompetition.mutCompetitionList.insert(arrcompetition, at: self.selectedIndex.section)
                    self.tblCompetition.reloadData()
                }
                self.tblCompetition.reloadData()
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
        }
        // self.imgUploadByUser.contentMode = .scaleAspectFit
        
        
        //        self.imgUploadByUser.image = Common.createImage(withImage: chosenImage, forSize: CGSize.init(width: chosenImage.size.width > 200 ? 200 : chosenImage.size.width , height: chosenImage.size.height > 200 ? 200 :  chosenImage.size.height))
        //        self.UploadRequest()
        
        dismiss(animated:true, completion: nil)
        
    }
}

extension StoreCheckCompetition:StoreCheckContainerDelegate{
    func updateBrandData() {
        print("begrwvfecdwsx")
    }
    
    func updateCompetitonData() {
        tblCompetition.reloadData()
        if(StoreCheckCompetition.mutCompetitionList.count == 0){
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.isHidden =  true
        }else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
        if(StoreCheckContainer.visitCompetitionExists == true){
             btnSubmit.isHidden =  true
        }
        if(StoreCheckContainer.visitCompetitionExists == false){
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
            for storecompetition in StoreCheckCompetition.mutCompetitionList{
                if(storecompetition.aryAssignedActivities?.count ?? 0  > 0){
                for oba in storecompetition.aryAssignedActivities!{
                    if(StoreCheckCompetition.mutCompetitionList.count > 0){
                        let objjust = storecompetition.storeJustificationIDList?[0]
                        oba.justificationID = objjust?.iD
                        oba.justificationName = objjust?.storeJustification
                        oba.isYES = NSNumber.init(value: 1)
                    }else{
                        oba.justificationID = NSNumber.init(value: 0)
                        oba.justificationName = ""
                        oba.isYES = NSNumber.init(value: 1)
                    }
                }
                }
            }
        }
    }
}
