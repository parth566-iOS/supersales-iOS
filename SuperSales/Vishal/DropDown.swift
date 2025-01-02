//
//  DropDown.swift
//  SuperSales
//
//  Created by Apple on 17/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation

@objc protocol DropDownDelegate:NSObjectProtocol {
    func dropDown(_ dropDown:AutoCompleteDropDown, didSelect text:String, index:Int)
    @objc optional func dropDown(_ dropDown:AutoCompleteDropDown, didChangeEmails emails: [String])
}

class AutoCompleteDropDown: NSObject, LUAutocompleteViewDataSource, LUAutocompleteViewDelegate {

    let autocompleteView = LUAutocompleteView()
    weak var textField:UITextField?
    weak var delegate:DropDownDelegate?
    var NumberOfCar = 2
    var isEmail = false
    
    let inputArray : [String]

    required init(_ textField : UITextField, inputArray:[String], view:UIView, upDirection:Bool = false , isClear:Bool? = false) {
        self.inputArray = inputArray
        super.init()
        self.textField = textField
        self.textField?.shouldResignOnTouchOutsideMode = .disabled
        self.textField?.rightView = nil
        if isClear == false{
            self.textField?.clearButtonMode = .always
        }else{
            self.textField?.clearButtonMode = .never

        }
        view.addSubview(autocompleteView)
        autocompleteView.upPopUpDirection = upDirection
        autocompleteView.textField = self.textField
        autocompleteView.dataSource = self
        autocompleteView.delegate = self
        autocompleteView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        autocompleteView.rowHeight = 30
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        textField?.resignFirstResponder()
        let index = self.inputArray.firstIndex{$0 == text} ?? 0
        
        let arrayDuplicateIndexes = getIndexesOfDuplicateText(text: text, selectedRow: autocompleteView.tableView.indexPathForSelectedRow?.row ?? 0)
        
        //delegate?.dropDown(self, didSelect: text, index: count > 1 ? (index + autocompleteView.tag): index)
        delegate?.dropDown(self, didSelect: text, index: arrayDuplicateIndexes.first ?? index)
    }
    
    func getIndexesOfDuplicateText (text : String, selectedRow : Int) -> [Int]{
        var duplicateIndexes = [Int]()
        if (inputArray.count-1) > 0 {
            var flag = 0
            for index in 0...inputArray.count-1 {
//                if inputArray[index] == text{
                if inputArray[index].lowercased().contains(text.lowercased()){
                    if flag == selectedRow {
                        duplicateIndexes.append(index)
                    }
                    flag = flag + 1
                }
            }
        }
        return duplicateIndexes
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        if text.count == 0 {
           //delegate?.dropDown(self, didSelect: text)
            delegate?.dropDown(self, didSelect: text, index: 0)
        }
        if text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > NumberOfCar {
            if text.count > 0 {
                if isEmail{
                    var array = text.components(separatedBy: ",")
                    
                    var textToSearch = text
                    if array.count > 1{
                        textToSearch = String(array.last ?? "")
                    }
                    array.removeLast()
                    self.delegate?.dropDown!(self, didChangeEmails:array)
                    let elementsThatMatchInput = inputArray.filter { $0.lowercased().contains(textToSearch.lowercased()) }
                    completion(elementsThatMatchInput)
                }
                else{
                    let elementsThatMatchInput = inputArray.filter { $0.lowercased().contains(text.lowercased()) }
                    completion(elementsThatMatchInput)
                }
            }
        }
        else {
            completion([])
        }
    }
}
