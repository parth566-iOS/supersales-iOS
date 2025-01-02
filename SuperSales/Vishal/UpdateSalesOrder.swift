//
//  DRSalesOrder.swift
//  SuperSales
//
//  Created by Apple on 17/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping

class UpdateSalesOrder: BaseViewController {
    private let refreshControl = UIRefreshControl()
    @IBOutlet var tblSOList: UITableView!
    var aNewOrders = [SOrder]()
    // Setting for user
    let setting = Utils().getActiveSetting()
    let account = Utils().getActiveAccount()
    var customerID: Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblSOList.rowHeight = UITableView.automaticDimension;
        self.tblSOList.estimatedRowHeight = 100.0; // set to whatever your "average" cell height is
        self.tblSOList.separatorStyle = .none
//        self.tblSOList.addInfiniteScrolling { [self] in
//            insertRowAtBottom()
//        }
        
        self.tblSOList.addPullToRefresh { [self] in
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            self.callWebservice()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.callWebservice()
        tblSOList.reloadData()
    }

    
    //MARK: - Load More
    func insertRowAtBottom() {
        print("Load More..............");
        self.callWebservice()
    }

    func callWebservice() {
        var subParam = [String: Any]()
        subParam["CreatedBy"] = account?.userID
        subParam["CompanyID"] = account?.company?.iD
        subParam["CustomerID"] = customerID
        
        var param = [String: Any]()
        param["getLatestSalesOrdersOfCustomerJson"] = subParam.rs_jsonString(withPrettyPrint:true)
        param["TokenID"] = account?.securityToken
        param["UserID"] = account?.userID
        param["CompanyID"] = account?.company?.iD
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        RestAPIManager.httpRequest("getLatestSalesOrdersOfCustomer", .get, parameters: param, isTeamWorkUrl: true, isFull: true) { [self] response, success, error in
            SVProgressHUD.dismiss()
            if let res = response as? [String: Any], let aDataInfo = res["data"] as? [[String: Any]]{
                if(aDataInfo.count > 0){
                    let mapping = SOrder.defaultMapping()// your mapping here
                    let store = FEMManagedObjectStore(context: SOrder.getContext())
                    store.saveContextOnCommit = false;
                    let deserializer = FEMDeserializer(store: store)
                    aNewOrders.removeAll()
                    if let objects = deserializer.collection(fromRepresentation: aDataInfo, mapping: mapping) as? [SOrder] {
                        aNewOrders.append(contentsOf: objects)
                    }
                    
                    self.tblSOList.isHidden = true
                    self.tblSOList.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.tblSOList.isHidden = false
                        self.tblSOList.reloadData()
                        self.tblSOList.pullToRefreshView.stopAnimating()
                    })
                }else{
                    self.tblSOList.isHidden = true
                    self.tblSOList.reloadData()
                }
            }else if let res = response as? [String: Any], let message = res["message"] as? String {
                self.view.makeToast(message)
            }
        }
    }


    
    // Validate PDF using NSData
    func isValidePDF(pdfData: Data) -> Bool {
        var isPDF = false
        if (pdfData.count >= 1024 ) {
            let startMetaCount = 4, endMetaCount = 5;
                // check pdf data is the NSData with embedded %PDF & %%EOF
            let startPDFData = Data(bytes: UnsafeRawPointer("%PDF"), count: startMetaCount)
            let endPDFData = Data(bytes: UnsafeRawPointer("%%EOF"), count: endMetaCount)
            // startPDFData, endPDFData data are the NSData with embedded in pdfData
            let startRange = pdfData.range(of: startPDFData, options: [], in: Range(NSRange(location: 0, length: 1024)))
            let endRange = pdfData.range(of: endPDFData, options: [], in: Range(NSRange(location: 0, length: pdfData.count)))

            if startRange != nil && startRange?.count == startMetaCount && endRange != nil && endRange?.count == endMetaCount {
                // This assumes the checkstartPDFData doesn't have a specific range in file pdf data
                isPDF = true
            } else {
                isPDF = false
            }
        }
        return isPDF;
    }

        // Download PDF file in asynchronous way and validate pdf file formate.
    func downloadPDFfile(fileName:String, withFileURL url1: String) {
        DispatchQueue.main.async {
            let request = URLRequest(url: URL(string: url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                SVProgressHUD.dismiss()
                guard let unwrappedData = data else { return }
                //if self.isValidePDF(pdfData: unwrappedData) {
                    DispatchQueue.main.async(execute: {
                        let url = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                        // write data
                        do {
                            try unwrappedData.write(to: url)
                            let activityItems = [url]
                            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                                //Delete file
                                do {
                                    try FileManager.default.removeItem(at: url)
                                } catch {
                                    print("json error: \(error)")
                                }
                            }
                            self.present(activityVC, animated: true)
                        }catch {
                            print("json error: \(error)")
                        }
                    })
                //}
            }).resume()
        }
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

