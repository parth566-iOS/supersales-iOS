//
//  ManagerCell.swift
//  SuperSales
//
//  Created by Apple on 10/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

class ManagerCell: UITableViewCell {

    
    @IBOutlet var imgManager: UIImageView!
    
    @IBOutlet var lblManagerName: UILabel!
    
    @IBOutlet var lblManagerPosition: UILabel!
    
    
    @IBOutlet var lblManagerContactNo: UILabel!
    
    
    @IBOutlet var lblLink: UILabel!
    
    @IBOutlet var lblManagerEmail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgManager.backgroundColor = UIColor.white
        imgManager.cornerRadius = Double(imgManager.frame.width/2)
//        imgManager.layer.borderColor = UIColor.white.cgColor
//        imgManager.layer.borderWidth = 2.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
