//
//  ActivityReport.swift
//  SuperSales
//
//  Created by Apple on 26/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation
import CoreLocation
import FastEasyMapping


class ActivityReport: BaseViewController {

    var activityId:NSNumber!
    var activitymodel:Activity?
    var selectedcustomerId = NSNumber.init(value: 0)
    
    @IBOutlet weak var tfNoOfParticipant: UITextField!
    
    @IBOutlet weak var vwNoOfPatricipant: UIView!

    
    @IBOutlet weak var tblParticipant: UITableView!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    
    @IBOutlet weak var img1: UIImageView!
   
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    
    @IBOutlet weak var img4: UIImageView!
    
    
    @IBOutlet weak var img5: UIImageView!
    
    @IBOutlet weak var lblCustomerNameValue: UILabel!
    @IBOutlet weak var vwCustomer: UIView!
    let settingactive = Utils().getActiveSetting()
    @IBOutlet weak var vwNoOfParticipant: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnAddParticipant: UIButton!
    
    
    @IBOutlet weak var cnsttblactivityparticipantHeightConstant: NSLayoutConstraint!
    
    var tableViewHeight: CGFloat {
        tblParticipant.layoutIfNeeded()
        return tblParticipant.contentSize.height
    }
    var isActivityImage1:Bool! = false
    var isActivityImage2:Bool! = false
    var isActivityImage3:Bool! = false
    var isActivityImage4:Bool! = false
    var isActivityImage5:Bool! = false
    var actimg1:UIImage?
    var actimg2:UIImage?
    var actimg3:UIImage?
    var actimg4:UIImage?
    var actimg5 : UIImage?
    
