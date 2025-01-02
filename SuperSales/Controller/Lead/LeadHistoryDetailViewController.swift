//
//  LeadHistoryDetailViewController.swift
//  SuperSales
//
//  Created by Apple on 20/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CoreLocation

class LeadHistoryDetailViewController: BaseViewController {
    
    var leadhistory:Lead!
    
    @IBOutlet weak var vwBorder: UIView!
    @IBOutlet weak var tblLeadStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var vwLeadDetail: UIView!
    
    @IBOutlet weak var tblLeadHistoryProductHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var tblLeadHistoryProduct: UITableView!
    
    @IBOutlet weak var tblLeadStatus: UITableView!
    
    @IBOutlet weak var lblCustomerNamevalue: UILabel!
    
    @IBOutlet weak var lblContactNo: UILabel!
    
    
    @IBOutlet weak var lblInfluencerAddress: UILabel!
    
    @IBOutlet weak var lblCustomerOrientationValue: UILabel!
    
    @IBOutlet weak var lblAssignedToValue: UILabel!
    
    @IBOutlet weak var lblLeadSourceValue: UILabel!
    
    @IBOutlet weak var lblCreateDate: UILabel!
    @IBOutlet weak var imgInteraction: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblInfluencerNameValue: UILabel!
    
    // MARK: - Method
    func setUI(){
        self.vwLeadDetail.addBorders(edges: [.left,.right,.top,.bottom], color: UIColor.lightGray, cornerradius: 5)
        self.vwBorder.addBorders(edges: [.top,.bottom], color: UIColor.clear, cornerradius: 45)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = String.init(format:"Lead No. \(leadhistory.seriesPostfix)")
        let strContact = NSMutableAttributedString.init(string: "Contact:")
        
        lblInfluencerAddress.setMultilineLabel(lbl: lblInfluencerAddress)
        imgInteraction.image = UIImage.init(named: "icon_placeholder")
        imgInteraction.image = Utils.getImageFrom(interactionId: Int(leadhistory.nextActionID))
        self.lblCustomerOrientationValue.text = Utils.getStringCustomerOrintationFromCustomerOrintationID(oriID: Int(leadhistory.customerOrientationID))
        
        if let inflencer = CustomerDetails.getCustomerByID(cid:  NSNumber.init(value:leadhistory.influencerID)){
            lblInfluencerNameValue.text = inflencer.name
        }else{
            lblInfluencerNameValue.text = "text"
        }
        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if let leadsource  =  LeadSource.getLeadSourceFromLeadSourceID(leadsourceID: NSNumber.init(value:leadhistory.leadSourceID)) as? String{
            self.lblLeadSourceValue.text = leadsource
        }else{
            self.lblLeadSourceValue.text = ""
        }
        let createdDate = self.dateFormatter.date(from: leadhistory.createdTime)
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
       
        lblCreateDate.text = self.dateFormatter.string(from: createdDate ?? Date()  )//leadhistory.createdTime
        let strAddress = NSMutableAttributedString.init(string: "Address :")
        if let address = AddressList().getAddressByAddressId(aId: NSNumber.init(value: leadhistory.addressMasterID)){
            var stradd = ""
            if let stradd1  =  address.addressLine1 as? String{
                stradd.append(stradd1)
            }
            if let stradd2  = address.addressLine2 as? String{
                stradd.append(stradd2)
            }
            if let straddcity  = address.city as? String{
                stradd.append(straddcity)
            }
            if let straddcity  = address.city as? String{
                stradd.append(straddcity)
            }
            
            let straddressline = NSAttributedString.init(string:String.init(format:"\(stradd)"),attributes: [:])
            strAddress.append(straddressline)
        }
        lblInfluencerAddress.attributedText = strAddress

        //strAddress.append(NSAttributedString.init(string: leadhistory.addressMasterID, attributes: [:]))
        if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:leadhistory.contactID)) as? Contact{
            strContact.append(NSAttributedString.init(string: contact.mobile, attributes:[NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor : UIColor.systemBlue,NSAttributedString.Key.underlineStyle : 1]))
        }
        lblContactNo.attributedText = strContact
        tblLeadStatus.delegate = self
        tblLeadStatus.dataSource = self
        tblLeadHistoryProduct.delegate = self
        tblLeadHistoryProduct.dataSource = self
        lblCustomerNamevalue.text = leadhistory.customerName
        if let assignuser  = CompanyUsers().getUser(userId: NSNumber.init(value:leadhistory.assignedBy)){
            lblAssignedToValue.text = String.init(format:"Assigned To: \(assignuser.firstName) \(assignuser.lastName)")
        }
        tblLeadStatus.reloadData()
        tblLeadHistoryProduct.reloadData()
        self.updateContraints()
    }
    
    func updateContraints(){
//        tblLeadStatus.reloadData()
        tblLeadStatus.layoutSubviews()
        
        tblLeadStatusHeight.constant = tblLeadStatus.contentSize.height
        tblLeadHistoryProductHeight.constant = tblLeadHistoryProduct.contentSize.height
        
      //  tblLeadHistoryProductHeight.constant = tb
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBAction
    @objc func viewPicClicked(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            if let selectedstatus = self.leadhistory.leadStatusList[sender.tag] as? LeadStatusList{
         
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
    
    @objc func viewPic2Clicked(_ sender: UIButton) {
        if let selectedstatus = leadhistory.leadStatusList[sender.tag] as? LeadStatusList{
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
    
    
    @objc func viewPic3Clicked(_ sender: UIButton) {
        if let selectedstatus = leadhistory.leadStatusList[sender.tag] as? LeadStatusList{
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
    
    @objc func viewPic4Clicked(_ sender: UIButton) {
        if let selectedstatus = leadhistory.leadStatusList[sender.tag] as? LeadStatusList{
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
    
    @objc func viewPic5Clicked(_ sender: UIButton) {
        if let selectedstatus = leadhistory.leadStatusList[sender.tag] as? LeadStatusList{
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

}
extension LeadHistoryDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView ==  tblLeadStatus){
        return leadhistory.leadStatusList.count
        }else{
        return leadhistory.productList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(leadhistory.leadStatusList.count)
        print(leadhistory.productList.count)
        
        if(tableView == tblLeadStatus){
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "leadinteractioncell", for: indexPath) as? LeadInteractionCell{
            cell.selectionStyle = .none
            
            if let status = leadhistory.leadStatusList[indexPath.row] as? LeadStatusList{
            print("next action date = \(status.nextActionTime)")
                cell.btnvwPic1.tag = indexPath.row
                cell.btnvwPic2.tag = indexPath.row
                cell.btnvwPic3.tag = indexPath.row
                cell.btnvwPic4.tag = indexPath.row
                cell.btnvwPic5.tag = indexPath.row
                cell.btnvwPic1.addTarget(self, action: #selector(viewPicClicked), for: UIControl.Event.touchUpInside)
                cell.btnvwPic2.addTarget(self, action: #selector(viewPic2Clicked), for: UIControl.Event.touchUpInside)
                cell.btnvwPic3.addTarget(self, action: #selector(viewPic3Clicked), for: UIControl.Event.touchUpInside)
                cell.btnvwPic4.addTarget(self, action: #selector(viewPic4Clicked), for: UIControl.Event.touchUpInside)
                cell.btnvwPic5.addTarget(self, action: #selector(viewPic5Clicked), for: UIControl.Event.touchUpInside)
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let nextactiondate = dateformatter.date(from: status.nextActionTime)
                dateformatter.dateFormat = "dd-MM-yyyy"
                cell.lblInteractionDate.text = dateformatter.string(from:Date())
                if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:status.interactionWith)){
                    cell.lblContactDetail.text = String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")")
                }else{
                    cell.lblContactDetail.text = "No Contact"
                }
                dateformatter.dateFormat = "dd-MM-yyyy hh:mm a"
                cell.lblNExtActionTimeDetail.text = dateformatter.string(from:nextactiondate ?? Date())
                dateformatter.dateFormat = "dd-MM-yyyy"
                cell.lblNextActionDateValue.text = dateformatter.string(from:nextactiondate ?? Date())
                //cell.lblOutComeValue.text = status.outcomeID
               // if(status.imagePath.count > 0)
                  
                if let selectedOutcome = Outcomes.getOutcome(leadSourceID: NSNumber.init(value: status.outcomeID)){
                    cell.lblOutComeValue.text = selectedOutcome.leadOutcomeValue
                }
                print("customer orientation id = \(status.customerOrientationID) remark = \(status.remarks)")
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
                    cell.btnvwPic2.isHidden = false
                }else{
                    cell.btnvwPic2.isHidden = true
                }
                if(status.imagePath5.count > 0){
                    cell.btnvwPic5.isHidden = false
                }else{
                    cell.btnvwPic5.isHidden = true
                }
                
                cell.lblRemarkValue.text = status.remarks
                if(status.remarks.count > 0){
                    cell.lblRemarkTitle.isHidden = false
                    cell.lblRemarkValue.isHidden = false
                }else{
                    cell.lblRemarkTitle.isHidden = true
                    cell.lblRemarkValue.isHidden = true
                }
                
                cell.lblCustomerOrientationValue.text = Utils.getStringCustomerOrintationFromCustomerOrintationID(oriID: Int(status.customerOrientationID))//status.customerOrientationID
            }
        return cell
        
        }else{
            return UITableViewCell()
        }
        }else if(tableView == tblLeadHistoryProduct){
            if  let cell = tableView.dequeueReusableCell(withIdentifier: "leadhistoryproductcell", for: indexPath) as? LeadHistoryProductCell{
                cell.selectionStyle = .none
               if let product = leadhistory.productList[indexPath.row] as? ProductsList{
                cell.lblProductNameValue.text = product.productName
                cell.lblProductNameValue.setMultilineLabel(lbl: cell.lblProductNameValue)
                cell.lblProductQuantityValue.text = String.init(format:"\(product.quantity)")
                cell.lblProductBudgetvale.text = String.init(format:"\(product.budget ?? 0)")
                cell.layoutSubviews()
                }
                return  cell
        }else{
            return UITableViewCell()
        }
        }else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
extension LeadHistoryDetailViewController:IDMPhotoBrowserDelegate{
    
}
