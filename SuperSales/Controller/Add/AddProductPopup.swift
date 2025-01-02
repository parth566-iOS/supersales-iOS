
//
//  AddProductPopup.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class AddProductPopup: UIView {
    // swiftlint:disable line_length
    var view:UIView = UIView()
    
    func displayPopup(parentView:UIView)->(){
        let btnClose:UIButton = UIButton()
        btnClose.setImage(UIImage.init(named: "icon_close_gray"), for: .normal)
        parentView.addSubview(view)
        view.addSubview(btnClose)
        
        parentView.isUserInteractionEnabled = false
      //  btnClose.translatesAutoresizingMaskIntoConstraints = false
       // view.translatesAutoresizingMaskIntoConstraints = false
       
        
       btnClose.frame = CGRect.init(x: 50, y: 50, width: 50, height: 50)
       
        parentView.addConstraints([NSLayoutConstraint.init(item: view, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1.0, constant: 20),NSLayoutConstraint.init(item:parentView , attribute: .trailing, relatedBy: .equal, toItem: view , attribute: .trailing, multiplier: 1.0, constant: 20),NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1.0, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant:parentView.frame.size.width - 40 ),NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: parentView.frame.size.width - 40),NSLayoutConstraint.init(item:view, attribute: .trailing, relatedBy: .equal, toItem: btnClose , attribute: .trailing, multiplier: 1.0, constant: 0),NSLayoutConstraint.init(item:view, attribute: .top, relatedBy: .equal, toItem: btnClose , attribute: .top, multiplier: 1.0, constant: 0)])
        
        btnClose.addConstraints([NSLayoutConstraint.init(item: btnClose, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant:50),NSLayoutConstraint.init(item: btnClose, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant:50)])
         btnClose.addTarget(self, action: #selector(btnCloseTapped), for: .touchUpInside)
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400).isActive = true
        view.frame = CGRect.init(x: 20, y: parentView.frame.size.height/2, width: parentView.frame.size.width-40, height: 300)
         btnClose.center = view.center
      /*  let viewsdic = ["mainview":view,"closebutton":btnClose]
        let matric = ["mainviewheight":200,"btnCloseHeight":50.0,"btnCloseWidth":50.0]
        var allConstraints: [NSLayoutConstraint] = []
        let horizontalconstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[mainview]-20-|", options: [.alignAllCenterX], metrics: matric, views: viewsdic)
        let horizontalContraintForCloseBtn = NSLayoutConstraint.constraints(withVisualFormat: "H:[closebutton(btnCloseWidth)]", options: [], metrics: matric, views: viewsdic)
        allConstraints.append(contentsOf:horizontalContraintForCloseBtn)
        allConstraints.append(contentsOf:horizontalconstraint)
       let verticalconstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[mainview]-100-|", options: [.alignAllCenterY], metrics: matric, views: viewsdic)
        let verticalContraintForCloseBtn = NSLayoutConstraint.constraints(withVisualFormat: "V:[closebutton(btnCloseHeight)]", options: [.alignAllTrailing], metrics: matric, views: viewsdic)
        allConstraints.append(contentsOf:verticalContraintForCloseBtn)
         allConstraints.append(contentsOf:verticalconstraint)
        
        NSLayoutConstraint.activate(allConstraints)*/
        view.backgroundColor  = .red
        btnClose.backgroundColor = .green
        view.isUserInteractionEnabled = true
        btnClose.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        
    }
    @objc func viewTapped(){
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @objc func btnCloseTapped(){
        
    }

}
