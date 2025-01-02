//
//  ViewFeedback.swift
//  
//
//  Created by Apple on 14/02/20.
//

import UIKit
import SVProgressHUD

class ViewFeedback: BaseViewController {
      var visitType:VisitType!
       var planVisit:PlannVisit?
       var unplanVisit:UnplannedVisit?
   var selectedIndex = 0
    var arrFeedBack:[Feedback] = [Feedback]()
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblFeedback: UILabel!
    
    @IBOutlet weak var lblTextFeedback: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnViewNext: UIButton!
    
    @IBOutlet var btnAddFeedback: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0)){
            
        }else{
            self.apihelper.getCustomerDetail(cid: NSNumber.init(value:planVisit?.customerID ?? 0))
        }
        if let selectedcustomer = CustomerDetails.getCustomerByID(cid: unplanVisit?.customerID ?? (NSNumber.init(value:0))){
            
        }else{
            self.apihelper.getCustomerDetail(cid: unplanVisit?.customerID ?? (NSNumber.init(value:0)))
        }
        self.getFeedback()
       
    }
    
    // MARK: - Method
    
    func setUI(){
         self.showControls(lbl: false)
        self.title =  NSLocalizedString("Your_feedback", comment: "")
        if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory
        ){
            btnAddFeedback.isHidden = true
        }else{
            var strnt = ""
            if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: planVisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
               strnt = strn
            }
            }else{
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: unplanVisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                   strnt = strn
                }
            }
            self.dateFormatter.dateFormat =  "yyyy/MM/dd HH:mm:ss"
            let date = self.dateFormatter.date(from: strnt) ?? Date()
            let strnextactionDate =  self.dateFormatter.string(from: date)
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            let planDate = self.dateFormatter.date(from: strnextactionDate)
          //  plandate < createddate
            if(self.activesetting.allowEditVisitDataForPreviousDate == NSNumber.init(value: 0)){

                if(date.isEndDateIsSmallerThanCurrent(checkendDate: Date())){
                  
           
                btnAddFeedback.isHidden = true
            }
             
            }
            else{
            btnAddFeedback.isHidden = false
            }
        
        }
        
    }
    
    func showControls(lbl:Bool){
        if(lbl == true){
            lblFeedback.isHidden = false
             lblQuestion.isHidden = false
            lblTextFeedback.isHidden = false
            btnNext.isHidden = false
        }
        else{
             lblFeedback.isHidden = true
            lblQuestion.isHidden = true
            lblTextFeedback.isHidden = true
            btnNext.isHidden = true
        }
        
    }
    
    
    
    
    func configureFeedback(selectedindex:Int){
        if(selectedindex ==  arrFeedBack.count ){
            self.navigationController?.popViewController(animated: true)
        }
       else if(selectedindex == arrFeedBack.count - 1){
            self.a(feedback:arrFeedBack[selectedindex])
        btnNext.setbtnFor(title:NSLocalizedString("close", comment:""), type: Constant.kPositive)
          //  btnNext.setTitle(NSLocalizedString("close", comment:""), for: .normal)
        }else{
            
            self.a(feedback:self.arrFeedBack[selectedindex])
            btnNext.setbtnFor(title:NSLocalizedString("VIEW_NEXT", comment:""), type: Constant.kPositive)
            // btnNext.setTitle(NSLocalizedString("VIEW_NEXT", comment:""), for: .normal)
        }
        selectedIndex += 1
    }
    
    func a(feedback:Feedback)->(){
       
        let text = String.init(format:"%@ %d: %@","Feedback ", feedback.questionIndex ?? 0   ,feedback.desc ?? "")
        self.lblQuestion.text = text
        let attributedText = NSMutableAttributedString.init(string:self.lblQuestion.text! , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21)])
        self.lblQuestion.attributedText = attributedText
        self.lblFeedback.text = String.init(format:"%@: %@",NSLocalizedString("your_feedback", comment:""),feedback.userAnswerValue ?? 0)
        
        self.lblTextFeedback.isHidden = feedback.description?.count ?? 0 > 0 ? false : true
        self.lblTextFeedback.text = String.init(format:"%@: %@",NSLocalizedString("textual_feedback", comment:""),feedback.description ?? "")
    }
    
    // MARK: - API Call
    func getFeedback(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if(visitType == VisitType.coldcallvisit){
        param["VisitTypeID"] = "2"
        }else{
        param["VisitTypeID"] = "1"
        }
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            param["visitId"] = unplanVisit?.localID
            param["CustomerID"] =  unplanVisit?.customerID
            if(unplanVisit?.customerID!.intValue ?? 0 > 0){
                if   let customer = CustomerDetails.getCustomerByID(cid: unplanVisit?.customerID ?? 0){
                    param["CustomerName"] = customer.name
            }else{
            param["CustomerName"] = ""
            }
            }else{
                 param["CustomerName"] = ""
            }
        }else{
            param["visitId"] =  planVisit?.iD
            param["CustomerID"] = NSNumber.init(value:planVisit!.customerID)
            if(planVisit?.customerID ?? 0 > 0){
                if   let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0)){
                param["CustomerName"] = customer.name
            }else{
                 param["CustomerName"] = ""
            }
            }else{
                 param["CustomerName"] = ""
            }
        }
            
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetUserFeedback, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
             self.showControls(lbl:false)
        if(status.lowercased() == Constant.SucessResponseFromServer){
            print(responseType)
            if(responseType ==  ResponseType.arr){
                let arrOfFeedback = arr as? [[String:Any]] ?? [[String:Any]]()
                if(arrOfFeedback.count > 0){
                    
                    self.selectedIndex = 0
                    self.arrFeedBack.removeAll()
                    for feed in  arrOfFeedback{
                        let feedback  = Feedback().initwithdic(dic: feed)
                        self.arrFeedBack.append(feedback)
                    }
                    if(self.arrFeedBack.count > 0){
                        let firstfeedback = self.arrFeedBack.first
                        if(firstfeedback?.userAnswerValue?.count ?? 0 > 0){
                            self.showControls(lbl: true)
                        }else{
                            self.showControls(lbl: false)
                        }
                    }else{
                self.showControls(lbl: true)
                    }
                    self.configureFeedback(selectedindex: self.selectedIndex)
                }else{
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                }
            }
        }else if(error.code == 0){
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }else{
           Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
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

    // Mark: - IBAction
    
    @IBAction func addFeedbackClicked(_ sender: UIButton) {
           if  let addfeedback = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddFeedback) as? SendFeedback{
            addfeedback.visitType = visitType
            addfeedback.planVisit = planVisit ?? PlannVisit()
            addfeedback.unplanVisit = unplanVisit ??  UnplannedVisit()
            self.navigationController?.pushViewController(addfeedback, animated: true)
        }
    }
    
    
    @IBAction func btnViewNextClicked(_ sender: UIButton) {
        self.configureFeedback(selectedindex: selectedIndex)
    }
}
