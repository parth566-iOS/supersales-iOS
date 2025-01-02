//
//  AddExpenseViewController.swift
//  SuperSales
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddExpenseViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vwFromDate: UIView!
    
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var vwFromLocation: UIView!
    
    @IBOutlet weak var tfFromLocation: UITextField!
    @IBOutlet weak var vwToDate: UIView!
    
    @IBOutlet weak var tfToDate: UITextField!
    @IBOutlet weak var vwToLocation: UIView!
    
    @IBOutlet weak var tfToLocation: UITextField!
    @IBOutlet weak var vwCustomer: UIView!
    
    @IBOutlet weak var tfCustomer: UITextField!
    @IBOutlet weak var vwAddExpense: UIView!
    
    @IBOutlet weak var btnAddExpnse: UIButton!
    
    @IBOutlet weak var tblExpense: UITableView!
    
    
    @IBOutlet weak var cnstTableExpenseHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblRequestedExpense: UILabel!
    
    @IBOutlet weak var lblApprovedExpense: UILabel!
    
    @IBOutlet weak var tfRequestedComment: UITextField!
    
    @IBOutlet weak var tfApproverComment: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBOutlet weak var btnSubmit2: UIButton!
    @IBOutlet weak var stkAddExpense: UIStackView!
    
    
    
    
    // MARK: - Variable
    var fromNotification:Bool!
    var arrexpense = [Any]()
    var arrOFExpense:[Expense] = [Expense]()
    var isExpenseDrawn:Bool!
    var iseditExpense:Bool!
    var editableExpense:UserExpense!
    var startDate:Date!
    var endDate:Date!
    var startDatedatepicker:UIDatePicker!
    var endDatePicker:UIDatePicker!
    var popup:CustomerSelection? = nil
    var arrOfExpenseType = [String]()
    var arrOfSelectedSingleCustomer = [CustomerDetails]()
    var arrOfCustomers = [CustomerDetails]()
    var arrOffilteredCustomer = [CustomerDetails]()
    var arrAllCustomer:[NSString] = [NSString]()
    var filteredCustomer:[NSString] = [NSString]()
    var selectedCustomer:CustomerDetails?
    var selectedIndexPath:IndexPath!
    // MARK: -  View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
      
    }
    // MARK: - Method
    func setUI(){
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = "Expense"
        btnAddExpnse.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        btnAddExpnse.titleRect(forContentRect: CGRect.init(x: 10, y: 0, width: btnAddExpnse.frame.size.width, height: btnAddExpnse.frame.size.height))
        vwFromDate.setShadow()
        vwFromLocation.setShadow()
        vwToDate.setShadow()
        vwToLocation.setShadow()
        vwCustomer.setShadow()
        vwAddExpense.setShadow()
        tfRequestedComment.setBottomBorder(tf: tfRequestedComment, color: UIColor.black)
        self.btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        self.btnSubmit.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.btnSubmit2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.btnSubmit2.translatesAutoresizingMaskIntoConstraints = false
        self.btnSubmit2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if(iseditExpense){
            self.btnSubmit.setbtnFor(title:"UPDATE", type: Constant.kPositive)
            
            
        }else{
        self.btnSubmit.setbtnFor(title:"SUBMIT", type: Constant.kPositive)
        }
        tfApproverComment.setBottomBorder(tf: tfApproverComment, color: UIColor.black)
        
        //set background color
        tfFromDate.backgroundColor = UIColor.AppthemeAqvacolor
        tfToDate.backgroundColor = UIColor.AppthemeAqvacolor
        tfToLocation.backgroundColor = UIColor.AppthemeAqvacolor
        tfFromLocation.backgroundColor = UIColor.AppthemeAqvacolor
        tfFromDate.backgroundColor = UIColor.AppthemeAqvacolor
        tfCustomer.backgroundColor = UIColor.AppthemeAqvacolor
        
        
        tfFromDate.setCommonFeature()
        tfToDate.setCommonFeature()
        tfToLocation.setCommonFeature()
        tfFromLocation.setCommonFeature()
        tfFromDate.setCommonFeature()
        tfCustomer.setCommonFeature()

        tfFromDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        tfToDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        tfFromLocation.setrightImage(img: UIImage.init(named: "icon_location")!)
        tfToLocation.setrightImage(img: UIImage.init(named: "icon_location")!)
        tfCustomer.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfCustomer.placeholder = "Select Customer"
        tblExpense.delegate = self
        tblExpense.dataSource = self
        if(self.activesetting.customerInExpense == NSNumber.init(value: 1)){
            vwCustomer.isHidden = true
        }else{
            vwCustomer.isHidden = false
           
        }
        
        DispatchQueue.main.async{
            self.tblExpense.rowHeight = UITableView.automaticDimension;
            self.tblExpense.estimatedRowHeight = 410.0;
                self.tblExpense.layoutIfNeeded()
                self.tblExpense.reloadData()
                self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
           
       
        }
        self.getExpenseType()
        //  tblExpense. = self
        startDatedatepicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        //tfStartDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        arrOfCustomers = CustomerDetails.getAllCustomers()
        arrAllCustomer = arrOfCustomers.map{ $0.name } as [NSString]? ?? [NSString]()
        startDatedatepicker.setCommonFeature()
        endDatePicker.setCommonFeature()
        if(iseditExpense){
            
            self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
            let datestart = self.dateFormatter.date(from: editableExpense.startDate)
            let dateend =  self.dateFormatter.date(from: editableExpense.endDate)
            //2021/07/07 00:00:00
            self.dateFormatter.dateFormat = "dd/MM/yyyy"
            startDate = datestart
            endDate = dateend
            if let customer = CustomerDetails.getCustomerByID(cid: editableExpense.customerID){
                tfCustomer.text = customer.name
                selectedCustomer = customer
            }else{
                tfCustomer.text = editableExpense.customerName
            }
            tfToDate.text = self.dateFormatter.string(from: dateend ?? Date())
            tfFromDate.text = self.dateFormatter.string(from: datestart ?? Date())
            tfFromLocation.text = self.editableExpense.fromLocation
            tfToLocation.text = self.editableExpense.toLocation
            tfRequestedComment.text = self.editableExpense.requesterComment
            
            btnSubmit.setTitle("UPDATE", for: UIControl.State.normal)
            self.arrOFExpense = self.editableExpense.expenseDetailsList
            self.tblExpense.reloadData()
            print(editableExpense.status)
            if((editableExpense.status.lowercased() != "pending") && (editableExpense.status.lowercased() != "level1accept")){
                btnSubmit.isHidden = true
                btnSubmit2.isHidden = true
                tfApproverComment.isHidden = true
                self.setInteractionEnable(status: false)
            }else{
                tfApproverComment.isHidden = false
               
              
                btnSubmit2.backgroundColor = UIColor.red
                if(editableExpense.user.userID == self.activeuser?.userID){
                    btnSubmit2.isHidden = true
                    self.setrightbtn(btnType: BtnRight.edit, navigationItem: self.navigationItem)
                    self.salesPlandelegateObject = self
                    btnSubmit.setTitle("UPDATE", for: UIControl.State.normal)
                    tfApproverComment.isHidden = true
                    self.setInteractionEnable(status: true)
                }else{
                    btnSubmit.setTitle("Accept", for: UIControl.State.normal)
                    btnSubmit.setTitle("Accept", for: UIControl.State.selected)
                    btnSubmit2.setTitle("Reject", for: UIControl.State.normal)
                    btnSubmit2.setTitle("Reject", for: UIControl.State.selected)
                    tfApproverComment.isHidden = false
                btnSubmit.isHidden = false
                btnSubmit2.isHidden = false
                    self.setInteractionEnable(status: false)
                }
                
            }
            lblRequestedExpense.text =  String.init(format:"%.2f",editableExpense.totalExpenseRequested.doubleValue)
            lblApprovedExpense.text = String.init(format:"%.2f",editableExpense.totalExpenseApproved?.doubleValue ?? 0.00)
            if let approvedby = editableExpense.approvedBy.userID?.intValue as? Int  {
                if(approvedby > 0){
                    lblApprovedExpense.text = editableExpense.totalExpenseApproved?.stringValue ?? "0"
                }else{
                    lblApprovedExpense.text =  "0.0"
                }
            }else{
                lblApprovedExpense.text =  "0.0"
            }
            self.tfRequestedComment.text = editableExpense.requesterComment
        }else{
            self.tfApproverComment.isHidden = true
            self.btnSubmit2.isHidden = true
            self.btnSubmit.isHidden = false
            if(arrOFExpense.count == 0){
         //   arrOFExpense.append(Expense().initwithdic(dict: ["amountApproved":NSNumber.init(value:0),"amountRequested":NSNumber.init(value:0),"billAttachmentPath":"","billNo":"","expenseType":arrexpense.first ?? ""]))//,"userID":self.activeuser?.userID
            }
           
            startDatedatepicker.maximumDate = Date()
            endDatePicker.maximumDate = Date()
            
            
            startDatedatepicker.date = Date()
            endDatePicker.date = Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            
            startDate = Date()
            endDate = Date()
            tfFromDate.text =  Utils.getDateWithAppendingDay(day: 0, date: startDatedatepicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)//dateFormatter.string(from: startDate)
            tfToDate.text = Utils.getDateWithAppendingDay(day: 0, date: endDatePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
            lblApprovedExpense.text = "0.0"
            lblRequestedExpense.text = "0.0"
            
            tblExpense.reloadData()
        }
        tfToDate.delegate = self
        tfFromDate.delegate = self
        tfFromLocation.delegate = self
        tfToLocation.delegate = self
        tfCustomer.delegate = self
        tfFromDate.inputView = startDatedatepicker
        tfToDate.inputView = endDatePicker
        tblExpense.isScrollEnabled = false
        tblExpense.layoutIfNeeded()
        cnstTableExpenseHeight.constant = tblExpense.contentSize.height
    }
    
    func setInteractionEnable(status:Bool){
        tfFromDate.isUserInteractionEnabled = status
        tfToDate.isUserInteractionEnabled = status
        tfFromLocation.isUserInteractionEnabled = status
        tfToLocation.isUserInteractionEnabled = status
        tfCustomer.isUserInteractionEnabled = status
        tfRequestedComment.isUserInteractionEnabled = status
      //  tblExpense.isUserInteractionEnabled = status
        tfApproverComment.isUserInteractionEnabled != status
        btnAddExpnse.isUserInteractionEnabled = status
        tblExpense.reloadData()
    }
    
    // MARK: - API Call
    func getExpenseType(){
        //  kWSUrlGetExpenseType
        arrOFExpense = [Expense]()
        let param = Common.returndefaultparameter()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetExpenseType, method: Apicallmethod.get){ [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
               print(responseType)
                let arrOfExpense = arr as? [String:Any] ?? [String:Any]()
                
                arrexpense = arrOfExpense["expenseTypes"] as? [Any] ?? [Any]()
                self.arrOfExpenseType = arrexpense.map{
                    $0 as! String
                }
                if(!iseditExpense){
                arrOFExpense = [Expense]()
                }
                if(arrOfExpense.count > 0 && arrOFExpense.count == 0){
                    /*
                     @"amountApproved": @"0.00",@"amountRequested":@"0.00",@"billAttachmentPath":@"",@"billNo":@"",@"expenseType":arrExepenseType[0]
                     **/
                    arrOFExpense.append(Expense().initwithdic(dict: ["amountApproved":NSNumber.init(value:0),"amountRequested":NSNumber.init(value:0),"billAttachmentPath":"","billNo":"","expenseType":arrexpense.first ?? ""]))//,"userID":self.activeuser?.userID ?? NSNumber.init(value: 0)DocumentReportModel(dictionary: doc as NSDictionary)
//                    let doc = ["amountApproved":NSNumber.init(value:0),"amountRequested":NSNumber.init(value:0),"billAttachmentPath":"","billNo":"","expenseType":arrexpense.first ?? ""]
//                    arrOFExpense.append(Expense(dictionary: doc as NSDictionary))
                    tblExpense.reloadData()
                }
                tblExpense.reloadData()
              
              
            }else if(error.code == 0){
             
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
             
            }
        }
    }
    
    
    
    func uploadImage(img:UIImage){
        SVProgressHUD.show()
        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadAttachment, img: img, imgparamname: "File", param: Common.returndefaultparameter()) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status == Constant.SucessResponseFromServer){
             
                if let imagepath = arr as? String{
                    let selectedexpense = self.arrOFExpense[selectedIndexPath.row]
                    selectedexpense.billAttachmentPath = imagepath
                    self.arrOFExpense.remove(at: selectedIndexPath.row)
                    print("attachemnt path = \(selectedexpense.billAttachmentPath)")
                    self.arrOFExpense.insert(selectedexpense, at: selectedIndexPath.row)
                    self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
                    DispatchQueue.main.async {
                        self.tblExpense.reloadData()
                        self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
                    }
                   
                }
            }else{
                if(message.count > 0){
                    print(responseType)
                    print(arr)
                    Utils.toastmsg(message:message,view: self.view)
                    if let imagepath = arr as? String{
                        let selectedexpense = self.arrOFExpense[selectedIndexPath.row]
                        selectedexpense.billAttachmentPath = imagepath
                        
                        self.arrOFExpense.remove(at: selectedIndexPath.row)
                        print("attachemnt path = \(selectedexpense.billAttachmentPath), \(selectedIndexPath.row)")
                        self.arrOFExpense.insert(selectedexpense, at: selectedIndexPath.row)
                     
                      //  DispatchQueue.main.async {
                            self.tblExpense.reloadData()
                            self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
                     //   }
                      
                    }
                }else if error.localizedDescription.count > 0{
                    Utils.toastmsg(message:error.localizedDescription,view: self.view)
                   
                }else{
                    Utils.toastmsg(message:"Something went wrong,Please try again",view: self.view)
                  
                }
                    
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
    
    
    //MARK: - IBAction
    
    
    @IBAction func btnAddExpenseClicked(_ sender: UIButton) {
        /*
         if (aryExpenseHead.count > 0) {
             [tblView beginUpdates];
             [aryExpenseHead addObject:[[ExpenseDetails alloc] initWithDictionary:@{@"amountApproved": @"0.00",@"amountRequested":@"0.00",@"billAttachmentPath":@"",@"billNo":@"",@"expenseType":arrExepenseType[0]}]];
             [tblView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:aryExpenseHead.count-1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];  //or a rowAnimation of your choice
             [tblView endUpdates];
         }
         **/
        if(arrOFExpense.count > 0){
            tblExpense.beginUpdates()
            
           arrOFExpense.append(Expense().initwithdic(dict: ["amountApproved":NSNumber.init(value:0),"amountRequested":NSNumber.init(value:0),"billAttachmentPath":"","billNo":"","expenseType":arrexpense.first ?? ""]))//,"userID":self.activeuser?.userID ?? NSNumber.init(value:0),
            tblExpense.insertRows(at: [IndexPath.init(row: arrOFExpense.count - 1, section: 0)], with: UITableView.RowAnimation.bottom)
            tblExpense.endUpdates()
       
            self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
//            DispatchQueue.main.async {
//                self.tblExpense.layoutIfNeeded()
//                self.tblExpense.reloadData()
//                self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
//                print("no. of expense = \(self.arrOFExpense.count) and constant height of table = \(self.cnstTableExpenseHeight.constant)")
//            }
        }
      //  tblExpense.reloadData()
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        var arrOfExpense = [[String:Any]]()
  
            
            for expense in arrOFExpense{
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let bildate =  dateFormatter.date(from: expense.bilDate)
              //  let strbildate = Utils.getstringFromOneFormatToOther(fFormat: 0, stringindate: bildate, sFormat: <#T##String#>)
                if(iseditExpense){
                    arrOfExpense.append(["id":expense.iD,"billAttachmentPath":expense.billAttachmentPath ?? "","amountRequested":expense.amountRequested ??  "0.0" ,"expenseType": expense.expenseType ?? "Demo Expenses" ,"billDate": String.init(format:"\(Utils.getDateWithAppendingDay(day: 0, date: bildate ?? Date(), format: "yyyy/MM/dd", defaultTimeZone: true)) 00:00:00") ?? "","billNo":expense.billNo ?? "","remarks": expense.remark,"amountApproved":expense.amountApproved])//,"amountApproved":expense.amountApproved
                    
                }else{
                    arrOfExpense.append(["billAttachmentPath":expense.billAttachmentPath ?? "","amountRequested":expense.amountRequested ??  "0.0" ,"expenseType": expense.expenseType ?? "Demo Expenses" ,"billDate": String.init(format:"\(Utils.getDateWithAppendingDay(day: 0, date: bildate ?? Date(), format: "yyyy/MM/dd", defaultTimeZone: true)) 00:00:00") ?? "","billNo":expense.billNo ?? "","remarks": expense.remark,"amountApproved":expense.amountApproved])//
                }
            }
    if(sender.currentTitle?.lowercased() == "submit" || sender.currentTitle?.lowercased() == "update"){
        
    if(startDate.compare(endDate) == .orderedDescending){
       // Utils.toastmsg(message:"Something went wrong,Please try again",view: self.view)
        Utils.toastmsg(message:"You can't select start date after and date",view: self.view)
        return
    }
    for cell in tblExpense.visibleCells{
        let expcell = cell as? AddExpenseCellTableViewCell
        let requestedamount = expcell?.tfRequestedAmount.text?.toDouble() //Double(expcell?.tfRequestedAmount.text ?? "0.0") ?? 0
        if(requestedamount == 0){
            Utils.toastmsg(message:"Please enter requested amount",view: self.view)
            return
        }
    }
        SVProgressHUD.show()
   
    
    var param = Common.returndefaultparameter()
    var param1 = [String:Any]()
        var url = ""
            if(sender.currentTitle?.lowercased() == "submit"){
                url = ConstantURL.kWSUrlAddExpense
            }else{
                param1["expenseId"] = editableExpense.expenseId
                url = ConstantURL.kWSUrlUpdateExpense
            }
    param1["CustomerID"] =  selectedCustomer?.iD ?? 0
    param1["requesterComment"] = tfRequestedComment.text
    param1["startDate"] = String.init(format:"\(Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true)) 00:00:00")
    param1["endDate"] = String.init(format:"\(Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true)) 00:00:00")
    param1["fromLocation"] = tfFromLocation.text
    param1["toLocation"] = tfToLocation.text
        param1["totalExpenseRequested"] = lblRequestedExpense.text
    param1["expenseDetailsList"] = arrOfExpense
        param1["amountApproved"] = lblApprovedExpense.text
        param["ExpenseApproval"] =  self.activesetting.expenseApproval

    param["ExpenseJSON"] =  Common.returnjsonstring(dic: param1)
      print("parameter of add expense = \(param)")
   
    self.apihelper.getdeletejoinvisit(param: param, strurl: url, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
        if(status.lowercased() == Constant.SucessResponseFromServer){
            if ( message.count > 0 ) {
                 Utils.toastmsg(message:message,view: self.view)
            }
            self.navigationController?.popViewController(animated: true)
        }else if(error.code == 0){
            self.dismiss(animated: true, completion: nil)
            if ( message.count > 0 ) {
                 Utils.toastmsg(message:message,view: self.view)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
            Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
        }
    }
    
}
    else{
        
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
           var arrOFExpenseWithzeroamount = 0
            for cell in self.tblExpense.visibleCells{
                let expcell = cell as? AddExpenseCellTableViewCell
                if(expcell?.tfAmmountApproved.text?.count == 0){
                    arrOFExpenseWithzeroamount += 1
                }
            }
//            let arrOFExpenseWithzeroamount = self.arrOFExpense.filter{
//                $0.amountApproved.stringValue == ""
//            }
            if(arrOFExpenseWithzeroamount == self.arrOFExpense.count){
                Utils.toastmsg(message: "Please enter approved Amount", view: self.view)
                return
            }
    //accept or reject
        let userexpense = self.editableExpense//self.arrExpense[indexpath.row]
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
//        if(userexpense.status == "Pending"){
        var param = Common.returndefaultparameter()
            var param1 = [String:Any]()
            param1["startDate"] = userexpense?.startDate
            param1["endDate"] = userexpense?.endDate
            param1["totalExpenseRequested"] = userexpense?.totalExpenseRequested
            param1["fromLocation"] = userexpense?.fromLocation
            param1["toLocation"] =  userexpense?.toLocation
            param1["requesterComment"] = userexpense?.requesterComment
            param1["approverComment"] = self.tfApproverComment.text//userexpense?.approverComment
            param1["expenseId"] = userexpense?.expenseId
       
       param["TransactionID"] = userexpense?.transactionID

        param["isApproved"] = true
//
//        param1["ExpenseID"] = userexpense?.expenseId
       
        param1["expenseDetailsList"] = arrOfExpense//Common.json(from: arrOfExpense)
            param["ExpenseJSON"] = Common.json(from: param1)
            /*
             
             {"startDate":"2022\/02\/16 00:00:00","endDate":"2022\/02\/16 00:00:00","expenseDetailsList":[{"id":"21017","expenseType":"Mobile","amountRequested":"100","amountApproved":"50","billNo":"","billAttachmentPath":"","remarks":null,"billDate":"1970\/01\/01 00:00:00"},{"id":"21018","expenseType":"Internet","amountRequested":"200","amountApproved":"100","billNo":"","billAttachmentPath":"","remarks":null,"billDate":"1970\/01\/01 00:00:00"},{"id":"21019","expenseType":"Food","amountRequested":"300","amountApproved":"150","billNo":"","billAttachmentPath":"","remarks":null,"billDate":"1970\/01\/01 00:00:00"}],"totalExpenseRequested":600,"fromLocation":"","toLocation":"","requesterComment":"jgjh","approverComment":"I am approving Half Amount for every Expense Type","expenseId":"13137"
             
             **/
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveRejectExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
//                self.arrExpense.remove(at: indexpath.row)
////                if(isaccept){
//                userexpense.status = "Aceept"
////                }else{
////                    userexpense.status = "Reject"
////                }
//                self.loadData()
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                 
                }
                self.navigationController?.popViewController(animated: true)
            }else if(error.code == 0){
                self.dismiss(animated: true, completion: nil)
                         if ( message.count > 0 ) {
                            Utils.toastmsg(message:message,view: self.view)
                }
                     }else{
                self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                     }
        }
    }
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        Common.showalert(title: "SuperSales", msg: "Are you sure you want to accept this expense request for requested amount?", yesAction: yesAction, noAction: noAction, view: self)
        //Common.showalert(msg: "Are you sure you want to accept this expense request for requested amount?", view: self)
    }
    }
    
    @IBAction func btnSubmit2Clicked(_ sender: UIButton) {
        var arrOfExpense = [[String:Any]]()
        for expense in arrOFExpense{
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let bildate =  dateFormatter.date(from: expense.bilDate)
          //  let strbildate = Utils.getstringFromOneFormatToOther(fFormat: 0, stringindate: bildate, sFormat: <#T##String#>)
            if(iseditExpense){
                arrOfExpense.append(["id":expense.iD,"billAttachmentPath":expense.billAttachmentPath ?? "","amountRequested":expense.amountRequested ??  "0" ,"expenseType": expense.expenseType ?? "Demo Expenses" ,"billDate": String.init(format:"\(Utils.getDateWithAppendingDay(day: 0, date: bildate ?? Date(), format: "yyyy/MM/dd", defaultTimeZone: true)) 00:00:00") ?? "","billNo":expense.billNo ?? "","remarks": expense.remark,"amountApproved":expense.amountApproved ?? 0 ])//,"amountApproved":expense.amountApproved
                
            }else{
                arrOfExpense.append(["billAttachmentPath":expense.billAttachmentPath ?? "","amountRequested":expense.amountRequested ??  "0" ,"expenseType": expense.expenseType ?? "Demo Expenses" ,"billDate": String.init(format:"\(Utils.getDateWithAppendingDay(day: 0, date: bildate ?? Date(), format: "yyyy/MM/dd", defaultTimeZone: true)) 00:00:00") ?? "","billNo":expense.billNo ?? "","remarks": expense.remark,"amountApproved":expense.amountApproved ?? 0])//
            }
        }
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
            
    
            let userexpense = self.editableExpense//self.arrExpense[indexpath.row]
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var param1 = [String:Any]()
           
            param1["startDate"] = userexpense?.startDate
            param1["endDate"] = userexpense?.endDate
            param1["totalExpenseRequested"] = userexpense?.totalExpenseRequested
            param1["fromLocation"] = userexpense?.fromLocation
            param1["toLocation"] =  userexpense?.toLocation
            param1["requesterComment"] = userexpense?.requesterComment
            param1["approverComment"] = self.tfApproverComment.text//userexpense?.approverComment
            param1["expenseId"] = userexpense?.expenseId
       
       param["TransactionID"] = userexpense?.transactionID
            param["isApproved"] = false
         //   param1["ExpenseID"] = userexpense?.expenseId
            //var param1 = [String:Any]()
        param1["expenseDetailsList"] = arrOfExpense//Common.json(from: arrOfExpense)
        param["ExpenseJSON"] = Common.json(from: param1)
           // param["expenseDetailsList"] = Common.json(from: arrOfExpense)
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveRejectExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    
//                    self.arrExpense.remove(at: indexpath.row)
//                    userexpense.status = "Reject"
//
//                    self.loadData()
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                  
                }
                    self.navigationController?.popViewController(animated: true)
                }else if(error.code == 0){
                    self.dismiss(animated: true, completion: nil)
                             if ( message.count > 0 ) {
                
                                Utils.toastmsg(message:message,view: self.view)
                }
                         }else{
                    self.dismiss(animated: true, completion: nil)
                            Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view: self.view)
                           
                         }
            }
            }
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        Common.showalert(title: "Supersales", msg: "Are you sure want to reject this expense request?", yesAction: yesAction , noAction: noAction, view: self)
        
    }
}
extension AddExpenseViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfFromDate){
            startDatedatepicker.date = startDate
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            startDatedatepicker.datePickerMode = .date
            startDatedatepicker.date = self.dateFormatter.date(from: tfFromDate.text!)!
            if(iseditExpense  == true && self.activeuser?.userID != editableExpense.user.userID){
                return false
            }else{
            return true
            }
        }else if(textField == tfToDate){
            endDatePicker.date = endDate
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            endDatePicker.datePickerMode = .date
            endDatePicker.date = self.dateFormatter.date(from: tfToDate.text!)!
            
            if(iseditExpense  == true && self.activeuser?.userID != editableExpense.user.userID){
                return false
            }else{
                return true
            }
        }else if(textField ==  tfCustomer){
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = ""
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.parentViewOfPopup = self.view
            self.popup?.arrOfList = self.arrOfCustomers
            self.popup?.arrOfSelectedSingleCustomer = self.arrOfSelectedSingleCustomer
            self.popup?.strLeftTitle = "REFRESH"
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = true
            self.popup?.viewfor = ViewFor.customer
            
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            if(iseditExpense  == true && self.activeuser?.userID != editableExpense.user.userID){
                return false
            }else{
            self.present(self.popup!, animated: false, completion: nil)
            }
            return false
            
        }else if(textField == tfRequestedComment){
            if(iseditExpense  == true && self.activeuser?.userID != editableExpense.user.userID){
                return false
            }else{
            return true
            }
        }else {
            return true
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        if(textField == tfFromDate){
            startDatedatepicker.date =  dateFormatter.date(from: tfFromDate.text ?? "") ?? Date()
            //datepicker.reloadInputViews()
        }else if(textField == tfToDate){
            endDatePicker.date = dateFormatter.date(from: tfToDate.text ?? "") ?? Date()
            // datepicker.reloadInputViews()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfFromDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            startDate = startDatedatepicker.date
            tfFromDate.text = dateFormatter.string(from: startDatedatepicker.date)
            
        }else if(textField == tfToDate){
            //
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            endDate = endDatePicker.date
            tfToDate.text =  dateFormatter.string(from: endDatePicker.date)
            
            //
        }
    }
    
}
extension AddExpenseViewController:PopUpDelegateNonMandatory{
    
    
    
