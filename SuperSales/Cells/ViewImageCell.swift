//
//  ViewImageCell.swift
//  SuperSales
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class ViewImageCell: UICollectionViewCell {
     @IBOutlet weak var imgVisit: UIImageView!
    
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
       
        self.imgVisit.image = UIImage()
        
       
    }
}
