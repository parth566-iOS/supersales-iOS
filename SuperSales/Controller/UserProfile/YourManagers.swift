//
//  YourManagers.swift
//  SuperSales
//
//  Created by Apple on 17/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//


import UIKit
import SVProgressHUD

class YourManagers: BaseViewController {

    @IBOutlet var tblManagers: UITableView!
    var  arrOfManager = [[String:Any]]()
    var arrManagerHierarchy = [ManagerHierachy]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.getMangerList()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    func getMangerList(){
        SVProgressHUD.show()
        let param = Common.returndefaultparameter()
        ApiHelper().getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetManagerHierarchy, method: Apicallmethod.get) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                self.arrOfManager = arr as? [[String:Any]] ?? [[String:Any]]()
                for managerdic in self.arrOfManager{
                    let manager = ManagerHierachy().initwithdic(dict: managerdic)
                    self.arrManagerHierarchy.append(manager)
                }
               // arrManagerHierarchy.sort {$0.role.id?.intValue.localizedStandardCompare($1.role.id?.intValue) == .Ascending}
                self.arrManagerHierarchy =  self.arrManagerHierarchy.reversed()
               
//                arrManagerHierarchy.sort { m1, m2 in
//                    m1.role?.id?.intValue ?? 0 < m2.role?.id?.intValue ?? 0
//                }
//                if let dicOFselfuser = self.activeuser?.toDictionary() as? [String:Any]{
//                let selfuser = ManagerHierachy().initwithdic(dict: dicOFselfuser)
//                arrManagerHierarchy.insert(selfuser, at:  arrManagerHierarchy.count)
//                }
                self.tblManagers.reloadData()
            }else{
                if(message.count > 0){
                 Utils.toastmsg(message:message,view: self.view)
                }else{
                    if(error.localizedDescription.count > 0){
                    Utils.toastmsg(message:error.localizedDescription,view: self.view)
                    }
                }
            }
        }
        
    }
    func setUI(){
        self.title = "Your Managers"
        
        
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        tblManagers.separatorColor = UIColor.clear
        tblManagers.tableFooterView = UIView()
        tblManagers.delegate = self
        tblManagers.dataSource = self
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
extension YourManagers: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrManagerHierarchy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "managercell") as? ManagerCell{
            if(indexPath.row == arrManagerHierarchy.count - 1){
                cell.lblLink.isHidden =  true
            }else{
                cell.lblLink.isHidden = false
            }
            let selectedmanager = arrManagerHierarchy[indexPath.row]
            var username = ""
            if let firstname = selectedmanager.firstName {
                username.append(firstname)
            }
            if let lastname = selectedmanager.lastName {
                username.append(" \(lastname)")
            }
            if let contactno = selectedmanager.mobileNo1 {
                cell.lblManagerContactNo.text = contactno
            }
            if let email = selectedmanager.email {
                cell.lblManagerEmail.text = email
            }
            cell.lblManagerName.text = username
            if let roleOfManager = selectedmanager.role {
                if let managerpostname = roleOfManager.desc{
                    cell.lblManagerPosition.text = managerpostname.capitalized
            }else{
                cell.lblManagerPosition.text = ""
            }
            }else{
                cell.lblManagerPosition.text = ""
            }
            
           
            if(selectedmanager.picture?.count ?? 0  > 0){
                cell.imgManager.sd_setImage(with: URL.init(string: selectedmanager.picture ?? ""), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    print("image downloaded")
                }
            }else{
                
                cell.imgManager.image = UIImage.init(named: "icon_placeholder_user")
            }
     
            return cell
        }else{
            return    UITableViewCell()
        }
    }
    
    
}
