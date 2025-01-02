//
//  SalesReportCell.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class SalesReportCell: UITableViewCell {

    @IBOutlet var lblTitleType: UILabel!
    
    @IBOutlet var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblMinute: UILabel!
    @IBOutlet var vwTitle: UIView!
    
    @IBOutlet var vwConclusion: UIView!
    
    @IBOutlet var vwSpeedDistance: UIView!
    @IBOutlet var vwCheckinout: UIView!
    @IBOutlet var vwSubTile: UIView!
    @IBOutlet var lblConclusion: UILabel!
    
    @IBOutlet var lblDistitle: UILabel!
    
    @IBOutlet var lblDisValue: UILabel!
    
    @IBOutlet var lblInTitle: UILabel!
    
    @IBOutlet var lblInValue: UILabel!
    
    
    @IBOutlet var lblOutTilte: UILabel!
    
    
    @IBOutlet var lblOutValue: UILabel!
    
    @IBOutlet var lblSpeedTitle: UILabel!
    
    
    @IBOutlet var lblSpeedValue: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lblMinute.text = ""
      
        //self.imgContact.backgroundColor = UIColor.red
        // Clear all content based views and their actions here
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        vwParent.layer.borderColor = UIColor().colorFromHexCode(rgbValue: (0xEEEEEE)).cgColor
//        vwParent.setShadow()
        self.contentView.layer.borderColor = UIColor().colorFromHexCode(rgbValue: (0xEEEEEE)).cgColor
        self.contentView.setShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
