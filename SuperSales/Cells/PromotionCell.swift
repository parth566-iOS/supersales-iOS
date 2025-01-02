//
//  PromotionCell.swift
//  SuperSales
//
//  Created by Apple on 10/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class PromotionCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblPromoTitle: UILabel!
    
    @IBOutlet weak var lblPromoType: UILabel!
    
    @IBOutlet weak var lblStatusPromotion: UILabel!
    
    @IBOutlet weak var heightlblStatusConstant: NSLayoutConstraint!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblPromoTitle.text = ""
        self.lblPromoType.text = ""
        self.lblStatusPromotion.text = ""
       
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        // Initialization code
        lblPromoType.numberOfLines = 0
        lblPromoType.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblPromoType.preferredMaxLayoutWidth = lblPromoType.frame.size.width
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
