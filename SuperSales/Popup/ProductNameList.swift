//
//  ProductSelection.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import UIKit
@objc protocol ProductSelectionPopUpDelegate {
    // func btnClicked(btn:UIButton)
    @objc optional func completionSelectedTerritory(arr:[[String:Any]])
     @objc optional func completionDataProduct(arr:[Product])
     @objc optional  func completionNameData(arr:[String])
    @objc optional func completionSelectedSegment(arr:[CustomerSegment])
    @objc optional func completionSelectedClass(arr:[String],recordNo:Int)
   
}

protocol ProductSelectionPopUpMandatoryDelegate{
    func completionSelectedBeatPlan(arr:[BeatPlan],recordnoForBeatplan:Int)
   
}
class ProductNameList: UIViewController {
    
   // var selectedIndexPath:IndexPath?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stackSearch: UIStackView!
    @IBOutlet weak var tblProductSelection: UITableView!
    var parentViewForPopup:UIView!
    var selectedClassNo = 0
    var selectedBeatplanNo = 0
    var selectionmode:SelectionMode!
    var isSearchRequire:Bool!
    var isDisplayName:Bool!
    var strTitle:String!
    var searchActive : Bool = false
    var filtered:[Product] = []
    var delegate:ProductSelectionPopUpDelegate?
    var mandatorydelegate:ProductSelectionPopUpMandatoryDelegate?
    var isFilterRequire:Bool! = false
   // var isMultipleSelection:Bool! = false
    var viewfor:ViewFor!
    var isContactNameRequire:Bool! = true
    var arrOfTerritory:[[String:Any]]! = [[String:Any]]()
    var arrOfSelectedTerritory:[[String:Any]]! = [[String:Any]]()
    var arrOfList = [Product]()
    var arrOfExecutive:[CompanyUsers]!
    var arrOfCustomerSegment:[CustomerSegment]!
    var arrOfselectedCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfCustomerClass:[String]! = [String]()
    var arrOfSelectedClass:[String]! = [String]()
    var arrOfName = [String]()
    var strLeftTitle:String = ""
    var strRightTitle:String = ""
    var arrOfSelectedSingleCustomer:[Product]! = [Product]()
    var arrOfSelectedMultipleCustomer:[Product]! = [Product]()
    
    var arrOfBeatPlan:[BeatPlan]! = [BeatPlan]()
    var arrOfSelectedBeatPlan:[BeatPlan]! = [BeatPlan]()
    var arrOffilteredBeatPlan:[BeatPlan] = [BeatPlan]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    // @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnClose: UIButton!
  
    @IBOutlet weak var cnstHeighttbl: NSLayoutConstraint!
    
    @IBOutlet var btnLeft: UIButton!

