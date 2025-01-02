//
//  Filter.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
protocol FilterDelegate {

}
class Filter: BaseViewController {
    var parentView:UIButton!
   var delegate:FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
       
       // self.view.frame =  CGRect.init(x: Int(parentView.frame.origin.x - (parentView.frame.size.width)/2) , y: Int(parentView.frame.origin.y + parentView.frame.size.height), width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height))
        //
        // Do any additional setup after loading the view.
    }
    
//    func frameOfPresentedViewInContainerView() -> CGRect {
//        return CGRect.init(x: Int(parentView.frame.origin.x - (parentView.frame.size.width)/2) , y: Int(parentView.frame.origin.y + parentView.frame.size.height), width: Int(containerView!.frame.size.width), height: Int(containerView!.frame.size.height))
//    }
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
/*
final class CardPresentationController: UIPresentationController {
    var touchForwardingView:UIView = UIView()
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let height: CGFloat = 200
        return CGRect(x: 0, y: containerView!.bounds.height - height, width: containerView!.bounds.width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView()
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        touchForwardingView = PSPDFTouchForwardingView(frame: containerView!.bounds)
        touchForwardingView.passthroughViews = [presentingViewController.view];
        containerView?.insertSubview(touchForwardingView, at: 0)
    }
}
class CardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresentedViewController presented: UIViewController,
                                presenting: UIViewController?,
                                sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return CardPresentationController(presentedViewController: presented,
                                          presenting: presenting)
    }
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentationAnimator()
    }
    
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissionAnimator()
    }
}
class CardPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        toViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        toViewController.view.layer.shadowColor = UIColor.black.cgColor
        toViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toViewController.view.layer.shadowOpacity = 0.3
        toViewController.view.layer.cornerRadius = 4.0
        toViewController.view.clipsToBounds = true
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: animationDuration, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
        
    }
}
class CardDismissionAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
*/
