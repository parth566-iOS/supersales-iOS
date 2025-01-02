//
//  SplashViewController.swift
//  RootControllerNavigation
//
//  Created by Stanislav Ostrovskiy on 12/5/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    var splashviewParent:UIView?
    var  img:UIImageView!
    var imgviewsplash:UIImageView!
    var lblAppName:UILabel!
    var lblEmpowers:UILabel!
  //  @IBOutlet var imgCompsnyLogo: UIImageView!
 //   private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.hexStringToUIColor(hex: "#2A718E")
        splashviewParent = UIView.init()
      //  self.view.backgroundColor = UIColor.red
      
        //
      //  makeServiceCall()
        
//        activityIndicator.frame = view.bounds
//        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
//        activityIndicator.startAnimating()
        self.setSplashScreen()
        
    }
    //makeServiceCall()
    func setSplashScreen(){
     //   activityIndicator.stopAnimating()
        if var splashview = splashviewParent{
         splashview = UIView.init(frame: self.view.frame)
       
        imgviewsplash = UIImageView.init(image: UIImage.init(named: "App_Logo"))
        imgviewsplash.frame = CGRect.init(x: 0, y: 0, width: 144, height: 144)
        lblAppName = UILabel.init(frame:CGRect.init(x: 20, y: 20, width: 200, height: 50))
        lblAppName.text = "SuperSales"
        lblAppName.font = UIFont.boldSystemFont(ofSize: 35)
        lblAppName.textColor = UIColor.white
        lblEmpowers = UILabel.init(frame:CGRect.init(x: 20, y: 20, width: 200, height: 50))
        lblEmpowers.text = "Empowers"
        lblEmpowers.font = UIFont.boldSystemFont(ofSize: 35)
        lblEmpowers.textColor = UIColor.white
        lblEmpowers.backgroundColor = UIColor.clear
        lblEmpowers.translatesAutoresizingMaskIntoConstraints = false
        lblAppName.backgroundColor = UIColor.clear
        lblAppName.translatesAutoresizingMaskIntoConstraints = false
        //    self.lblEmpowers.isHidden =  true
        
       
        self.view.addSubview(splashview)
        imgviewsplash.translatesAutoresizingMaskIntoConstraints = false
        lblEmpowers.translatesAutoresizingMaskIntoConstraints = false
        lblAppName.translatesAutoresizingMaskIntoConstraints = false
        splashview.addSubview(imgviewsplash)
        splashview.addSubview(self.lblAppName)
        splashview.addSubview(self.lblEmpowers)
        
     //   splashview.addSubview(self.imgviewsplash)
       
        self.view.addConstraints([NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: splashview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0),
        NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: splashview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0),
        NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: splashview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
        NSLayoutConstraint.init(item: self.view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: splashview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)])
            
        //for label
        splashview.addConstraints([NSLayoutConstraint.init(item: splashview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lblAppName, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
                               
            NSLayoutConstraint.init(item: lblAppName, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: splashview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 70
            ),
            
            NSLayoutConstraint.init(item: lblAppName, attribute: NSLayoutConstraint.Attribute.width
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           , relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 150),
            
            NSLayoutConstraint.init(item: lblAppName, attribute: NSLayoutConstraint.Attribute.height
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     , relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 42)])
            //For Label empowers
            splashview.addConstraints([NSLayoutConstraint.init(item: splashview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lblEmpowers, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: lblEmpowers, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imgviewsplash, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 40),
                NSLayoutConstraint.init(item: lblEmpowers, attribute: NSLayoutConstraint.Attribute.width
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               , relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 150),
                NSLayoutConstraint.init(item: lblEmpowers, attribute: NSLayoutConstraint.Attribute.height
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         , relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 42)])
        
//        //for app logo
            splashview.addConstraint(NSLayoutConstraint.init(item: splashview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imgviewsplash, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
            splashview.addConstraint(NSLayoutConstraint.init(item: imgviewsplash, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem:lblAppName , attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 50))
            
            
            imgviewsplash.addConstraints([NSLayoutConstraint.init(item: imgviewsplash, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 144),NSLayoutConstraint.init(item: imgviewsplash, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 144)])
            
        
//        //self.view.addSubview(splashview ?? UIView())
        if let activeuser = Utils().getActiveAccount(){
        
            print("not got the image \(activeuser.picture)")
            img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 144, height: 144))
            self.img.translatesAutoresizingMaskIntoConstraints = false
            splashview.addSubview(img)
            splashview.addConstraint(NSLayoutConstraint.init(item: splashview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: img, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
            splashview.addConstraint(NSLayoutConstraint.init(item: img, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lblEmpowers, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 40))
            img.addConstraints([NSLayoutConstraint.init(item: img, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 144),NSLayoutConstraint.init(item: img, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 144)])
            
            
            self.img.sd_setImage(with: URL.init(string: activeuser.company?.logo ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
         
                if(err == nil){
                    print("got the image")
                    self.img.isHidden = false
                  //  self.lblEmpowers.isHidden = false
                    self.img.image = img

                }else{
                    print("not got the image \(activeuser.picture)")
                    self.img.image = nil
                    self.img.isHidden = true
                   // self.lblEmpowers.isHidden =  true
                    
                }
           
            }
        }
        }
        makeServiceCall()
    }
    private func makeServiceCall() {
     
        self.splashviewParent?.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            self.splashviewParent?.removeFromSuperview()
            if UserDefaults.standard.bool(forKey: Constant.kIsSyncDone) {
                AppDelegate.shared.rootViewController.switchToMainScreen()
            } else {
                AppDelegate.shared.rootViewController.showLoginScreen()
            }
        }
    }
}
