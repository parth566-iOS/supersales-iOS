//
//  PastInteractionOfLeadUpdateStatus.swift
//  SuperSales
//
//  Created by Apple on 17/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CoreLocation

class PastInteractionOfLeadUpdateStatus: BaseViewController {
    var objLead:Lead!
    
    @IBOutlet weak var tblPastInteraction: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    // MARK: - Method
    func setUI(){
        tblPastInteraction.delegate = self
        tblPastInteraction.dataSource = self
        tblPastInteraction.reloadData()
        tblPastInteraction.tableFooterView = UIView()
    }

    
    
    @IBAction func viewPicClicked(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            if let selectedstatus = self.objLead.leadStatusList[sender.tag] as? LeadStatusList{
         
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedstatus.imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
            var strcaption = ""
            if let datetime  = selectedstatus.imageTimeStamp as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
    self.getAddressFromLatLong(lattitude: CLLocationDegrees.init(selectedstatus.imageLattitude.toDouble()), longitude:
                                CLLocationDegrees.init(selectedstatus.imageLongitude.toDouble())) { (stradd) in
                                       //selectedstatus.imageLattitude, longitude: selectedstatus.imageLongitude) { (stradd) in
                strcaption.append("\n \(stradd)")
            }
          //  strcaption.append("\n \()")
            if let lat =  selectedstatus.imageLattitude as? String{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  selectedstatus.imageLongitude as? String{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                 //photos?.append(photo)
                 let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: [photo])
                 browser.delegate = self
                 browser.displayCounterLabel = true
                 browser.displayActionButton = false
                 browser.autoHideInterface = false
                 browser.dismissOnTouch = false
                 browser.displayArrowButton = false
                 browser.displayActionButton = false
                 browser.disableVerticalSwipe = true
    
                 self.present(browser, animated: true, completion: nil)
    }
        }
    }
    
