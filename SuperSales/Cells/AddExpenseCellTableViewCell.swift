//
//  ExpenseCellTableViewCell.swift
//  SuperSales
//
//  Created by Apple on 13/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
protocol AddExpenseCellDelegate {
    func updateExpenseApprovedAmountValue(expenseCell:AddExpenseCellTableViewCell)
    func updateExpenseRequestedAmountValue(expenseCell:AddExpenseCellTableViewCell)
    func updateExpenseValue(expenseCell:AddExpenseCellTableViewCell)
    func deleteExpenseValue(expenseCell:AddExpenseCellTableViewCell)
    func addAttachmentInExpense(expenseCell:AddExpenseCellTableViewCell)
    func clearAttachmentInExpense(expenseCell:AddExpenseCellTableViewCell)
    func deleteAttachmentInExpense(expenseCell:AddExpenseCellTableViewCell)
}
class AddExpenseCellTableViewCell: UITableViewCell {
   
    @IBOutlet weak var tfExpenseType: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var vwExpense: UIView!
    @IBOutlet weak var tfBillNumber: UITextField!
    
    @IBOutlet weak var tfBillDate: UITextField!
  
    @IBOutlet weak var tfRemark: UITextField!
    
    @IBOutlet weak var tfRequestedAmount: UITextField!
    
    @IBOutlet weak var tfAmmountApproved: UITextField!
    
    @IBOutlet weak var stkClearAttachment: UIStackView!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnClearAttachment: UIButton!
    
    @IBOutlet weak var btnDeleteAttachment: UIButton!
    var arrOfExpense:[String]! = [String]()
    var arrOfselectedExpense:[String]!  = [String]()
    var popup:CustomerSelection?
    var expensedelegate:AddExpenseCellDelegate?
    var dateFormatter:DateFormatter = DateFormatter.init()
    var billdatepicker:UIDatePicker! = UIDatePicker()
    var billDate:Date!
   
    override func prepareForReuse() {
        
        super.prepareForReuse()
       
        self.tfExpenseType.text = ""
        self.tfBillNumber.text = ""
        self.tfRemark.text = ""
        self.tfRequestedAmount.text = ""
       
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwExpense.setShadow()
        self.tfExpenseType.backgroundColor = UIColor.AppthemeAqvacolor
        self.tfRequestedAmount.delegate = self
        self.tfAmmountApproved.delegate = self
        self.tfExpenseType.delegate = self
        self.tfBillDate.delegate = self
        self.tfRemark.delegate = self
        self.tfBillNumber.delegate = self
        self.tfExpenseType.delegate = self
        tfRequestedAmount.keyboardType = .decimalPad
        tfAmmountApproved.keyboardType = .decimalPad
        
        self.tfBillDate.inputView = billdatepicker
        
        billdatepicker.setCommonFeature()
        tfRemark.setCommonFeature()
        tfExpenseType.setCommonFeature()
        tfBillNumber.setCommonFeature()
        tfBillDate.setCommonFeature()
        tfRequestedAmount.setCommonFeature()
        tfAmmountApproved.setCommonFeature()
        
        
        billdatepicker.maximumDate = Date()
        billDate = Date()
        billdatepicker.backgroundColor = UIColor.white
      //self.tfBillDate.inputView = 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setExpenseData(expense:Expense){
        self.tfExpenseType.text = expense.expenseType ?? self.arrOfExpense.first ?? ""
      
        self.tfBillNumber.text = expense.billNo
       
        if(expense.amountApproved.intValue > 0){
            self.tfAmmountApproved.text = String(format:"%.2f",expense.amountApproved.doubleValue)//expense.amountApproved.stringValue
        }
        if(expense.amountRequested.intValue > 0){
        self.tfRequestedAmount.text = String(format:"%.2f",expense.amountRequested.doubleValue)//expense.amountRequested.stringValue
        }//String.init(format:"\(expense.amountRequested)")
        self.tfRemark.text = expense.remark
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        if let expensebilldate =  expense.bilDate{
            self.tfBillDate.text = Utils.getDatestringWithGMT(gmtDateString: expensebilldate, format: "dd-MM-yyyy")
        }else{
            let todaydate = self.dateFormatter.string(from: Date())
            self.tfBillDate.text = todaydate
            
        }
      
        if(expense.billAttachmentPath.count > 0){
            print("clear attachment should be there")
            self.stkClearAttachment.isHidden = false
            var  attrs = [NSAttributedString.Key:Any]()
            if #available(iOS 13.0, *) {
                 attrs = [
                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor : UIColor.link,
                    NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            } else {
                // Fallback on earlier versions
                attrs = [
                   NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),
                   NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
                   NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            }
            let buttonTitleStr = NSMutableAttributedString(string:expense.billAttachmentPath, attributes:attrs)
            self.btnClearAttachment.setAttributedTitle(buttonTitleStr, for: .normal)
        }else{
            print("should not display clear btn")
            var  attrs = [NSAttributedString.Key:Any]()
            if #available(iOS 13.0, *) {
             attrs = [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor : UIColor.link,
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            }else{
                // Fallback on earlier versions
                attrs = [
                   NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),
                   NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
                   NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            }
            let buttonTitleStr = NSMutableAttributedString(string:NSLocalizedString("Add Attachment", comment: ""), attributes:attrs)
            btnAttachment.setAttributedTitle(buttonTitleStr, for: UIControl.State.normal)
            self.stkClearAttachment.isHidden = true
        }
       // self.tfRemark.text = expense.
       // self.tfBillDate.text = expense.billNo
    }
    
