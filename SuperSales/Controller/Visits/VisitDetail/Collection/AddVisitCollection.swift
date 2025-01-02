//
//  AddVisitCollection.swift
//  SuperSales
//
//  Created by Apple on 13/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import FastEasyMapping

class AddVisitCollection: BaseViewController {

    @IBOutlet weak var tfCollection: UITextField!
    
    @IBOutlet weak var tfBalance: UITextField!
    
    @IBOutlet weak var lblPayMode: UILabel!
    
    @IBOutlet weak var btnPayModeSelection: UIButton!
    
    @IBOutlet weak var txtRefNo: UITextField!
    
    
    @IBOutlet weak var vwTfRef: UIView!
    @IBOutlet weak var txtFollowDt: UITextField!
    
    @IBOutlet weak var vwPayMode: UIView!
    
    @IBOutlet weak var vwFlwDtwHeader: UIView!
    
    @IBOutlet weak var vwTxtFlw: UIView!
    
    var paymentOptionsDropDown:DropDown = DropDown()
    var isEditCollection:Bool!
    var collectionList:VisitCollection?
    var datePicker:UIDatePicker! =  UIDatePicker()
   // var objvisitcollection:VisitCollection?
    var planvisit:PlannVisit!
    var modeOfPayment:Int!
    
    @IBOutlet weak var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    func setUI(){
        
        btnSubmit.setbtnFor(title:NSLocalizedString("submit", comment:""), type: Constant.kPositive)
        self.title = NSLocalizedString("add_collection", comment: "")
       
        tfCollection.placeholder = String.init(format:"%@ (%@)",NSLocalizedString("collection_value", comment: ""), self.activeuser?.company?.currCode ?? "$")
        tfBalance.placeholder = String.init(format:"%@ (%@)",NSLocalizedString("balance_value", comment:""),self.activeuser?.company?.currCode ?? "$");
       // txtRefNo.placeholder = "Please Enter Refferance Number"
        vwTxtFlw.isHidden = true
        vwFlwDtwHeader.isHidden = true
//        tfCollection.text = "0"
//        tfBalance.text = "0"
        CustomeTextfield.setBottomBorder(tf: tfBalance)
        CustomeTextfield.setBottomBorder(tf: tfCollection)
        CustomeTextfield.setBottomBorder(tf: txtRefNo)
        
        tfCollection.setCommonFeature()
        txtFollowDt.setCommonFeature()
        tfBalance.setCommonFeature()
        txtRefNo.setCommonFeature()
        
        tfCollection.delegate = self
        txtFollowDt.delegate = self
       
        txtRefNo.delegate = self
        tfBalance.addTarget(self, action: #selector(self.tfBalanceTextDidChange(_:)), for: UIControl.Event.editingChanged)
        
        datePicker = UIDatePicker()
        datePicker.setCommonFeature()
        datePicker.datePickerMode =  .date
        
        datePicker.minimumDate =  Utils.getNSDateWithAppendingDay(day: 1, date1: Date(), format: "dd-MM-yyyy")
        datePicker.date = Utils.getNSDateWithAppendingDay(day: 1, date1: Date(), format: "dd-MM-yyyy")
        txtFollowDt.inputView = datePicker
        txtFollowDt.textColor = UIColor.gray
        txtFollowDt.text = Utils.getDateWithAppendingDay(day:  0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
        datePicker.addTarget(self, action: #selector(self.datepickerChanged(_:)), for: .editingDidEnd)
       
if(self.activesetting.modeOfPayReferenceRequiredInCollection == 1){
            vwPayMode.isHidden = false
            
         self.initDropDown()
        }else{
             self.vwTfRef.isHidden = true
            modeOfPayment = 0
            vwPayMode.isHidden = true
        }
        if((Int(tfBalance.text ?? "0") ?? 0 ) > 0){
            vwFlwDtwHeader.isHidden = false
        }else{
            vwFlwDtwHeader.isHidden = true
            
            
        }
        if(isEditCollection ==  true){
            if  let  visitcollection = planvisit.visitCollection {
            if let collectvalue = visitcollection.collectionValue as? Double{
        tfCollection.text = String.init(format:"\(collectvalue)")
                           }else{
                               tfCollection.text = ""
                           }
                           if let balancevalue = visitcollection.balanceValue as? Double {
                            tfBalance.text = String.init(format:"\(balancevalue)")
                           }else{
                                tfBalance.text = ""
                           }
            
            
            
           /* tfCollection.text =  String.init(format:"%.0f",visitcollection.collectionValue)
            
            tfBalance.text = String.init(format:"%.0f",visitcollection.balanceValue)*/
                var   modeOfPayment = visitcollection.modeOfPayment
            if(modeOfPayment == 1){
                vwTfRef.isHidden = true
            }else{
                
                vwTfRef.isHidden = false
                
            }
            txtRefNo.text = visitcollection.referenceNo
                if(self.activesetting.modeOfPayReferenceRequiredInCollection == 0){
        self.vwTfRef.isHidden = true
                    
                    vwPayMode.isHidden = true
                }else{
            if(modeOfPayment == 0){
                 self.lblPayMode.text = paymentOptionsDropDown.dataSource[0]
     //   btnPayModeSelection.setTitle(paymentOptionsDropDown.dataSource[0]  ,for: .normal)
            }else{
                self.lblPayMode.text = paymentOptionsDropDown.dataSource[Int(modeOfPayment)-1]
               
       // btnPayModeSelection.setTitle(paymentOptionsDropDown.dataSource[Int(modeOfPayment)-1]  ,for: .normal)
            }
                }
           if let followdate = visitcollection.followUpDate as? String{
            vwTxtFlw.isHidden = false
            vwFlwDtwHeader.isHidden = false
            var fdate = Date()
            if  let fdate1 = Utils.getDateFromStringWithFormat(gmtDateString: followdate)  as? Date{
                fdate = fdate1
            }
            else{
                fdate = Utils.getDateBigFormatToCurrent(date: visitcollection.followUpDate, format: "yyyy/MM/dd HH:mm:ss")
            }
            datePicker.date = fdate
            txtFollowDt.text = Utils.getDateWithAppendingDay(day: 0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
//            if (objVisitCollection.followUpDate != nil) {
//                vwTxtFlw.hidden = NO;
//                vwFlwDtHeader.hidden = NO;
//                NSDate *date = [Utils getDateFromStringWithFormat:objVisitCollection.followUpDate];
//                if (date==nil) {
//                    date = [Utils getDateBigFormatToDefaultFormat1:objVisitCollection.followUpDate andFormat:@"yyyy/MM/dd HH:mm:ss"];
//                }
//                datePicker.date = date;
//                txtFollowDt.text = [Utils getDateWithAppendingDay:0 Date:datePicker.date andFormat:@"dd-MM-yyyy"];
            }
          //  btnPayModeSelection.setTitle(visitcollection.modeOfPayment, for: .normal)
            }
          //  isEditCollection.text = visitcollection
        }else{
          
        }
    
    }
    func initDropDown(){
      
        paymentOptionsDropDown.dataSource =  Utils.getCollectinPaymentMode()
        if let objvisitcollection = planvisit.visitCollection{
        
            modeOfPayment = Int(objvisitcollection.modeOfPayment)
            if(modeOfPayment == 1){
                vwTfRef.isHidden = true
            }else{
                vwTfRef.isHidden = false
            }
          //  lblPayMode.text = //(modeOfPayment==0)?paymentOptionsDropDown.dataSource.first:paymentOptionsDropDown.dataSource[modeOfPayment-1]
            if(modeOfPayment == 0){
                lblPayMode.text = paymentOptionsDropDown.dataSource.first
            }else{
               lblPayMode.text = paymentOptionsDropDown.dataSource[modeOfPayment-1]
            }
        }else{
            modeOfPayment = 1
            self.lblPayMode.text = Utils.getCollectinPaymentMode().first
              if(modeOfPayment == 1){
                vwTfRef.isHidden = true
                      }else{
                        vwTfRef.isHidden = false
                      }
            
        }
        paymentOptionsDropDown.anchorView = btnPayModeSelection
        paymentOptionsDropDown.bottomOffset = CGPoint.init(x: 0, y: 0)
        paymentOptionsDropDown.selectionAction = {(index,item) in
self.lblPayMode.text = item
self.modeOfPayment = index + 1
if(self.modeOfPayment == 1){
   
                self.vwTfRef.isHidden = true
            }else{
                 self.vwTfRef.isHidden = false
            }
        }
        paymentOptionsDropDown.reloadAllComponents()
    }
    
    // MARK: - UITextfielddeleagate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if( textField == tfCollection || textField == tfBalance){
            let maxLength = 12
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
         }else if(textField == txtRefNo){
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
         }else{
            return true
        }
    }
  
    // MARK:  - IBAction
    
    @IBAction func selectPaymentMode(_ sender: UIButton) {
        //payment mode options
        paymentOptionsDropDown.show()
        
    }
    @IBAction func selectFollowDate(_ sender: UIButton) {
        txtFollowDt.becomeFirstResponder()
        txtFollowDt.text = Utils.getDateWithAppendingDay(day:  0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
    }
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        var msg = ""
        if(self.activesetting.modeOfPayReferenceRequiredInCollection == 1){
            if(txtRefNo.text?.count == 0 && modeOfPayment != 1){
                msg = NSLocalizedString("please_enter_reference_no", comment:"")
            }
            
        }
        if(msg.count > 0){
            Utils.toastmsg(message:msg,view:self.view)
        }else{
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var visitcollectiondic = [String:Any]()
            if(isEditCollection == true){
               if let  visitcollection = planvisit.visitCollection as? VisitCollection{
                if let visitcollectionId = visitcollection.iD as? Int64{
                print(visitcollectionId)
                visitcollectiondic["ID"] = NSNumber.init(value:visitcollectionId)
                    //as? NSNumber ?? NSNumber.init(value:0)
                }
                }
            }
            visitcollectiondic["visitID"] = planvisit.iD
            visitcollectiondic["createdBy"] =  self.activeuser?.userID
            visitcollectiondic["collectionValue"] = tfCollection.text
            visitcollectiondic["balanceValue"] = tfBalance.text
            if((Int(tfBalance.text ?? "0") ?? 0 ) > 0){
                //FormatString(@"%@ 00:00:00", [Utils getDateWithAppendingDayLang:0 Date:datePicker.date andFormat:@"yyyy/MM/dd"])
                visitcollectiondic["followUpDate"] = String.init(format:"%@ 00:00:00",Utils.getDateWithAppendingDay(day: 0, date: datePicker.date, format: "yyyy/MM/dd", defaultTimeZone: true))
            }
            if(self.activesetting.modeOfPayReferenceRequiredInCollection == true){
                visitcollectiondic["modeOfPayment"] = NSNumber.init(value: modeOfPayment)
                if(modeOfPayment != 1){
                    visitcollectiondic["referenceNo"] = txtRefNo.text
                }else{
                    txtRefNo.text = ""
                }
            }
            param["addVisitCollectionJson"] = Common.json(from:visitcollectiondic )
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddUpdateVisitCollection, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                 if(status.lowercased() == Constant.SucessResponseFromServer){
                    print(arr)
                    print(responseType)
                    if(responseType == ResponseType.arr){
                                
                     let arrvisitcollection = arr as? [Any] ?? [Any]()
                     print(arrvisitcollection)
                     MagicalRecord.save({ (localContext) in
                        FEMDeserializer.collection(fromRepresentation: arrvisitcollection, mapping: VisitCollection.defaultmapping(), context: localContext)
                             localContext.mr_save({ (localContext) in
                                 print("saving")
                             }, completion: { (status, error) in
                                 print("saved")
                             })
                            // FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping())

                         }, completion: { (contextdidsave, error) in
                             print("visit saved")
                             print(error?.localizedDescription ?? "")
                            let visitcollection = VisitCollection.getVisitCollectionFromID(id:NSNumber.init(value:self.planvisit.visitCollection?.iD ?? 0))
            self.planvisit.visitCollection = visitcollection!
                           
       self.planvisit.visitCollection?.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                if(error == nil){
                                  //  self.navigationController?.popViewController(animated: true)
                                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                }else {
                                    Utils.toastmsg(message:error?.localizedDescription ?? "",view:self.view)
                                }
                            })
                           
                         })
                                
                    }else if(responseType == ResponseType.dic){
                        let dicvisitcollection = arr as? [String:Any] ?? [String:Any]()
                      
                        MagicalRecord.save({ (localContext) in
                           FEMDeserializer.collection(fromRepresentation: [dicvisitcollection], mapping: VisitCollection.defaultmapping(), context: localContext)
                                localContext.mr_save({ (localContext) in
                                    print("saving")
                                }, completion: { (status, error) in
                                    print("saved")
                                    print(error?.localizedDescription)
                                    print(status)
                                })
                               // FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping())

                            }, completion: { (contextdidsave, error) in
                                print("visit saved")
                                print(error?.localizedDescription ?? "")
                                if let visitcollection = VisitCollection.getVisitCollectionFromID(id:NSNumber.init(value:self.planvisit.iD)){
                               self.planvisit.visitCollection = visitcollection
                                }
                               self.planvisit.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                   if(error == nil){
                                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
                                 //      self.navigationController?.popViewController(animated: true)
                                    }
                                   }else {
                                       Utils.toastmsg(message:error?.localizedDescription ?? "" ,view:self.view)
                                   }
                               })
                              
                            })
                    }
//                    self.navigationController?.popViewController(animated: true)
//                     Utils.toastmsg(message:message,view: self.view)
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

}
extension AddVisitCollection:UITextFieldDelegate{
    @objc func tfBalanceTextDidChange(_ textField: UITextField) {
        if((Int(tfBalance.text ?? "0") ?? 0 ) > 0){
                                  vwFlwDtwHeader.isHidden = false
                                    vwTxtFlw.isHidden = false
           if(self.activesetting.modeOfPayReferenceRequiredInCollection == 1){
                      vwPayMode.isHidden = false
                      self.initDropDown()
                  }else{
                      modeOfPayment = 0
                      vwPayMode.isHidden = true
                  }
                              }else{
                                  vwFlwDtwHeader.isHidden = true
                                  vwTxtFlw.isHidden = true
                                 
                                  
                              }
               }
    @objc func datepickerChanged(_ datepicker:UIDatePicker){
      //  self.dateFormatter.dateFormat = "dd-MM-yyyy"
      
        txtFollowDt.text = Utils.getDateWithAppendingDay(day:  0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if(textField == tfBalance){
        if((Int(tfBalance.text ?? "0") ?? 0 ) > 0){
        vwFlwDtwHeader.isHidden = false
            if(modeOfPayment == 1){
                vwTfRef.isHidden = true
            }else{
                vwTfRef.isHidden = false
            }
        }else{
            vwFlwDtwHeader.isHidden = true
        }
         }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfBalance){
            
            if((Int(tfBalance.text ?? "0") ?? 0 ) > 0){
                      vwFlwDtwHeader.isHidden = false
                if(modeOfPayment == 1){
                    vwTfRef.isHidden = true
                }else{
                    vwTfRef.isHidden = false
                }
                  }else{
                      vwFlwDtwHeader.isHidden = true
                      
                      
                  }
            
        }else if(textField ==  txtFollowDt){
            textField.text = Utils.getDateWithAppendingDay(day:  0, date: datePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
        }
    }
    
}
