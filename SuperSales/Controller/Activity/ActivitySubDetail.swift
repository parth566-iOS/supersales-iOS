//
//  ActivitySubDetail.swift
//  SuperSales
//
//  Created by Apple on 26/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class ActivitySubDetail: BaseViewController {
    var activitymodel:Activity?
    
    @IBOutlet weak var imgInteractionType: UIImageView!
    
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var vwCreatedDate: UIView!
    @IBOutlet weak var vwScheduleInfo: UIView!
    @IBOutlet weak var vwCustomerDetail: UIView!
    
    @IBOutlet weak var vwStatusInfo: UIView!
    @IBOutlet weak var lblStatusDescription: UILabel!
   
    @IBOutlet weak var lblNoOfParticipant: UILabel!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var btnEditCustomer: UIButton!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var stkContact: UIStackView!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblContactValue: UILabel!
    
    @IBOutlet weak var tblCheckin: UITableView!
    
    @IBOutlet weak var tblCheckinHeight: NSLayoutConstraint!
    @IBOutlet weak var vwDescription: UIView!
    
    @IBOutlet weak var lblDescriptionTitle: UILabel!
   // @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var lblDescriptionValue: UILabel!
    @IBOutlet weak var statusimg1: UIImageView!
    
    @IBOutlet weak var statusimg2: UIImageView!
    
    @IBOutlet weak var statusimg3: UIImageView!
    
    @IBOutlet weak var statusimg4: UIImageView!
    
    @IBOutlet weak var statusimg5: UIImageView!
    
    @IBOutlet weak var btnViewParticipant: UIButton!
    
    
    @IBOutlet weak var lblCustomerNameValue: UILabel!
    @IBOutlet weak var vwCustomer: UIView!
    
    var statusImage1  = UIImage()
    var statusImage2  = UIImage()
    var statusImage3  = UIImage()
    var statusImage4  = UIImage()
    var statusImage5  = UIImage()
    var strAddline:NSMutableString!
    
    var statusImg1: IDMPhoto! = IDMPhoto()
    
    var statusImg2: IDMPhoto! = IDMPhoto()
    
    var statusImg3: IDMPhoto! = IDMPhoto()
    
    var statusImg4: IDMPhoto! = IDMPhoto()
    
    var statusImg5: IDMPhoto! = IDMPhoto()
    
  
    
    var dateFormater:DateFormatter = DateFormatter()
    var browser:IDMPhotoBrowser! = IDMPhotoBrowser()
    
    var tablecheckInViewHeight: CGFloat {
        tblCheckin.layoutIfNeeded()
        return tblCheckin.contentSize.height
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
        super.viewDidLoad()
        self.setUI()
        })
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateActivityCheckinInfo"), object: nil)
    }

      override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(true)
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
          self.setUI()
          })
        NotificationCenter.default.addObserver(forName: Notification.Name("updateActivityCheckinInfo"), object: nil, queue: OperationQueue.main) { [self] (notify) in
            tblCheckin.reloadData()
            updateViewConstraints()
        }
      }
    // MARK: - Method
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
     tblCheckin.reloadData()
        updateViewConstraints()
    }
    
    func setUI(){
        vwCreatedDate.isHidden = true
        tblCheckin.separatorColor = UIColor.clear
        strAddline = NSMutableString.init(string: "")
        
        print("participant of activity = \(activitymodel?.activityParticipantList.count)")
        if(activitymodel?.activityParticipantList.count ?? 0 > 0){
            btnViewParticipant.isHidden = false
        }else{
            btnViewParticipant.isHidden = true
        }
       
            
//            if let stradd1 = activitymodel.addressDetails.addressLine1 {
//
//            }
        /*if let address =  AddressList().getAddressByAddressmasterId(aId: NSNumber.init(value:activitymodel.addressMasterID ?? 0)){*/
        if let address = activitymodel?.addressDetails{
            if let stradd1 = address.addressLine1{
                strAddline.append(NSMutableString.init(string: stradd1) as String)
              //  strAddline.append(stradd1)
            }
            if let stradd2 = address.addressLine2{
                strAddline.append(NSMutableString.init(string:", \(stradd2)") as String)
            }
            if let straddcity = address.city{
                strAddline.append(NSMutableString.init(string:", \(straddcity)") as String)
            
            }
            if let straddstate = address.state{
                strAddline.append(NSMutableString.init(string:", \(straddstate)") as String)
            }
            if let straddcountry = address.country{
                strAddline.append(NSMutableString.init(string:", \(straddcountry)") as String)
            }
            if let straddcpincode = address.pincode as?  String{
                strAddline.append(NSMutableString.init(string:", \(straddcpincode)") as String)
            }
        }
        if let strAdd = strAddline as? String{
        lblAddress.text = strAdd
        }
        
          
//            if(strAddline.string == "Address: "){
//                strAddline.append(NSAttributedString.init(string:AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:activitymodel.addressMasterID )) ?? "", attributes: [:]))
//                lblAddress.attributedText = strAddline
//            }
        if let activitymodel = activitymodel as? Activity{
            if(activitymodel.customerName?.count ?? 0 > 0){
                vwCustomer.isHidden = false
                lblCustomerNameValue.text = activitymodel.customerName
            }else{
                vwCustomer.isHidden = true
            }
        
            self.stkContact.isHidden = true
            self.btnEditCustomer.isHidden = true
            if(activitymodel.statusDescription.count > 0){
                vwStatusInfo.isHidden = false
                lblStatusDescription.text = activitymodel.statusDescription
        if let statusnoofparticipant = activitymodel.noOfParticipants as? Int64{
            if(statusnoofparticipant > 0){
                            lblNoOfParticipant.isHidden = false
                let strnoOfParticipant = NSMutableAttributedString.init(string: "Number Of Participants: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                strnoOfParticipant.append(NSAttributedString.init(string: "\(statusnoofparticipant)", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)]))
                lblNoOfParticipant.attributedText = strnoOfParticipant
                //text = String.init(format:" \(statusnoofparticipant)")
                        }else{
                            lblNoOfParticipant.isHidden = true
                        }
                    }
              
                if let strimg1 = activitymodel.picture1{
            
                 let  urlpic1 = URL.init(string: strimg1.replacingOccurrences(of: " ", with: "%20").trimString)
                 
                    if let urlofimage = urlpic1 as? URL{
                    print(urlofimage)
                    self.statusimg1.sd_setImage(with: urlofimage  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                  
                        if(err == nil){
                            self.statusimg1.image = img
                            self.statusImage1 = img ?? UIImage()
                            self.statusImg1 = IDMPhoto.init(url: urlofimage)
                            let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img1Tapped))
                            self.statusimg1.isUserInteractionEnabled = true
                            self.statusimg1.addGestureRecognizer(imggesture)
                        }else{
                            self.statusimg1.image = nil
                        }
                    }
                   
                    }
                }
                    if let strimg2 = activitymodel.picture2{
                        print(strimg2)
                        let urlpic2 = URL.init(string: strimg2.replacingOccurrences(of: " ", with: "%20").trimString)
                        if let urlofimage = urlpic2 as? URL{
                        self.statusimg2.sd_setImage(with: urlofimage , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                  
                            if(err == nil){
                                self.statusimg2.image = img
                                self.statusImage2 = img ?? UIImage()
                                self.statusImg2 = IDMPhoto.init(url: urlpic2)
                                let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img2Tapped))
                                self.statusimg2.isUserInteractionEnabled = true
                                self.statusimg2.addGestureRecognizer(imggesture)
                            }else{
                                self.statusimg2.image = nil
                            }
                        // self.imgUser.image = nil
                        }
                        }
                    }
                if let strimg3 = activitymodel.picture3{
            
                 let  urlpic3 = URL.init(string: strimg3.replacingOccurrences(of: " ", with: "%20").trimString)
                 
                    if let urlofimage = urlpic3 as? URL{
                    print(urlofimage)
                    self.statusimg3.sd_setImage(with: urlofimage  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                  
                        if(err == nil){
                            self.statusimg3.image = img
                            self.statusImage3 = img ?? UIImage()
                            self.statusImg3 = IDMPhoto.init(url: urlofimage)
                            let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img3Tapped))
                            self.statusimg3.isUserInteractionEnabled = true
                            self.statusimg3.addGestureRecognizer(imggesture)
                        }else{
                            self.statusimg3.image = nil
                        }
                    }
                   
                    }
                }
                if let strimg4 = activitymodel.picture4{
            
                 let  urlpic4 = URL.init(string: strimg4.replacingOccurrences(of: " ", with: "%20").trimString)
                 
                    if let urlofimage = urlpic4 as? URL{
                    print(urlofimage)
                    self.statusimg4.sd_setImage(with: urlofimage  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                 
                        if(err == nil){
                            self.statusimg4.image = img
                            self.statusImage4 = img ?? UIImage()
                            self.statusImg4 = IDMPhoto.init(url: urlofimage)
                            let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img4Tapped))
                            self.statusimg4.isUserInteractionEnabled = true
                            self.statusimg4.addGestureRecognizer(imggesture)
                        }else{
                            self.statusimg4.image = nil
                        }
                    }
                   
                    }
                }
                if let strimg5 = activitymodel.picture5{
            
                 let  urlpic5 = URL.init(string: strimg5.replacingOccurrences(of: " ", with: "%20").trimString)
                 
                    if let urlofimage = urlpic5 as? URL{
                    print(urlofimage)
                    self.statusimg5.sd_setImage(with: urlofimage  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    print("image downloaded")
                        if(err == nil){
                            self.statusimg5.image = img
                            self.statusImage5 = img ?? UIImage()
                            self.statusImg5 = IDMPhoto.init(url: urlofimage)
                            let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img5Tapped))
                            self.statusimg5.isUserInteractionEnabled = true
                            self.statusimg5.addGestureRecognizer(imggesture)
                        }else{
                            self.statusimg5.image = nil
                        }
                    }
                   
                    }
                }
                
            }else{
                vwStatusInfo.isHidden = true
            }
            vwCustomerDetail.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
       
             vwScheduleInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
            
            vwStatusInfo.addBorders(edges: [.top,.right,.bottom], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 0)
            
            
        lblCustomerName.text =  activitymodel.activityTypeName
      
            lblAddress.setMultilineLabel(lbl: lblAddress)
            if let activitydescription =  activitymodel.activitydescription as? String{
                lblDescriptionValue.text = activitydescription
                lblDescriptionValue.setMultilineLabel(lbl: lblDescriptionValue)
//                tvDescription.text = activitydescription
//
//               tvDescription.setFlexibleHeight()
            }
        }
       //     tvDescription.isUserInteractionEnabled = false
        
        tblCheckin.delegate = self
        tblCheckin.dataSource = self
        tblCheckinHeight.constant =  tablecheckInViewHeight
        tblCheckin.reloadData()
        updateViewConstraints()
    }
    
    @objc func img1Tapped(sender:UITapGestureRecognizer){
        
        if let statusimg1 = statusImage1 as? UIImage{
        var idmarr = [IDMPhoto]()
     /*
             NSString *address = FormatString(@"%@, %@, %@-%@, %@ %@", [_activity.AddressDetails valueForKey:@"AddressLine1"], [_activity.AddressDetails valueForKey:@"AddressLine2"], [_activity.AddressDetails valueForKey:@"City"], [_activity.AddressDetails valueForKey:@"Pincode"], [_activity.AddressDetails valueForKey:@"State"], [_activity.AddressDetails valueForKey:@"Country"]);
             photo.caption = FormatString(@"%@\n%@\nLatitude: %@ Longitude: %@", [Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:_activity.LastModifiedTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"dd-MM-yyyy hh:mm a"],address,_activity.ImageLattitude,_activity.ImageLongitude);
             **/
            let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: activitymodel?.picture1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
           
            var strcaption = ""
            if let datetime  = activitymodel?.lastModifiedTime as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            if let add = strAddline as? String{
            strcaption.append("\n \(add)")
            }
            if let lat =  activitymodel?.imageLattitude{
                strcaption.append("\n Lattitude: \(lat),")
            }
            if let long =  activitymodel?.imageLongitude{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                //String.init(format:"date\(activitymodel?.imageTimeStamp) \n \(strAddline) \n Lattitude: \(activitymodel?.imageLattitude) , Longitude: \(activitymodel?.imageLattitude)")
            idmarr.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: idmarr)
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
    @objc func img2Tapped(sender:UITapGestureRecognizer){
        if let statusimg2 = statusImage2 as? UIImage{
            var idmarr = [IDMPhoto]()
         
                let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: activitymodel?.picture2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
            var strcaption = ""
            if let datetime  = activitymodel?.lastModifiedTime as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            if let add = strAddline as? String{
            strcaption.append("\n \(add)")
            }
            if let lat =  activitymodel?.imageLattitude{
                strcaption.append("\n Lattitude: \(lat)")
            }
            if let long =  activitymodel?.imageLongitude{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                idmarr.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: idmarr)
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
    @objc func img3Tapped(sender:UITapGestureRecognizer){
        if let statusimg3 = statusImage3 as? UIImage{
            var idmarr = [IDMPhoto]()
         
                let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: activitymodel?.picture3.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
            var strcaption = ""
            if let datetime  = activitymodel?.lastModifiedTime as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            if let add = strAddline as? String{
            strcaption.append("\n \(add)")
            }
            if let lat =  activitymodel?.imageLattitude{
                strcaption.append("\n Lattitude: \(lat)")
            }
            if let long =  activitymodel?.imageLongitude{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                idmarr.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: idmarr)
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
    @objc func img4Tapped(sender:UITapGestureRecognizer){
        if let statusimg4 = statusImage4 as? UIImage{
            var idmarr = [IDMPhoto]()
         
                let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: activitymodel?.picture4.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
            var strcaption = ""
            if let datetime  = activitymodel?.lastModifiedTime as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            if let add = strAddline as? String{
            strcaption.append("\n \(add)")
            }
            if let lat =  activitymodel?.imageLattitude{
                strcaption.append("\n Lattitude: \(lat)")
            }
            if let long =  activitymodel?.imageLongitude{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                idmarr.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: idmarr)
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
    
    @objc func img5Tapped(sender:UITapGestureRecognizer){
        if let statusimg5 = statusImage5 as? UIImage{
            var idmarr = [IDMPhoto]()
         
                let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: activitymodel?.picture5.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
            var strcaption = ""
            if let datetime  = activitymodel?.lastModifiedTime as? String
            {
                strcaption.append(Utils.getDatestringWithGMT(gmtDateString: datetime, format: "dd-MM-yyyy hh:mm a"))
            }
            if let add = strAddline as? String{
            strcaption.append("\n \(add)")
            }
            if let lat =  activitymodel?.imageLattitude{
                strcaption.append("\n Lattitude: \(lat)")
            }
            if let long =  activitymodel?.imageLongitude{
                strcaption.append(" Longitude: \(long)")
            }
            photo.caption = strcaption
                idmarr.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: idmarr)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - IBAction
    
    
    @IBAction func btnViewparticipant(_ sender: UIButton) {
        if let popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ViewActivityParticipant) as? ActivityParticipatDisplay{
            
            popup.modalPresentationStyle = .overCurrentContext
            popup.activity =  activitymodel
//         popup.modalPresentationStyle = .overCurrentContext
//         self.present(popup, animated: true, completion: nil)
//        self.popup?.modalPresentationStyle = .overCurrentContext
//        self.present(popup, animated: false, completion: nil)
            Utils.addShadow(view: self.view)
        self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func btnEditCustomerClicked(_ sender: UIButton) {
        
    }
    

    
    override func updateViewConstraints() {
        super.updateViewConstraints()
  //      tblCheckIn.beginUpdates()
        tblCheckinHeight.constant = tblCheckin.contentSize.height + 80
   //     tblCheckIn.endUpdates()
        //tblCheckin.lay
    }
}
extension ActivitySubDetail:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("no of checkin in Activity detail \(activitymodel?.activityCheckInCheckOutList.count) , \(activitymodel?.activityId) , \(activitymodel?.customerName)")
        return (activitymodel?.activityCheckInCheckOutList.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CheckinDetailCell, for: indexPath) as? CheckInDetailCell{
            cell.selectionStyle = .none
            cell.lblTitle.font = UIFont.systemFont(ofSize: 17)
            cell.lblCheckinTime.font = UIFont.systemFont(ofSize: 15)
            cell.lblINTitle.font = UIFont.systemFont(ofSize: 15)
            cell.lblInTime.font = UIFont.systemFont(ofSize: 15)
            cell.lblOutTitle.font = UIFont.systemFont(ofSize: 15)
            cell.lblOutTime.font = UIFont.systemFont(ofSize: 15)
            if(indexPath.row == 0){
                cell.lblTitle.text = "Plan"
                dateFormater.dateFormat =  "yyyy/MM/dd HH:mm:ss"
                if let strnextTime = activitymodel?.originalNextActionTime{
                let date = dateFormater.date(from: strnextTime)
            //[Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:objActivity.NextActionTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"dd-MM-yyyy, hh:mm a"]
//                dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
//                let nextadate = dateFormater.date(from: planVisit?.originalNextActionTime ?? "9:00  am , 05 Nov 20")
                    cell.lblCheckinTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: activitymodel?.nextActionTime ?? "67/68/678687", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/02/12 09:02:12", format: "dd-MM-yyyy, hh:mm a")
                        //Utils.getDateinstrwithaspectedFormat(givendate:date ?? Date(), format: "dd-MM-yyyy ,  hh:mm a", defaultTimZone: false)
                    
                    /*
                     [Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:objActivity.NextActionTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"dd-MM-yyyy, hh:mm a"]
                     **/
                }
                    //dateFormater.string(from: date ?? Date())
                cell.stkInTime.isHidden = true
                cell.stkOutTime.isHidden = true
            }else{
             
                if let checkin = activitymodel?.activityCheckInCheckOutList[indexPath.row - 1] as? ActivityCheckinCheckout{

                    if let executive = CompanyUsers().getUser(userId:NSNumber.init(value:checkin.createdBy)){
cell.lblTitle.text = String.init(format:"\(executive.firstName)  \(executive.lastName)")
}else{
cell.lblTitle.text = checkin.createdByName
    cell.lblTitle.font = UIFont.boldSystemFont(ofSize: 15)
}
      
cell.lblCheckinTime.isHidden = true
dateFormater.dateFormat = "MMM dd, yyyy hh:mm:ss a"
//if(checkin.statusID == 3){
//cell.lblINTitle.text = "In"
//let date = dateFormater.date(from: checkin.checkOutTime ?? "22/10/2010")
//    dateFormater.dateFormat = "hh:mm a  EEE,dd MMM yy"
//cell.lblCheckinTime.text = dateFormater.string(from: date ?? Date())
//if let checkouttime = checkin.checkOutTime{
//print("Checkout time \(checkouttime)")
//cell.lblOutTitle.text = "Out"
//var strch =   ""
//if let strcht = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss"){
//strch = strcht
//}
//
//cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strch, format: "hh:mm a  EEE,dd MMM yy")
//}
//else if let checkintime = checkin.checkInTime{
//
//    cell.lblTitle.text = "In"
//    var strchit = ""
//    if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
//    strchit = strch
//                        }
//                        cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
//                    }
//
//                }
//else{
    
 //   if(checkin.visitManualCheckIn == 0 ){
    cell.lblINTitle.text = "In"
    if let checkintime = checkin.checkInTime as? String{
    var strchit = ""
        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkintime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                      strchit = strch
                    }
        cell.lblInTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                }
  //  }

    if(checkin.checkOutTime.count > 0){
//        cell.lblOutTitle.isHidden = false
//        cell.lblOutTime.isHidden =  false
       // cell.stkInTime.isHidden = false
        cell.stkOutTime.isHidden = false
      if let checkouttime = checkin.checkOutTime as? String{
        cell.lblOutTitle.text = "Out"
        var strchit = ""
        if let strch = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                strchit = strch
        }
        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
                    }else{
                     
                         cell.stkOutTime.isHidden = true
//        cell.lblOutTitle.isHidden = true
//        cell.lblOutTime.isHidden =  true
                    }
                    }
   /* else if let manualCheckOutStatusID  =  checkin.manualCheckOutStatusID as? Int16 {
        cell.lblOutTitle.isHidden = false
        cell.lblOutTime.isHidden =  false
                        if (manualCheckOutStatusID == 1 || manualCheckOutStatusID == 2){
                            cell.lblOutTitle.text = "Out"
    if let checkouttime = checkin.checkOutTime{
    var strchit = ""
    if let strchi = Utils.getDateBigFormatToDefaultFormat(date: checkouttime, format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strchit = strchi
                            }
        cell.lblOutTime.text = Utils.getDatestringWithGMT(gmtDateString: strchit, format: "hh:mm a  EEE,dd MMM yy")
    cell.lblOutTime.textColor = Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                        }
                            
                        }
                    }
*/
else{
  
     cell.stkOutTime.isHidden = true
    
}
}
}
            return cell
        }else{
        return UITableViewCell()
        }
    }
    
    
    
}
extension ActivitySubDetail:IDMPhotoBrowserDelegate{
    
}
