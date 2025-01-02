//
//  ProductCell.swift
//  SuperSales
//
//  Created by Apple on 01/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
protocol ProductCellDelegate{
    func deleteProduct(cell: ProductCell)
}
class ProductCell: UITableViewCell {
    
    var deleteAction: ((Any) -> Void)?
    var teridelegate:AddTerritoryDelegate?
    var leadDelegate:LeadAddProductDelegate?
    var updateleadStatusDelegate:UpdateLeadSatusDelegate?
    @IBOutlet weak var lblProductName: UILabel!
    var delegate: ProductCellDelegate?
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var tfQty: UITextField!
    
    @IBOutlet weak var stkQuantity: UIStackView!
    @IBOutlet weak var tfBudget: UITextField!
    var selectedPro:SelectedProduct!
    var selectededitproduct:ProductsList!
    var addStockDelegate: AddStockDelegate!
    @IBOutlet weak var stkBudget: UIStackView!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        self.tfQty.text = ""
        tfBudget.setCommonFeature()
        tfQty.setCommonFeature()
       
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
//        CustomeTextfield.setBottomBorder(tf: self.tfQty)
//        CustomeTextfield.setBottomBorder(tf: self.tfBudget)
        self.tfQty.setCommonFeature()
        self.tfBudget.setCommonFeature()
        
        self.tfQty.delegate = self
        self.tfQty.keyboardType = UIKeyboardType.numberPad
        self.tfBudget.keyboardType = UIKeyboardType.numberPad
        self.tfBudget.delegate = self
//        self.tfBudget.setBottomBorder(tf: tfBudget, color: UIColor.black)
//        self.tfQty.setBottomBorder(tf: tfQty, color: UIColor.black)
        self.tfBudget.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfQty.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProductInfo(pro:SelectedProduct,record:Int)->(){
        let  strProductName = NSMutableAttributedString.init(string: "",attributes: [:])
        let proname =  pro.productName ?? ""
        let subcatname = pro.subCategoryName ?? ""
        let catname = pro.categoryName ?? ""
        if(proname.count > 0){
            strProductName.append(NSAttributedString.init(string: String.init(format:"\(proname) \n"), attributes: nil))
        }else if(subcatname.count > 0){
            strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname) \n"), attributes: nil))
        }else{
            strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(catname) \n"), attributes: nil))
        }
       
        self.lblProductName.attributedText = strProductName
       
        self.tfBudget.tag = record
        self.tfQty.tag = record
       // self.lblProductName.text = pro.productName
        self.tfQty.text = String.init(format:"%@",pro.quantity ?? 0)
        selectedPro = pro
    }
    
    func setProductInfoEdit(pro:ProductsList,record:Int)->(){
        let  strProductName = NSMutableAttributedString.init(string: "",attributes: [:])
        let proname =  pro.productName ?? ""
        let subcatname = pro.subCategoryName ?? ""
        let catname = pro.categoryName ?? ""
        if(proname.count > 0){
            strProductName.append(NSAttributedString.init(string: String.init(format:"\(proname) \n"), attributes: nil))
        }else if(subcatname.count > 0){
            strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname) \n"), attributes: nil))
        }else{
            strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(catname) \n"), attributes: nil))
        }
       
        self.lblProductName.attributedText = strProductName
        self.tfBudget.tag = record
        self.tfQty.tag = record
       // self.lblProductName.text = pro.productName
        self.tfQty.text = String.init(format:"%@",pro.quantity ?? 0)
        selectededitproduct = pro
    }
    
    @IBAction func btnDeletePro(_ sender: Any) {
        delegate?.deleteProduct(cell: self)
    }

}
extension ProductCell:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(textField == tfQty){
        let maxLength = 5
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }else if(textField == tfBudget){
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
         }else{
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfQty){
//            let intquantity = Int(textField.text ?? "0")
//            selectedPro.quantity = NSNumber.init(value: intquantity ?? 0)
            selectedPro.quantity = textField.text
        }else if(textField == tfBudget){
            selectedPro.budget = textField.text 
//            let intbudget = Int(textField.text ?? "0")
//            selectedPro.budget = NSNumber.init(value: intbudget ?? 0)
        }
        teridelegate?.updateProductInfo(product: selectedPro, Record: textField.tag)
        addStockDelegate?.updateProductInfo(product: selectedPro, Record: textField.tag)
        leadDelegate?.updateProductInfo(product: selectedPro, Record: textField.tag)
        
        updateleadStatusDelegate?.updateProductInfo(product: selectedPro, Record: textField.tag)
        
    }
}
