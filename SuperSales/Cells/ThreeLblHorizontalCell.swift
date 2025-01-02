
//
//  ThreeLblHorizontalCell.swift
//  SuperSales
//
//  Created by Apple on 02/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class ThreeLblHorizontalCell: UITableViewCell {

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
   
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lbl1.text = ""
        self.lbl2.text = ""
        self.lbl3.text = ""
       
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle =  UITableViewCell.SelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDashboardVisitData(report:VisitDashboardReport,indexpath:IndexPath){
        self.lbl1.text = report.UserName
        self.lbl1.font = UIFont.boldSystemFont(ofSize: 16)
      // self.lbl3.isHidden  = true
        self.lbl2.font = UIFont.systemFont(ofSize: 13)
        self.lbl3.font = UIFont.systemFont(ofSize: 12)
        if let  planned = report.PlannedVisit as? NSInteger{
        self.lbl2.text = String.init(format: "\(planned) planned", [])
        }else{
             self.lbl2.text = ""
        }
        if let donevisit = report.MissedVisit as? NSInteger{
            self.lbl3.text = String.init(format:"\(donevisit) m",[])
            if let updatedvisit = report.UpdatedVisit as? NSInteger{
                self.lbl3.text?.append(String.init(format:"\(updatedvisit) u",[]))
            }
            if let donevisit = report.ActualVisit as? NSInteger{
                self.lbl3.text?.append(String.init(format:"\(donevisit) d",[]))
            }
        }else{
             self.lbl3.text = ""
        }
        if(report.ColorCode == NSInteger.init(CGFloat(1))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x35DF8F)
        }else if(report.ColorCode == NSInteger.init(CGFloat(2))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x45A0CD)
        }else{
            lbl1.textColor = UIColor.gray//Common().UIColorFromRGB(rgbValue:0x000000)
        }
    }
    
    func setDashboardLeadData(leadReport:LeadDashboardReport,indexpath:IndexPath){
      
        self.lbl1.font = UIFont.boldSystemFont(ofSize: 16)
        self.lbl2.font = UIFont.systemFont(ofSize: 13)
        self.lbl3.font = UIFont.systemFont(ofSize: 12)
      //  self.lbl3.isHidden  = true
        self.lbl3.isHidden = false
        if let  planned = leadReport.AssignedLead as? NSInteger{
        self.lbl2.text = String.init(format: "\(planned) lead", [])
        }else{
             self.lbl2.text = ""
        }
        if let assigned = leadReport.AssignedLead as? NSInteger{
            self.lbl3.text = String.init(format:"as \(assigned)")
            if let generated = leadReport.GeneratedLead as? NSInteger{
                self.lbl3.text?.append(" ad \(generated)")
                if let updated = leadReport.UpdatedLead as? NSInteger{
                    self.lbl3.text?.append("up \(updated  )")
                }
            }
        }
       // self.lbl3.text = String.init(format:"as \(leadReport.AssignedLead) ad\(leadReport.GeneratedLead) u\(leadReport.UpdatedLead)",[])
               if(leadReport.ColorCode == NSInteger.init(CGFloat(1))){
                   lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x35DF8F)
               }else if(leadReport.ColorCode == NSInteger.init(CGFloat(2))){
                   lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x45A0CD)
               }else{
                   lbl1.textColor =  UIColor.gray//Common().UIColorFromRGB(rgbValue:0x000000)
               }
    }
    
    func setDashboardOrderData(orderReport:OrderDashboardReport,indexpath:IndexPath){
          self.lbl2.isHidden = false
        self.lbl3.isHidden = false
        self.lbl1.font = UIFont.boldSystemFont(ofSize: 16)
        self.lbl2.font = UIFont.systemFont(ofSize: 13)
        self.lbl3.font = UIFont.systemFont(ofSize: 13)
        if let  planned = orderReport.GeneratedSalesOrder as? NSInteger{
       self.lbl3.text   = String.init(format: "\(planned) Orders", [])
        }else{
          self.lbl3.text  = ""
        }
        if let  amount = orderReport.TotalAmount as? Double{
           //  var rupeeSymbol = india.NumberFormat.CurrencySymbol
            self.lbl2.text =  String.init(format:"\("₹") \(amount)",[])
       //  self.lbl2.text   = String.init(format: "\(Utils().getActiveAccount()?.company?.currCode ?? "$") \(amount)", [])
        }else{
             self.lbl2.text   = ""
        }
       if(orderReport.ColorCode == NSInteger.init(CGFloat(1))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x35DF8F)
        }else if(orderReport.ColorCode == NSInteger.init(CGFloat(2))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x45A0CD)
        }else{
            lbl1.textColor =  UIColor.gray//Common().UIColorFromRGB(rgbValue:0x000000)
        }
        
        self.lbl2.textColor =  UIColor.gray
      self.lbl3.textColor =  UIColor.gray
    }

}
