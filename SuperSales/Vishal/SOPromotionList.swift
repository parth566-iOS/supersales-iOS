//
//  SOPromotionList.swift
//  SuperSales
//
//  Created by ebsadmin on 22/08/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

protocol SOPromotionListDelegate {
    func returnPromotionIndex(promotionRow: NSInteger)

}

class SOPromotionList: BaseViewController {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnApply: UIButton!
    var promotionList = [Promotion]()
    var delegate:SOPromotionListDelegate?
    var selectedIndexPath: IndexPath? = nil
    var nvc: UINavigationController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc @IBAction func selectPromotion(_ sender: Any){
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tbl)
        if let indexPath = self.tbl.indexPathForRow(at: buttonPosition) {
            selectedIndexPath = indexPath;
            tbl.reloadData()
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.removeAnimate()
    }

    @IBAction func btnOk(_ sender: Any) {
        if (selectedIndexPath != nil) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.delegate?.returnPromotionIndex(promotionRow: selectedIndexPath?.row ?? 0)
            self.removeAnimate()
        }else{
            self.view?.makeToast("Select Promotion", duration: 1.0, position: CGPoint(x: AppDelegate.shared.window?.center.x ?? 0 + tbl.frame.origin.x, y: btnApply.center.y+10))
        }
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            self.view.alpha = 0.0;
        } completion: { finished in
            if (finished) {
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.removeFromParent()
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

extension SOPromotionList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SOPromotionCell") as! SOPromotionCell
        let objPromo = self.promotionList[indexPath.row]
        cell.lblPromoTitle.text = objPromo.promotionTitle;
        cell.lblPromoBalBudget.text = String(format: "Balanced Budget: %d.0", objPromo.availableUserBudget);
        cell.lblPromoDedBudget.text = String(format: "Deducted Budget: %d.0", objPromo.usedUserBudget);
        if (selectedIndexPath?.row == indexPath.row && selectedIndexPath != nil) {
            cell.btnSelectedPromo.isSelected = true;
        }else{
            cell.btnSelectedPromo.isSelected = false;
        }
        cell.btnSelectedPromo.addTarget(self, action: #selector(selectPromotion(_:)), for: .touchUpInside)

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.PromotionDetail) as? PromotionDetail {
            objDetail.promotionData = self.promotionList;
            objDetail.selectedPromotionID = NSNumber(value: indexPath.row)
            nvc?.pushViewController(objDetail, animated: true)
        }
    }
}
