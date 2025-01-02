//
//  ProductCell.swift
//  SuperSales
//
//  Created by Apple on 06/07/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class ProductCellSwift: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    //lblSuggestedQty
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblProductName.text = ""
       
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
