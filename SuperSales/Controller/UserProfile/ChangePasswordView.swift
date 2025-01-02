//
//  ChangePasswordView.swift
//  SuperSales
//
//  Created by Apple on 16/04/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class ChangePasswordView: BaseViewController {
    var parentviewForpopup:UIView!
    
    @IBOutlet weak var tfOldPassword: UITextField!
    
    @IBOutlet weak var tfNewPassword: UITextField!
    
    
    @IBOutlet weak var tfReEnterNewPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    func setUI(){
        tfReEnterNewPassword.setCommonFeature()
        tfOldPassword.setCommonFeature()
        tfNewPassword.setCommonFeature()
        self.tfOldPassword.addBorders(edges: UIRectEdge.bottom, color: UIColor.blue, cornerradius: 0)
        self.tfNewPassword.addBorders(edges: UIRectEdge.bottom, color: UIColor.blue, cornerradius: 0)
        self.tfReEnterNewPassword.addBorders(edges: UIRectEdge.bottom, color: UIColor.blue, cornerradius: 0)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBAction
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        Utils.removeShadow(view: parentviewForpopup)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnOKClicked(_ sender: UIButton) {
        if(tfOldPassword.text?.count == 0){
            Utils.toastmsg(message:"Please enter old password",view: self.view)
        }else if(tfNewPassword.text?.count == 0){
            Utils.toastmsg(message:"Please enter new password",view: self.view)
        }else if(tfReEnterNewPassword.text?.count == 0){
            Utils.toastmsg(message:"Please re-enter new password",view: self.view)
        }else if(!(tfNewPassword.text  == tfReEnterNewPassword.text ))
        {
            Utils.toastmsg(message:"Password does not match" ,view: self.view)
        }else{
            var param = Common.returndefaultparameter()
            if let oldpw = self.tfOldPassword.text as? String{
                param["OldPassword"] = oldpw
            }
            if let newpw = self.tfNewPassword.text as? String{
                param["NewPassword"] = newpw
            }
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlChangePassword, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                if(status.lowercased() == Constant.SucessResponseFromServer){
                 
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dismiss(animated: true) {
                        Utils.removeShadow(view: self.parent?.view ?? UIView())
                        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    }
                    })
                    
                }else{
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                }
            }
        }
    }
}
