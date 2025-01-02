//
//  ValidAttendanceCell.swift
//  SuperSales
//
//  Created by mac on 07/05/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

protocol ValidAttendancellDelegate {
    func requestDevliationClicked(cell:ValidAttendanceCell)
    func viewvalidationClicked(cell:ValidAttendanceCell)
    
}
class ValidAttendanceCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblUserFLetter: UILabel!
    
    @IBOutlet weak var lblTotalVisits: UILabel!
    
    @IBOutlet weak var lblTotalVisitValue: UILabel!
    
    @IBOutlet weak var lblValidVisitValue: UILabel!
    
    
    
    
    @IBOutlet weak var btnDeviation: UIButton!
    var validatedelegate:ValidAttendancellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDeviation.setbtnFor(title:"Request Deviation" , type:Constant.kPositive )
        lblUserFLetter.layer.cornerRadius = lblUserFLetter.frame.size.width/2
        lblUserFLetter.layoutIfNeeded()
        lblUserFLetter.layer.masksToBounds = true
        parentView.addBorders(edges: .all, color: UIColor.gray, cornerradius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: IBAction
    
    @IBAction func btnEyeClicked(_ sender: UIButton) {
        validatedelegate?.viewvalidationClicked(cell:self)
    }
    
    @IBAction func btnDeviationClicked(_ sender: UIButton) {
        validatedelegate?.requestDevliationClicked(cell: self)
    }
    
}
