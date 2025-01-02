//
//  SendFeedback.swift
//  SuperSales
//
//  Created by Apple on 14/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class SendFeedback: BaseViewController {

    
    @IBOutlet var vwYes: UIView!
    
    @IBOutlet var vwNo: UIView!
    
    
    @IBOutlet var vwNotSure: UIView!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnNotSure: UIButton!
    
    @IBOutlet var vwAnwser4: UIView!
    
    @IBOutlet var btnAnwser4: UIButton!
    
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet var lblAnwser1: UILabel!
    
    @IBOutlet var lblAnwser4: UILabel!
    @IBOutlet var lblAnwser3: UILabel!
    @IBOutlet var lblAnwser2: UILabel!
    @IBOutlet weak var txtFeedback: UITextField!
    
    
    var selectedIndex = 0
    var arrFeedBack:[Feedback] = [Feedback]()
    
    var visitType:VisitType!
    var planVisit:PlannVisit?
    var unplanVisit:UnplannedVisit?
    var answerID = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        selectedIndex = 0
        self.getQuestionList()
    }
    
    // MARK:  - Method
    func setUI(){
        txtFeedback.setCommonFeature()
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem:self.navigationItem)
        self.title = NSLocalizedString("feedback", comment: "")
        CustomeTextfield.setBottomBorder(tf: txtFeedback)
    }
    
    func showControls(lbl:Bool){
        if(lbl == true){
           // lblFeedback.isHidden = false
            // lblTextFeedback.isHidden = false
             lblQuestion.isHidden = false
            btnNext.isHidden = false
            vwYes.isHidden = false
            vwNo.isHidden = false
            vwNotSure.isHidden = false
            vwAnwser4.isHidden =  false
            btnNo.isHidden = false
            btnYes.isHidden = false
            btnAnwser4.isHidden = false
            btnNotSure.isHidden = false
            
            txtFeedback.isHidden = false
            
        }
        else{
           //  lblFeedback.isHidden = true
            // lblTextFeedback.isHidden = true
            vwYes.isHidden = true
                       vwNo.isHidden = true
                       vwNotSure.isHidden = true
            vwAnwser4.isHidden =  true
            lblQuestion.isHidden = true
            btnNext.isHidden = true
            btnNo.isHidden = true
            btnYes.isHidden = true
            btnAnwser4.isHidden = true
            btnNotSure.isHidden = true
            txtFeedback.isHidden = true
        }
        
    }
    
    
    func configurenormal(btn:UIButton){
        btn.isSelected = false
    }
    
    func configureselected(btn:UIButton){
        answerID = btn.tag
        btn.isSelected = true
    }
    
    func configureFeedback(feedbackindex:Int){
        if(selectedIndex == arrFeedBack.count - 1){
            self.a(feedback:arrFeedBack[selectedIndex])
           // btnNext.setTitle(NSLocalizedString("submit", comment:""), for: .normal)
            self.btnNext.setbtnFor(title: NSLocalizedString("submit", comment:""), type: Constant.kPositive)
        }else{
            self.a(feedback:arrFeedBack[selectedIndex])
            self.btnNext.setbtnFor(title: NSLocalizedString("SAVE_NEXT", comment:""), type: Constant.kPositive)
            // btnNext.setTitle(NSLocalizedString("SAVE_NEXT", comment:""), for: .normal)
        }
        
    }
    
    func a(feedback:Feedback)->(){
        let text = String.init(format:"%@ %d: %@","Feedback", feedback.questionIndex ?? 0   ,feedback.desc ?? "")
        self.lblQuestion.text = text
        self.lblAnwser1.text = feedback.option1
        self.lblAnwser2.text = feedback.option2
        self.lblAnwser3.text = feedback.option3
        self.lblAnwser4.text = feedback.option4
        
        let attributedText = NSMutableAttributedString.init(string:self.lblQuestion.text! , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 21)])
        self.lblQuestion.attributedText = attributedText
