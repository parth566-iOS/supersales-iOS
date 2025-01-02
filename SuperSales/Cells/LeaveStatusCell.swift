//
//  LeaveStatusCell.swift
//  SuperSales
//
//  Created by mac on 01/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
protocol LeaveStatusDelegate {
    func withdrawClicked(cell:LeaveStatusCell)
    func approvebtnClicked(cell:LeaveStatusCell)
    func rejectClicked(cell:LeaveStatusCell)
    
}
class LeaveStatusCell: UITableViewCell {

    var delegate:LeaveStatusDelegate?
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var lblAppliedDate: UILabel!
    
    
    @IBOutlet weak var lblLeaveType: UILabel!
    
    @IBOutlet weak var stkBtnAction: UIStackView!
    
    @IBOutlet weak var btnWithDraw: UIButton!
    
    @IBOutlet weak var vwAccept: UIView!
    
    @IBOutlet weak var vwReject: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: IBAction
    
    @IBAction func btnWithDrawClicked(_ sender: UIButton) {
        delegate?.withdrawClicked(cell: self)
    }
    
    @IBAction func btnApproveClicked(_ sender: UIButton) {
        delegate?.approvebtnClicked(cell: self)
    }
    
    @IBAction func btnRejectClicked(_ sender: UIButton) {
        delegate?.rejectClicked(cell: self)
    }
}
