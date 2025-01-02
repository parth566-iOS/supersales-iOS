//
//  CheckInDetailCell.swift
//  SuperSales
//
//  Created by Apple on 22/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class CheckInDetailCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet var lblINTitle: UILabel!
    
    @IBOutlet var lblInTime: UILabel!
    
    @IBOutlet weak var stkPlanTime: UIStackView!
    @IBOutlet weak var stkOutTime: UIStackView!
    @IBOutlet weak var stkInTime: UIStackView!
    @IBOutlet weak var lblCheckinTime: UILabel!
    
    @IBOutlet var lblOutTitle: UILabel!
    
    @IBOutlet var lblOutTime: UILabel!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
       
        self.lblCheckinTime.text = ""
        self.lblOutTime.text = ""
       
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
