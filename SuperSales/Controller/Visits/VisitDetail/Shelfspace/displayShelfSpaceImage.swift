//
//  displayShelfSpaceImage.swift
//  SuperSales
//
//  Created by Apple on 07/07/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class displayShelfSpaceImage: BaseViewController {
    var activityIndicator:UIActivityIndicatorView!
    var urlForImage:String!
    @IBOutlet weak var imgShelfSpace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
            self.imgShelfSpace.backgroundColor = .black
        activityIndicator.center = self.imgShelfSpace.center
        self.imgShelfSpace.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        Common.getImageFromURL(strURL: urlForImage) { (ImgForShelfSpace) in
             DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.imgShelfSpace.backgroundColor = .clear
            self.imgShelfSpace.image = ImgForShelfSpace
            }
        }
        // Do any additional setup after loading the view.
    }


}
