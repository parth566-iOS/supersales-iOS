//
//  promotionLineDetail.swift
//  ACFloatingTextfield-Objc
//
//  Created by Apple on 14/06/19.
//

import UIKit

class PromotionLineDetail: UITableViewCell {

    @IBOutlet weak var lblPromotionDetail: UILabel!
    
   // @IBOutlet weak var lblProductDetail: UILabel!
    @IBOutlet weak var viewBgForPromotionDetail: UIView!
    
   // @IBOutlet weak var constraintHeightForPoduct: NSLayoutConstraint!
    
    @IBOutlet weak var btnEye: UIButton!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblPromotionDetail.text = ""
    
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
