//
//  ShelfSpaceCell.swift
//  SuperSales
//
//  Created by Apple on 26/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class ShelfSpaceCell: UITableViewCell {

    @IBOutlet weak var heightForViewImageLbl: NSLayoutConstraint!
    @IBOutlet weak var lblViewImage: UILabel!
    @IBOutlet weak var lblGivenBreadth: UILabel!
    @IBOutlet weak var lblGivenWidth: UILabel!
    @IBOutlet weak var lblTotalWidth: UILabel!
    @IBOutlet weak var lblTotalBreadth: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
//        self.lblViewImage.text = ""
        self.lblGivenBreadth.text = ""
        self.lblGivenWidth.text = ""
        self.lblTotalWidth.text = ""
        self.lblTotalBreadth.text = ""
        self.lblPosition.text = ""
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
