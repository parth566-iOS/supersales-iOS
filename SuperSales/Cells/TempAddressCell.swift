//
//  TempAddressCell.swift
//  SuperSales
//
//  Created by Apple on 30/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import DropDown

protocol TempAddressCellDelegate: AnyObject  {
    func switchClicked(sender:UIButton,cell:TempAddressCell)
   // func typeOfAddressChanged(address:AddressList,cell:TempAddressCell)
}

class TempAddressCell: UITableViewCell {
    typealias CompletionBlock = (TempAddressCell) -> Void
    weak var delegate: TempAddressCellDelegate?
    var block:CompletionBlock!
    var addcustdelegate:AddCustomerDelegate?
    var addressTypeDropdown:DropDown! = DropDown()
    var arrAddressType = ["Temporary","Residencial","Factory"]
    var selectedActivityType:String = ""
    var selectedAdd:AddressListModel!
    var selectedrecord:Int!
    @IBOutlet weak var tfAddressType: UITextField!
    
    @IBOutlet var btnMap: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var tfTempAddressLine1: UITextField!
    
    @IBOutlet weak var tfTempAddressLine2: UITextField!
    
    @IBOutlet weak var tfTempTown: UITextField!
    
    
    @IBOutlet weak var tfTempPincode: UITextField!
    
    @IBOutlet weak var tfTempState: UITextField!
    
    
    @IBOutlet weak var tfTempCountry: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CustomeTextfield.setBottomBorder(tf: tfTempAddressLine1)
        CustomeTextfield.setBottomBorder(tf: tfTempAddressLine2)
        self.tfAddressType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfTempTown.setCommonFeature()
        tfTempState.setCommonFeature()
        tfAddressType.setCommonFeature()
        tfTempPincode.setCommonFeature()
        tfTempCountry.setCommonFeature()
        tfTempAddressLine1.setCommonFeature()
        tfTempAddressLine2.setCommonFeature()
        
        self.initdropdown()
        self.tfAddressType.delegate = self
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDashboardVisitData(address:AddressListModel,indexpath:IndexPath){
        selectedAdd = address
        self.tfAddressType.delegate = self
        self.tfTempAddressLine1.text = address.addressLine1
        self.tfTempAddressLine2.text = address.addressLine2
        self.tfTempTown.text = address.city
        self.tfTempState.text = address.state
        self.tfTempPincode.text = address.pincode.stringValue
        self.tfTempCountry.text = address.country
        if(address.type == "2"){
            self.tfAddressType.text = "Temporary"
        }else if(address.type == "3"){
            self.tfAddressType.text = "Residencial"
        }else{
            self.tfAddressType.text = "Factory"
        }
    }
//    func cellCompeletion(dic:[String:Any],completionblock:@escaping CompletionBlock){
//        self.txtQty.delegate = self
//        block = completionblock
//    }

  

//    @IBAction func btnSwitchClicked(_ sender: UIButton) {
//
//        self.delegate?.switchClicked(sender: sender, cell: self)
//    }
    
    //MARK: - Method
    func initdropdown(){
    //    activityTypeDropdown =
        addressTypeDropdown.dataSource =  arrAddressType/* arrActivityType.map({
                ($0.activityType)
            })*/
        addressTypeDropdown.anchorView =  tfAddressType
        
        tfAddressType.text =  addressTypeDropdown.dataSource.first
//        self.selectedAdd.type = String.init(format:"\(2)")
//        self.addcustdelegate?.updateAddressType!(address: self.selectedAdd, Record: self.selectedrecord)
        self.selectedActivityType = self.arrAddressType.first ?? ""
        addressTypeDropdown.bottomOffset = CGPoint.init(x: 0.0, y: tfAddressType.bounds.size.height)
        addressTypeDropdown.selectionAction = {(index,item) in
            self.tfAddressType.text = item
            if(item == "Temporary"){
                self.selectedAdd.type = String.init(format:"\(2)")
            }else if(item == "Residencial"){
                self.selectedAdd.type = String.init(format:"\(3)")
            }else{
                self.selectedAdd.type = String.init(format:"\(4)")
            }
            
            self.addcustdelegate?.updateAddressType!(address: self.selectedAdd, Record: self.selectedrecord)
      
            self.selectedActivityType = self.arrAddressType[index]
            self.addressTypeDropdown.reloadAllComponents()
        }
    }
}
extension TempAddressCell:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == self.tfAddressType){
           
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.tfAddressType){
            addressTypeDropdown.show()
            return false
        }
        return false
    }
}