extension UpdateSalesOrder:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aNewOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderCell
        let dict = aNewOrders[indexPath.row]
        cell.configureCell(order: dict, s: setting)
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.focProducts.removeAll()
        cell.products = nil
        cell.products = dict.soProductList
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let objSalesOrder = aNewOrders[indexPath.row]
        if let p = objSalesOrder.soProductList.firstObject as? SOrderProducts, p.gSTEnabled {
            print("Sales Order Details")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                vc.delegate = self
                vc.order = objSalesOrder
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            self.view.window?.makeToast("you can't update previous sales order which has applied VAT/CST")
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UpdateSalesOrder: AddEditSODelegate {
    func successfullySaveOrUpdateSO() {

    }
    
}

extension UpdateSalesOrder: OrderCellDelegate {
    func deleteSO(cell: OrderCell) {
        let indexPath = tblSOList.indexPath(for: cell)
        let objSalesOrder = aNewOrders[indexPath?.row ?? 0]
        if (objSalesOrder.statusID == 1){
            self.view.window?.makeToast("You can't delete pending sales order")
            return;
        }
        let alertController = UIAlertController(title: "SuperSales", message: "Are you sure you want to delete this sales order?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default) { (action) in
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            let dict = ["ID": objSalesOrder.iD, "CreatedBy": self.account?.userID ?? 0,"CompanyID": self.account?.company?.iD ?? 0, "SeriesPrefix": objSalesOrder.seriesPrefix,"SeriesPostfix": objSalesOrder.seriesPostfix] as [String : Any]
            let maindict = ["delsalesorderjson": dict.rs_jsonString(withPrettyPrint: true) ?? "","UserID": self.account?.userID ?? 0,"TokenID": self.account?.securityToken ?? ""] as [String : Any]
            RestAPIManager.httpRequest(ConstantURL.delsalesorder, .get, parameters: maindict, isTeamWorkUrl: true,isFull: true) { [self] (response, success, error) in
                SVProgressHUD.dismiss()
                if success {
                    if let res = response as? [String: Any], let st = res["data"] as? Int,st == 1 {
                        self.aNewOrders.remove(at: indexPath?.row ?? 0)
                        let predicate  = NSPredicate(format: "iD == %d", objSalesOrder.iD)
                        SOrder.mr_deleteAll(matching: predicate)
                        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                        tblSOList.reloadData()
                    }else if let res = response as? [String: Any]{
                        self.view.window?.makeToast(res["message"] as? String)
                    }
                }else{
                    self.view.window?.makeToast(error?.localizedDescription)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    func shareSO(cell: OrderCell) {
        let indexPath = tblSOList.indexPath(for: cell)
        let objSalesOrder = aNewOrders[indexPath?.row ?? 0]

        let dict = ["ID": objSalesOrder.iD,"CompanyID": self.account?.company?.iD ?? 0] as [String : Any]
        let maindict = ["Application":"SalesPro", "generateSalesOrderPDFJson": dict.rs_jsonString(withPrettyPrint: true) ?? "","UserID": self.account?.userID ?? 0,"TokenID": self.account?.securityToken ?? "","CompanyID": self.account?.company?.iD ?? 0] as [String : Any]
        SVProgressHUD.show(withStatus: "Generating sales order file....")
        RestAPIManager.httpRequest(ConstantURL.generateSOPDF, .post, parameters: maindict, isTeamWorkUrl: true) { (response, success, error) in
            if let result = response as? [String: Any], let pdfUrl = result["PDFPath"] as? String {
                self.downloadPDFfile(fileName: String(format: "%@%ld.pdf", objSalesOrder.seriesPrefix,objSalesOrder.seriesPostfix), withFileURL: pdfUrl)
            }else if let result = response as? [String: Any]{
                SVProgressHUD.dismiss()
                if result["status"] as? String == "Error"{
                    self.view.makeToast(result["message"] as? String)
                }else if result["status"] as? String == "Invalid Token"{
                    self.view.makeToast(result["message"] as? String)
//                    AppDelegate.shared.logout
                }else{
                    self.view.makeToast(error?.localizedDescription)
                }
            }else{
                SVProgressHUD.dismiss()
                self.view.makeToast(error?.localizedDescription)
            }
        }

    }
    
    func dispatchSO(cell: OrderCell) {
        
    }
    
}