    @IBAction func viewPic2Clicked(_ sender: UIButton) {
        if let selectedstatus = objLead.leadStatusList[sender.tag] as? LeadStatusList{
            DispatchQueue.main.async {
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedstatus.imagePath2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
            var strcaption = ""
            if let datetime  = selectedstatus.imageTimeStamp as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            self.getAddressFromLatLong(lattitude: CLLocationDegrees.init(selectedstatus.imageLattitude.toDouble()), longitude: CLLocationDegrees.init(selectedstatus.imageLongitude.toDouble())) { (stradd) in
                strcaption.append("\n \(stradd)")
            }
          //  strcaption.append("\n \()")
            if let lat =  selectedstatus.imageLattitude as? String{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  selectedstatus.imageLongitude as? String{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                 //photos?.append(photo)
                 let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: [photo])
                 browser.delegate = self
                 browser.displayCounterLabel = true
                 browser.displayActionButton = false
                 browser.autoHideInterface = false
                 browser.dismissOnTouch = false
                 browser.displayArrowButton = false
                 browser.displayActionButton = false
                 browser.disableVerticalSwipe = true
    
                 self.present(browser, animated: true, completion: nil)
    }
        }
    }
    
    
    @IBAction func viewPic3Clicked(_ sender: UIButton) {
        if let selectedstatus = objLead.leadStatusList[sender.tag] as? LeadStatusList{
            DispatchQueue.main.async {
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedstatus.imagePath3.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
            var strcaption = ""
            if let datetime  = selectedstatus.imageTimeStamp as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            self.getAddressFromLatLong(lattitude: CLLocationDegrees.init(selectedstatus.imageLattitude.toDouble()), longitude: CLLocationDegrees.init(selectedstatus.imageLongitude.toDouble())) { (stradd) in
                strcaption.append("\n \(stradd)")
            }
          //  strcaption.append("\n \()")
            if let lat =  selectedstatus.imageLattitude as? String{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  selectedstatus.imageLongitude as? String{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                 //photos?.append(photo)
                 let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: [photo])
                 browser.delegate = self
                 browser.displayCounterLabel = true
                 browser.displayActionButton = false
                 browser.autoHideInterface = false
                 browser.dismissOnTouch = false
                 browser.displayArrowButton = false
                 browser.displayActionButton = false
                 browser.disableVerticalSwipe = true
     
                 self.present(browser, animated: true, completion: nil)
    }
        }
    }
    
    @IBAction func viewPic4Clicked(_ sender: UIButton) {
        if let selectedstatus = objLead.leadStatusList[sender.tag] as? LeadStatusList{
            DispatchQueue.main.async {
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedstatus.imagePath4.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
            var strcaption = ""
            if let datetime  = selectedstatus.imageTimeStamp as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            self.getAddressFromLatLong(lattitude: CLLocationDegrees.init(selectedstatus.imageLattitude.toDouble()), longitude: CLLocationDegrees.init(selectedstatus.imageLongitude.toDouble())) { (stradd) in
                strcaption.append("\n \(stradd)")
            }
          //  strcaption.append("\n \()")
            if let lat =  selectedstatus.imageLattitude as? String{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  selectedstatus.imageLongitude as? String{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                 //photos?.append(photo)
                 let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: [photo])
                 browser.delegate = self
                 browser.displayCounterLabel = true
                 browser.displayActionButton = false
                 browser.autoHideInterface = false
                 browser.dismissOnTouch = false
                 browser.displayArrowButton = false
                 browser.displayActionButton = false
                 browser.disableVerticalSwipe = true
    
                 self.present(browser, animated: true, completion: nil)
    }
        }
    }
    
    @IBAction func viewPic5Clicked(_ sender: UIButton) {
        if let selectedstatus = objLead.leadStatusList[sender.tag] as? LeadStatusList{
            DispatchQueue.main.async {
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedstatus.imagePath5.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
            var strcaption = ""
            if let datetime  = selectedstatus.imageTimeStamp as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            self.getAddressFromLatLong(lattitude: CLLocationDegrees.init(selectedstatus.imageLattitude.toDouble()), longitude: CLLocationDegrees.init(selectedstatus.imageLongitude.toDouble())) { (stradd) in
                strcaption.append("\n \(stradd)")
            }
          //  strcaption.append("\n \()")
            if let lat =  selectedstatus.imageLattitude as? String{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  selectedstatus.imageLongitude as? String{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                 //photos?.append(photo)
                 let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: [photo])
                 browser.delegate = self
                 browser.displayCounterLabel = true
                 browser.displayActionButton = false
                 browser.autoHideInterface = false
                 browser.dismissOnTouch = false
                 browser.displayArrowButton = false
                 browser.displayActionButton = false
                 browser.disableVerticalSwipe = true
    
                 self.present(browser, animated: true, completion: nil)
    }
        }
    }
    
    
    
    @IBAction func btnLeadAttachmentClicked(_ sender: UIButton) {
        if let selectedstatus = objLead.leadStatusList[sender.tag] as? LeadStatusList{
            DispatchQueue.main.async {
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedstatus.leadAttachementPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
            var strcaption = ""
            if let datetime  = selectedstatus.imageTimeStamp as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            self.getAddressFromLatLong(lattitude: CLLocationDegrees.init(selectedstatus.imageLattitude.toDouble()), longitude: CLLocationDegrees.init(selectedstatus.imageLongitude.toDouble())) { (stradd) in
                strcaption.append("\n \(stradd)")
            }
          //  strcaption.append("\n \()")
            if let lat =  selectedstatus.imageLattitude as? String{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  selectedstatus.imageLongitude as? String{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                 //photos?.append(photo)
                 let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: [photo])
                 browser.delegate = self
                 browser.displayCounterLabel = true
                 browser.displayActionButton = false
                 browser.autoHideInterface = false
                 browser.dismissOnTouch = false
                 browser.displayArrowButton = false
                 browser.displayActionButton = false
                 browser.disableVerticalSwipe = true
    
                 self.present(browser, animated: true, completion: nil)
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
extension PastInteractionOfLeadUpdateStatus:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(" count of status for lead = \(objLead.leadStatusList.count) table")
        return objLead.leadStatusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //return UITableViewCell()
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "leadinteractioncell", for: indexPath) as? LeadInteractionCell{
            if let status = objLead.leadStatusList[indexPath.row] as? LeadStatusList{
       
                cell.btnvwPic1.tag = indexPath.row
                cell.btnvwPic2.tag = indexPath.row
                cell.btnvwPic3.tag = indexPath.row
                cell.btnvwPic4.tag = indexPath.row
                cell.btnvwPic5.tag = indexPath.row
                cell.btnLeadAttachmentLink.tag = indexPath.row
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
             
                let nextactiondate = Utils.getDateBigFormatToCurrent(date:status.nextActionTime
                                                                       , format: "dd-MM-yyyy")// dateformatter.date(from: status.nextActionTime)
                dateformatter.dateFormat = "dd-MM-yyyy"
               
                cell.lblStatusFrom.text = dateformatter.string(from:nextactiondate)//dateformatter.string(from:Date())
//                let mutattstringnad = NSMutableAttributedString.init(string: "Changed From ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)])
//                mutattstringnad.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: dateformatter.string(from:prenextactiondate) , attributes: [:])))
//                mutattstringnad.append(NSAttributedString.init(string: " to ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)]))
//                mutattstringnad.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: dateformatter.string(from:nextactiondate) , attributes: [:])))
              
                
               // cell.lblRemarkValue.attributedText = mutattstringremark
                
             //   cell.lblStatusFrom.attributedText = mutattstringnad
               var  strInfluname = ""
                if(objLead.influencerID > 0 || objLead.secondInfluencerID > 0){
                    cell.lblInteractionDate.isHidden = false
                if(status.statusFrom == "C"){
                    strInfluname = "[Customer]"
                }else if(status.statusFrom == "I"){
                   strInfluname  = "[Inf - "
                    if let influen = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:objLead.influencerID)) {
                    cell.lblInteractionDate.text = strInfluname
                        strInfluname.append(String.init(format:"\(influen) ]"))
                    }
                }else if(status.statusFrom == "S"){
                     strInfluname  = "[Inf - "
                       if let influen = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:objLead.secondInfluencerID)){
                       cell.lblInteractionDate.text = strInfluname
                        strInfluname.append(String.init(format: "\(influen) ]"))
                       }
                }
                }else{
                    cell.lblInteractionDate.isHidden = true
                }
                cell.lblInteractionDate.text = strInfluname
             //   cell.lblInteractionDate.text = status.statusFrom
                cell.imgInteraction.image = Utils.getImageFromForLead(interactionId: Int(status.interactionTypeID))
                cell.imgNextActionIcon.image  = Utils.getImageFromForLead(interactionId: Int(status.nextActionID))
                
                let mutattstringcontact = NSMutableAttributedString.init(string: "Contact Changed From ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor])
            
                if let contact1 = Contact.getContactFromID(contactID: NSNumber.init(value:status.preInteractionWith)){
                mutattstringcontact.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: String.init(format:"\(contact1.firstName ?? "") \(contact1.lastName ?? "")") , attributes: [NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor])))
                }
                mutattstringcontact.append(NSAttributedString.init(string: " to ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor]))
                
                if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:status.interactionWith)){
                mutattstringcontact.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")") , attributes: [NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor])))
                }
                
               // cell.lblRemarkValue.attributedText = mutattstringremark
                
                cell.lblContactDetail.setMultilineLabel(lbl: cell.lblContactDetail)
                if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:status.interactionWith)){
                    if(status.preInteractionWith > 0 && status.preInteractionWith != status.interactionWith){
                    cell.lblContactDetail.attributedText = mutattstringcontact//String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")")
                    }else{
                        cell.lblContactDetail.text = String.init(format:"Contact : \(contact.firstName ?? "") \(contact.lastName ?? "")")
                    }
                }else{
                    cell.lblContactDetail.text = "No Contact"
                }
                dateformatter.dateFormat = "dd-MM-yyyy HH:mm a"//"yyyy-MM-dd hh:mm:ss"
                cell.lblNExtActionTimeDetail.text = dateformatter.string(from:nextactiondate ?? Date())
                dateformatter.dateFormat = "yyyy-MM-dd"
               // cell.lblNextActionDateValue.text = Utils.getDateBigFormatToDefaultFormat(date: nextactiondate, format: "yyyy-MM-dd") //dateformatter.string(from:nextactiondate ?? Date())2022/01/13 11:35:00
                /*
                 
                 if let strn = Utils.getDateBigFormatToDefaultFormat(date: lastoutcome.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                     if let strnt = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
             tfExpectedDate.text  = strnt
             tfNextActionDate.text = strnt
                         self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                         nextActionDate = dateFormatter.date(from: strnt) ?? Date()
                 
                 **/
                
                
                let mutattstringNAT = NSMutableAttributedString.init(string: "Changed From ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)])
               // mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: status.preRemarks , attributes: [:])))
                
                
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: status.preNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    if let strnt = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
                       
                        mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: strnt, attributes: [:])))
                    }
                }
                else if let str = Utils.getstringFromOneFormatToOther(fFormat:"yyyy/MM/dd hh:mm:ss",stringindate:status.preNextActionTime,sFormat:"yyyy-MM-dd"){
                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: str , attributes: [:])))
                }else if let str1 = Utils.getstringFromOneFormatToOther(fFormat:"yyyy/MM/dd HH:mm:ss",stringindate:status.preNextActionTime,sFormat:"yyyy-MM-dd"){
                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: str1 , attributes: [:])))
                }else{
                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "" , attributes: [:])))
                    
                }
                mutattstringNAT.append(NSAttributedString.init(string: " to ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)]))
               // mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: status.remarks , attributes: [:])))
                
                
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: status.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    if let strnt = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
                       
                        mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: strnt, attributes: [:])))
                    }
                }
                else if let str = Utils.getstringFromOneFormatToOther(fFormat:"yyyy/MM/dd hh:mm:ss",stringindate:status.nextActionTime,sFormat:"yyyy-MM-dd"){
                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: str , attributes: [:])))
                }else if let str1 = Utils.getstringFromOneFormatToOther(fFormat:"yyyy/MM/dd HH:mm:ss",stringindate:status.nextActionTime,sFormat:"yyyy-MM-dd"){
                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: str1 , attributes: [:])))
                }else{
                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "" , attributes: [:])))
                    
                }
                
                