    func completionData(arr: [CustomerDetails]) {
        arrOfSelectedSingleCustomer = arr
        if let  selectedCustomer1 = arrOfSelectedSingleCustomer.first{
            tfCustomer.text = selectedCustomer1.name
            selectedCustomer = selectedCustomer1
        }
    }
    
    
    
    
}
extension AddExpenseViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("no of expense = \(arrOFExpense.count)")
        return  arrOFExpense.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "addexpensecell", for: indexPath) as? AddExpenseCellTableViewCell{
            if(indexPath.row == 0){
                cell.btnDelete.isHidden = true
            }
            cell.selectionStyle = .none
            cell.expensedelegate = self
            cell.arrOfExpense = arrOfExpenseType
            cell.tfExpenseType.text = arrOfExpenseType.first ?? "Demo Expenses"
            cell.vwExpense.setShadow()
            cell.tfBillNumber.setBottomBorder(tf: cell.tfBillNumber, color: UIColor.black)
            cell.tfAmmountApproved.setBottomBorder(tf: cell.tfAmmountApproved, color: UIColor.black)
            cell.tfBillDate.setBottomBorder(tf: cell.tfBillDate, color: UIColor.black)
            cell.tfRequestedAmount.setBottomBorder(tf: cell.tfRequestedAmount, color: UIColor.black)
            cell.tfRemark.setBottomBorder(tf: cell.tfRemark , color: UIColor.black)
            cell.tfExpenseType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
            cell.tfBillDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
            let selectedexpense = arrOFExpense[indexPath.row]
       
            if(iseditExpense && editableExpense.status.lowercased() != "pending"){
            
               
                cell.tfAmmountApproved.isHidden = false
            }else{
                if(iseditExpense){
                if(editableExpense.user.userID == self.activeuser?.userID){
                    
                    cell.tfAmmountApproved.isHidden = true
                    cell.tfAmmountApproved.isUserInteractionEnabled = true
                    cell.tfRemark.isUserInteractionEnabled = true
                    cell.tfBillDate.isUserInteractionEnabled = true
                    cell.tfBillNumber.isUserInteractionEnabled = true
                    cell.vwExpense.isUserInteractionEnabled = true
                    cell.tfRequestedAmount.isUserInteractionEnabled = true
                    cell.btnDelete.isUserInteractionEnabled = true
                    cell.btnAttachment.isUserInteractionEnabled = true
                    cell.btnClearAttachment.isUserInteractionEnabled = true
                    cell.btnDeleteAttachment.isUserInteractionEnabled = true
                    
                }else{
                    cell.tfAmmountApproved.isHidden = false
                    cell.tfAmmountApproved.isUserInteractionEnabled = true
                    
                    cell.tfRemark.isUserInteractionEnabled = false
                    cell.tfBillDate.isUserInteractionEnabled = false
                    cell.tfBillNumber.isUserInteractionEnabled = false
                    cell.vwExpense.isUserInteractionEnabled = false
                    cell.tfRequestedAmount.isUserInteractionEnabled = false
                    cell.btnDelete.isUserInteractionEnabled = false
                    cell.btnAttachment.isUserInteractionEnabled = false
                    cell.btnDeleteAttachment.isUserInteractionEnabled = false
                    cell.btnClearAttachment.isUserInteractionEnabled = true
                }
                }else{
                    cell.tfAmmountApproved.isHidden = true
                    cell.tfAmmountApproved.isUserInteractionEnabled = true
                }
            }
         
            print(
                "attachemnet path = \(selectedexpense.billAttachmentPath ?? "")")
            cell.setExpenseData(expense: selectedexpense)
            //cell.btnDelete.addTarget(self, action: #selector(deleteExpenseHead), for: UIControl.Event.touchUpInside)
           
            return cell
        }else{
           
            return UITableViewCell()
        }
    }
    
    
}
extension AddExpenseViewController:AddExpenseCellDelegate{
    
