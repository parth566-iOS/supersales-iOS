//
//  CustomerVendorCell.swift
//  SuperSales
//
//  Created by Apple on 24/09/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class CustomerVendorCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblCustName: UILabel!
    
    @IBOutlet var lblContactNo: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var vwlblName: UIView!
    
    @IBOutlet var vwCustName: UIView!
    
    @IBOutlet var vwEmail: UIView!
    @IBOutlet var vwContactNo: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
