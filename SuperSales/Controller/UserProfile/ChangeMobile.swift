//
//  ChangePassword.swift
//  SuperSales
//
//  Created by Apple on 20/10/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangeMobile: BaseViewController {

    @IBOutlet weak var tfOldMobileNo: UITextField!
    
    @IBOutlet weak var tfNewMobileNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    func setUI(){
        self.title = "Change Mobile No"
        tfOldMobileNo.setCommonFeature()
        tfNewMobileNo.setCommonFeature()
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.tfNewMobileNo.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfOldMobileNo.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
       
    }
    //MARK: - API Call
    func ChangeMobileNo(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["OldMobileNo"] = tfOldMobileNo.text
        param["NewMobileNo"] = tfNewMobileNo.text
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSChangeMobileNo , method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                if let verifyMobilevw = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.VerifyMobile) as? MobileVerification{
                if let newmobileno = self.tfNewMobileNo.text{
                verifyMobilevw.strMobileNo = newmobileno
                }
                self.navigationController?.pushViewController(verifyMobilevw, animated: true)
                }
            }else{
                Utils.toastmsg(message:error.localizedDescription,view:self.view)
            }
          
        }

    }
    //MARK: - IBAction
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(tfOldMobileNo.text?.count == 0){
            Utils.toastmsg(message:"Please enter old mobile no",view:self.view)
        }else if(tfOldMobileNo.text?.count ?? 0 < 6 || tfOldMobileNo.text?.count ?? 0 > 15){
            Utils.toastmsg(message:"Please enter valid old mobile no",view:self.view)
        }else if(tfNewMobileNo.text?.count ?? 0 < 6 || tfNewMobileNo.text?.count ?? 0 > 15){
            Utils.toastmsg(message:"Please enter valid new mobile no",view:self.view)
        }else if(tfNewMobileNo.text?.count == 0){
            Utils.toastmsg(message:"Please enter new mobile no",view:self.view)
        }else{
            self.ChangeMobileNo()
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
