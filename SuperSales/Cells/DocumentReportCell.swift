//
//  DocumentReportCell.swift
//  SuperSales
//
//  Created by mac on 02/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

class DocumentReportCell: UITableViewCell {

    @IBOutlet weak var lblDocumentName: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
