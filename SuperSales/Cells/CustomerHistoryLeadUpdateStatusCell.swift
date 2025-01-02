//
//  CustomerHistoryLeadUpdateStatusCell.swift
//  SuperSales
//
//  Created by mac on 05/12/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class CustomerHistoryLeadUpdateStatusCell: UITableViewCell {

    @IBOutlet weak var vwBackgroundBg: UIView!
    
    @IBOutlet weak var lblShortDate: UILabel!
    
    @IBOutlet weak var lblCreatedName: UILabel!
    
    @IBOutlet weak var lblOutcome: UILabel!
    
    @IBOutlet weak var lblConclusion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
