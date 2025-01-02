//
//  AddProposal.swift
//  SuperSales
//
//  Created by Apple on 29/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class AddProposal: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
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
        self.title = "Add Proposal"
    }

}
