//
//  CustomerVisitHistoryCell.swift
//  SuperSales
//
//  Created by mac on 05/12/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class CustomerVisitHistoryCell: UITableViewCell {

    @IBOutlet weak var vwParent: UIView!
    
    @IBOutlet weak var lblOutcome: UILabel!
    @IBOutlet weak var lblConclusion: UILabel!
    
    @IBOutlet weak var lblShortDate: UILabel!
    @IBOutlet weak var lblCreatedName: UILabel!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
       
        self.lblOutcome.text = ""
        self.lblConclusion.text = ""
        self.lblShortDate.text = ""
        self.lblCreatedName.text = ""
       
        
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
