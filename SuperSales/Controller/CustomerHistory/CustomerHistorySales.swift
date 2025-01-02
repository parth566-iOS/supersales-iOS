//
//  CustomerHistorySales.swift
//  SuperSales
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class CustomerHistorySales: BaseViewController {
    var customerId = 0
    @IBOutlet var tblView: UITableView!
    var arrSalesOrders = [SOrder]()
    let setting = Utils().getActiveSetting()

    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            super.viewDidLoad()
            self.setUI()
        })
        // Do any additional setup after loading the view.
    }
    
    // MARK: -  Method
    func setUI(){
        tblView.delegate =  self
        tblView.dataSource =  self
        tblView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CustomerHistorySales: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSalesOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderCell
        let dict = arrSalesOrders[indexPath.row]
        cell.configureCell(order: dict, s: setting)
        cell.selectionStyle = .none
        if let orders = CustomerHistoryContainer.customerhistory["SalesOrder"] as? [[String: Any]], let order = orders[indexPath.row] as? Dictionary<String, Any>, let createdBy = order["CreatedByName"] as? String {
            cell.lblProposalNo.text = createdBy
        }
        cell.focProducts.removeAll()
        cell.products = nil
        cell.products = dict.soProductList
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objSalesOrder = arrSalesOrders[indexPath.row]
        if let p = objSalesOrder.soProductList.firstObject as? SOrderProducts, p.gSTEnabled {
            print("Sales Order Details")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                vc.delegate = self
                vc.order = objSalesOrder
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            self.view.window?.makeToast("you can't update previous sales order which has applied VAT/CST")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension CustomerHistorySales: AddEditSODelegate {
    func successfullySaveOrUpdateSO() {
//        self.getSalesOrderFromDB()
    }
    
}
