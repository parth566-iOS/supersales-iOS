//
//  QuizView.swift
//  
//
//  Created by Apple on 20/01/22.
//

import UIKit
import SVProgressHUD

class QuizView: BaseViewController {

    var docID:NSNumber!
    var code:String!
    var arrOfQuestionModels:[Quizmodel]! = [Quizmodel]()
    var questionNo = 0
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var btnAnwser1: UIButton!
    @IBOutlet weak var btnAnwser2: UIButton!
    @IBOutlet weak var btnAnwser3: UIButton!
    @IBOutlet weak var btnAnwser4: UIButton!
    
    @IBOutlet weak var btnDontKnow: UIButton!
    
    @IBOutlet weak var btnSaveNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Metod

    func setUI(){
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title =  "Quiz"
        btnSaveNext.backgroundColor = UIColor.Appthemegreencolor
        btnDontKnow.backgroundColor = UIColor.Appthemecolor
        btnSaveNext.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnDontKnow.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnDontKnow.cornerRadius =  5
        btnSaveNext.cornerRadius = 5
        btnAnwser1.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnAnwser2.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnAnwser3.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnAnwser4.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.getQuestionList()
    }
    
    func configureFeedBack(){
        let selectedQuestion = arrOfQuestionModels[questionNo]
//        var strQuestion = String.init(format: "Ques. No. \(questionNo) \(selectedQuestion.questionText)")
        var strquestionTitle = NSMutableAttributedString.init(string: String.init(format: "Ques. No. \(questionNo + 1) "), attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 21)])
        strquestionTitle.append(NSAttributedString.init(string: selectedQuestion.questionText, attributes: nil))
        lblQuestion.attributedText = strquestionTitle
        btnAnwser1.setTitle(selectedQuestion.option1, for: UIControl.State.normal)
        btnAnwser2.setTitle(selectedQuestion.option2, for: UIControl.State.normal)
        btnAnwser3.setTitle(selectedQuestion.option3, for: UIControl.State.normal)
        btnAnwser4.setTitle(selectedQuestion.option4, for: UIControl.State.normal)
        
        btnAnwser1.isSelected =  false
        btnAnwser2.isSelected = false
        btnAnwser3.isSelected =  false
        btnAnwser4.isSelected = false
    }
    
    func hideview(status:Bool){
        lblQuestion.isHidden = status
        btnAnwser1.isHidden = status
        btnAnwser2.isHidden = status
        btnAnwser3.isHidden = status
        btnAnwser4.isHidden = status
        btnDontKnow.isHidden = status
        btnSaveNext.isHidden = status
        
    }
    
    func checkValidation()->Bool{
        if((!btnAnwser1.isSelected) && (!btnAnwser2.isSelected) && (!btnAnwser3.isSelected) && (!btnAnwser4.isSelected)){
            Common.showalert(msg: "Please select at-least one option or press Don't Know button to skip this question", view: self)
            return false
        }else{
            return true
        }
    }
    
    
    func saveanwser(objquiz:Quizmodel,anwser:String){
       
        var param = [String:Any]()
        param["UserID"] = self.activeuser?.userID?.stringValue
        param["TokenID"] = self.activeuser?.securityToken ?? "ds"
        param["Application"] = ConstantURL.APPLICATIONSUPERSALESPRO
       
        // Common.returndefaultparameter()
        param["companyID"] =  self.activeuser?.company?.iD
        var param1 = [String:Any]()
        param1["documentID"] = NSNumber.init(value: objquiz.documentID)
        param1["quizID"] = NSNumber.init(value: objquiz.quizID)
        param1["code"] = self.code
        param1["selectedOption"] = anwser
        param1["companyID"] =  self.activeuser?.company?.iD
       // documentID
        if(arrOfQuestionModels.count == (questionNo + 1)){
            param1["completedQuiz"] = NSNumber.init(value: 1)
        }else{
            param1["completedQuiz"] = NSNumber.init(value: 0)
        }
        param["QuizAnswerJSON"] = Common.json(from: param1)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddQuizAnswer, method: Apicallmethod.post)  {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                self.questionNo += 1
                if(anwser != "0000"){
                    let formatter =  NumberFormatter.init()
                    formatter.numberStyle = .decimal
                    let numobj = formatter.number(from: anwser)
                    if(numobj?.intValue == objquiz.answer){
                        Utils.toastmsg(message: "Correct Answer", view: self.view)
                    }else{
                        Utils.toastmsg(message: "Incorrect Answer", view: self.view)
                    }
                }
                
                if(self.arrOfQuestionModels.count > 0){
                    if(self.arrOfQuestionModels.count == self.questionNo){
                        self.viewScore()
                    }else if(self.arrOfQuestionModels.count + 1 == self.questionNo){
                        self.btnSaveNext.setTitle("SAVE & NEXT", for: UIControl.State.normal)
                        self.configureFeedBack()
                    }else{
                        self.btnSaveNext.setTitle("SUBMIT", for: UIControl.State.normal)
                        self.configureFeedBack()
                    }
                    
                }else{
                    self.hideview(status: true)
                    self.lblQuestion.isHidden = false
                    self.lblQuestion.text = "Company has no feedback questions yet"
                }
            }else{
                
            }
        }
    }
    
    //MARK: - APICall
    func getQuestionList(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["documentID"] = docID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetQuizQuestionList, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
          
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print("response is of question list api = \(arr)")
                let arrOfQuestion = arr as? [[String:Any]] ?? [[String:Any]]()
                if(arrOfQuestion.count == 0){
                    self.hideview(status: true)
                    Utils.toastmsg(message: "No Questions are available for this quiz", view: self.view)
                }else{
                    self.hideview(status: false)
                    for dic in arrOfQuestion{
//                        do {
//                          //  let jointvisit = try JSONDecoder().decode(Quizmodel.self, from: JSONSerialization.data(withJSONObject:dic))
                        let question =  Quizmodel().initwithDicForQuestion(dic:dic)
                            self.arrOfQuestionModels.append(question)
//                        } catch {
//                            // print error here.
//                            print("get some error")
//                        }
                    }
                    self.configureFeedBack()
//                    do {
//                       let jsonData = try JSONSerialization.data(withJSONObject: arrOfQuestion)
//                        let res = try JSONDecoder().decode([Quizmodel].self, from: jsonData)
//                        print(res)
//
//                    }
//                    catch {
//
//                        print(error)
//                    }
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count  > 0 ?(error.userInfo["localiseddescription"] as? String ?? "" ):error.localizedDescription ?? "" , view: self.view)
            }
        }
    }
    
    
    func viewScore(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["documentID"] = self.docID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetQuizResult, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
                SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                 let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                Common.showalertWithAction(msg: message, arrAction: [okAction], view: self)
               // Common.showalert(title: "Your Score", msg: message, view: self)
            }else{
                if(message.count > 0){
                    Utils.toastmsg(message: message, view: self.view)
                }else{
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count  > 0 ?(error.userInfo["localiseddescription"] as? String ?? "" ):error.localizedDescription ?? "" , view: self.view)
                }
            }
        }
    }
    
    
    //MARK: - IBAction
    
    @IBAction func btnDontknowClicked(_ sender: UIButton) {
        let selectedQuestion = arrOfQuestionModels[questionNo]
        self.saveanwser(objquiz: selectedQuestion, anwser: "0000")
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(self.checkValidation()){
            SVProgressHUD.show()
            if(questionNo < arrOfQuestionModels.count){
            let selectedQuestion = arrOfQuestionModels[questionNo]
            var strans = ""
            if(btnAnwser1.isSelected){
                strans.append("1")
            }else{
                strans.append("0")
            }
            if(btnAnwser2.isSelected){
                strans.append("1")
            }else{
                strans.append("0")
            }
            if(btnAnwser3.isSelected){
                strans.append("1")
            }else{
                strans.append("0")
            }
            if(btnAnwser4.isSelected){
                strans.append("1")
            }else{
                strans.append("0")
            }
                self.saveanwser(objquiz: selectedQuestion, anwser: strans)
            }
           
        }
    }
    
    @IBAction func selectAnwser(_ sender: UIButton) {
        let selectedans = sender.tag
        switch selectedans {
        case 1:
            btnAnwser1.isSelected = true
            btnAnwser2.isSelected = false
            btnAnwser3.isSelected = false
            btnAnwser4.isSelected = false
            break
            
        case 2:
            btnAnwser2.isSelected = true
            btnAnwser1.isSelected = false
            btnAnwser3.isSelected = false
            btnAnwser4.isSelected = false
            break
            
        case 3:
            btnAnwser3.isSelected = true
            btnAnwser1.isSelected = false
            btnAnwser2.isSelected = false
            btnAnwser4.isSelected = false
            break
            
        default:
            btnAnwser4.isSelected = true
            btnAnwser1.isSelected = false
            btnAnwser3.isSelected = false
            btnAnwser2.isSelected = false
            
            break
            
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
