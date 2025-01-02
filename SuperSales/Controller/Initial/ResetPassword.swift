//
//  ResetPassword.swift
//  
//
//  Created by Apple on 16/04/21.
//

import UIKit
import SVProgressHUD

class ResetPassword: BaseViewController {

    @IBOutlet weak var tfResgisteredMobileNo: UITextField!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    @IBOutlet var lblEnterYourmonumTitle: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Method
    func setUI(){
        self.title = "Reset Password"
        Common.setTitleOfView(color:UIColor.white, viewController: self)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
//        self.navigationController?.navigationBar.isHidden = false
        btnResetPassword.setbtnFor(title: "Reset Password", type: Constant.kPositive)
        tfResgisteredMobileNo.setCommonFeature()
        self.tfResgisteredMobileNo.keyboardType = .numberPad
        self.tfResgisteredMobileNo.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
    }

    // MARK: - IBAction
    
    @IBAction func btnResetPasswordClicked(_ sender: UIButton) {
        tfResgisteredMobileNo.resignFirstResponder()
        if(tfResgisteredMobileNo.text?.count == 0){
            Utils.toastmsg(message:"Please enter mobile no",view: self.view)
        }else if(tfResgisteredMobileNo.text?.count ?? 0 < 6 || tfResgisteredMobileNo.text?.count ?? 0 > 15){
            Utils.toastmsg(message:"Please enter valid  mobile no",view: self.view)
        }else{
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = [String:Any]()
            if let mobileno = tfResgisteredMobileNo.text{
                param["MobileNo"] = mobileno
            }
            
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlResetPassword , method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    self.navigationController?.popViewController(animated: true)
                    if let rootview =       UIApplication.shared.keyWindow?.rootViewController{
                        rootview.view.makeToast(message)
                    }else{
                if (message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    }
                   
                }else{
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                }
            }
        }
    }
}