//                if let strn = Utils.getDateBigFormatToDefaultFormat(date: status.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
//                    if let strnt = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
//                       
//                        mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: strn , attributes: [:])))
//                    }
//                }
//                else if let str = Utils.getstringFromOneFormatToOther(fFormat:"yyyy/MM/dd hh:mm:ss",stringindate:status.nextActionTime,sFormat:"yyyy-MM-dd"){
//                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: str , attributes: [:])))
//                }else if let str1 = Utils.getstringFromOneFormatToOther(fFormat:"yyyy/MM/dd HH:mm:ss",stringindate:status.nextActionTime,sFormat:"yyyy-MM-dd"){
//                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: str1 , attributes: [:])))
//                }else{
//                    mutattstringNAT.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "" , attributes: [:])))
//                    
//                }
                cell.lblNextActionDateValue.setMultilineLabel(lbl: cell.lblNextActionDateValue)
                cell.lblNextActionDateValue.attributedText =  mutattstringNAT
                if let selectedOutcome = Outcomes.getOutcome(leadSourceID: NSNumber.init(value: status.outcomeID)){
                    cell.lblOutComeValue.text = selectedOutcome.leadOutcomeValue
                }
                cell.lblOutComeValue.setMultilineLabel(lbl: cell.lblOutComeValue)
                print("customer orientation id = \(status.customerOrientationID) remark = \(status.remarks) , next action date = \(status.nextActionTime)")
                cell.selectionStyle = .none
                
                let mutattstringremark = NSMutableAttributedString.init(string: "Changed From ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)])
                mutattstringremark.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: status.preRemarks , attributes: [:])))
                mutattstringremark.append(NSAttributedString.init(string: " to ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)]))
                mutattstringremark.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: status.remarks , attributes: [:])))
              
                if(status.preRemarks.count > 0){
                cell.lblRemarkValue.attributedText = mutattstringremark
                }else{
                    cell.lblRemarkValue.text =  status.remarks
                }
                
                cell.lblRemarkValue.setMultilineLabel(lbl: cell.lblRemarkValue)
                
                if(status.remarks.count > 0){
                    cell.lblRemarkTitle.isHidden = false
                    cell.lblRemarkValue.isHidden = false
                }else{
                    cell.lblRemarkTitle.isHidden = true
                    cell.lblRemarkValue.isHidden = true
                }
                
                let mutattstringcustorientation = NSMutableAttributedString.init(string: "Changed From ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)])
                mutattstringcustorientation.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: Utils.getStringCustomerOrintationFromCustomerOrintationID(oriID: Int(status.preCustomerOrientationID)) , attributes: [:])))
                mutattstringcustorientation.append(NSAttributedString.init(string: " to ", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)]))
                mutattstringcustorientation.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: Utils.getStringCustomerOrintationFromCustomerOrintationID(oriID: Int(status.customerOrientationID)) , attributes: [:])))
                
