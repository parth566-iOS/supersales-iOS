//
//  MobileVerification.swift
//  SuperSales
//
//  Created by Apple on 16/04/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class MobileVerification: BaseViewController {
    
    var strMobileNo:String!

    @IBOutlet weak var tfOTP: UITextField!
    
   
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnRegenerateOTP: UIButton!
    
    @IBOutlet weak var btnCancelRequest: UIButton!
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
    
    //MARK: - Method
    func setUI(){
        self.title = "OTP Verification"
        tfOTP.setCommonFeature()
        btnVerify.backgroundColor = UIColor.Appthemegreencolor
        btnCancelRequest.backgroundColor = UIColor.Appthemegreencolor
        tfOTP.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        let attributedtitle = NSAttributedString.init(string: "Regenerate OTP", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.underlineColor: UIColor.systemBlue])
        
        self.btnRegenerateOTP.setAttributedTitle(attributedtitle, for: .normal)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
    }

    
    // MARK: - IBAction
    
    @IBAction func btnVerifyClicked(_ sender: UIButton) {
        if(tfOTP.text?.count ?? 0 > 0){
        var param = Common.returndefaultparameter()
        if let userid = self.activeuser?.userID{
        param["UserID"] = userid
        }
            if let strotp = tfOTP.text{
        param["Otp"] = strotp
            }
        param["MobileNo"] = strMobileNo
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlVerifyMobile, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
               if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }else{
              if  let dicerror =  error.userInfo as? [String:Any]{
                if let strerror = dicerror["localisedDescription"] as? String{
                    if(strerror.count > 0){
                        Utils.toastmsg(message:strerror,view: self.view)
                    }else{
                        Utils.toastmsg(message:error.localizedDescription,view: self.view)
                    }
                }
                }
              
            }
        }
        }else{
            Utils.toastmsg(message:"please enter otp",view: self.view)
        }
    }
    
    @IBAction func btnRegenreateOTPClicked(_ sender: UIButton) {
        var param = Common.returndefaultparameter()
        if let userid = self.activeuser?.userID{
        param["UserID"] = userid
        }
        param["MobileNo"] = strMobileNo
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlResendOTP, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                Utils.toastmsg(message:error.localizedDescription,view: self.view)
            }
        }
       // param["UserID"] = self
    }
    
    @IBAction func btnCancelRequestClicked(_ sender: UIButton) {
        var param = Common.returndefaultparameter()
        if let userid = self.activeuser?.userID{
        param["UserID"] = userid
        }
        param["MobileNo"] = strMobileNo
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlCancelMobile , method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                Utils.toastmsg(message:error.localizedDescription,view: self.view)
            }
        }
    }
}
