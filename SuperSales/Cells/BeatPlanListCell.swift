//
//  BeatPlanListCell.swift
//  SuperSales
//
//  Created by Apple on 03/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class BeatPlanListCell: UITableViewCell {

    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var lblBeatID: UILabel!
    
    @IBOutlet weak var lblVisitStatus: UILabel!
    
    @IBOutlet weak var lblVisitDate: UILabel!
    
    @IBOutlet weak var imgStatusIndicator: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = UITableViewCell.SelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
