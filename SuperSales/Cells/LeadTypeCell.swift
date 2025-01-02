//
//  LeadTypeCell.swift
//  SuperSales
//
//  Created by Apple on 25/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

class LeadTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLeadType: UILabel!
    @IBOutlet var imgLeadType: UIImageView!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.titleLeadType.text = ""
       
    }
    
}