    var currentcoordinate:CLLocationCoordinate2D!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(AddParticipant.arrOfParticipant.count > 0){
            vwNoOfPatricipant.isHidden = false
        }else{
            vwNoOfPatricipant.isHidden = true
        }
        tblParticipant.reloadData()
        cnsttblactivityparticipantHeightConstant.constant = tableViewHeight
    }
    
    //MARK: -  Method
    func setUI(){
    AddParticipant.arrOfParticipant = [participant]()
    tfNoOfParticipant.setCommonFeature()
    btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
    self.title = "Activity Report"
    self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        
    self.tfNoOfParticipant.keyboardType = .numberPad
    self.tvDescription.delegate = self
    tfNoOfParticipant.setBottomBorder(tf: tfNoOfParticipant, color: UIColor.lightGray)
    lblCustomerNameValue.addBorders(edges: [UIRectEdge.bottom], color: UIColor.lightGray, cornerradius: 0)
        if let activitymodel = activitymodel as? Activity{
            if(activitymodel.customerName?.count ?? 0 > 0){
                vwCustomer.isHidden = false
                lblCustomerNameValue.text = activitymodel.customerName
            }else{
                vwCustomer.isHidden = true
            }
        }
        //addParticipantInActivity
//        if(settingactive.addParticipantInActivity == NSNumber.init(value: 1)){
//           vwNoOfParticipant.isHidden = false
//        }else{
//            vwNoOfParticipant.isHidden = true
//        }
        tfNoOfParticipant.delegate = self
        //Add action for image click
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.activityImage1Clicked(_:)))
        gesture1.numberOfTapsRequired = 1
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.activityImage2Clicked(_:)))
        gesture2.numberOfTapsRequired = 1
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.activityImage3Clicked(_:)))
        gesture3.numberOfTapsRequired = 1
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(self.activityImage4Clicked(_:)))
        gesture4.numberOfTapsRequired = 1
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(self.activityImage5Clicked(_:)))
        gesture5.numberOfTapsRequired = 1
        img1.isUserInteractionEnabled = true
        img2.isUserInteractionEnabled = true
        img3.isUserInteractionEnabled = true
        img4.isUserInteractionEnabled = true
        img5.isUserInteractionEnabled = true
       // custExImg1.addGestureRecognizer(gesture1)
        img1.addGestureRecognizer(gesture1)
        img2.addGestureRecognizer(gesture2)
        img3.addGestureRecognizer(gesture3)
        img4.addGestureRecognizer(gesture4)
        img5.addGestureRecognizer(gesture5)
        tblParticipant.delegate = self
        tblParticipant.dataSource = self
        
        if(activitymodel?.activityParticipantList.count ?? 0 > 0){
            vwNoOfPatricipant.isHidden = false
            tblParticipant.reloadData()

        }else{
            vwNoOfPatricipant.isHidden = true
        }
        
    }
    
    func checkValidation()->Bool{
        if(tvDescription.text.count == 0){
            Utils.toastmsg(message:"Please enter Description",view: self.view)
        return false
        }else{
            return true
        }
    }
    
    @objc func activityImage1Clicked(_ sender: UITapGestureRecognizer){
        isActivityImage1 = true
        self.takeNewPhotoFromCamera()
        
    }
    @objc func activityImage2Clicked(_ sender: UITapGestureRecognizer){
       isActivityImage2 = true
     
        self.takeNewPhotoFromCamera()
        
    }
    @objc func activityImage3Clicked(_ sender: UITapGestureRecognizer){
       
        isActivityImage3 = true
        self.takeNewPhotoFromCamera()
        
    }
    @objc func activityImage4Clicked(_ sender: UITapGestureRecognizer){
        
        isActivityImage4 = true
        self.takeNewPhotoFromCamera()
        
    }
    @objc func activityImage5Clicked(_ sender: UITapGestureRecognizer){
        isActivityImage5 = true
        self.takeNewPhotoFromCamera()
        
    }
    // MARK: - Camera method
    func takeNewPhotoFromCamera(){
       if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera) as? Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if(deviceHasCamera){
               switch authStatus {
                   case .authorized:
                       showCameraPicker()
                   case .denied:
                       alertPromptToAllowCameraAccessViaSettings()
                   case .notDetermined:
                      // permissionPrimeCameraAccess()
              
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                        if(granted){
                            self.showCameraPicker()
                        }else{
                            self.permissionPrimeCameraAccess()
                        }
                    }
                   default:
                       permissionPrimeCameraAccess()
               }
        }else{
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
              //  Analytics.track(event: .permissionsPrimeCameraNoCamera)
            })
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
             
            
        }
           } else {
               let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
               let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                 //  Analytics.track(event: .permissionsPrimeCameraNoCamera)
               })
               alertController.addAction(defaultAction)
               present(alertController, animated: true, completion: nil)
           }
       }


       func alertPromptToAllowCameraAccessViaSettings() {
           let alert = UIAlertController(title: "SuperSales Would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can  customer benefit.", preferredStyle: .alert )
           alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
              // Analytics.track(event: .permissionsPrimeCameraOpenSettings)
            if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(appSettingsURL as URL)
               }
           })
           present(alert, animated: true, completion: nil)
       }


       func permissionPrimeCameraAccess() {
        DispatchQueue.main.async {
           let alert = UIAlertController( title: "SuperSales Would Like To Access the Camera", message: "SuperSales would like to access your Camera so that you can customer benefit.", preferredStyle: .alert )
           let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
              // Analytics.track(event: .permissionsPrimeCameraAccepted)
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] granted in
                       DispatchQueue.main.async {
                          // self?.cameraSelected() // try again
                       }
                   })
               }
           })
           alert.addAction(allowAction)
           let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
             //  Analytics.track(event: .permissionsPrimeCameraCancelled)
           }
           alert.addAction(declineAction)
            self.present(alert, animated: true, completion: nil)
        }
       }


       func showCameraPicker() {

        DispatchQueue.main.async {
           let picker = UIImagePickerController()
            picker.delegate = self
            picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            
            self.present(picker, animated: true, completion: nil)
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
    
    
    // MARK: - IBAction
    
    @IBAction func btnAddParticipantClicked(_ sender: UIButton) {
        //Add Activity
        if let addActivity = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.AddParticipant) as? AddParticipant{
            addActivity.selectedcustomerId =  selectedcustomerId
            if let activityID = activitymodel?.activityId{
                addActivity.selectedActivityId = NSNumber.init(value:activityID)
            }
            self.navigationController?.pushViewController(addActivity, animated: true)
        }
    }
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(tvDescription.text.count == 0){
            Utils.toastmsg(message:"Please enter Description",view: self.view)
        }else{
            if let currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            if(CLLocationCoordinate2DIsValid(currentcoordinate) && currentcoordinate.latitude > 0 && currentcoordinate.longitude > 0){
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            var jsonparam = [String:Any]()
            jsonparam["ID"] = activityId//activity.ID
            jsonparam["CompanyID"] = self.activeuser?.company?.iD
            jsonparam["ImageLattitude"] = currentcoordinate.latitude
            jsonparam["ImageLongitude"] = currentcoordinate.longitude
            jsonparam["CreatedBy"] = self.activeuser?.userID
            if(tvDescription.text.count > 0){
                jsonparam["StatusDescription"] = tvDescription.text
            }
            if(tfNoOfParticipant.text?.count ?? 0 > 0){
                jsonparam["NoOfParticipants"] = tfNoOfParticipant.text
                
            }
            if let intcustomerId = activitymodel?.customerID{
                let customerID = NSNumber.init(value: Int(intcustomerId) ?? 0)
            if let selectedCustomer = CustomerDetails.getCustomerByID(cid: customerID){
                selectedcustomerId = NSNumber.init(value:selectedCustomer.iD)
            }
            }
            jsonparam["customerID"] = selectedcustomerId
            var jsonparticipant = [[String:Any]]()
                for actparticipant in AddParticipant.arrOfParticipant{
                            var participant = [String:Any]()
                            participant["CreatedBy"] = self.activeuser?.userID
                            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                            participant["CreatedTime"] = self.dateFormatter.string(from: Date())
                            participant["CustomerID"] =  selectedcustomerId
                    participant["CustomerMobile"] = actparticipant.contactno.toInt()
                    participant["CustomerName"] =  actparticipant.name
                    participant["UserID"] = self.activeuser?.userID
                    participant["ActivityID"] = activitymodel?.activityId
                    jsonparticipant.append(participant)
                    
                }
            var parameter =  Common.returndefaultparameter()
            parameter["updateActivityStatusjson"] = Common.returnjsonstring(dic: jsonparam)
            parameter["activityParticipantJson"] =  Common.json(from: jsonparticipant)
           var  arrImgParamname = [String]()
            var arrImg = [UIImage]()
            if let img1 = actimg1 as? UIImage{
                arrImgParamname.append("Picture1")
                arrImg.append(img1)
            }
            if let img2 = actimg2 as? UIImage{
                arrImgParamname.append("Picture2")
                arrImg.append(img2)
            }
            if let img3 = actimg3 as? UIImage{
                arrImgParamname.append("Picture3")
                arrImg.append(img3)
            }
            if let img4 = actimg4 as? UIImage{
                arrImgParamname.append("Picture4")
                arrImg.append(img4)
            }
            if let img5 = actimg5 as? UIImage{
                arrImgParamname.append("Picture5")
                arrImg.append(img5)
            }
            print("parameter of Activity report = \(parameter) , arrof image name =\(arrImgParamname)")
        self.apihelper.addCustomerWithMultipartBody(fullUrl: ConstantURL.kWSUrlUpdateActivityStatus, arrimg: arrImg, arrimgparamname: arrImgParamname, param: parameter) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
           var dicResponse = arr as? [String:Any] ?? [String:Any]()
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                AddParticipant.arrOfParticipant = [participant]()
                print(responseType)
                print("response of activity report = \(dicResponse)")
               /* MagicalRecord.save { (localcontext) in

                    localcontext.mr_saveToPersistentStore { (status, error) in
                        self.activitymodel?.statusDescription = self.tvDescription.text
                        self.activitymodel?.noOfParticipants = Int64(self.tfNoOfParticipant.text ?? "0") ?? 0
                    }
                } completion: { (status, error) in
                    print("report save to database")
                }*/
                var address = dicResponse["AddressDetails"] as? [String:Any] ?? [String:Any]()
                let addtype = address["Type"] as? NSNumber
                address["Type"] = addtype?.stringValue
                print("address  = \(address)")
                dicResponse["AddressDetails"] = address
                print(" result = \(addtype) and type of it is  = \(type(of: addtype)) , dic = \(dicResponse)")
                MagicalRecord.save({ (localcontext) in
                    
                    
                     FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: Activity.defaultMapping(), context: localcontext)
                    if let activity = Activity().getActivityFromId(userID: NSNumber.init(value:self.activitymodel?.activityId ?? 0)) as? Activity{
                        
                        activity.picture1 = dicResponse["Picture1"]  as? String
                        activity.picture1 = dicResponse["Picture1"]  as? String
                        activity.picture2 = dicResponse["Picture2"]  as? String
                        activity.picture3 = dicResponse["Picture3"]  as? String
                        activity.picture4 = dicResponse["Picture4"]  as? String
                        activity.picture5 = dicResponse["Picture5"]  as? String
                        activity.statusDescription =  Common.returndefaultstring(dic: dicResponse, keyvalue: "StatusDescription")
                        activity.noOfParticipants = Int64(Common.returndefaultInteger(dic: dicResponse, keyvalue: "NoOfParticipants"))
                    }
                    let context = Activity.getContext()
                    context.mr_saveToPersistentStore { (status, error) in
                        if(error ==  nil){
                            
                        }
                    }
                
//                  localcontext.mr_save({ (localcontext) in
//                  print("saving")
//                      })
                  }, completion: { (status, error) in
                  print(status)
              print(error?.localizedDescription ?? "")
                    if let activity = Activity().getActivityFromId(userID: NSNumber.init(value:self.activitymodel?.activityId ?? 0)) as? Activity{
                        print(activity.picture1)
                        print(activity.statusDescription)
                    }
             /* if  let status = VisitStatus.getvisitstatus(visitID:NSNumber.init(value:self.planVisit?.iD ?? 0)){
                          let folder = self.planVisit?.visitStatusList as! NSMutableOrderedSet
                          folder.insert(status, at: 0)
                          self.planVisit?.visitStatusList = folder as NSOrderedSet
                
                                          }
                 
                                          let context = PlannVisit.getContext()
                                          context.mr_saveToPersistentStore { (status, error) in
                                              if(error ==  nil){
                                          print("context did saved \(status)")
                                                  if(self.isFromVisit){
                          VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
                                                  }else{
                          
                                  self.navigationController?.popViewController(animated: true)
                                                  }
                                                                 }else{
                                                                     Utils.toastmsg(message:error?.localizedDescription)
                                                                 }*/
                                          })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    
                self.navigationController?.popViewController(animated: true)
                })
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
            }
                
            }else{
            let cancelaction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
            }
                Common.showalertWithAction(msg: "Please enable Location Services in Settings", arrAction: [cancelaction,settingAction], view: self)
        }
        }
    }
    
}
extension ActivityReport:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.text?.count ?? 0 > 6){
            return false
        }else{
            return true
        }
    }
}
extension ActivityReport:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView.text.count > 0){
            textView.setFlexibleHeight()
        }
        return true
    }
}
extension ActivityReport :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if(isActivityImage1){
            isActivityImage1 = false
        }
        if(isActivityImage2){
            isActivityImage2 = false
        }
        if(isActivityImage3){
            isActivityImage3 = false
        }
        if(isActivityImage4){
            isActivityImage4 = false
        }
        if(isActivityImage5){
            isActivityImage5 = false
        }
        picker.dismiss(animated: true
            , completion:   nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      //  SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
        
       if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       {
        if(isActivityImage1){
            img1.image = chosenImage
            actimg1 = chosenImage
           
        }
        if(isActivityImage2){
            img2.image = chosenImage
            actimg2 = chosenImage
        }
        if(isActivityImage3){
            img3.image = chosenImage
            actimg3 = chosenImage
        }
        if(isActivityImage4){
            img4.image = chosenImage
            actimg4 = chosenImage
        }
        if(isActivityImage5){
            img5.image = chosenImage
            actimg5 = chosenImage
        }
        isActivityImage1 = false
        isActivityImage2 = false
        isActivityImage3 = false
        isActivityImage4 = false
        isActivityImage5 = false
        dismiss(animated:true, completion: nil)
        
    }
    }
}
extension ActivityReport:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count of participant = \(AddParticipant.arrOfParticipant.count)")
        return AddParticipant.arrOfParticipant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityparticipantcell", for: indexPath) as? ActivityParticipantCell{
            let selectedParticipant  = AddParticipant.arrOfParticipant[indexPath.row]
            cell.lblCustomername.text =  selectedParticipant.name as? String
           
            let strattrMobileno = NSMutableAttributedString.init(string: "Mobile No :", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
            strattrMobileno.append(NSAttributedString.init(string: selectedParticipant.contactno, attributes: [:]))
            cell.lblCustomerContact.attributedText = strattrMobileno
            
//            cell.lblCustomerContact.text = selectedParticipant.contactno as? String
            
            cell.celldelegate = self
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
extension ActivityReport:ActivityParticipantCelldelegate
{
    func btndeleteparticipantclicked(cell: ActivityParticipantCell) {
        if let indexPath = tblParticipant.indexPath(for: cell) as? IndexPath{
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in


            //self.arrOfProduct.remove(at: indexPath.row)
            AddParticipant.arrOfParticipant.remove(at: indexPath.row)

            self.tblParticipant.beginUpdates()
        
            self.tblParticipant.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
            DispatchQueue.main.async {
                self.tblParticipant.layoutIfNeeded()
                self.tblParticipant.reloadData()
               self.cnsttblactivityparticipantHeightConstant.constant = self.tableViewHeight
            }
            self.tblParticipant.endUpdates()


        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
    
    
}
