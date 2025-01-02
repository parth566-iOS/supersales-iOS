//
//  CountershareSubcatCell.swift
//  SuperSales
//
//  Created by Apple on 11/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

protocol CountershareSubcatCellDelegate: AnyObject  {
    func switchClicked(sender:UIButton,cell:CountershareSubcatCell)
}

class CountershareSubcatCell: UITableViewCell {
    typealias CompletionBlock = (CountershareSubcatCell) -> Void
    weak var delegate: CountershareSubcatCellDelegate?
    var block:CompletionBlock!
//        //3. assign this action to close button
//        @IBAction func btnCloseTapped(sender: AnyObject) {
//            //4. call delegate method
//            //check delegate is not nil with `?`
//            delegate?.switchClicked(sender:UIButton,cell:CountershareSubcatCell)
//        }
   // var block:compler
    @IBOutlet var bgView: UIView!
    //@IBOutlet var lblCatName: UILabel!
    @IBOutlet var lblSubCatName: UILabel!
    @IBOutlet var btnSwitch: UIButton!
    
    @IBOutlet weak var txtQty: UITextField!
    
   // @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet var btnSubCatDisplay: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblSubCatName.textColor = UIColor().colorFromHexCode(rgbValue:(0x444444))

      //  self.txtQty.delegate = self
//        if let comp = self.completionBlock{
//            (completionBlock ?? {(CountershareSubcatCell())})(self)
//
//        }
        // Initialization code
    }
    func cellCompeletion(dic:[String:Any],completionblock:@escaping CompletionBlock){
        self.txtQty.delegate = self
        block = completionblock
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnSwitchClicked(_ sender: UIButton) {
        
        self.delegate?.switchClicked(sender: sender, cell: self)
    }
}
extension CountershareSubcatCell:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == self.txtQty){
            
        }
        block(self)
//        if CompletionBlock.self != nil{
//            (block ?? )(self)
//        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if(textField == txtPhilipsSalesValue || textField == txtCompetitorShare || textField ==  txtLightSalesValue || textField == txtCompetitorShare){
//               let maxLength = 20
//               let currentString: NSString = textField.text! as NSString
//               let newString: NSString =
//                   currentString.replacingCharacters(in: range, with: string) as NSString
//               return newString.length <= maxLength
//               }
//
      if let text = textField.text,
                  let textRange = Range(range, in: text) {
                  let updatedText = text.replacingCharacters(in: textRange,
                                                              with: string)
        if(textField == self.txtQty){
        if(updatedText.count < 13){
            
        }else{
            return false
            }
        }
        }
        return true
    }
}
