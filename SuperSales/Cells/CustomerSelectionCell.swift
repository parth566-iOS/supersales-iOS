//
//  CustomerSelectionCell.swift
//  SuperSales
//
//  Created by Apple on 19/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class CustomerSelectionCell: UITableViewCell {

    @IBOutlet var vwBackground: UIView!
    @IBOutlet weak var vwMultipleSelection: UIView!
    
    @IBOutlet var vwProduct: UIView!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var vwCustomerName: UIView!
    @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var vwContactNo: UIView!
    
    @IBOutlet weak var btnCustomerSelection: UIButton!
    
    @IBOutlet weak var btnMandatorySwitch: UIButton!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
       
        self.lblContactNo.text = ""
        self.lblCustomerName.text = ""
       
    }
    
    
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
