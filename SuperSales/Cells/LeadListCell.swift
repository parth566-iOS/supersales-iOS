
//
//  LeadCell.swift
//  SuperSales
//
//  Created by Apple on 17/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class LeadListCell: UITableViewCell {
    @IBOutlet weak var stackViewAssignDetail: UIStackView!
    
    @IBOutlet weak var stackViewNextActionDetail: UIStackView!
    @IBOutlet weak var vwCustomer: UIView!
    
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet var lblLeadNo: UILabel!
    @IBOutlet weak var imgInteractionType: UIImageView!
    
    @IBOutlet weak var lblAssigneeName: UILabel!
    
    @IBOutlet weak var lblCheckinDetail: UILabel!
    
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblNextActionDetail: UILabel!
    @IBOutlet weak var lblVisitDate: UILabel!
    
    @IBOutlet weak var lblNextActionDt: UILabel!
    
    @IBOutlet weak var lblNextActionTm: UILabel!
    
    @IBOutlet var vwProductDetail: UIView!
    
    
    @IBOutlet var lbl3ProductBudget: UILabel!
    
    @IBOutlet var lbl2ProductQuantity: UILabel!
    
    @IBOutlet var lbl1ProductName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLeadData(lead:Lead){
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        //self.vwParent.addBorders(edges: [UIRectEdge.top,UIRectEdge.bottom,UIRectEdge.left,UIRectEdge.right], color: UIColor.clear, cornerradius: 5)
        
        print("Lead status = \(lead.leadStatusID)")
        self.vwParent.setShadow()
        
        var ndate = Date()
        var strNextActionTime = ""
        if (lead.leadStatusList.count > 0){
            if let latestleadStatus = lead.leadStatusList.firstObject as? LeadStatusList{
                strNextActionTime = latestleadStatus.nextActionTime
            }
        }else {
            if lead.nextActionTime != "" || lead.nextActionTime != nil {
                strNextActionTime = lead.nextActionTime
            }
        }
        if let ndt = Utils.getDateFromStringWithFormat(gmtDateString: strNextActionTime) as? Date{
            ndate = ndt
        }
        if(Date().compare(ndate) == .orderedAscending){
            vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue:0xF3F3F3)
        }else{
            vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue:0xC5E7D9)
        }
        vwProductDetail.backgroundColor = UIColor.clear
        
        print("lead type = \(lead.leadTypeID)")
        if(lead.leadTypeID == 1){
            self.vwCustomer.backgroundColor = Common().UIColorFromRGB(rgbValue:0xEF5350)//UIColor.red
        }else if(lead.leadTypeID == 2){
            self.vwCustomer.backgroundColor = Common().UIColorFromRGB(rgbValue:0xF9A825)//UIColor.yellow
        }else{
            self.vwCustomer.backgroundColor = Common().UIColorFromRGB(rgbValue:0x00BCD4)//UIColor.systemBlue
        }
        self.lblCheckinDetail.text = ""
        self.lblCustomerName.textColor = UIColor.white
        self.lblCustomerName.font = UIFont.boldSystemFont(ofSize: 18)
        if(Utils().getActiveSetting().customTagging == NSNumber.init(value: 3)){
            if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:lead.customerID)))){
                let style = NSMutableParagraphStyle()
                let attributeString = NSMutableAttributedString(string:lead.customerName ?? "")
                    //NSMutableAttributedString(string: NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""))
                style.alignment = .left
                attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, lead.customerName?.count ?? 0))
                
                /*      let styleright = NSMutableParagraphStyle()
                 let attributeStringLeadNumber = NSMutableAttributedString(string: String.init(format:"(# %d)",lead.seriesPostfix))
                 styleright.alignment = .right
                 attributeStringLeadNumber.addAttribute(NSAttributedString.Key.paragraphStyle, value: styleright, range: NSMakeRange(0, String.init(format:"#(%d)",lead.seriesPostfix).count))
                 attributeString.append(attributeStringLeadNumber)*/
                
                self.lblCustomerName.attributedText = attributeString
                self.lblLeadNo.textColor = UIColor.white
                self.lblLeadNo.font = UIFont.boldSystemFont(ofSize: 18)
                self.lblLeadNo.textAlignment = NSTextAlignment.right
                let style1 = NSMutableParagraphStyle()
                let attributeString1 = NSMutableAttributedString(string: String.init(format: "(# \(String(lead.seriesPostfix)))", []))
                style1.alignment = .right
                //attributeString1.addAttribute(NSAttributedString.Key.paragraphStyle, value: style1, range: NSMakeRange(0, NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: "").count))
                self.lblLeadNo.attributedText =  attributeString1
                //self.lblCustomerName.text = String.init(format:"%@ (# %d)",NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: "") ,lead.seriesPostfix)
            }else{
                // && lead.customerName.count == 0
                if(lead.customerID > 0 ){
                    let customername = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value:lead.customerID))
                    let style = NSMutableParagraphStyle()
                    let attributeString = NSMutableAttributedString(string: customername)
                    style.alignment = .left
                    
                    attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, customername.count))
                    
                    /*      let styleright = NSMutableParagraphStyle()
                     let attributeStringLeadNumber = NSMutableAttributedString(string: String.init(format:"(# %d)",lead.seriesPostfix))
                     styleright.alignment = .right
                     attributeStringLeadNumber.addAttribute(NSAttributedString.Key.paragraphStyle, value: styleright, range: NSMakeRange(0, String.init(format:"#(%d)",lead.seriesPostfix).count))
                     attributeString.append(attributeStringLeadNumber)*/
                    
                    self.lblCustomerName.attributedText = attributeString
                    self.lblLeadNo.textColor = UIColor.white
                    self.lblLeadNo.textAlignment = NSTextAlignment.right
                    let style1 = NSMutableParagraphStyle()
                    let attributeString1 = NSMutableAttributedString(string: String.init(format: "(# \(String(lead.seriesPostfix)))", []))
                    style1.alignment = .right
                    //attributeString1.addAttribute(NSAttributedString.Key.paragraphStyle, value: style1, range: NSMakeRange(0, NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: "").count))
                    self.lblLeadNo.attributedText =  attributeString1
                    
                    //self.lblCustomerName.text = String.init(format:"%@ (# %d)",customername,lead.seriesPostfix)
                }else{
                    if let  cname = lead.customerName{
                        self.lblCustomerName.text = String.init(format:"%@ (# \(String(lead.seriesPostfix)))",cname)
                    }else{
                        self.lblCustomerName.text = String.init(format:"%@ (# \(String(lead.seriesPostfix)))", "")
                    }
                }
            }
        }else{
            if(lead.customerID > 0 ){
                let customername = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value:lead.customerID))
                self.lblCustomerName.text = String.init(format:"%@",customername)
                self.lblLeadNo.textColor = UIColor.white
                self.lblLeadNo.textAlignment = NSTextAlignment.right
                self.lblLeadNo.text = String.init(format:"(# \(String(lead.seriesPostfix)))", [])
            }else{
                self.lblCustomerName.text = String.init(format:"%@",lead.customerName ?? "")
                self.lblLeadNo.textColor = UIColor.white
                self.lblLeadNo.textAlignment = NSTextAlignment.right
                self.lblLeadNo.text = String.init(format:"(# \(String(lead.seriesPostfix)))", [])
            }
        }
        let img = Utils.getImageFrom(interactionId:Int(lead.nextActionID))
        self.imgInteractionType.image = img
        if let strc = Utils.getDateBigFormatToDefaultFormat(date: lead.createdTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            if let strct = Utils.getDatestringWithGMT(gmtDateString: strc, format: "dd-MM-yyyy") as? String{
                self.lblAssigneeName.text = strct
            }
        }else{
            self.lblAssigneeName.text = ""
        }
        self.lblVisitDate.textColor = UIColor.red
      
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "yyyy/MM/dd hh:mm:ss"
        if let date = dateFormater.date(from: strNextActionTime){
            dateFormater.dateFormat = "dd-MM-yyyy"
            print(date)
            self.lblVisitDate.text = dateFormater.string(from: date)
        }else{
            dateFormater.dateFormat = "yyyy-MM-dd, HH:mm a"
            if let date1 = dateFormater.date(from: strNextActionTime){
                dateFormater.dateFormat = "dd-MM-yyyy"
                print(date1)
                self.lblVisitDate.text = dateFormater.string(from: date1)
            }else{
                dateFormater.dateFormat = "dd-MM-yyyy, hh:mm a"
                if let date1 = dateFormater.date(from: strNextActionTime){
                    dateFormater.dateFormat = "dd-MM-yyyy"
                    print(date1)
                    self.lblVisitDate.text = dateFormater.string(from: date1)
                }
                if(self.lblVisitDate.text?.count == 0){
                    dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    if let date = dateFormater.date(from: strNextActionTime){
                        dateFormater.dateFormat = "dd-MM-yyyy"
                        print(date)
                        self.lblVisitDate.text = dateFormater.string(from: date)
                    }
                }
            }
        }
        //  }
        self.lblCreatedBy.font = UIFont.boldSystemFont(ofSize: 16)
        //self.lblCreatedBy.text = "Products"
