//
//  StoreCompActivityCell.swift
//  SuperSales
//
//  Created by Apple on 10/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

protocol  StoreCompActivityCellDelegate{
    func checkAvailability(cell:StoreCompActivityCell)
    func addPictureClicked(cell:StoreCompActivityCell)
    func addJustificationClicked(cell:StoreCompActivityCell)
}
class StoreCompActivityCell: UITableViewCell {

    @IBOutlet weak var lblCompetitionName: UILabel!
    
    
    @IBOutlet weak var lblTargetQty: UILabel!
    @IBOutlet weak var lblJustification: UILabel!
    @IBOutlet weak var lblActivityTitle: UILabel!
    @IBOutlet weak var lbActivityName: UILabel!
    
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var stkQuantity: UIStackView!
    
    @IBOutlet weak var tfQuantity: UITextField!
    
    @IBOutlet weak var stkJustification: UIStackView!
    
    @IBOutlet weak var lblDescription: UILabel!
    
   // @IBOutlet weak var tfJustification: UITextField!
    
    @IBOutlet weak var btnJustifiction: UIButton!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    
    @IBOutlet weak var stkbtn: UIStackView!
    @IBOutlet weak var btnAddPicture: UIButton!
    var compdelegate:StoreCompActivityCellDelegate?
    typealias CompletionBlock = (StoreCompActivityCell) -> Void
    var block:CompletionBlock!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle =  UITableViewCell.SelectionStyle.none
        tfQuantity.setCommonFeature()
        
        self.tfQuantity.delegate = self
        self.tvDescription.delegate = self
        CustomeTextfield.setBottomBorder(tf: self.tfQuantity)
        self.lblCompetitionName.textColor = UIColor.Appthemecolor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setexistCompetitionData(competetiondata:StoreCheckVisitCompetitionActivity,indxpath:IndexPath){
        
        self.lblCompetitionName.text = competetiondata.competitionName
        if(competetiondata.competitiondescription?.count ?? 0 > 0){
                   self.tvDescription.text =  competetiondata.competitiondescription
                   self.tvDescription.setFlexibleHeight()
               }
               else{
                   self.tvDescription.isHidden = true
               }
         self.lbActivityName.text = competetiondata.activityName
        self.btnJustifiction.contentHorizontalAlignment = .left
        if(competetiondata.justificationName?.count ?? 0 > 0){
       // self.tfJustification.text = competetiondata.justificationName
            self.btnJustifiction.setTitleColor(UIColor.black, for: .normal)
            self.btnJustifiction.setTitle(competetiondata.justificationName, for: .normal)
            self.btnJustifiction.setTitle(competetiondata.justificationName, for: .selected)
           
        }else{
            self.stkJustification.isHidden = true
            //self.stkQuantity.isHidden = true
        }
        //self.tfJustification.isUserInteractionEnabled = false
            
        self.btnJustifiction.isUserInteractionEnabled = false
        self.tfQuantity.isUserInteractionEnabled = false
        self.lbActivityName.textColor = UIColor.black
        self.tvDescription.text = competetiondata.competitiondescription
        if(competetiondata.competitiondescription?.count ?? 0 > 0){
            self.lblDescription.isHidden = false
            self.tvDescription.isHidden = false
        }else{
            self.lblDescription.isHidden = true
            self.tvDescription.isHidden = true
        }
        if(competetiondata.activityImage?.count ?? 0 > 0){
            self.btnAddPicture.isHidden = false
            
        }else{
            self.btnAddPicture.isHidden = true
        }
        self.btnAddPicture.setTitle("View Picture", for: .normal)
        self.btnAddPicture.setTitleColor(UIColor.Appskybluecolor, for: .normal)
        
        self.tfQuantity.text = String.init(format:"%.2f",competetiondata.targetQuantity?.floatValue ?? 0.00)
    }
    
    func setcompetitiondata(objStoreCompetition:StoreCompetition,indexpath:IndexPath,completionblock:@escaping CompletionBlock){
        self.tfQuantity.keyboardType = .numberPad
        block = completionblock
//        self.lblCompetitionName.text = objStoreCompetition.storeCompetition
        self.lblCompetitionName.font = UIFont.boldSystemFont(ofSize: 18)
//        self.btnJustifiction.setrightImage()
        if(objStoreCompetition.aryAssignedActivities?.count ?? 0 > 0){
                    let activity = objStoreCompetition.aryAssignedActivities?[indexpath.row]
                    self.tvDescription.isUserInteractionEnabled = true
                    self.lblActivityTitle.isHidden = true
                    self.btnJustifiction.tag = indexpath.row
                    self.btnAddPicture.tag = indexpath.row
                    self.btnJustifiction.setTitleColor(UIColor.black, for: .normal)
                    self.lbActivityName.text = activity?.storeActivityName
                    self.tvDescription.text = activity?.activitydescription
                    if(activity?.checkAvailability == true){
                            self.stkbtn.isHidden = false
                        if(activity?.isYES == NSNumber.init(value:1)){
                                self.btnYes.isSelected = true
                                self.btnNo.isSelected = false
                                self.stkJustification.isHidden = false
                                
                            }else{
                                self.btnYes.isSelected = false
                                self.btnNo.isSelected = true
                                self.stkJustification.isHidden = true
                            }
                    }else{
                            self.stkbtn.isHidden = true
                        self.stkJustification.isHidden = true
                        }
           
            self.tvDescription.setFlexibleHeight()
//                        if(activity?.inputQuantity == true){
//                            self.stkQuantity.isHidden = false
//                        }else{
//                            self.stkQuantity.isHidden = true
//                        }
            if let qua = activity?.inputQuantity{
            if(qua){
                self.stkQuantity.isHidden = false
                self.tfQuantity.text = String.init(format:"%@" ,activity?.quantity as! CVarArg)
            }else{
                self.stkQuantity.isHidden = true
                self.tfQuantity.text = ""
            }
           }else{
            self.stkQuantity.isHidden = true
            self.tfQuantity.text = ""
           }
            
            
            if  (activity?.activityImage?.count ?? 0 > 0){
                   self.btnAddPicture.setTitle("View Pictue", for: .normal)
            }else{
                self.btnAddPicture.setTitle("Add Pictue", for: .normal)
            }
           
          
            self.tfQuantity.text = String.init(format:"%@", activity?.quantity ?? "");
                        //cell.targetQty.delegate = self;
         //   self.tfJustification.text = activity?.justificationName
            self.btnJustifiction.setTitle(activity?.justificationName, for: .normal)
            self.btnJustifiction.contentHorizontalAlignment = .left
      
        
        }
        
        
    }
    

    

   
    @IBAction func checkAvailability(_ sender: UIButton) {
        self.btnYes.isSelected = false
        self.btnNo.isSelected  = false
        sender.isSelected = true
        self.compdelegate?.checkAvailability(cell: self)
        
    }
    
    @IBAction func btnAdPictureClicked(_ sender: UIButton) {
        self.compdelegate?.addPictureClicked(cell: self)
    }
    @IBAction func btnJustificationClicked(_ sender: UIButton) {
        self.compdelegate?.addJustificationClicked(cell: self)
    }
}
extension StoreCompActivityCell:UITextFieldDelegate{
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
extension StoreCompActivityCell:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        self.block(self)
        
    }
}
