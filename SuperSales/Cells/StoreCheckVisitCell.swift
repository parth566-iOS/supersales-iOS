//
//  StoreCheckVisitCell.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
protocol  StoreCheckVisitCellDelegate{
//    func checkAvailability(cell:StoreCompActivityCell)
    func addPictureClicked(cell:StoreCheckVisitCell)
  
}
class StoreCheckVisitCell: UITableViewCell {
    typealias block = (StoreCheckVisitCell) -> Void
    @IBOutlet weak var lblActivityName: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblJustification: UILabel!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var stkDescription: UIStackView!
    @IBOutlet weak var btnAddImage: UIButton!
    var storeblock:block!
    var storecheckvisitdelegate:StoreCheckVisitCellDelegate?
    
    @IBOutlet weak var stkCondition: UIStackView!
    
    @IBOutlet weak var stkJustification: UIStackView!
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.tfQuantity.text = ""
        self.lblCondition.text = ""
        self.lblActivityName.text = ""
        self.lblJustification.text = ""
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.selectionStyle =  UITableViewCell.SelectionStyle.none
        CustomeTextfield.setBottomBorder(tf: self.tfQuantity)
        tfQuantity.setCommonFeature()
        
      //  tvDescription.setBottomBorder(tv:tvDescription)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setactivitydata(brandactivity:StoreCheckVisitBrandActivity){
          // self.lblActivityName.text = storeCheckbrandactivity.storeActivityName

        
           //cell.btnAddImage.setTitle("View Image", for: .normal)
                 
     //      self.btnAddImage.addTarget(self, action: #selector(activityImageClicked), for: .touchUpInside)
        if(brandactivity.branddescription?.count ?? 0 > 0){
        self.tvDescription.text = brandactivity.branddescription
        self.tvDescription.setFlexibleHeight()
        }else{
            self.stkDescription.isHidden = true
        }
        self.btnAddImage.setTitle("View Picture", for: .normal)
        if(brandactivity.activityImage?.count ?? 0 > 0 ){
            self.btnAddImage.isHidden = false
        }else{
            self.btnAddImage.isHidden = true
        }
        self.lblActivityName.text = brandactivity.activityName
        self.lblCondition.text = brandactivity.conditionName
        self.lblJustification.text = brandactivity.justificationName
      
        self.tfQuantity.text = String.init(format:"%@", brandactivity.targetQuantity ?? 00.00)
//        self.btnAddImage.addTarget(self, action: #selector(activityImageClicked), for: .touchUpInside)
       }

//       @objc func activityImageClicked(sender:UIButton){
//        self.storecheckdelegate?.addPictureClicked(cell: self)
//       }
    
    
    @IBAction func btnAddImageClicked(_ sender: UIButton) {
        self.storecheckvisitdelegate?.addPictureClicked(cell: self)
    }
    
}