//        self.lblCreatedBy.isHidden = true
        self.lblCustomerName.font = UIFont.boldSystemFont(ofSize: 18)
        self.lblLeadNo.font = UIFont.boldSystemFont(ofSize: 18)
        let strProductDetail = NSMutableAttributedString.init(string:"",attributes:[:])
        self.lblNextActionDetail.isHidden = true
        var strProductName = NSMutableAttributedString()
        var strProductQuantity = NSMutableAttributedString()
        var strProductBudget = NSMutableAttributedString()
        
        if(lead.productList.count > 0){
            for p in 0...lead.productList.count{
                if(p == 0){
                    strProductQuantity = NSMutableAttributedString.init(string: "Qty \n \n", attributes: [NSAttributedString.Key.foregroundColor:Utils.hexStringToUIColor(hex: "#43369A"),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    strProductName = NSMutableAttributedString.init(string: "Product \n \n", attributes: [NSAttributedString.Key.foregroundColor:Utils.hexStringToUIColor(hex:"#43369A"),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    strProductBudget = NSMutableAttributedString.init(string: "Budget \n \n", attributes: [NSAttributedString.Key.foregroundColor:Utils.hexStringToUIColor(hex:"#43369A"),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                    
                    
                }else{
                    if let product = lead.productList[p-1] as? ProductsList{
                        let proname =  product.productName ?? ""
                        let subcatname = product.subCategoryName ?? ""
                        let catname = product.categoryName ?? ""
                        if(proname.count > 0){
                            strProductName.append(NSAttributedString.init(string: String.init(format:"\(proname) \n"), attributes: nil))
                        }else if(subcatname.count > 0){
                            strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname) \n"), attributes: nil))
                        }else{
                            strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(catname) \n"), attributes: nil))
                        }
                        if let prodQuantity = product.quantity as? Int64 {
                            let quantivalue = NSAttributedString.init(string: String.init(format:"%d \n",prodQuantity) , attributes: [:])
                            lbl2ProductQuantity.attributedText = quantivalue
                            strProductQuantity.append(quantivalue)
                        }
                        /*
                         if  let price = product.budget{
                         cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", String(describing:price))
                         }else{
                         cell.lbl3.text = String.init(format:"%@ %@",self.activeuser?.company?.currCode ?? "$", "0")
                         }
                         */
                        if let probudget = product.budget as? NSDecimalNumber{
                            let budgetvalue = NSAttributedString.init(string: String.init(format:"%.1f \n",probudget.floatValue) , attributes: [:])
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
            self.lbl1ProductName.text = ""
            self.lbl2ProductQuantity.text = ""
            self.lbl3ProductBudget.text = ""
        }
        self.lbl1ProductName.textAlignment = .left
        self.lbl3ProductBudget.textAlignment = .right
        self.lbl2ProductQuantity.textAlignment = .left
        self.lblNextActionDetail.setMultilineLabel(lbl: self.lblNextActionDetail)
        //self.lblNextActionDetail.attributedText = strProductDetail
        self.contentView.layoutIfNeeded()
    }
    //self.lblNextActionDetail.setMultilineLabel(lbl:self.lblNextActionDetail)
}


