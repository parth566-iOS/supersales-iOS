//
//  DocumentReport.swift
//  SuperSales
//
//  Created by Apple on 20/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import  SVProgressHUD

class DocumentReport: BaseViewController {
    var docID:NSNumber!
    var doctitle:String!
    
    @IBOutlet weak var tblDocumentReport: UITableView!
    var arrofdoc:[DocumentReportModel] = [DocumentReportModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - Method
    func setUI(){
        self.title = "Document Report"
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.homeedit, navigationItem: self.navigationItem)
        self.getReportList()
        tblDocumentReport.reloadData()
        tblDocumentReport.delegate = self
        tblDocumentReport.dataSource = self
        self.salesPlandelegateObject = self
        
    }
    
    //MARK: - API Call
    func getReportList(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["DocumentID"] = self.docID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetUserDocumentViewList, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let arrofdoc = arr as? [[String:Any]] ?? [[String:Any]]()
                print(arrofdoc)
                for doc in arrofdoc{
                    let modObj = DocumentReportModel(dictionary: doc as NSDictionary)
                    
                    self.arrofdoc.append(modObj)
                }
                self.tblDocumentReport.reloadData()
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count  > 0 ?(error.userInfo["localiseddescription"] as? String ?? "" ):error.localizedDescription , view: self.view)
            }
        }
    }
    func createCSV(){
        var csvString = String.init(format: "USER, VIEWED, TIME\n")
        for doc in self.arrofdoc{
            csvString.append(String.init(format: "\(doc.userName)"))
            if(doc.viewStatus == true){
                csvString.append(String.init(format: "\("YES")  \n \n"))
            }else{
                csvString.append(String.init(format: "\("NO")  \n \n"))
            }
        }
        let filename = String.init(format: "\(self.doctitle)_Report.csv")
        let  paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentdirectory = paths[0]
        let filepath = String.init(format: "\(documentdirectory)/\(filename)")
//        let sucess = csvString.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
//        if(sucess){
//
//        }
        do {
            let sucess =  try csvString.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
            print(sucess)
          
//            if(!sucess){
//                Utils.toastmsg(message: "Could not write to the file", view: self.view)
//            }else{
//                Utils.toastmsg(message: "Your report generated successfully", view: self.view)
//                let fileurl = NSURL.fileURL(withPath: filepath, isDirectory: false)
//                let arrActivityItems = [fileurl]
//                let activitycontrol = UIActivityViewController.init(activityItems: arrActivityItems, applicationActivities: nil)
//                self.present(activitycontrol, animated: true, completion: nil)
//                
//            }
            
        } catch  {
            print(error)
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
extension DocumentReport:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrofdoc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.DocumentReportCell, for: indexPath) as? DocumentReportCell{
            let selectedDocument = self.arrofdoc[indexPath.row]
            cell.lblDocumentName.text = selectedDocument.userName
            if(selectedDocument.viewStatus){
                cell.lblStatus.text = "YES"
            }else{
                cell.lblStatus.text = "NO"
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
}
extension DocumentReport:BaseViewControllerDelegate{
    func editiconTapped(sender:UIBarButtonItem) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            self.createCSV()
        }
        Common.showalert(title:"Super Sales" , msg: "Do you want to Export? ", yesAction: yesAction, noAction: noAction, view: self)
    }
    
}
