//
//  NameDisplay.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class NameDisplay: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var vwParent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.lblProductName.text = "Checkin"
      
        //self.imgContact.backgroundColor = UIColor.red
        // Clear all content based views and their actions here
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
