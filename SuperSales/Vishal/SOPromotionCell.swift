//
//  SOPromotionCell.swift
//  SuperSales
//
//  Created by ebsadmin on 22/08/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class SOPromotionCell: UITableViewCell {
    @IBOutlet weak var btnSelectedPromo: UIButton!
    @IBOutlet weak var lblPromoTitle: UILabel!
    @IBOutlet weak var lblPromoBalBudget: UILabel!
    @IBOutlet weak var lblPromoDedBudget: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
