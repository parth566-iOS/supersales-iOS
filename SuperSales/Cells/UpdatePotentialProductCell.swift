//
//  UpdatePotentialProductCell.swift
//  SuperSales
//
//  Created by mac on 28/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
protocol UpdatePotentialProductDelegate {
    func prodeleteClicked(cell:UpdatePotentialProductCell)
    func btnHotClicked(cell:UpdatePotentialProductCell)
    func btnWarmClicked(cell:UpdatePotentialProductCell)
    func btnColdClicked(cell:UpdatePotentialProductCell)
    func btnPitchedClicked(cell:UpdatePotentialProductCell)
}
class UpdatePotentialProductCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnPitched: UIButton!
    
    @IBOutlet weak var btnHot: UIButton!
    
    @IBOutlet weak var btnWarm: UIButton!
    
    @IBOutlet weak var btnCold: UIButton!
    
    var potproductDelegate:UpdatePotentialProductDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnPitchedClicked(_ sender: UIButton) {
        sender.isSelected !=  sender.isSelected
        potproductDelegate?.btnPitchedClicked(cell: self)
    }
    
    @IBAction func btnHotClicked(_ sender: UIButton) {
        sender.isSelected !=  sender.isSelected
        potproductDelegate?.btnHotClicked(cell: self)
    }
    
    @IBAction func btnWarmClicked(_ sender: UIButton) {
        sender.isSelected !=  sender.isSelected
        potproductDelegate?.btnWarmClicked(cell: self)
    }
    @IBAction func btnColdClicked(_ sender: UIButton) {
        sender.isSelected !=  sender.isSelected
        potproductDelegate?.btnColdClicked(cell: self)
    }
    
    @IBAction func btnDeleteProductClicked(_ sender: UIButton) {
        sender.isSelected !=  sender.isSelected
        potproductDelegate?.prodeleteClicked(cell: self)
    }
}
