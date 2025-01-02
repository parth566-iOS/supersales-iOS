//
//  FilterPopUp.swift
//  SuperSales
//
//  Created by Apple on 27/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
//protocol FilterPopUpDelegate{
//    func btnCloseTapped(sender: UIButton)
//}
class FilterPopUp: UIView {
    var   popview = UIView.init()
    var btnClose = UIButton()
    //var delegate: FilterPopUpDelegate?
     func showpopup(list:[String],btnparent:UIButton,parentView:UIView){
        
        let verticalStackView = UIStackView()
        
        btnClose.frame = CGRect.init(x: parentView.frame.size.width - 50, y: 100 , width: 40, height: 40)
        btnClose.backgroundColor = .gray
        verticalStackView.backgroundColor = .green
        btnClose.setImage(UIImage.init(named: "icon_close"), for: .normal)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.isUserInteractionEnabled = true
        btnClose.backgroundColor = .green
        btnClose.addTarget(self, action: #selector(btnCloseTapped(_:)), for: .touchUpInside)
        popview.backgroundColor = .red
        for title in 0...list.count-1 {
            let btn = UIButton.init(type: .custom)
            btn.setTitle(list[title], for: .normal)
            btn.backgroundColor = .blue
            btn.frame = CGRect.init(x: 0, y: title*40, width: 200, height: 40)
            verticalStackView.addArrangedSubview(btn)
        }
        var allConstraints: [NSLayoutConstraint] = []
        popview.addSubview(btnClose)
        popview.isUserInteractionEnabled = true
       
        verticalStackView.isUserInteractionEnabled = true
        popview.addSubview(verticalStackView)
        
        parentView.isUserInteractionEnabled = false
      //  parentView.addSubview(popview)
        UIApplication.shared.windows.first?.addSubview(popview)
        popview.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        let views = ["view":popview ,"btnparent":btnparent,"verticalStackView":verticalStackView,"btnClose":btnClose]//
            
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.isUserInteractionEnabled = true
        btnClose.addTarget(self, action: #selector(btnCloseTapped(_:)), for: .touchUpInside)
       
        let matrics = ["viewHeight" : CGFloat(list.count * 40) , "viewWidth" : CGFloat(200.0),"viewTop": CGFloat(btnparent.frame.origin.y + btnparent.frame.size.height + 10),"btnHeight" :  CGFloat(40.0),"btnWidth" :  CGFloat(90.0),"verticalStackViewHeight":CGFloat(list.count * 40),"verticalStackViewWidth" : CGFloat(200.0),"btnLeading":CGFloat(150),"popviewleading":CGFloat(parentView.frame.size.width - 220.0) ]//
        
        let horizontalConstraintForPopUp = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(popviewleading)-[view(viewWidth)]",options: [], metrics: matrics, views: views)
        allConstraints.append(contentsOf: horizontalConstraintForPopUp)
        let verticalConstraintForPopUp =  NSLayoutConstraint.constraints(withVisualFormat: "V:|-(viewTop)-[view(viewHeight)]", metrics: matrics,views: views)//[view(viewHeight)]
        allConstraints.append(contentsOf: verticalConstraintForPopUp)
        let verticalConstraintForbtnClose =  NSLayoutConstraint.constraints(withVisualFormat: "V:[btnClose(btnHeight)][verticalStackView]", metrics: matrics,views: views)//[view(viewHeight)]
        allConstraints.append(contentsOf: verticalConstraintForbtnClose)
       /* let horizontalConstraint1 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[btnClose(btnWidth)]-|",options: [.alignAllCenterY], metrics: matrics, views: views)
        allConstraints.append(contentsOf: horizontalConstraint1)
        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[verticalStackView(verticalStackViewWidth)]-|",options: [.alignAllCenterY], metrics: matrics, views: views)
        allConstraints.append(contentsOf: horizontalConstraint)*/
//        let verticalConstraint1 =  NSLayoutConstraint.constraints(withVisualFormat: "V:|-viewTop-[btnClose(btnHeight)][verticalStackView(verticalStackViewHeight)]|", metrics: matrics,views: views)//[view(viewHeight)]
//        allConstraints.append(contentsOf: verticalConstraint1)
//        let verticalConstraint =  NSLayoutConstraint.constraints(withVisualFormat: "V:|-viewTop-[btnClose(btnHeight)][verticalStackView(verticalStackViewHeight)]|", metrics: matrics,views: views)//[view(viewHeight)]
//        allConstraints.append(contentsOf: verticalConstraint)
       
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(popviewTapped))
        gesture.numberOfTapsRequired = 1
        popview.isUserInteractionEnabled = true
        popview.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate(allConstraints)
        popview.layoutIfNeeded()
        
        popview.layoutSubviews()
        
        //
    }
    @objc func popviewTapped(){
        popview.removeFromSuperview()
    }
    @objc func btnCloseTapped(_ sender: UIButton){
        
        popview.removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
