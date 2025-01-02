//
//  ActivityParticipatDisplay.swift
//  SuperSales
//
//  Created by mac on 16/06/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

class ActivityParticipatDisplay: UIViewController, UIGestureRecognizerDelegate {
    var tap: UITapGestureRecognizer!
    var activity:Activity!
    
    @IBOutlet weak var tblparticiapntDisplay: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: method
    func setUI(){
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
         tap.numberOfTapsRequired = 1
         tap.numberOfTouchesRequired = 1
         tap.cancelsTouchesInView = false
         tap.delegate = self
            self.view.window?.isUserInteractionEnabled = true
         self.view.window?.addGestureRecognizer(tap)
        tblparticiapntDisplay.delegate = self
        tblparticiapntDisplay.dataSource = self
        tblparticiapntDisplay.setCommonFeature()
        
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.tblparticiapntDisplay)
      
       if self.tblparticiapntDisplay.point(inside: location, with: nil) {
            return false
        }
        else {
            return true
        }
    }

    @objc private func onTap(sender: UITapGestureRecognizer) {
        self.view.window?.removeGestureRecognizer(sender)
       if let topviewcontroller = UIApplication.shared.keyWindow?.rootViewController as? UIViewController{
           Utils.removeShadow(view: topviewcontroller.view)
       }
       // Utils.removeShadow(view:  self.view)
      //  self.dismiss(animated: true, completion: nil)
        self.dismiss(animated:true, completion: {
            Utils.removeShadow(view: self.view)
        })
    }
    
    //MARK: IBAction
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated:true, completion: {
            Utils.removeShadow(view: self.view)
        })
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
extension ActivityParticipatDisplay:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.activityParticipantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblparticiapntDisplay.dequeueReusableCell(withIdentifier: "activityparticipantcell", for: indexPath) as? ActivityParticipantCell{
          if  let selecteadparticipant = activity.activityParticipantList[indexPath.row] as? ActivityParticipant{
            cell.lblCustomername.text = selecteadparticipant.customerName
            cell.lblCustomerContact.text = String.init(format:"Mobile No:   \(selecteadparticipant.customerMobile)")
            cell.selectionStyle = .none
          }
            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    
}
