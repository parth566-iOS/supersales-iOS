//
//  ProductMultiLineCell.swift
//  SuperSales
//
//  Created by ebsadmin on 18/12/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class ProductMultiLineCell: UITableViewCell {
    @IBOutlet weak var lblProductNm: UILabel!
    @IBOutlet weak var lblOnHand: UILabel!
    @IBOutlet weak var lblAvl: UILabel!
    @IBOutlet weak var lblSuggestedQty: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
