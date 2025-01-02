//
//  NamePictureCell.swift
//  SuperSales
//
//  Created by Apple on 17/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
class TitleCell:UITableViewCell{
    
    @IBOutlet weak var btnTitle: UIButton!
}
class NamePictureCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var pictureImageView: UIImageView?
    
//    var item: ProfileViewModelItem? {
//        didSet {
//            guard let item = item as? ProfileViewModelNamePictureItem else {
//                return
//            }
//
//            nameLabel?.text = item.name
//            pictureImageView?.image = UIImage(named: item.pictureUrl)
//        }
//    }
    
//    static var nib:UINib {
//        return UINib(nibName: identifier, bundle: nil)
//    }
//
//    static var identifier: String {
//        return String(describing: self)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        pictureImageView?.layer.cornerRadius = 50
        pictureImageView?.clipsToBounds = true
        pictureImageView?.contentMode = .scaleAspectFit
        pictureImageView?.backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView?.image = nil
    }
}
