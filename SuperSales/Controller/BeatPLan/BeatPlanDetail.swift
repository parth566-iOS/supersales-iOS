//
//  BeatPlanDetail.swift
//  SuperSales
//
//  Created by Apple on 04/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class BeatPlanDetail: BaseViewController {
 // swiftlint:disable line_length
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblBeatplanID: UILabel!
    
    
    @IBOutlet weak var tblBeatDetail: UITableView!
    
    var selectedDate:String!
    var strbeatplanname:String!
    var strbeatplanID:String!
    var arrOfBeatPlanDetail:[BeatPlan]! = [BeatPlan]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Method
    func setUI(){
        
        
        print(selectedDate)
        lblDate.text = selectedDate
        lblBeatplanID.text = String.init(format:"BeatPlan ID : %@",strbeatplanID)
        self.title = strbeatplanID
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        tblBeatDetail.delegate = self
        tblBeatDetail.dataSource = self
        tblBeatDetail.tableFooterView = UIView()
        tblBeatDetail.separatorColor = UIColor.clear
        self.getIndiviudalBeatPlanDetail()
    }
    
    
    // MARK: APICall
    func getIndiviudalBeatPlanDetail(){
        var param = Common.returndefaultparameter()
        param["getBeatPlanDetailsJson"] =  Common.json(from: ["CompanyID":self.activeuser?.company?.iD ?? 0,"BeatPlanID":strbeatplanID])
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlForIndividiualBeatDetail, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if(responseType == ResponseType.arr){
                   let arrbDetail = arr as? [[String:Any]] ?? [[String:Any]]()
                    for int in arrbDetail{
                        let beatplan = BeatPlan.init(int)
                    self.arrOfBeatPlanDetail.append(beatplan)
                    }
                }
                self.tblBeatDetail.reloadData()
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
extension BeatPlanDetail:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfBeatPlanDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:FourLblVerticalCell =  tableView.dequeueReusableCell(withIdentifier: Constant.ForuLabelVerticalCell, for: indexPath) as? FourLblVerticalCell{
        let beatplan =  arrOfBeatPlanDetail[indexPath.row]
        let customer = beatplan.customer
       // cell.vwParent.addBorders(edges: [.left,.right,.top,.bottom], color: UIColor.gray, cornerradius: 5)
        cell.vwParent.backgroundColor = UIColor.init(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0) //UIColor.lightBackgroundColor
        cell.lblCustomerName.font = UIFont.boldSystemFont(ofSize: 16)
        cell.lblCustomerName.text = customer?.Name
        cell.lblCustomerContactNo.text = customer?.MobileNo
        cell.lblCustomerAddress.font = UIFont.boldSystemFont(ofSize: 16)
        if(customer?.AddressList.count ?? 0 > 0){
        let address = customer?.AddressList.first
            cell.lblCustomerAddress.text = String.init(format: "%@:%@, %@, %@, %@, %@", "Address:",address?.AddressLine1 ?? "",address?.AddressLine2 ?? "",address?.State ?? "",address?.City ?? "",address?.Country ?? "")
            cell.lblCustomerAddress.setMultilineLabel(lbl: cell.lblCustomerAddress)
        }else{
            cell.lblCustomerAddress.text = ""
        }
        self.dateFormatter.dateFormat = "HH:mm:ss"
        let time = self.dateFormatter.date(from: beatplan.StartTime)
        self.dateFormatter.dateFormat = "hh:mm a"
        let strTime = NSMutableAttributedString.init(string: "Time:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        strTime.append(NSAttributedString.init(string: self.dateFormatter.string(from: time ?? Date()), attributes: [:]))
        cell.lblTime.attributedText = strTime
        /*
         FormatString(@"%@:%@, %@, %@, %@, %@",NSLocalizedString(@"Address", @""),[address objectForKey:@"AddressLine1"],[address objectForKey:@"AddressLine2"],[address objectForKey:@"State"],[address objectForKey:@"City"],[address objectForKey:@"Country"])
         */
        
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
