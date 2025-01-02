//
//  KYCCell.swift
//  SuperSales
//
//  Created by mac on 13/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SDWebImage

protocol KYCCellDelegate {
    func textfieldKYCTYPEEditing(textfield:UITextField)
    func textfieldKYCNumberEditDone(textfield:UITextField)
    func imgkycClicked(img:UIImageView)
    
}
class KYCCell: UITableViewCell {

    var kycdelegate:KYCCellDelegate?
    
    @IBOutlet weak var lblKYCTitle: UILabel!
    
    @IBOutlet weak var tfKYCType: UITextField!
    
    @IBOutlet weak var imgKYC: UIImageView!
    
    @IBOutlet weak var tfKYCNumber: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tfKYCType.setrightImage(img: UIImage.init(named:"icon_down_arrow_gray")!)
        self.tfKYCNumber.setBottomBorder(tf: self.tfKYCNumber, color: UIColor.black)
     //   let tfKYCType = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        tfKYCType.backgroundColor = .white
        tfKYCType.attributedPlaceholder = NSAttributedString(
            string: "Select KYC Type",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
  //      self.tfKYCType.placeholder.
 //       self.tfKYCType.setBottomBorder(tf: self.tfKYCType, color: UIColor.black)
//        CustomeTextfield.setBottomBorder(tf:  self.tfKYCType)
//        CustomeTextfield.setBottomBorder(tf:  self.tfKYCNumber)
        let   tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
           tap.numberOfTapsRequired = 1
           tap.numberOfTouchesRequired = 1
           tap.cancelsTouchesInView = false
           tap.delegate = self
          imgKYC.isUserInteractionEnabled = true
          imgKYC.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setKYCData(indexpath:IndexPath,dic:[String:Any]){
        imgKYC.tag = indexpath.row
        lblKYCTitle.text = String.init(format: "KYC \(indexpath.row +  1)")
        tfKYCType.delegate = self
        tfKYCNumber.delegate = self
        tfKYCType.tag = indexpath.row
        tfKYCNumber.tag = indexpath.row
        var kycnumber = ""
        var kycType = ""
        var kyc1number = ""
        var kyc1Type = ""
        var kyc2number = ""
        var kyc2Type = ""
        if(dic.keys.count > 0){
       
        if(indexpath.row == 0){
             kycnumber = ""
            kycType = ""
            if let kycnum = dic["KycNumber"] as? String{
            kycnumber =  kycnum
            }
            if let kyctype = dic["KycType"] as? String{
            kycType = kyctype
            }
            tfKYCNumber.text = kycnumber
            tfKYCType.text = kycType
            if let kycurl = dic["KycUrl"] as? String{
            imgKYC.sd_setImage(with:  URL.init(string: (kycurl.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
           
                if(err == nil){
                    self.imgKYC.image = img
                    AddCustomer.custKYCImg = img
                }else{
                    print("get some error \(err?.localizedDescription)")
                }
            }
            }
        }else if(indexpath.row == 1){
            
            if let kycnum = dic["Kyc1Number"] as? String{
                kyc1number =  kycnum
            }
            if let kyctype = dic["Kyc1Type"] as? String{
            kyc1Type = kyctype
            }
            tfKYCNumber.text = kyc1number
            tfKYCType.text = kyc1Type
            if let kycurl = dic["Kyc1Url"] as? String{
            imgKYC.sd_setImage(with:  URL.init(string: (kycurl.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
           
                if(err == nil){
                    self.imgKYC.image = img
                    AddCustomer.custKYCImg1 = img

                }else{
                  
                }
            }
            }
        }else{
           
            if let kycnum = dic["Kyc2Number"] as? String{
            kyc2number =  kycnum
            }
            if let kyctype = dic["Kyc2Type"] as? String{
            kyc2Type = kyctype
            }
            tfKYCNumber.text = kyc2number
            tfKYCType.text = kyc2Type
            if let kycurl = dic["Kyc2Url"] as? String{
            imgKYC.sd_setImage(with:  URL.init(string: (kycurl.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
           
                if(err == nil){
                    self.imgKYC.image = img
                    AddCustomer.custKYCImg2 = img
                }else{
                  
                }
            }
            }
        }
            print(indexpath.row)
            print(tfKYCType.text ?? "" )
            print(tfKYCNumber.text ?? "")
        }
       
        
     //   imgKYC.
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        self.kycdelegate?.imgkycClicked(img: self.imgKYC)
      
    }
    

}
extension KYCCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfKYCType){
           
            self.kycdelegate?.textfieldKYCTYPEEditing(textfield: textField)
            return false
        }else{
        return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == tfKYCNumber){
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfKYCNumber){
            self.kycdelegate?.textfieldKYCNumberEditDone(textfield: textField)
            tfKYCNumber.resignFirstResponder()
        }
    }
}
