//
//  CustomerHistoryLeadCell.swift
//  SuperSales
//
//  Created by mac on 05/12/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class CustomerHistoryLeadCell: UITableViewCell {

    @IBOutlet weak var vwBackgroundBg: UIView!
    
    @IBOutlet weak var lblShortDate: UILabel!
    
    @IBOutlet weak var lblLeadID: UILabel!
    
    
    @IBOutlet weak var lblCreatedBy: UILabel!
    
    @IBOutlet weak var lblProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
