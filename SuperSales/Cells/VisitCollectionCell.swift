//
//  VisitCollectionCell.swift
//  SuperSales
//
//  Created by Apple on 16/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class VisitCollectionCell: UITableViewCell {
    @IBOutlet weak var vwTitleInfo: UIView!
     @IBOutlet weak var stackTitleInfo: UIStackView!
    
    @IBOutlet weak var vwParentView: UIView!
    @IBOutlet weak var vwIndication: UIView!
    @IBOutlet weak var imgExpantion: UIImageView!
    @IBOutlet weak var lblIndicator: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var isexpand:Bool! = false
    
    @IBOutlet var vwBalance: UIView!
    
    @IBOutlet var vwCollectionPaymentmode: UIView!
    
    @IBOutlet var vwRefferance: UIView!
    @IBOutlet var vwCollection: UIView!
    @IBOutlet var lblCollectedValue: UILabel!
    
    @IBOutlet var lblBalanceValue: UILabel!
    
    
    @IBOutlet var lblCollectionPaymentmode: UILabel!
    
    
    @IBOutlet var lblRefferanceValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.lblIndicator.layer.cornerRadius = self.lblIndicator.frame.size.width/2
        self.lblIndicator.layer.masksToBounds = true
    }

    func setCollectionData(obj:SalesPlanModel, expaned:IndexPath ,currentindexpath:IndexPath){
       self.lblIndicator.text = "O"
       
        self.imgExpantion.image = UIImage.init(named: "icon_right_green")
        self.vwIndication.backgroundColor = UIColor.CollectionIndicaationcolor
        self.lblCompanyName.text = obj.checkInCustomerName
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: obj.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    strnt = strn
                }
                
            self.lblTime.text = (obj.nextActionTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
        self.lblTime.text = "10:00 AM"
              //  self.lblContactPersonName.text = visit.contactMobileNo
                
        //        if(visit.contactName?.count == 0 && visit.contactID  > 0){
        //        let contact =  Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value:visit.contactID) ).first
        //        self.lblContactPersonName.text = String.init(format: "%@ %@", (contact?.firstName ?? "") ,(contact?.lastName ?? ""))
        //            self.lblContactPersonName.text = contact?.mobile
        //        }else{
        //        self.lblContactPersonName.text = ""//(visit.contactName?.count == 0) ? "No Contact" : visit.contactName
        //        }
        if let collectvalue = obj.collectionValue{
        self.lblCollectedValue.text = String.init(format:"\(collectvalue)")
        }else{
            self.lblCollectedValue.text = ""
        }
        if let balancevalue = obj.balanceValue {
        self.lblBalanceValue.text = String.init(format:"\(balancevalue)")
        }else{
            self.lblBalanceValue.text = ""
        }
        
        if let refferancevalue = obj.referenceNo{
            if(refferancevalue.count > 0){
            self.vwRefferance.isHidden = false
            }else{
                self.vwRefferance.isHidden = true
            }
        self.lblRefferanceValue.text = String.init(format:"\(refferancevalue)")
        }else{
        self.lblRefferanceValue.text = ""
            self.vwParentView.isHidden = true
        }
    
        if let collectionPaymentmode = obj.modeOfPayment{
    self.lblCollectionPaymentmode.text = String.init(format:"\(Utils.getCollectinPaymentMode()[collectionPaymentmode.intValue - 1])")
        }else{
          self.lblCollectionPaymentmode.text = ""
        }
        
       
                       
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