//                if(status.preCustomerOrientationID  == status.customerOrientationID || status.preCustomerOrientationID == 0){
//
//                    cell.lblCustomerOrientationValue.text =  Utils.getStringCustomerOrintationFromCustomerOrintationID(oriID: Int(status.customerOrientationID))
//
//                }else{
                    cell.lblCustomerOrientationValue.attributedText = mutattstringcustorientation
              //  }
                
           //
                
                if(status.imagePath.count > 0){
                    cell.btnvwPic1.isHidden = false
                }else{
                    cell.btnvwPic1.isHidden = true
                }
                if(status.imagePath2.count > 0){
                    cell.btnvwPic2.isHidden = false
                }else{
                    cell.btnvwPic2.isHidden = true
                }
                if(status.imagePath3.count > 0){
                    cell.btnvwPic3.isHidden = false
                }else{
                    cell.btnvwPic3.isHidden = true
                }
                if(status.imagePath4.count > 0){
                    cell.btnvwPic4.isHidden = false
                }else{
                    cell.btnvwPic4.isHidden = true
                }
                if(status.imagePath5.count > 0){
                    cell.btnvwPic5.isHidden = false
                }else{
                    cell.btnvwPic5.isHidden = true
                }
                if(status.leadAttachementPath.count > 0){
                    cell.btnLeadAttachmentLink.isHidden = false
                    cell.btnLeadAttachmentLink.setAttributedTitle(NSAttributedString.init(string: status.leadAttachementPath, attributes: [:]), for: UIControl.State.normal)
                }else{
                    cell.btnLeadAttachmentLink.isHidden = true
                }
              /*  var str = ""
                if(status.preLeadStage5 == status.leadstage5){
                    
                }else{
                    if(status.leadstage5 == 1){
                        if let strleadst5text = self.activesetting.leadStage5Text {
                        str.append("Lead Satage \(strleadst5text) turned on \n")
                        }
                    }
                }
                if(status.preLeadStage6 == status.leadstage6){
                    
                }else{
                    if(status.leadstage6 == 1){
                         if let strleadst6text = self.activesetting.leadStage6Text {
                        str.append("Lead Satage \(strleadst6text) turned on \n")
                         }
                    }

                }
                if(status.preProposalSubmitted == status.proposalSubmitted){
                    
                }else{
                    if(status.proposalSubmitted == 1){
                        if let strposutext = self.activesetting.proposalSubTextInLead{
                        str.append("Lead Satage \(strposutext) turned on \n")
                        }
                    }

                }
                if(status.preIsTrialDone == status.isTrialDone){
                    
                }else{
                    if(status.isTrialDone == 1){
                        if let strtridtext = self.activesetting.trialDoneTextInLead{
                        str.append("Lead Satage \(strtridtext) turned on \n")
                        }
                    }

                }
                if(status.preIsLeadQualified == status.isLeadQualified){
                    
                }else{
                    if(status.isLeadQualified == 1){
                        if let strleqtext = self.activesetting.leadQualifiedTextInLead{
                        str.append("Lead Satage \(strleqtext) turned on \n")
                        }
                    }

                }
                if(status.preIsNegotiationDone == status.isNegotiationDone){
                    
                }else{
                    if(status.isNegotiationDone == 1){
                        if let strnegotext = self.activesetting.negotiationTextInLead{
                        str.append("Lead Satage \(strnegotext) turned on \n")
                        }
                    }

                }
               
                if(str.count  == 0){
                    cell.lblStagesUpdate.isHidden = true
                }else{
                    cell.lblStagesUpdate.isHidden = false
                    cell.lblStagesUpdate.text = str
                }
                cell.lblStagesUpdate.setMultilineLabel(lbl: cell.lblStagesUpdate)
                print("lead product  = \(status.productList.count) , count = \(status.leadPreviousProductsList.count)")*/
                cell.lblStagesUpdate.isHidden = true
                if(status.leadPreviousProductsList.count == 0 && status.productList.count == 0){
                    cell.lblProductUpdate.isHidden = true
                }else{
                    cell.lblProductUpdate.isHidden = false
                    let strproductInfo = NSMutableAttributedString.init(string: "",attributes: nil)
                    for pro in status.productList{
                        if let product = pro as? ProductsList{
                            print("product name is  = \(product.productName) , and it is = \(product.isnewproduct) new added")
                           if(product.isnewproduct == 1){
                                var  strProductName = ""// NSMutableAttributedString.init(string: "",attributes: [:])
                                let proname =  product.productName ?? ""
                                let subcatname = product.subCategoryName ?? ""
                                let catname = product.categoryName ?? ""
                                if(proname.count > 0){
                                    strProductName.append(proname)
                                   // strProductName.append(NSAttributedString.init(string: String.init(format:"\(proname)"), attributes: [:]))
                                }else if(subcatname.count > 0){
                                    strProductName.append("SubCat: \(subcatname)")
                                    //strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname)"), attributes: [:]))
                                }else{
                                    strProductName.append("Cat: \(catname)")
                                  //  strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(catname)"), attributes: [:]))
                                }
                               // strproductInfo.append("\(strProductName) added with \(product.quantity) quanity \n")
                                print("product name = \(strProductName)")
                                strproductInfo.append(NSAttributedString.init(string: "\(strProductName) added with \(product.quantity) quanity \n", attributes: nil))
                            }
                        }
                    }
                    for pro in status.leadPreviousProductsList{
                        
                        if let product = pro as? ProductsList{
                            print("product name is  = \(product.productName) , and it is = \(product.isnewproduct) new deleted ")
                      //      if(product.isnewproduct == 1){
                                var  strProductName1 = ""
                                    //NSMutableAttributedString.init(string: "",attributes: nil)
                           
                                let proname =  product.productName ?? ""
                                let subcatname = product.subCategoryName ?? ""
                                let catname = product.categoryName ?? ""
                                if(proname.count > 0){
                                    strProductName1.append(proname)
                                }else if(subcatname.count > 0){
                                  //  strProductName1.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname) \n"), attributes: nil))
                                }else{
                                    strProductName1.append("Cat: \(catname) ")
                                }
                                if(strproductInfo.string.count > 0){
                                    strproductInfo.append(NSAttributedString.init(string: "\n \(strProductName1) is deleted \n", attributes: nil))
                                   // strproductInfo.append(NSAttributedString.init(string:String.init(format:" is deleted \n"), attributes:nil))
                                }else{
                                    strproductInfo.append(NSAttributedString.init(string:String.init(format:"\(strProductName1) is deleted \n"),attributes:nil))
                                }
                           // }
                        }
                    }
                    cell.lblProductUpdate.attributedText = strproductInfo
                    cell.lblProductUpdate.setMultilineLabel(lbl: cell.lblProductUpdate)
                    print("product detail :: \(strproductInfo)")
                    
                }
                cell.contentView.layoutSubviews()
                cell.contentView.layoutIfNeeded()
               // cell.lblCustomerOrientationValue.text = status.customerOrientationID
            }
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
extension PastInteractionOfLeadUpdateStatus :IDMPhotoBrowserDelegate{
    
}
