
//
//  LeadReportCell.swift
//  SuperSales
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class LeadReportCell: UITableViewCell {
    
    @IBOutlet var vwParent: UIView!
    
    @IBOutlet var imgLeft: UIImageView!
    
    @IBOutlet var lblLeadTitle: UILabel!
    
    @IBOutlet var imgRight: UIImageView!
    
    @IBOutlet var lblContact: UILabel!
    
    @IBOutlet weak var vwContact: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var vwDescription: UIView!
    
    @IBOutlet weak var stkCustomerDetail: UIStackView!
    @IBOutlet var lblNextAction: UILabel!
    
    @IBOutlet var imgNextAction: UIImageView!
    @IBOutlet weak var vwNextAction: UIView!
    
    @IBOutlet var lblReason: UILabel!
    
    @IBOutlet weak var vwReason: UIView!
    @IBOutlet var vwProduct: UIView!
    
    @IBOutlet var lbl1ProductName: UILabel!
    
    @IBOutlet var lbl2ProductQuantity: UILabel!
    
    
    @IBOutlet var lbl3ProductBudget: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        vwParent.layer.borderColor = UIColor().colorFromHexCode(rgbValue: (0xEEEEEE)).cgColor
        vwParent.setShadow()
        vwParent.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xF5F5F5)
        // UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
        vwProduct.backgroundColor = UIColor.clear
        //UIColor.gray.cgColor
        //vwParent.layer.cornerRadius =  10
        
        vwParent.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setReportLeadAssign(leadstatus:Lead,assign:Bool)->(){
        self.lblLeadTitle.text = leadstatus.customerName
        self.lblLeadTitle.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
        self.lblLeadTitle.text?.append(String.init(format:"(#\(leadstatus.seriesPostfix))"))
        if(leadstatus.contactID > 0){
            let strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:leadstatus.contactID)) as? Contact{
                strContact.append(NSAttributedString.init(string: String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")"), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
                self.lblContact.attributedText = strContact
            }else{
                let strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
                strContact.append(NSAttributedString.init(string: NSLocalizedString("no_contact", comment: ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
                self.lblContact.attributedText = strContact
            }
        }else{
            let strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            strContact.append(NSAttributedString.init(string: NSLocalizedString("no_contact", comment: ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            self.lblContact.attributedText = strContact
        }
        self.imgRight.isHidden = true
        
        let imgNextActionID = Utils.getImageFrom(interactionId: Int(leadstatus.nextActionID))
        imgNextAction.image = imgNextActionID
        imgLeft.image = imgNextActionID
        
        let strnextaction = NSMutableAttributedString.init(string: "NextAction:", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        strnextaction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: leadstatus.nextActionTime, format: "dd-MM-yyyy hh:mm a"), attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize:15)] ))
        lblNextAction.attributedText =  strnextaction
        let lstatus = leadstatus.leadStatusList.firstObject as? LeadStatusList
        self.lblReason.text  = Outcomes.getOutcomeFromID(leadSourceID: NSNumber.init(value: lstatus?.outcomeID ?? 0))
        //   self.lblReason.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
        // self.vwProduct.isHidden = true
        vwNextAction.backgroundColor = UIColor.white
        if(assign){
            stkCustomerDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xBEEAFD)
            vwReason.isHidden = true
        }else{
            stkCustomerDetail.backgroundColor = UIColor.clear
            vwReason.isHidden = false
        }
        var strProductName = NSMutableAttributedString()
        var strProductQuantity = NSMutableAttributedString()
        var strProductBudget = NSMutableAttributedString()
        if(leadstatus.productList.count > 0){
            for p in 0...leadstatus.productList.count{
                if(p == 0){
                    strProductQuantity = NSMutableAttributedString.init(string: "  Qty \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    strProductName = NSMutableAttributedString.init(string: "  Product \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    strProductBudget = NSMutableAttributedString.init(string: "  Budget \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    
                    
                }else{
                    if let product = lstatus?.productList[p-1] as? ProductsList{
                        //if let product = p  as? ProductsList {
                        if let productname = product.productName as? String{
                            let productName = NSAttributedString.init(string:String.init(format:"\(productname) \n"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                            strProductName.append(productName)
                        }
                        
                        //    strProductDetail.append(productName)
                        if let prodQuantity = product.quantity as? Int64 {
                            let quantivalue = NSAttributedString.init(string: String.init(format:"%d \n",prodQuantity) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                            lbl2ProductQuantity.attributedText = quantivalue
                            strProductQuantity.append(quantivalue)
                        }
                        if let probudget = product.budget as? NSDecimalNumber{
                            let budgetvalue = NSAttributedString.init(string: String.init(format:"%.1f \n",probudget.floatValue) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                            //strProductDetail.append(budgetvalue)
                            lbl3ProductBudget.attributedText = budgetvalue
                            strProductBudget.append(budgetvalue)
                        }
                    }else{
                        print("product not get")
                    }
                    self.lbl1ProductName.setMultilineLabel(lbl: self.lbl1ProductName)
                    self.lbl2ProductQuantity.setMultilineLabel(lbl: self.lbl2ProductQuantity)
                    self.lbl3ProductBudget.setMultilineLabel(lbl: self.lbl3ProductBudget)
                    
                }
                
                self.lbl1ProductName.attributedText = strProductName
                self.lbl2ProductQuantity.attributedText = strProductQuantity
                self.lbl3ProductBudget.attributedText = strProductBudget
                
            }
            self.vwProduct.isHidden = false
        }else{
            self.vwProduct.isHidden = true
        }
        
        if(lstatus?.remarks.count ?? 0 > 0){
            if let reportremark =  leadstatus.remarks as? String{
                print("description = \(reportremark) ")
                
                lblDescription.text = String.init(format:"Remarks: \(reportremark)")
                lblDescription.setMultilineLabel(lbl: lblDescription)
            }
            vwDescription.isHidden =  false
        }else{
            vwDescription.isHidden = false
        }
        vwReason.isHidden = true
        self.vwDescription.isHidden = true
    }
    func setReportLeadStatus(obj:LeadStatusList,assign:Bool)->(){
        self.imgRight.isHidden = true
        
        let imgNextActionID = Utils.getImageFrom(interactionId: Int(obj.nextActionID))
        imgNextAction.image = imgNextActionID
        imgLeft.image = imgNextActionID
        
        let strnextaction = NSMutableAttributedString.init(string: "NextAction:", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        strnextaction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: obj.nextActionTime, format: "dd-MM-yyyy hh:mm a"), attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize:15)] ))
        lblNextAction.attributedText =  strnextaction
        //  let lstatus = obj.leadStatusList.firstObject as? LeadStatusList
        self.lblReason.text  = Outcomes.getOutcomeFromID(leadSourceID: NSNumber.init(value: obj.outcomeID ?? 0))
        //   self.lblReason.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
        // self.vwProduct.isHidden = true
        vwNextAction.backgroundColor = UIColor.white
        if(assign){
            stkCustomerDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xBEEAFD)
            vwReason.isHidden = true
        }else{
            stkCustomerDetail.backgroundColor = UIColor.clear
            vwReason.isHidden = false
        }
        var strProductName = NSMutableAttributedString()
        var strProductQuantity = NSMutableAttributedString()
        var strProductBudget = NSMutableAttributedString()
        if(obj.productList.count > 0){
            for p in 0...obj.productList.count{
                if(p == 0){
                    strProductQuantity = NSMutableAttributedString.init(string: "  Qty \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    strProductName = NSMutableAttributedString.init(string: "  Product \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    strProductBudget = NSMutableAttributedString.init(string: "  Budget \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    
                    
                }else{
                    if let product = obj.productList[p-1] as? ProductsList{
                        //if let product = p  as? ProductsList {
                        if let productname = product.productName as? String{
                            let productName = NSAttributedString.init(string:String.init(format:"\(productname) \n"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                            strProductName.append(productName)
                        }
                        
                        //    strProductDetail.append(productName)
                        if let prodQuantity = product.quantity as? Int64 {
                            let quantivalue = NSAttributedString.init(string: String.init(format:"%d \n",prodQuantity) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                            lbl2ProductQuantity.attributedText = quantivalue
                            strProductQuantity.append(quantivalue)
                        }
                        if let probudget = product.budget as? NSDecimalNumber{
                            let budgetvalue = NSAttributedString.init(string: String.init(format:"%.1f \n",probudget.floatValue) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                            //strProductDetail.append(budgetvalue)
                            lbl3ProductBudget.attributedText = budgetvalue
                            strProductBudget.append(budgetvalue)
                        }
                    }else{
                        print("product not get")
                    }
                    self.lbl1ProductName.setMultilineLabel(lbl: self.lbl1ProductName)
                    self.lbl2ProductQuantity.setMultilineLabel(lbl: self.lbl2ProductQuantity)
                    self.lbl3ProductBudget.setMultilineLabel(lbl: self.lbl3ProductBudget)
                    
                }
                
                self.lbl1ProductName.attributedText = strProductName
                self.lbl2ProductQuantity.attributedText = strProductQuantity
                self.lbl3ProductBudget.attributedText = strProductBudget
                
            }
            self.vwProduct.isHidden = false
        }else{
            self.vwProduct.isHidden = true
        }
        
        if(obj.remarks.count ?? 0 > 0){
            if let reportremark =  obj.remarks as? String{
                print("description = \(reportremark) ")
                
                lblDescription.text = String.init(format:"Remarks: \(reportremark)")
                lblDescription.setMultilineLabel(lbl: lblDescription)
            }
            vwDescription.isHidden =  false
        }else{
            vwDescription.isHidden = true
        }
    }
    
    func setReportLeadCreated(obj:Lead)->(){
        
        //       self.stkCustomerDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
        //        self.lblLeadTitle.backgroundColor =  UIColor.lightText
        self.lblLeadTitle.text = obj.customerName
        self.imgRight.isHidden = true
        self.imgLeft.isHidden = true
        self.lblLeadTitle.text?.append(String.init(format:"(#\(obj.seriesPostfix))"))
        if(obj.contactID > 0){
            let strContact = NSMutableAttributedString.init(string: "Contact: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:obj.contactID)) as? Contact{
                strContact.append(NSAttributedString.init(string: String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")"), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
                self.lblContact.attributedText = strContact
            }else{
                let strContact = NSMutableAttributedString.init(string: "Contact: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
                strContact.append(NSAttributedString.init(string: NSLocalizedString("no_contact", comment: ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
                self.lblContact.attributedText = strContact
            }
        }else{
            let strContact = NSMutableAttributedString.init(string: "Contact: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            strContact.append(NSAttributedString.init(string: NSLocalizedString("no_contact", comment: ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            self.lblContact.attributedText = strContact
        }
        let imgNextActionID = Utils.getImageFrom(interactionId: Int(obj.nextActionID))
        imgNextAction.image = UIImage.init(named: "icon_call_black")//imgNextActionID
        let strnextaction = NSMutableAttributedString.init(string: "NextAction: ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)])
        strnextaction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: obj.nextActionTime, format: "dd-MM-yyyy hh:mm a"), attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize:13)]))
        lblNextAction.attributedText =  strnextaction
        
        
        self.vwReason.isHidden = true
        var strProductName = NSMutableAttributedString()
        var strProductQuantity = NSMutableAttributedString()
        var strProductBudget = NSMutableAttributedString()
        
        if(obj.productList.count > 0){
            for p in 0...obj.productList.count{
                if(p == 0){
                    strProductQuantity = NSMutableAttributedString.init(string: "  Qty \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appthemebluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                    strProductName = NSMutableAttributedString.init(string: "  Product \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appthemebluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                    strProductBudget = NSMutableAttributedString.init(string: "  Budget \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appthemebluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                    
                    
                }else{
                    if let product = obj.productList[p-1] as? ProductsList{
                        //if let product = p  as? ProductsList {
                        if let productname = product.productName as? String{
                            let productName = NSAttributedString.init(string:String.init(format:"\(productname) \n"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                            strProductName.append(productName)
                        }
                        print(product.quantity)
                        //    strProductDetail.append(productName)
                        if let prodQuantity = product.quantity as? Int64 {
                            let quantivalue = NSAttributedString.init(string: String.init(format:"%d \n",prodQuantity) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                            lbl2ProductQuantity.attributedText = quantivalue
                            strProductQuantity.append(quantivalue)
                        }
                        
                        if let probudget = product.budget as? NSDecimalNumber{
                            let budgetvalue = NSAttributedString.init(string: String.init(format:"%.1f \n",probudget.floatValue) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                            //strProductDetail.append(budgetvalue)
                            lbl3ProductBudget.attributedText = budgetvalue
                            strProductBudget.append(budgetvalue)
                        }
                    }else{
                        print("product not get")
                    }
                    self.lbl1ProductName.setMultilineLabel(lbl: self.lbl1ProductName)
                    self.lbl2ProductQuantity.setMultilineLabel(lbl: self.lbl2ProductQuantity)
                    self.lbl3ProductBudget.setMultilineLabel(lbl: self.lbl3ProductBudget)
                    
                }
                self.lbl1ProductName.attributedText = strProductName
                self.lbl2ProductQuantity.attributedText = strProductQuantity
                self.lbl3ProductBudget.attributedText = strProductBudget
                
            }
        }else{
            self.vwProduct.isHidden = true
        }
    }
}
