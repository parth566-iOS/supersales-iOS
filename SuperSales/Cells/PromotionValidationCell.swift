//
//  PromotionValidationCell.swift
//  SuperSales
//
//  Created by Apple on 14/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class PromotionValidationCell: UITableViewCell {

    @IBOutlet weak var lblStartFrom: UILabel!
    
    @IBOutlet weak var lblUpTo: UILabel!
    
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var viewStartFrom: UIView!
    
    @IBOutlet weak var viewFrom: UIView!
    
    @IBOutlet weak var viewUpto: UIView!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblStartFrom.text = ""
        self.lblUpTo.text = ""
        self.lblFrom.text = ""
       
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblFrom.numberOfLines = 0
        self.lblFrom.lineBreakMode = .byWordWrapping
        self.lblFrom.preferredMaxLayoutWidth = self.lblFrom.frame.size.width
        
        self.lblStartFrom.numberOfLines = 0
        self.lblStartFrom.lineBreakMode = .byWordWrapping
        self.lblStartFrom.preferredMaxLayoutWidth = self.lblStartFrom.frame.size.width
        
        self.lblUpTo.numberOfLines = 0
        self.lblUpTo.lineBreakMode = .byWordWrapping
        self.lblUpTo.preferredMaxLayoutWidth = self.lblUpTo.frame.size.width
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