//        self.lblFeedback.text = String.init(format:"%@: %@",NSLocalizedString("your_feedback", comment:""),feedback.userAnswerValue ?? 0)
//
//        self.lblTextFeedback.isHidden = feedback.description?.count ?? 0 > 0 ? false : true
//        self.lblTextFeedback.text = String.init(format:"%@: %@",NSLocalizedString("textual_feedback", comment:""),feedback.description ?? "")
    }
    
    // MARK: -  IBAction
    
    @IBAction func saveandnextClicked(_ sender: UIButton) {
let feedback = arrFeedBack[selectedIndex]
SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
var param = Common.returndefaultparameter()
        var anwserdic = [String:Any]()
//        anwserdic["questionId"] = NSNumber.init(value:feedback.iD ?? 0)
//        anwserdic["createdBy"] = self.activeuser?.userID ?? 0
//        anwserdic["companyId"] = self.activeuser?.company?.iD ?? 0
//        anwserdic["Description"] = txtFeedback.text ?? ""
//          anwserdic["Description"] = txtFeedback.text ?? ""
        anwserdic =  ["questionId":NSNumber.init(value:feedback.iD ?? 0), "createdBy":self.activeuser?.userID ?? 0,"companyId":self.activeuser?.company?.iD ?? 0,"Description":txtFeedback.text ?? ""  ,"answerId":NSNumber.init(value: answerID)] as [String : Any]
        
        
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            anwserdic["visitId"] = unplanVisit?.localID
            anwserdic["CustomerID"] =  unplanVisit?.customerID
           
        }else{
            anwserdic["visitId"] =  planVisit?.iD
            anwserdic["CustomerID"] = NSNumber.init(value:planVisit!.customerID)
        }
        param["AnswerJSON"] =  Common.json(from: anwserdic)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddUpdateAnswer, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
               SVProgressHUD.dismiss()
               if(status.lowercased() == Constant.SucessResponseFromServer){
                   print(responseType)
                if(self.btnNext.currentTitle == NSLocalizedString("submit", comment:"")){
                    Utils.toastmsg(message:NSLocalizedString("feedback_submitted_successfully", comment:""),view: self.view)
                    self.planVisit?.isFeedBackAvailable = 1
                    self.planVisit?.managedObjectContext?.mr_save({ (localcontext) in
                        print("saving")
                    }, completion: { (status, error) in
                        print(error?.localizedDescription ?? "no error")
                        print("saved , \(self.planVisit?.isPictureAvailable)")
                        
                    })
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showControls(lbl: true)
                    self.selectedIndex += 1
                    self.answerID = 3
                    self.txtFeedback.text = ""
        self.selectAnwser(self.btnYes)
                    self.configureFeedback(feedbackindex: self.selectedIndex)
//                    [self selectAnswer:_btnNotSure];
//                    [self configureFeedback:selectedIndex];
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
    
    @IBAction func selectAnwser(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.configurenormal(btn: btnNo)
            self.configurenormal(btn: btnNotSure)
            self.configureselected(btn: btnYes)
            self.configurenormal(btn: btnAnwser4)
            break
            
            case 2:
                      self.configurenormal(btn: btnNotSure)
                      self.configurenormal(btn: btnYes)
                      self.configureselected(btn: btnNo)
            self.configurenormal(btn: btnAnwser4)
                      break
            case 3:
                      self.configurenormal(btn: btnNo)
                      self.configurenormal(btn: btnYes)
                      self.configureselected(btn: btnNotSure)
            self.configurenormal(btn: btnAnwser4)
                      break
            
            
            
        case 4:
                  self.configurenormal(btn: btnNo)
                  self.configurenormal(btn: btnYes)
                self.configureselected(btn: btnAnwser4)
                  self.configurenormal(btn: btnNotSure)
                  break
            
        default:
            print("default case")
        }
    }
    
    // MARK: - APICall
    func getQuestionList(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        let param = Common.returndefaultparameter()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetQuestionList, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
        if(status.lowercased() == Constant.SucessResponseFromServer){
             if(responseType ==  ResponseType.arr){
    let arrOfFeedback = arr as? [[String:Any]] ?? [[String:Any]]()
    if(arrOfFeedback.count > 0){
                                for feed in  arrOfFeedback{
                                    let feedback  = Feedback().initwithdic(dic: feed)
            self.selectAnwser(self.btnYes)
                                    self.arrFeedBack.append(feedback)
                                    
                                }
                    self.showControls(lbl: true)
                                self.configureFeedback(feedbackindex: self.selectedIndex)
                            }else{
            self.showControls(lbl: false)
            self.lblQuestion.text = "Company has no feedback questions yet"
            self.lblQuestion.font = UIFont.boldSystemFont(ofSize: 14)
            self.lblQuestion.isHidden = false
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

}
