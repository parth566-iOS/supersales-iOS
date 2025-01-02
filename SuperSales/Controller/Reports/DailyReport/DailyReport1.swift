//
//  DailyReport.swift
//  SuperSales
//
//  Created by Apple on 30/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DailyReport: BaseViewController {
    var isHome:Bool!
     var arrLowerLevelUser = [CompanyUsers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0 ){
            arrLowerLevelUser = BaseViewController.staticlowerUser!
            
        }else{
            DispatchQueue.global(qos: .background).async {
        self.fetchuser{
            (arrOfuser,error) in
            
        }
           // SalesPlanHome().fetchuser()
        }
        
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.isNavigationBarHidden = false
    }
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Location.sharedInsatnce.startLocationManager()
        //let arrOfMenu:[UPStackMenuItem] =
    }
    
    // MARK: - UI
    func setUI(){
      //  getRoleIDFromUserId
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
