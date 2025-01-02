//
//  LeadHistoryProductCell.swift
//  SuperSales
//
//  Created by Apple on 22/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class LeadHistoryProductCell: UITableViewCell {

    
    @IBOutlet weak var lblProductNameValue: UILabel!
    
    
    @IBOutlet weak var lblProductQuantityValue: UILabel!
    
    
    @IBOutlet weak var lblProductBudgetvale: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