    func clearAttachmentInExpense(expenseCell: AddExpenseCellTableViewCell) {
        if let indexPath = tblExpense.indexPath(for: expenseCell) as? IndexPath{
            let selectedexpense = self.arrOFExpense[indexPath.row]
            if(selectedexpense.billAttachmentPath.count > 0){
//                let ato =  arrHistory[sender.tag]
                var photos:Array<IDMPhoto>? = Array()
                let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: selectedexpense.billAttachmentPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                         //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
                photo.caption = " "
                photos?.append(photo)
                let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: photos)
                browser.delegate = self
                browser.displayCounterLabel = true
                browser.displayActionButton = false
                browser.autoHideInterface = false
                browser.dismissOnTouch = false
                browser.displayArrowButton = false
                browser.displayActionButton = false
                browser.disableVerticalSwipe = true
                DispatchQueue.main.async {
                self.present(browser, animated: true, completion: nil)
            }
            }
        }}
  
    func addAttachmentInExpense(expenseCell: AddExpenseCellTableViewCell) {
        if(Utils.isReachable()){
        if let indexPath = tblExpense.indexPath(for: expenseCell) as? IndexPath{
            selectedIndexPath = indexPath
        }
            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            let cameraAction = UIAlertAction.init(title: "From Camera", style: UIAlertAction.Style.default) { (action) in
                if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera) as? Bool {
                    DispatchQueue.main.async {
                       let picker = UIImagePickerController()
                        picker.delegate = self
                        picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        picker.allowsEditing = false
                        picker.sourceType = UIImagePickerController.SourceType.camera
                        
                        self.present(picker, animated: true, completion: nil)
                    }
                }else{
                    Utils.toastmsg(message:"Camera is not present",view: self.view)
                }
            }
            let galaryAction = UIAlertAction.init(title: "From Gallery", style: UIAlertAction.Style.default) { (action) in
                if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) as? Bool {
                    DispatchQueue.main.async {
                       let picker = UIImagePickerController()
                        picker.delegate = self
                        picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        picker.allowsEditing = false
                        picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                        
                        self.present(picker, animated: true, completion: nil)
                    }
                }else{
                    Utils.toastmsg(message:"Camera is not present",view: self.view)
                }
            }
            Common.showalertWithAction(msg: "How you want to attach Document", arrAction: [cameraAction,galaryAction,cancelAction], view: self)
        
            
        }
        else{
            Utils.toastmsg(message:"you need interent to upload image",view: self.view)
        }
    }
    func deleteAttachmentInExpense(expenseCell: AddExpenseCellTableViewCell) {
        if let indexPath = tblExpense.indexPath(for: expenseCell) as? IndexPath{
            let selectedexpense = self.arrOFExpense[indexPath.row]
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in


                
                self.arrOFExpense.remove(at: indexPath.row)
                selectedexpense.billAttachmentPath = ""
                self.arrOFExpense.insert(selectedexpense, at: indexPath.row)
                
                DispatchQueue.main.async {
                    self.tblExpense.layoutIfNeeded()
                    self.tblExpense.reloadData()
                    self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
                }
                self.tblExpense.endUpdates()


            }
            if(selectedexpense.userID == self.activeuser?.userID){
                
            }else{
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
            }
            
        }
        
    }
    func deleteExpenseValue(expenseCell: AddExpenseCellTableViewCell) {
        if let indexPath = tblExpense.indexPath(for: expenseCell) as? IndexPath{
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in


                self.arrOFExpense.remove(at: indexPath.row)
               

                self.tblExpense.beginUpdates()
            
                self.tblExpense.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
                DispatchQueue.main.async {
                   // self.tblExpense.layoutIfNeeded()
                    self.tblExpense.reloadData()
                    self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
                }
                self.tblExpense.endUpdates()


            }
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
            
        }
    }
    
   
    func  updateExpenseRequestedAmountValue(expenseCell:AddExpenseCellTableViewCell){
        var totalexpense = 0.00
        for expense in arrOFExpense{
            
            totalexpense   += expense.amountRequested.doubleValue //Int(expenseCell.tfRequestedAmount.text ?? "0") ?? 0
            
        }
        lblRequestedExpense.text = String.init(format:"%.2f",totalexpense)
    }
    func  updateExpenseApprovedAmountValue(expenseCell:AddExpenseCellTableViewCell){
        var approvedexpense = 0.0
        for expense in arrOFExpense{
            
            approvedexpense += Double(expense.amountApproved.doubleValue) //Int(expenseCell.tfRequestedAmount.text ?? "0") ?? 0
            
        }
        lblApprovedExpense.text = String.init(format:"%.2f",approvedexpense)
    }
    func updateExpenseValue(expenseCell: AddExpenseCellTableViewCell) {
        if let indexPath = tblExpense.indexPath(for: expenseCell){
            let selectedexpense = arrOFExpense[indexPath.row]
            arrOFExpense.remove(at: indexPath.row)
            selectedexpense.expenseType = expenseCell.tfExpenseType.text
            if let strrequested = expenseCell.tfRequestedAmount.text{
                selectedexpense.amountRequested = NSNumber.init(value:strrequested.toDouble())
            }else{
                selectedexpense.amountRequested = NSNumber.init(value:0)
            }
            if let strapproved = expenseCell.tfAmmountApproved.text{
                selectedexpense.amountApproved = NSNumber.init(value:strapproved.toDouble())
            }else{
                selectedexpense.amountApproved = NSNumber.init(value:0)
            }
            selectedexpense.billAttachmentPath = expenseCell.btnClearAttachment.titleLabel?.text ?? ""
//           chment.currentTitle)
            selectedexpense.remark = expenseCell.tfRemark.text ?? ""
            selectedexpense.bilDate = expenseCell.tfBillDate.text ?? ""
            selectedexpense.billNo = expenseCell.tfBillNumber.text ?? ""
            
            arrOFExpense.insert(selectedexpense, at: indexPath.row)
            tblExpense.reloadData()
            self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
        }
        
    }
    
    
    
}
//extension UpdateLeadStatus :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
extension AddExpenseViewController:UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
            , completion:   nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            //upload image call api
            self.uploadImage(img: chosenImage)
        }
        picker.dismiss(animated: true
            , completion:nil)
    }
}
extension AddExpenseViewController:IDMPhotoBrowserDelegate{
    
}
extension AddExpenseViewController:BaseViewControllerDelegate{
    func editiconTapped(sender:UIBarButtonItem) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
            let userexpense = self.editableExpense//self.arrExpense[indexpath.row]
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
                var param = Common.returndefaultparameter()
            param["TransactionID"] = userexpense?.transactionID
                param["isApproved"] = false
            param["ExpenseID"] = userexpense?.expenseId
                //param["ExpenseJSON"] =
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlWithdrawExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        
    //                    self.arrExpense.remove(at: indexpath.row)
    //                    userexpense.status = "Reject"
    //
    //                    self.loadData()
                        if ( message.count > 0 ) {
                            Utils.toastmsg(message:message,view: self.view)
                      
                    }
                        self.navigationController?.popViewController(animated: true)
                    }else if(error.code == 0){
                        self.dismiss(animated: true, completion: nil)
                                 if ( message.count > 0 ) {
                    
                                    Utils.toastmsg(message:message,view: self.view)
                    }
                             }else{
                        self.dismiss(animated: true, completion: nil)
                                Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view: self.view)
                               
                             }
                }
            
        }
        Common.showalert(title: "SuperSales", msg: "Are you sure you want to Withdraw Expense?", yesAction: yesAction, noAction: noAction, view: self)
    }}