    @IBOutlet var btnRight: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        parentViewForPopup = self.view
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        searchBar.delegate = self
        self.lblTitle.backgroundColor = UIColor.white
        tblProductSelection.delegate = self
        tblProductSelection.dataSource = self
        tblProductSelection.tableFooterView = UIView()
        if(!isFilterRequire){
            btnClose.setImage(UIImage.init(named: "icon_close"), for: .normal)
        }else{
            btnClose.setImage(UIImage.init(named: "icon_filter"), for: .normal)
        }
//        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        if(isSearchRequire == false){
            stackSearch.isHidden = true
        }else{
            stackSearch.isHidden = false
        }
        if(strTitle.count > 0){
            lblTitle.isHidden = false
            lblTitle.text = strTitle
        }else{
            lblTitle.isHidden = true
        }
        if(isDisplayName == true){
            cnstHeighttbl.constant = CGFloat(44 * arrOfName.count)
        }else{
            cnstHeighttbl.constant = CGFloat(44 * arrOfList.count)
        }
        if(viewfor == ViewFor.customerClass){
             cnstHeighttbl.constant =  CGFloat(44 * arrOfCustomerClass.count)
        }
        if(viewfor == ViewFor.beatplan){
             cnstHeighttbl.constant =  CGFloat(44 * arrOfBeatPlan.count)
        }
        if(viewfor == ViewFor.customersegment){
              cnstHeighttbl.constant =  CGFloat(44 * arrOfCustomerSegment.count)
        }
        if(viewfor == ViewFor.territory){
              cnstHeighttbl.constant =  CGFloat(44 * arrOfTerritory.count)
        }
        if(strLeftTitle.count == 0){
            btnLeft.isHidden = true
        }else{
            btnLeft.isHidden = false
            btnLeft.setTitle(strLeftTitle, for: .normal)
        }
        if(strRightTitle.count == 0){
            btnRight.isHidden = true
        }else{
            btnRight.setTitle(strRightTitle, for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    // MARK: - IBAction
    
//    @IBOutlet var btnOfCustomerSelectionPopUpClicked: [UIButton]!{
//
//    }
    
   @IBAction func btnOfCustomerSelectionPopUpClicked(_ sender: UIButton) {
        
        if(sender == btnClose){
            if(self.isFilterRequire){
                //filter action
            }else{
                Utils.removeShadow(view: parentViewForPopup)
                self.dismiss(animated: true, completion: nil)
            }
        }else if(sender == btnLeft){
            if(sender.currentTitle == "OK"){
                if(viewfor == ViewFor.customer){
                    self.delegate?.completionDataProduct!(arr: self.arrOfSelectedMultipleCustomer!)
                }else if(viewfor == ViewFor.customerClass){
                    self.delegate?.completionSelectedClass?(arr: self.arrOfSelectedClass,recordNo:selectedClassNo)
                }else if(viewfor == ViewFor.customersegment){
                    self.delegate?.completionSelectedSegment?(arr: self.arrOfselectedCustomerSegment)
                }
//                else if(viewfor == ViewFor.companyuser){
//                    self.delegate?.completionSelectedExecutive!(arr: arrOfSelectedExecutive!)
//                }else if(viewfor == ViewFor.visitoutcome){
//                    self.delegate?.CompletionSelectedVisitOutCome!(arr: arrOfSelectedVisitOutcome)
//                }else if(viewfor == ViewFor.productcategory){
//                    self.delegate?.CompletionProductCategory!(arr: arrOfSelectedProductCategory)
//                }
                else if(viewfor == ViewFor.product){
                    self.delegate?.completionDataProduct!(arr: arrOfSelectedSingleCustomer)
                }else if(viewfor == ViewFor.beatplan){
                  
                    self.mandatorydelegate?.completionSelectedBeatPlan(arr: self.arrOfSelectedBeatPlan, recordnoForBeatplan: selectedBeatplanNo)
                    
                }else if(viewfor == ViewFor.territory){
                    self.delegate?.completionSelectedTerritory?(arr: arrOfSelectedTerritory)
    
      //  self.nonmandatorydelegate?.completionSelectedTerritory?(arr: self.arrOfSelectedTerritory)
                }
                self.dismiss(animated: true, completion: nil)
            }else if(sender.currentTitle == "REFRESH"){
                //refresh the customers
            }else if(sender.currentTitle == "CANCEL"){
                Utils.removeShadow(view: parentViewForPopup)
                self.dismiss(animated: true, completion: nil)
            }
        }else if(sender == btnRight){
            Utils.removeShadow(view: parentViewForPopup)
            self.dismiss(animated: true, completion: nil)
        }
        
//        }else if(sender == btnLeft){
//            if(sender.currentTitle == "OK"){
//                self.delegate?.CompletionData(arr: self.arrOfSelectedMultipleCustomer)
//                self.dismiss(animated: true, completion: nil)
//            }else if(sender.currentTitle == "REFRESH"){
//                //refresh the customers
//            }
//        }else if(sender == btnRight){
//
//            self.dismiss(animated: true, completion: nil)
//        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //    func showAnimate()
    //    {
    //        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    //        self.view.alpha = 0.0
    //        UIView.animate(withDuration: 0.25, animations: {
    //            self.view.alpha = 1.0
    //            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    //        })
    //    }
    //
    //    func removeAnimate()
    //    {
    //        UIView.animate(withDuration: 0.25, animations: {
    //            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    //            self.view.alpha = 0.0
    //        }, completion: {(finished : Bool) in
    //            if(finished)
    //            {
    //                self.willMove(toParent: nil)
    //                self.view.removeFromSuperview()
    //                self.removeFromParent()
    //            }
    //        })
    //    }
    
}
extension ProductNameList : UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered =
            arrOfList.compactMap { (temp) -> Product in
                return temp
                }.filter { (aUser) -> Bool in
                    return aUser.productName?.localizedCaseInsensitiveContains(searchText) == true
        }//Product
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tblProductSelection.reloadData()
    }
}
extension ProductNameList: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isDisplayName == true){
            return arrOfName.count
        }else if(viewfor == ViewFor.customersegment){
            if(isSearchRequire == true && searchActive == true){
                return arrOfselectedCustomerSegment.count
            }else{
                print(arrOfCustomerSegment.count)
                return arrOfCustomerSegment.count
            }
            
        }else if(viewfor == ViewFor.customerClass){
            if(isSearchRequire == true && searchActive == true){
                return arrOfSelectedClass.count
            }else{
                return arrOfCustomerClass.count
            }
        }else if(viewfor == ViewFor.territory){
            if(isSearchRequire == true && searchActive == true){
                return arrOfSelectedTerritory.count
            }else{
            return arrOfTerritory.count
            }
        }else if(viewfor == ViewFor.beatplan){
            if(isSearchRequire == true && searchActive == true){
                return arrOffilteredBeatPlan.count
            }else{
                print(arrOfBeatPlan.count)
                return arrOfBeatPlan.count
            }
        }else{
        if(searchActive) {
            return filtered.count
        } else {
            return arrOfList.count
        }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "namedisplaycell", for: indexPath) as? NameDisplay{
        if(isDisplayName == true){
            cell.lblProductName.text = arrOfName[indexPath.row]
        }else if(viewfor == ViewFor.customersegment){
            if let cell =  tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell{
            cell.btnCustomerSelection.tag = indexPath.row
            cell.btnCustomerSelection.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            var selectedsegment = CustomerSegment()
            if(isSearchRequire == true && searchActive == true){
                selectedsegment = arrOfselectedCustomerSegment[indexPath.row]
            }else{
                selectedsegment = arrOfCustomerSegment[indexPath.row]
            }
            if(arrOfselectedCustomerSegment?.contains(selectedsegment) ?? false ==  true){
                
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            
            
            cell.lblContactNo.isHidden = true
            cell.lblCustomerName.text = selectedsegment.customerSegmentValue
            cell.contentView.layoutIfNeeded()
            return cell
            }
            else{
                return UITableViewCell()
            }
        
        }else if(viewfor == ViewFor.territory){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell{
            var customerTerritory = [String:Any]()
            if(isSearchRequire == true && searchActive == true){
                customerTerritory = arrOfSelectedTerritory[indexPath.row]
            }else{
                customerTerritory =  (arrOfTerritory?[indexPath.row])! 
            }
            
            if(indexPath.row == 0){
                cell.lblCustomerName.text =  customerTerritory["territoryName"] as! String
            }else{
            cell.lblCustomerName.text = String.init(format: "%@ ", customerTerritory["territoryName"] as! CVarArg)
            }
            cell.lblContactNo.isHidden = true
             
            if (selectionmode == SelectionMode.single){
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)

                var exist =  false
                for dic in arrOfSelectedTerritory{
                    if let leadID = dic["territoryId"] as? String{

                        if let teritoryid = customerTerritory["territoryId"] as? String{
                        if(leadID == teritoryid){
                        
                        exist = true
                        }
                        }
                    }else if let leadID = dic["territoryId"] as? Int{

                        if let teritoryid = customerTerritory["territoryId"] as? Int{
                        if(leadID == teritoryid){
                         
                        exist = true
                        }
                        }
                        
                    }else if let leadID = dic["territoryId"] as? Int64{
                            
                            if let teritoryid = customerTerritory["territoryId"] as? Int64{
                            if(leadID == teritoryid){
                                print("territory id = \(leadID) and selected territory id = \(teritoryid)")
                            exist = true
                            }
                            }
                    }else if let leadID = dic["territoryId"] as? Int32{
                                
                                if let teritoryid = customerTerritory["territoryId"] as? Int32{
                                if(leadID == teritoryid){
                                    print("territory id = \(leadID) and selected territory id = \(teritoryid)")
                                exist = true
                                }
                                }
                    }
                    }
                

                if (exist == true){
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                    }else{
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                    }
            
                }else if(selectionmode == SelectionMode.multiple){
//if(arrOfSelectedTerritory?.contains(where: customerTerritory) ?? false ==  true){
//                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
//                                       cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
//                    }else{
//                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
//                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
//}
                }
              
          
            cell.contentView.layoutIfNeeded()
            return cell
          /*  if  let cell =  tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell{
            let territory = arrOfTerritory[indexPath.row]
            cell.lblCustomerName.text = territory["territoryName"]
            cell.lblContactNo.isHidden = true
            if(selectionmode == SelectionMode.single){
            if(arrOfSelectedTerritory?.contains(territory) ?? false ==  true){
                
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
            }else{
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
            }
            }
            return cell*/
            }else{
                return UITableViewCell()
            }
        }else if(viewfor == ViewFor.beatplan){
            if let cell =  tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell{
            var selectedBeatPlan:BeatPlan!
            if(isSearchRequire == true && searchActive == true){
                selectedBeatPlan = arrOffilteredBeatPlan[indexPath.row]
            }else{
                selectedBeatPlan = arrOfBeatPlan[indexPath.row]
            }
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)

                var exist =  false
                for dic in arrOfSelectedBeatPlan{
                    if let leadID = dic.BeatPlanID as? String{
                        
                        
                        if(leadID == selectedBeatPlan.BeatPlanID){
                            print("beatplan id = \(leadID) and selected beaplan id = \(selectedBeatPlan.BeatPlanID)")
                        exist = true
                        }
                    }
                }
                if (exist == true){
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                    }else{
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                    }

            cell.lblContactNo.isHidden = true
            cell.lblCustomerName.text = String.init(format:"%@",selectedBeatPlan.BeatPlanName)
                return cell
            }else{
                return UITableViewCell()
            }
             
        }
        else if(viewfor == ViewFor.customerClass){
            if let cell1 =  tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell{
            cell1.btnCustomerSelection.tag = indexPath.row
            cell1.btnCustomerSelection.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            var selectedclass = String()
            if(isSearchRequire == true && searchActive == true){
                selectedclass = arrOfSelectedClass[indexPath.row]
            }else{
                selectedclass = arrOfCustomerClass[indexPath.row]
            }
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedClass?.contains(selectedclass) ?? false ==  true){
                    print("arr of selected class = \(arrOfSelectedClass) , selected class = \(selectedclass)")
                    cell1.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell1.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell1.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell1.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }
            
            
            cell1.lblContactNo.isHidden = true
            cell1.lblCustomerName.text = selectedclass
            cell1.contentView.layoutIfNeeded()
            return cell1
            }else{
                return UITableViewCell()
            }
        }else{
        var product = Product()
        if(searchActive) {
            product =  filtered[indexPath.row]
        } else {
            product =  arrOfList[indexPath.row]
        }
             cell.lblProductName.text = product.productName
        
      
//        if(!isMultipleSelection){
//            cell.vwMultipleSelection.isHidden = true
//        }
//
       
      //  cell.lblContactNo.text = customer.mobileNo
        cell.contentView.layoutIfNeeded()
        return cell
        }
            return cell
        }
        else{
            return UITableViewCell()
        }
    
    
}

    @objc func btnClicked(sender:UIButton){
        sender.isSelected = !sender.isSelected
        print(sender.tag)
//         selectedIndexPath = IndexPath.init(item: sender.tag, section: 0)
        if(viewfor == ViewFor.customersegment){
            arrOfselectedCustomerSegment.removeAll()
            arrOfselectedCustomerSegment.append(arrOfCustomerSegment[sender.tag])
        }else if(viewfor == ViewFor.customerClass){
            arrOfSelectedClass.removeAll()
            arrOfSelectedClass.append(arrOfCustomerClass[sender.tag])
        }
        tblProductSelection.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isDisplayName == true){
            self.dismiss(animated: true) {
                self.delegate?.completionNameData!(arr: [self.arrOfName[indexPath.row]])
            }
        }else if(viewfor == ViewFor.beatplan){
            selectedBeatplanNo = indexPath.row
            arrOfSelectedBeatPlan.removeAll()
            arrOfSelectedBeatPlan.append(arrOfBeatPlan[indexPath.row])
           
    }else if(viewfor == ViewFor.customersegment){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfselectedCustomerSegment.removeAll()
            arrOfselectedCustomerSegment.append(arrOfCustomerSegment[indexPath.row])
            }
        }else if(viewfor == ViewFor.customerClass){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                selectedClassNo = indexPath.row
                arrOfSelectedClass.removeAll()
                arrOfSelectedClass.append(arrOfCustomerClass[indexPath.row])
            }
        }else if(viewfor == ViewFor.territory){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedTerritory.removeAll()
                arrOfSelectedTerritory.append(arrOfTerritory[indexPath.row])
            }
         
           
           
           
        //    self.nonmandatorydelegate?.completionSelectedTerritory?(arr: arrOfSelectedTerritory)
           // }
            if((strLeftTitle.count == 0 && strRightTitle.count == 0)){
                Utils.removeShadow(view: parentViewForPopup)
                self.delegate?.completionSelectedTerritory?(arr: arrOfSelectedTerritory)
self.dismiss(animated: true) {
  //  self.nonmandatorydelegate?.completionSelectedTerritory?(arr: self.arrOfSelectedTerritory)
}
            }
//            if(selectionmode == SelectionMode.multiple){
//
//            }else{
//            arrOfSelectedTerritory.removeAll()
//            arrOfSelectedTerritory.append(arrOfTerritory[indexPath.row])
//            }
            
        }else{
        if(selectionmode == SelectionMode.none){
            arrOfSelectedMultipleCustomer.append(arrOfList[indexPath.row])
            
        }else{
            arrOfSelectedSingleCustomer.append(arrOfList[indexPath.row])
            self.dismiss(animated: true) {
                self.delegate?.completionDataProduct!(arr: self.arrOfSelectedSingleCustomer)
            }
        }
        }
          tblProductSelection.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


