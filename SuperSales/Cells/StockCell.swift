//
//  StockCell.swift
//  SuperSales
//
//  Created by Apple on 24/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblProductTitle: UILabel!
    
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblProductQuantity: UILabel!
    
    @IBOutlet weak var lblUpdatedBy: UILabel!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblDate.text = ""
        self.lblProductTitle.text = ""
        self.lblUpdatedBy.text = ""
        self.lblProductName.text = ""
        self.lblProductQuantity.text = ""
        
       
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
