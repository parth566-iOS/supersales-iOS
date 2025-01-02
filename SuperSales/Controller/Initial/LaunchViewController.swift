//
//  LaunchViewController.swift
//  SuperSales
//
//  Created by mac on 19/11/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet var imgCompsnyLogo: UIImageView!
    var  img:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utils.hexStringToUIColor(hex: "0x2A718E")
        if let activeuser = Utils().getActiveAccount(){
        
            print("not got the image \(activeuser.picture)")
            img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 144, height: 144))
            self.img.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(img)
            self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: img, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
            self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: img, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 30))
           
            
            
            self.img.sd_setImage(with: URL.init(string: activeuser.picture ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
          
                if(err == nil){
                    print("got the image")
                    self.img.isHidden = false
                    self.img.cornerRadius = 5
                    self.img.image = img
                    self.img.cornerRadius = 5
                    self.img.addBorders(edges: .all, color: .clear, cornerradius: 5)
//                    self.statusImage1 = img ?? UIImage()
//                    self.statusImg1 = IDMPhoto.init(url: urlofimage)
//                    let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img1Tapped))
//                    self.statusimg1.isUserInteractionEnabled = true
//                    self.statusimg1.addGestureRecognizer(imggesture)
                }else{
                    print("not got the image \(activeuser.picture)")
                    self.img.image = nil
                    self.img.isHidden = true
                }
           
            }
        }else{
            self.img.image = nil 
        }
        makeServiceCall()
        // Do any additional setup after loading the view.
    }
    
    private func makeServiceCall() {
     
        self.view?.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.view?.removeFromSuperview()
            if UserDefaults.standard.bool(forKey: Constant.kIsSyncDone) {
                AppDelegate.shared.rootViewController.switchToMainScreen()
            } else {
                AppDelegate.shared.rootViewController.showLoginScreen()
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
