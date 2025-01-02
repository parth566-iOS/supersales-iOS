//
//  BeatPlanAssignCell.swift
//  SuperSales
//
//  Created by Apple on 03/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class BeatPlanAssignCell: UITableViewCell {

    @IBOutlet weak var btnDate: UIButton!
    
    @IBOutlet weak var lblTerritoryTitle: UILabel!
    
    
   // @IBOutlet weak var tfTerritory: UITextField!
    
    @IBOutlet weak var lblBeatplanTitle: UILabel!
    
   // @IBOutlet weak var tfSelectedBeat: UITextField!
    
    @IBOutlet weak var btnSelectTerritory: UIButton!
    
    @IBOutlet weak var btnSelectBeat: UIButton!
    
    @IBOutlet weak var btnBeatplanDetail: UIButton!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
//        self.lblTerritoryTitle.text = ""
//        self.lblBeatplanTitle.text = ""
       
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.btnDate.setrightImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
