//
//  FourLblVertical.swift
//  SuperSales
//
//  Created by Apple on 04/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class FourLblVerticalCell: UITableViewCell {

    @IBOutlet weak var lblCustomerName: UILabel!
     @IBOutlet weak var lblCustomerContactNo: UILabel!
    
    @IBOutlet weak var lblCustomerAddress: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var vwParent: UIView!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblCustomerName.text = ""
        self.lblCustomerContactNo.text = ""
        self.lblCustomerAddress.text = ""
        self.lblTime.text = ""
       
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
