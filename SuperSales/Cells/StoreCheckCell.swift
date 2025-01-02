//
//  StoreCheckCell.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
protocol  StoreCheckCellDelegate{
//    func checkAvailability(cell:StoreCompActivityCell)
    func addPictureClicked(cell:StoreCheckCell)
    func addJustificationClicked(cell:StoreCheckCell)
    func addConditionClicked(cell:StoreCheckCell)
}
class StoreCheckCell: UITableViewCell {

    @IBOutlet weak var lblTargetQuantityValue: UILabel!
    
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var lblActivityName: UILabel!
//    @IBOutlet weak var tfCondtiton: UITextField!
//    @IBOutlet weak var tfJustification: UITextField!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var lblTargetQuantity: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var btnJustification: UIButton!
    @IBOutlet weak var btnCondition: UIButton!
    
  //  @IBOutlet weak var stkDescription: UIStackView!
    @IBOutlet weak var btnAddImage: UIButton!
    
    @IBOutlet weak var stkCondition: UIStackView!
    @IBOutlet weak var stkJustification: UIStackView!
    
    
    var storecheckdelegate:StoreCheckCellDelegate?
    typealias CompletionBlock = (StoreCheckCell) -> Void
    var block:CompletionBlock!
    
//    override func prepareForReuse() {
//
//        super.prepareForReuse()
//        self.tfQuantity.text = ""
//        self.lblTargetQuantity.text = ""
//        self.lblActivityName.text = ""
//        self.lblTargetQuantityValue.text = ""
//
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        tfQuantity.setCommonFeature()
      
//        self.lblTargetQuantityValue.textColor = UIColor.black
//        self.lblDescriptionTitle.textColor = UIColor.black
//        self.lblDescriptionTitle.text = "Description"
//        self.lblTargetQuantityValue.text = "1000"
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        CustomeTextfield.setBottomBorder(tf: self.tfQuantity)
      //  tvDescription.setBottomBorder(tv:tvDescription)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setactivitydata(storeCheckbrandactivity:StoreCheckBrandActivity,completionblock:@escaping CompletionBlock){
        block = completionblock
        self.tvDescription.setFlexibleHeight()
//        self.btnCondition.setrightImage()
//        self.btnJustification.setrightImage()
     
        if(storeCheckbrandactivity.targetQuantity?.intValue ?? 0 > 0){
            self.lblTargetQuantity.text =  String.init(format:"%@",storeCheckbrandactivity.targetQuantity as! CVarArg)
        }else{
            self.lblTargetQuantity.text =  ""
        }
        self.tfQuantity.delegate = self
        self.tvDescription.delegate = self
        self.btnCondition.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.btnJustification.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.lblActivityName.text = storeCheckbrandactivity.storeActivityName
        self.lblActivityName.textColor = UIColor.systemBlue
      
        if(storeCheckbrandactivity.activityImage?.count == 0){
        self.btnAddImage.setTitle("Add Picture", for: .normal)
        }else{
            self.btnAddImage.setTitle("View Picture", for: .normal)
        }
        self.btnCondition.layoutIfNeeded()
        self.btnJustification.layoutIfNeeded()
        self.btnAddImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.btnJustification.setTitle(storeCheckbrandactivity.justificationName, for: .normal)
        self.btnCondition.setTitle(storeCheckbrandactivity.storeConditionName, for: .normal)
        self.btnJustification.contentHorizontalAlignment = .left
        self.btnCondition.contentHorizontalAlignment = .left
        
        //cell.btnAddImage.setTitle("View Image", for: .normal)
    
        self.btnAddImage.addTarget(self, action: #selector(activityImageClicked), for: .touchUpInside)
    }

    @objc func activityImageClicked(sender:UIButton){
       // self.storecheckdelegate?.addPictureClicked(cell: self)
    }
    
    
    @IBAction func btnJustificationClicked(_ sender: UIButton) {
        self.storecheckdelegate?.addJustificationClicked(cell: self)
    }
    
    @IBAction func btnCondititonClicked(_ sender: UIButton) {
    self.storecheckdelegate?.addConditionClicked(cell: self)
    }
    
    @IBAction func btnAddImageClicked(_ sender: UIButton) {
        self.storecheckdelegate?.addPictureClicked(cell: self)
    }
}
extension StoreCheckCell:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.block(self)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(textField == tfQuantity){
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
        return true
    }
}
extension StoreCheckCell:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvDescription.setFlexibleHeight()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.block(self)
        
    }
}
