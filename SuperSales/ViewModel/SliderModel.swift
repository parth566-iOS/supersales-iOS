//
//  SliderModel.swift
//  SuperSales
//
//  Created by Apple on 18/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

protocol SliderModelItem {
    var companyMenus: [CompanyMenus] {get}
    var sectionTitle: String { get }
    var isCollapsed: Bool { get set }
}

protocol HeaderViewDelegate: class {
    func toggleSection(header: TitleCell, section: Int)
}
protocol SliderClickDelegate:class{
    func setViewAsPerSelection(selectedMenu:CompanyMenus)
}

extension SliderModelItem {
    
    
}

class SliderModel: NSObject {
    var sidemenudelegate:SliderClickDelegate?
    var hrTaskItem:[CompanyMenus] = [CompanyMenus]()
    var salesTaskItem:[CompanyMenus] = [CompanyMenus]()
    var items = [SliderModelItem]()
    var reloadSections: ((_ section: Int) -> Void)?
    
    override init() {
        super.init()
        let salesTaskobject = SalesTask.init()
        let hrTaskobj = HrTask.init()
        items.append(salesTaskobject)
        items.append(hrTaskobj)
      
    }

}

extension SliderModel: HeaderViewDelegate {
    func toggleSection(header: TitleCell, section: Int) {
        var item = items[section]
//        var anothersection:SliderModelItem!
//
//        switch section {
//        case 0:
//            anothersection = items[1]
//
//            break
//        case 1:
//            anothersection = items[0]
//
//            break
//        default:
//            break
//
//
//        }
            
       // anothersection.isCollapsed = true
        // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
     
           // header.setCollapsed(collapsed: collapsed)
            // Adjust the number of the rows inside the section
            reloadSections?(section)
        //reloadSections?([section,anotheritem])
    }
}

class SalesTask : SliderModelItem {
   
    
    var companyMenus:[CompanyMenus]{
        return Utils.getHrTask(type: "Sales")
        //getHRTask()
    }
    var isCollapsed = true
    var sectionTitle: String {
        return "My Sales Tasks"
    }
    var rowCount: Int {
        return 10
    }
    init(){
        
    }
}

class HrTask:SliderModelItem{
    var companyMenus: [CompanyMenus]{
        return Utils.getHrTask(type: "HR")
    }
    var isCollapsed = true
    
    var sectionTitle: String {
        return "My HR Tasks"
    }
    
    var rowCount: Int {
        return 2
    }
    
   
}

extension SliderModel:UITableViewDataSource {
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "namepicturecell", for: indexPath) as? NamePictureCell)!

        // let arrcompanyItem = items[indexPath.row][CompanyMenus]
        let item = items[indexPath.section]
        
        let companymenu = item.companyMenus[indexPath.row];
        cell.nameLabel?.text = companymenu.menuLocalText
        cell.nameLabel?.textColor = UIColor.darkGray
       
        cell.imageView?.image =  CompanyMenus.getImageFromMenu(menuID: Int(companymenu.menuID))
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "Cell") as? TitleCell)!
        cell.selectionStyle =  .none
        let item = items[section]
        cell.btnTitle.contentHorizontalAlignment = .left
        cell.btnTitle.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        cell.btnTitle.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: cell.btnTitle.frame.width - 85, bottom: 0, right: 50)
        cell.btnTitle.titleLabel?.textAlignment = .left
        if(item.isCollapsed){
            
            cell.btnTitle.setTitleColor(.black , for: .normal)
            cell.btnTitle.setAttributedTitle(NSAttributedString.init(string: item.sectionTitle, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedString.Key.foregroundColor :UIColor.gray]), for: .normal)
            cell.btnTitle.setImage(UIImage.init(named: "icon_right_arrow_gray"), for: .normal)
           
        }else{
            cell.btnTitle.setAttributedTitle(NSAttributedString.init(string: item.sectionTitle, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedString.Key.foregroundColor :(UIColor.Appskybluecolor)]), for: .normal)
           // cell.btnTitle.setTitleColor(UIColor.Appskybluecolor, for: .normal)
            cell.btnTitle.setImage(UIImage.init(named: "icon_down_arrow_blue"), for: .normal)
        }
        
        cell.btnTitle.tag = section
        cell.btnTitle.addTarget(self, action: #selector(headerTapped), for: .touchUpInside)
       
       // cell.btnTitle.setTitle(item.sectionTitle, for: .normal)

        return cell.contentView
    }
    
    @objc func headerTapped(btn:UIButton)  {
        
        btn.isSelected =  !btn.isSelected
        var item = items[btn.tag]
     item.isCollapsed = !item.isCollapsed
      
      

     
//        //self.relo
//        var anothersection:SliderModelItem!
//
//        switch btn.tag {
//        case 0:
//            anothersection = items[1]
//
//            break
//        case 1:
//            anothersection = items[0]
//
//            break
//        default:
//            break
//
//
//        }
//
//       anothersection.isCollapsed = true
        reloadSections!(btn.tag)
        
    }
}
extension SliderModel:UITableViewDelegate{
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let item = items[section]
        print("\(item.isCollapsed) , \(item.sectionTitle)")
        if (item.isCollapsed) {
            return 0
        } else {
           
            return item.companyMenus.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        let selectedCompanyMenu = item.companyMenus[indexPath.row];
       

        sidemenudelegate?.setViewAsPerSelection(selectedMenu: selectedCompanyMenu)

      
    }
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let vwForHeader = UIView.init(frame: CGRect.init(x: 0, y: 60, width: self.tblMenu.frame.width , height: 60))
    //
    //
    //        return vwForHeader
    //    }
    
}

