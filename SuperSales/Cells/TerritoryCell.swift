//
//  TerritoryCell.swift
//  SuperSales
//
//  Created by Apple on 26/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class TerritoryCell: UITableViewCell {

    @IBOutlet weak var btnTerritory: UIButton!
    
    @IBOutlet weak var btnSelectTerratory: UIButton!
    @IBOutlet weak var lblSelectedTerratory: UILabel!
    
    @IBOutlet weak var btnSelectBeat: UIButton!
    
    @IBOutlet weak var heightForViewSelectTerritory: NSLayoutConstraint!
    @IBOutlet weak var viewSelectTerritory: UIView!
    // @IBOutlet weak var lblSelectedTerritory: UIButton!
    @IBOutlet weak var lblselectedBeatID: UILabel!
    @IBOutlet weak var lblBeatPlanDetail: UILabel!
    
    @IBOutlet weak var heightForTitleTerritory: NSLayoutConstraint!
    @IBOutlet weak var viewTitleSelectTerritory: UIView!//CustomView!
    
    @IBOutlet weak var heightForViewBeatPlanDetail: NSLayoutConstraint!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblSelectedTerratory.text = ""
        self.lblBeatPlanDetail.text = ""
        self.lblselectedBeatID.text = ""
       
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
