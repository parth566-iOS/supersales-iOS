//
//  LeadInteractionCell.swift
//  SuperSales
//
//  Created by Apple on 18/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class LeadInteractionCell: UITableViewCell {

    @IBOutlet weak var imgInteraction: UIImageView!
    @IBOutlet var imgNextActionIcon: UIImageView!
    
    @IBOutlet weak var lblInteractionDate: UILabel!
   
    @IBOutlet weak var lblStatusFrom: UILabel!
    @IBOutlet weak var lblContactDetail: UILabel!
    
    @IBOutlet weak var lblNExtActionTimeDetail: UILabel!
    @IBOutlet weak var lblOutComeValue: UILabel!
    
    
    @IBOutlet weak var lblCustomerOrientationValue: UILabel!
    
    @IBOutlet weak var lblNextActionDateValue: UILabel!
    
    @IBOutlet weak var lblRemarkValue: UILabel!
    
    @IBOutlet weak var lblRemarkTitle: UILabel!
    
    
    @IBOutlet weak var btnvwPic1: UIButton!
    
    @IBOutlet weak var btnvwPic2: UIButton!
    
    @IBOutlet weak var btnvwPic3: UIButton!
    
    @IBOutlet weak var btnvwPic4: UIButton!
    
    @IBOutlet weak var btnvwPic5: UIButton!
    
    @IBOutlet weak var btnLeadAttachmentLink: UIButton!
    
    @IBOutlet weak var lblStagesUpdate: UILabel!
    @IBOutlet weak var lblProductUpdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblContactDetail.setMultilineLabel(lbl: self.lblContactDetail)
       btnvwPic1.setAttributedTitle(NSAttributedString.init(string: "View Picture 1", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        btnvwPic2.setAttributedTitle(NSAttributedString.init(string: "View Picture 2", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        btnvwPic3.setAttributedTitle(NSAttributedString.init(string: "View Picture 3", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        btnvwPic4.setAttributedTitle(NSAttributedString.init(string: "View Picture 4", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        btnvwPic5.setAttributedTitle(NSAttributedString.init(string: "View Picture 5", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
}
extension LeadInteractionCell:IDMPhotoBrowserDelegate{
    
}
