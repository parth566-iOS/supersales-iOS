//
//  KnowledgeCenter.swift
//  SuperSales
//
//  Created by Apple on 20/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class KnowledgeCenter: BaseViewController {
    
    @IBOutlet weak var tfDocumentType: UITextField!
    
    @IBOutlet weak var tblDocument: UITableView!
    
    var path = ""
    
    var popup:CustomerSelection?
    let baseviewcontrollerobj = BaseViewController()
    var selectedCategory:CategoryDocument!
    var arrOfCategoryDocument:[CategoryDocument]! = [CategoryDocument]()
    var arrOFCategoryName:[String]! = [String]()
    var arrOFDocument:[Document]! = [Document]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Method
    func setUI(){
        self.title = "Knowledge Center"
        tfDocumentType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.getCategoryList()
        tfDocumentType.delegate = self
        tfDocumentType.setCommonFeature()
        self.setparentview(control: self)
        
        //table view
        tblDocument.delegate = self
        tblDocument.dataSource = self
        tblDocument.tableFooterView = UIView()
        tblDocument.separatorColor = UIColor.clear
    }
    //MARK: - APICall
    func getCategoryList(){
        SVProgressHUD.show()
        let param = Common.returndefaultparameter()
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCategoryList, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                let arrOFCategory = arr as? [[String:Any]]
                if(arrOFCategory?.count ?? 0 > 0){
                    for i in 0...(arrOFCategory?.count ?? 0)  - 1 {
                        if  let dic = arrOFCategory?[i] {
                            let cat =  CategoryDocument.init(createdTime: dic["createdTime"] as? String ?? "", createdByName: dic["createdByName"] as? String ?? "", companyID: dic["companyID"] as? NSNumber ?? NSNumber.init(value: 0), categoryName: dic["categoryName"]  as? String ?? "", isActive: dic["isActive"] as? NSNumber ?? NSNumber.init(value: 0), lastModifiedBy: dic["lastModifiedBy"]as? NSNumber ?? NSNumber.init(value: 0), lastModified: dic["lastModified"] as? String ?? "", categoryID: dic["categoryID"] as? NSNumber ?? NSNumber.init(value: 0), createdBy: dic["createdBy"] as? NSNumber ?? NSNumber.init(value: 0), applicationID: dic["applicationID"] as? NSNumber ?? NSNumber.init(value: 0))
                            self.arrOfCategoryDocument.append(cat)
                            
                        }
                    }
                }
                //  let dic1 = [String:Any]()
                self.arrOfCategoryDocument.insert(CategoryDocument.init(createdTime:  "", createdByName: "", companyID:  NSNumber.init(value: 0), categoryName: "Latest", isActive:  NSNumber.init(value: 0), lastModifiedBy:  NSNumber.init(value: 0), lastModified:  "", categoryID:  NSNumber.init(value: 0), createdBy:  NSNumber.init(value: 0), applicationID:  NSNumber.init(value: 0)), at: 0)
                
                //                var arrOfCategoryname = arrOFCategory.map {_ in
                //                    $0["categoryName"] as? String ?? ""
                //                }
                
            }else{
                self.arrOfCategoryDocument.insert(CategoryDocument.init(createdTime:  "", createdByName: "", companyID:  NSNumber.init(value: 0), categoryName: "Latest", isActive:  NSNumber.init(value: 0), lastModifiedBy:  NSNumber.init(value: 0), lastModified:  "", categoryID:  NSNumber.init(value: 0), createdBy:  NSNumber.init(value: 0), applicationID:  NSNumber.init(value: 0)), at: 0)
            }
            self.arrOFCategoryName =  self.arrOfCategoryDocument.map {
                $0.categoryName
            }
            self.tfDocumentType.text = self.arrOFCategoryName.first ?? ""
            self.getDocumentList(catId: NSNumber.init(value: 0))
        }
    }
    
    func getDocumentList(catId:NSNumber){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["CategoryID"] = catId
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetDocumentList, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            print(arr)
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                let arrOFDoc = arr as? [[String:Any]] ?? [[String:Any]]()
                if(arrOFDoc.count == 0){
                    self.view.makeToast(message)
                }
                self.arrOFDocument = [Document]()
                for doc in arrOFDoc{
                    let document =   Document.init(documentID: NSNumber.init(value: doc["documentID"] as? Int  ?? 0), companyID: NSNumber.init(value: doc["companyID"] as? Int  ?? 0), applicationID: NSNumber.init(value: doc["applicationID"] as? Int  ?? 0), categoryID: NSNumber.init(value: doc["categoryID"] as? Int  ?? 0), accessToAll: NSNumber.init(value: doc["accessToAll"] as? Int  ?? 0), isQuizAvailable: NSNumber.init(value: doc["isQuizAvailable"] as? Int  ?? 0), createdBy: NSNumber.init(value: doc["createdBy"] as? Int  ?? 0), lastModifiedBy: NSNumber.init(value: doc["lastModifiedBy"] as? Int  ?? 0), isActive: NSNumber.init(value: doc["isActive"] as? Int  ?? 0), userDocumentView: NSNumber.init(value: doc["userDocumentView"] as? Int  ?? 0), documentUrl: doc["documentUrl"] as? String ?? "", createdTime: doc["createdTime"] as? String ?? "", lastModified: doc["lastModified"] as? String ?? "", createdByName: doc["createdByName"] as? String ?? "", title: doc["title"] as? String ?? "", categoryName: doc["categoryName"] as? String ?? "")
                    self.arrOFDocument.append(document)
                }
                self.tblDocument.reloadData()
            }else{
                self.view.makeToast("No Documents found")
                print("document lsit = \(arr)")
            }
        }
    }
    
    
    
    func getQiuzResult(docId:NSNumber){
        var param = Common.returndefaultparameter()
        param["documentID"] = docId
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetQuizResult, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            if(error.code == 0){
                Common.showalert(msg: message, view: self)
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? message,view:self.view)
                // Common.showalert(msg: error.localizedDescription, view: self)
            }
        }
    }
    
    func getQuizStatus(docid:NSNumber,code:String){
        var param = Common.returndefaultparameter()
        var  param1 = [String:Any]()
        param1["documentID"] = docid
        param1["startQuiz"] = NSNumber.init(value: 1)
        param["QuizStartJSON"] = Common.returnjsonstring(dic: param1)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlQuizStartStatus, method: Apicallmethod.post){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            if(error.code == 0){
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    print(arr)
                    let dic = arr as? [String:Any]
                    if let objqiz = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameKnowledgeCenter, classname: Constant.QuizView) as?  QuizView{
                        objqiz.docID = docid
                        objqiz.code = dic?["code"] as? String ?? ""
                        self.navigationController?.pushViewController(objqiz, animated: true)
                    }
                }
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? message,view:self.view)
            }
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
extension KnowledgeCenter:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.strTitle = "Select Document Category"
        self.popup?.isFromSalesOrder =  false
        self.popup?.nonmandatorydelegate = self
        self.popup?.parentViewOfPopup = self.contentView
        self.popup?.arrOfCustomerClass = arrOFCategoryName//self.arrOfExpense
        self.popup?.arrOfSelectedClass = [String]()///self.arrOfselectedExpense
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
    }
}
extension KnowledgeCenter:PopUpDelegateNonMandatory{
    func completionSelectedClass(arr: [String], recordno: Int , strTitle:String) {
        var strselectedexpense = ""
        if let string = arr.first{
            strselectedexpense =  string
        }
        self.tfDocumentType.text = strselectedexpense
        let selectedExpense = arrOfCategoryDocument[recordno]
        self.getDocumentList(catId: selectedExpense.categoryID)
    }
}
extension KnowledgeCenter:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOFDocument.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selecteddocument = self.arrOFDocument[indexPath.row]
        if let quizcell = tableView.dequeueReusableCell(withIdentifier: "quizcell", for: indexPath) as? QuizCell{
            quizcell.selectionStyle = .none
            quizcell.quizdelegate = self
            quizcell.vwParent.setShadow()
            quizcell.lblDocumentName.text = selecteddocument.title
            quizcell.vwParent.addBorders(edges: UIRectEdge.all, color:
                                            UIColor.clear, cornerradius: 5)
            if(self.activeuser?.role?.id == NSNumber.init(value: 5)){
                quizcell.btnViewDocumentReport.isHidden = false
            }else{
                quizcell.btnViewDocumentReport.isHidden = true
            }
            if(selecteddocument.isQuizAvailable == NSNumber.init(value: 1)){
                quizcell.stkQuiz.isHidden = false
            }else{
                quizcell.stkQuiz.isHidden = true
            }
            quizcell.btnViewScore.backgroundColor = UIColor.orange
            quizcell.btnStartQuiz.backgroundColor = UIColor.purple
            quizcell.btnStartQuiz.setTitleColor(UIColor.white, for: UIControl.State.normal)
            quizcell.btnViewScore.setTitleColor(UIColor.white, for: UIControl.State.normal)
            quizcell.btnStartQuiz.cornerRadius =  5.0
            quizcell.btnViewScore.cornerRadius =  5.0
            quizcell.lblTime.text = Utils.getDatestringWithGMT(gmtDateString: selecteddocument.createdTime, format: "dd-MM-yyyy hh:mm a")
            
            return quizcell
        }else{
            return UITableViewCell()
        }
    }
    func listFilesFromDocumentsFolder(caseId : String) -> [String]?
    {
        let fileMngr =  FileManager.default;
        var docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        docs = docs + "/SuperSales/Document"
        return try? fileMngr.contentsOfDirectory(atPath:docs)
    }
    
}
extension KnowledgeCenter:QuizCellDelegate{
    func viewDocumentClicked(cell: QuizCell) {
        // view document
        if let indexPath = tblDocument.indexPath(for: cell) as? IndexPath{
            let selectedDocument =  self.arrOFDocument[indexPath.row]
            //(contentsOf: "/SuperSales/Document")
            /*    var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as? String
             
             let  datapath  = documentsPath?.appending("/SuperSales/Document") ?? ""//(contentsOf: "/SuperSales/Document")
             
             if(!FileManager.default.fileExists(atPath: datapath ?? "")){
             do
             {
             try FileManager.default.createDirectory(atPath: datapath ?? "", withIntermediateDirectories: true, attributes:nil)
             
             
             
             }catch{
             print("get some error \(error.localizedDescription)")
             }
             
             }
             let tempname =  String.init(format: "\(datapath)/\(selectedDocument.documentUrl)")*/
            let audioUrl = URL(string: selectedDocument.documentUrl)
            
            var documentsDirectoryURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            documentsDirectoryURL =   documentsDirectoryURL.appendingPathComponent("SuperSales/Document")
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl?.lastPathComponent ?? "")
            print(destinationUrl)
            // Get the directory contents urls (including subfolders urls)
            do{
                //try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil)
                print("list of files = \(directoryContents)")
            }catch(let errorinfilelistget){
                print("error in getting list = \(errorinfilelistget)")
            }

            print("destination url = \(destinationUrl)")
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.absoluteString.replacingOccurrences(of: "file://", with: "")) {
                do{
                    SVProgressHUD.show()
                    let filesize =  try FileManager.default.attributesOfItem(atPath:  destinationUrl.absoluteString.replacingOccurrences(of: "file://", with: ""))
                    print("file size = \(filesize)")
//                    if(filesize as? Int ?? 0 < 2048){
//                        SVProgressHUD.dismiss()
//                        Utils.toastmsg(message: "Can not open the file", view: self.view)
//                    }else{
                        let obj = UIDocumentInteractionController.init(url: destinationUrl)
                        // self.closePopUp()
                        obj.delegate = self
                        obj.presentPreview(animated: true)
                   // }
                }catch(let error){
                    SVProgressHUD.dismiss()
                    print("error of file \(error.localizedDescription) , for url = \(destinationUrl.absoluteURL)")
                }
               
                
                //          //  if(FileManager.default.fileExists(atPath: tempname)){
                //                do {
                //
                //
                //                    if  let   file =  try FileManager.default.attributesOfItem(atPath: tempname) as? [String:Any] {
                ////                            if(file ){
                ////                                self.view.makeToast("Album doesn't support this type file")
                ////                            }else{
                ////
                ////                            }
                //                    }
                //                   //
                //                }catch{
                //
                //                }
                
                
                
                
            }else{
                var param = Common.returndefaultparameter()
                var param1 = [String:Any]()
                param1["documentID"] = selectedDocument.documentID
                param["documentViewJson"] = Common.json(from: param1)
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddDocumentViewStatus, method: Apicallmethod.post){
                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                    in
                    if(error.code == 0){
                        SVProgressHUD.dismiss()
                        if  let objDownload  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameKnowledgeCenter, classname: Constant.DownloadController) as? DownloadController{
                            objDownload.fileUrl = selectedDocument.documentUrl
                            objDownload.destinationPath = destinationUrl.absoluteString
                            self.view.addSubview(objDownload.view)
                            objDownload.didMove(toParent: self)
                            //  self.navigationController?.pushViewController(objDownload, animated: true)
                        }
                    }else{
                        Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? message,view:self.view)
                        // Common.showalert(msg: error.localizedDescription, view: self)
                    }
                }
            }
        }
    }
    
    func startQuizClicked(cell: QuizCell) {
        // start quiz
        if let indexPath = tblDocument.indexPath(for: cell){
            let selectedDocument =  self.arrOFDocument[indexPath.row]
            self.getQuizStatus(docid: selectedDocument.documentID, code: "")
            
        }
        
    }
    
    func viewDocumentReportClicked(cell:QuizCell){
        if let objqiz = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameKnowledgeCenter, classname: Constant.DocumentReport) as?  DocumentReport{
            if let indexPath = tblDocument.indexPath(for: cell) as? IndexPath{
                let selectedDocument =  self.arrOFDocument[indexPath.row]
                objqiz.docID = selectedDocument.documentID
                objqiz.doctitle = selectedDocument.title as? String ?? ""
                self.navigationController?.pushViewController(objqiz, animated: true)
            }
        }
        
    }
    func viewScoreClicked(cell: QuizCell) {
        // view score
        if let indexPath = tblDocument.indexPath(for: cell) as? IndexPath{
            let selectedDocument =  self.arrOFDocument[indexPath.row]
            self.getQiuzResult(docId: selectedDocument.documentID)
        }
        
    }
    
    
}
extension KnowledgeCenter:UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        SVProgressHUD.dismiss()
        print("preview should begin")
    }
    
}
