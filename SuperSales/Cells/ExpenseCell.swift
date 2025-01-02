//
//  ExpenseCell.swift
//  SuperSales
//
//  Created by Apple on 07/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var lblExpenseFrom: UILabel!
    @IBOutlet weak var vwExpenseFrom: UIView!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var btnWithdraw: UIButton!
    
    @IBOutlet weak var btnReject: UIButton!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.lblExpenseFrom.text = ""
        self.lblAmount.text = ""
        self.lblTo.text = ""
        self.lblFrom.text = ""
    
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
