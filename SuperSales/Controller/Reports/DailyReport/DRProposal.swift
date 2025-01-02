//
//  DRProposal.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRProposal: BaseViewController {
    private let refreshControl = UIRefreshControl()
    public static var arrProposal:[Proposal]!
    
    @IBOutlet var tblProposal: UITableView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblProposal.refreshControl = refreshControl
        } else {
            tblProposal.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
//         [_tblListing addPullToRefreshWithActionHandler:^{
//         jointVisitPageNo=1;
//         [self callWebservice];
//         }];
         
    }
    @objc private func refreshWeatherData(_ sender: Any) {
//        // Fetch Weather Data
        refreshControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
        tblProposal.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRProposal.arrProposal.count > 0 &&  tblProposal.visibleCells.count > 0){
        self.tblProposal.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
     tblProposal.reloadData()
    }
    
    //MARK: -Method
    func setUI(){
               
       tblProposal.delegate = self
       tblProposal.dataSource = self
       tblProposal.separatorColor = .clear
                
    tblProposal.estimatedRowHeight = 90
                
       tblProposal.rowHeight = UITableView.automaticDimension
       
       tblProposal.reloadData()
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
extension DRProposal:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(DRProposal.arrProposal)
        return DRProposal.arrProposal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
       
        let proposal = DRProposal.arrProposal[indexPath.row]
        cell.imgLeft.isHidden = true
        cell.imgRight.isHidden = true
         let strproposalno = NSMutableAttributedString.init(string: "Proposal Order No: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        
if let prono = proposal.SeriesPostfix as? NSNumber{
strproposalno.append(NSAttributedString.init(string: String.init(format:"\(prono)"), attributes: [:]))
       
}
cell.lblLeadTitle.attributedText = strproposalno
        
let strcustomername = NSMutableAttributedString.init(string: "Customer:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
strcustomername.append(NSAttributedString.init(string: String.init(format:"\(proposal.CustomerName ?? "")"), attributes: [:]))
       
        cell.vwProduct.backgroundColor = UIColor.clear
cell.lblContact.attributedText  = strcustomername
let strproduct = NSMutableAttributedString.init(string: "Products:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
if(proposal.Products.count > 0){
    for prodic  in 0...proposal.Products.count-1{
 let propoduct = proposal.Products[prodic]
        if let productname = propoduct.Name{
 if(prodic == 0){
    
    strproduct.append(NSAttributedString.init(string: productname, attributes: [:]))
            }
 else{
    strproduct.append(NSAttributedString.init(string: ",\(productname)", attributes: [:]))
 }
        }
    }
        }else{
            strproduct.append(NSAttributedString.init(string: "No Products", attributes: [:]))
        }
        cell.lblNextAction.backgroundColor = UIColor.clear
        
cell.lblNextAction.attributedText = strproduct
cell.lblReason.isHidden = true
cell.vwProduct.isHidden = true


cell.vwParent.layoutIfNeeded()
return cell

}else{
            return UITableViewCell()
        }
}
    
    
}

