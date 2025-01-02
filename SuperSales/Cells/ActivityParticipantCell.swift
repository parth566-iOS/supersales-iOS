//
//  ActivityParticipantCell.swift
//  
//
//  Created by mac on 16/06/22.
//

import UIKit
protocol ActivityParticipantCelldelegate {
    func btndeleteparticipantclicked(cell:ActivityParticipantCell)
}
class ActivityParticipantCell: UITableViewCell {

    @IBOutlet weak var lblCustomername: UILabel!
    @IBOutlet weak var lblCustomerContact: UILabel!
    var celldelegate:ActivityParticipantCelldelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        self.celldelegate?.btndeleteparticipantclicked(cell:self)
    }
}
