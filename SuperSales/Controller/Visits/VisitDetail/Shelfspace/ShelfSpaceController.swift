//
//  ShelfSpaceController.swift
//  SuperSales
//
//  Created by Apple on 21/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShelfSpaceController: BaseViewController {

    @IBOutlet weak var btnAddShelfSpace: UIButton!
    @IBOutlet weak var tblShelfSpace: UITableView!
    var ObjVisitForShelfSpace:PlannVisit!
    var ObjUnPlannedVisitForSpace:UnplannedVisit!
    var arrOfImage = [NSNumber:UIImage].self
    var arrOfShelfSpace:[ShelfSpaceModel]! = [ShelfSpaceModel]()
    var visitType:VisitType!
//    var planVisit:PlannVisit?
//    var unplanVisit:UnplannedVisit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.showNavBar1()
        
        self.setUI()
        
        // Do any additional setup after loading the view.
       
        //For Pull to refresh
        /*
         [_tblListing addPullToRefreshWithActionHandler:^{
         jointVisitPageNo=1;
         [self callWebservice];
         }];
         */
        
//        tblShelfSpace.addPullToRefresh {
//            self.getShelfSpaceList()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         self.getShelfSpaceList()
    }
    
    // MARK: IBAction
    
    @IBAction func AddShelfSpaceClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Visit", bundle: nil)
        if let AddShelfSpaceDetail = storyboard.instantiateViewController(withIdentifier: "AddShelfSpace") as? AddShelfSpace{
        AddShelfSpaceDetail.isEditShelfSpace = false
        AddShelfSpaceDetail.selectedShelfSpace = ShelfSpaceModel(dic: [String : Any]())
        AddShelfSpaceDetail.objVisitShelf = ObjVisitForShelfSpace
 self.navigationController?.pushViewController(AddShelfSpaceDetail, animated: true)
        }
        
    }
    
//    @objc func gotoHome()  {
//        self.navigationController?.popToRootViewController(animated: true)
//    }

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
        if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory){
            btnAddShelfSpace.isHidden = true
        }else{
            btnAddShelfSpace.isHidden = false
        }
        
        
        
        self.title  = NSLocalizedString("Shelf_Space", comment: "")
        arrOfShelfSpace = Array()
        tblShelfSpace.delegate = self
        tblShelfSpace.dataSource = self
        tblShelfSpace.reloadData()
        tblShelfSpace.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    // MARK: - APICall
    func getShelfSpaceList()  {
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if((visitType == VisitType.coldcallvisit) || (visitType == VisitType.coldcallvisitHistory)){
            param["VisitID"] = self.ObjUnPlannedVisitForSpace?.localID
        }else{
             param["VisitID"] = self.ObjVisitForShelfSpace?.iD
        }
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetShelfSpaceList1, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
           
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                self.arrOfShelfSpace.removeAll()
                if(responseType == ResponseType.arr){
                    let arrofshelfspce = arr as? [[String:Any]] ?? [[String:Any]]()
                    for sh in arrofshelfspce{
                        let shelfspace = ShelfSpaceModel.init(dic: sh)
                        self.arrOfShelfSpace.append(shelfspace)
                    }
                     self.tblShelfSpace.reloadData()
                }
            }else{
                
            }
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
             self.tblShelfSpace.reloadData()
        }
       
    }
}
extension ShelfSpaceController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfShelfSpace.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = Utils().getActiveSetting()
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "shelfspacecell", for: indexPath) as? ShelfSpaceCell{
        cell.selectionStyle = .none
        let shelfSpace:ShelfSpaceModel = arrOfShelfSpace[indexPath.row]
        
        cell.lblPosition.text =  "Position:" + shelfSpace.positionName
      
        cell.lblGivenWidth.text = String(format: "%.2f (%@)", shelfSpace.givenWidth ,setting.shelfSpaceUnit ?? "")
       
        cell.lblTotalWidth.text = String(format: "%.2f (%@)", shelfSpace.totalWidth,setting.shelfSpaceUnit ?? "")
       
        cell.lblGivenBreadth.text = String(format: "%.2f (%@)", shelfSpace.givenBreath,setting.shelfSpaceUnit ?? "")
        
        cell.lblTotalBreadth.text = String(format: "%.2f (%@)",  shelfSpace.totalBreadth,setting.shelfSpaceUnit ?? "")
            cell.lblViewImage.textColor = UIColor.Appskybluecolor
            cell.lblViewImage.font = UIFont.boldSystemFont(ofSize: 16)
           
        if(shelfSpace.shelfSpacePicture.count > 0){
            cell.lblViewImage.isHidden = false
            cell.heightForViewImageLbl.constant = 17
            print("image is = \(shelfSpace.shelfSpacePicture) and count is = \(shelfSpace.shelfSpacePicture.count)")
        }
        else{
            cell.lblViewImage.isHidden = true
            cell.heightForViewImageLbl.constant = 0
        }
        cell.lblViewImage.tag = indexPath.row
        let Gesture =  UITapGestureRecognizer.init(target: self , action: #selector(self.handleTap(_:)))
        
        cell.lblViewImage.addGestureRecognizer(Gesture)
        cell.lblViewImage.isUserInteractionEnabled = true
        
        return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       let visitStoryboard = UIStoryboard.init(name:"Visit", bundle:nil)
        if let addShelfSpaceObj = visitStoryboard.instantiateViewController(withIdentifier:"AddShelfSpace") as? AddShelfSpace{
        addShelfSpaceObj.isEditShelfSpace =  true
        addShelfSpaceObj.objVisitShelf = ObjVisitForShelfSpace
        addShelfSpaceObj.selectedShelfSpace = arrOfShelfSpace[indexPath.row]
            self.navigationController?.pushViewController(addShelfSpaceObj,animated:true)
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let shelfSpace:ShelfSpaceModel = arrOfShelfSpace[sender?.view?.tag ?? 0]
        let visitStoryboard = UIStoryboard.init(name:"Visit", bundle:nil)
        //visitObj.instantiateViewController(withIdentifier: "promotionlist") as! PromotionList
        if  let imgObject = visitStoryboard.instantiateViewController(withIdentifier: "displayShelfSpaceImage") as? displayShelfSpaceImage{
        imgObject.urlForImage = shelfSpace.shelfSpacePicture
        self.navigationController?.pushViewController(imgObject, animated: true)
        }
    }

}