    // MARK: IBAction
    
    @IBAction func btnDeleteExpenseClicked(_ sender: UIButton) {
        expensedelegate?.deleteExpenseValue(expenseCell: self)
    }
    @IBAction func btnAttachmentClicked(_ sender: UIButton) {
        expensedelegate?.addAttachmentInExpense(expenseCell: self)
    }
    
    @IBAction func btnClearAttachmentClicked(_ sender: UIButton) {
        expensedelegate?.clearAttachmentInExpense(expenseCell: self)
    }
    
    @IBAction func btnDeleteAtachmentClicked(_ sender: UIButton) {
        expensedelegate?.deleteAttachmentInExpense(expenseCell: self)
    }
}
extension AddExpenseCellTableViewCell:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(textField == tfRequestedAmount || textField == tfAmmountApproved){
            let requesteamount  = NSNumber.init(value:self.tfRequestedAmount.text?.toDouble() ?? 0)
            let approvedamount =  NSNumber.init(value:self.tfAmmountApproved.text?.toDouble() ?? 0)
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString

                        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                                return true
                            }

                            let newText = oldText.replacingCharacters(in: r, with: string)
                            let isNumeric = newText.isEmpty || (Double(newText) != nil)
                            let numberOfDots = newText.components(separatedBy: ".").count - 1

                            let numberOfDecimalDigits: Int
                            if let dotIndex = newText.firstIndex(of: ".") {
                                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                            } else {
                                numberOfDecimalDigits = 0
                            }
            if(isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && oldText.count < 9){
                if(oldText.count < 6){
                    if(textField == tfAmmountApproved){
                        if(requesteamount.doubleValue > newText.toDouble()){
                return true
                        }else if(requesteamount.doubleValue == newText.toDouble()){
                            return true
                        }else{
                        print(requesteamount.doubleValue)
                        print(approvedamount.doubleValue)
                        Utils.centertoastmsg(message: "approved amount can nobe more than requested amount", view: self)
                        return false
                    }
                    }else{
                        return true
                    }
                }else if (oldText.count == 6){
                    if(string == "."){
                        return true
                    }else if(string == ""){
                        return true
                    }else if(oldText.contains(".") && isNumeric && numberOfDots <= 1 && oldText.count < 9){
                        return true
                    }else{
                        Utils.centertoastmsg(message: "You can add maximum requested amount 999999.99 ", view: self)
                                     return false
                    }
                }else{
                    if(oldText.count < 9 && numberOfDots <= 1 && isNumeric){
                        return true
                    }else if(string == ""){
                        return true
                    }else{
                        Utils.centertoastmsg(message: "You can add maximum requested amount 999999.99 ", view: self)
                                     return false
                    }
                }
            }else if(string == ""){
                return true
            }else if(string == "." && numberOfDots <= 1){
                if(textField.text?.count == 0){
                    textField.text = "0"
                }
                if(textField == tfAmmountApproved){
                
                    if(requesteamount.doubleValue > newText.toDouble()){
                        return true
                    }else if(requesteamount.doubleValue == newText.toDouble()){
                        return true
                    }else{
                        Utils.centertoastmsg(message: "approved amount can nobe more than requested amount", view: self)
                                     return false
                    }
                }else{
                    return true
                }
               
            }else{
                Utils.centertoastmsg(message: "You can add maximum requested amount 999999.99 ", view: self)
                             return false
            }
            
         }
        
         else{
          
            return true
         }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfExpenseType){
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Expense Type"
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.parentViewOfPopup = self.contentView
            self.popup?.arrOfCustomerClass = self.arrOfExpense
            self.popup?.arrOfSelectedClass = self.arrOfselectedExpense
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.customerClass
            
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            //self.present(self.popup!, animated: false, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.popup!, animated: true, completion: {
                
            })
            return false
        }else if(textField == tfBillDate){
            billdatepicker.date = billDate
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            billdatepicker.datePickerMode = .date
            billdatepicker.date = self.dateFormatter.date(from: tfBillDate.text!) ?? Date()
            return true
        }else{
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField ==  tfRequestedAmount){
            expensedelegate?.updateExpenseValue(expenseCell: self)
            expensedelegate?.updateExpenseRequestedAmountValue(expenseCell: self)
        }else if(textField == tfAmmountApproved){
//            updateExpenseApprovedAmountValue
            expensedelegate?.updateExpenseValue(expenseCell: self)
            expensedelegate?.updateExpenseApprovedAmountValue(expenseCell: self)
        }else if(textField == tfBillDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            billDate = billdatepicker.date
            tfBillDate.text = self.dateFormatter.string(from: billdatepicker.date)
            expensedelegate?.updateExpenseValue(expenseCell: self)
        }else{
            expensedelegate?.updateExpenseValue(expenseCell: self)
        }
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if(textField == tfExpenseType){
            
            
        }
    }
}
extension AddExpenseCellTableViewCell:PopUpDelegateNonMandatory{
    func completionSelectedClass(arr: [String], recordno: Int , strTitle:String) {
        var strselectedexpense = ""
        if let string = arr.first as? String{
            strselectedexpense =  string
        }
        self.tfExpenseType.text = strselectedexpense
    }
}
