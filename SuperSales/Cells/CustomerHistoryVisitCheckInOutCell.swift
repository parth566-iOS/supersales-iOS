//
//  CustomerHistoryVisitCheckInOutCell.swift
//  SuperSales
//
//  Created by mac on 05/12/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class CustomerHistoryVisitCheckInOutCell: UITableViewCell {
    
    @IBOutlet weak var vwCheckinOutBg: UIView!
    @IBOutlet weak var lblCheckInOutDate: UILabel!
    @IBOutlet weak var lblCheckInOutByNm: UILabel!
    @IBOutlet weak var lblCheckInOutTime: UILabel!
  
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        self.lblCheckInOutDate.text = ""
        self.lblCheckInOutByNm.text = ""
        self.lblCheckInOutTime.text = ""
       
        
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
