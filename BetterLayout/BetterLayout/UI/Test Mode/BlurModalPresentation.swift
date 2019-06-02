//
//  BlurModalPresentation.swift
//  Trading
//
//  Created by Vlad Che on 3/11/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

class BlurModalPresentation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var destinationView : UIView!
    var animator: UIViewPropertyAnimator?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        destinationView = toVc!.view
        destinationView.alpha = 0.0
        
        blurView.effect = nil
        blurView.frame = containerView.bounds
        
        self.blurTransition(transitionContext) {
            self.unBlur(transitionContext, completion: {
                self.blurView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
        containerView.addSubview(toVc!.view)
        containerView.addSubview(blurView)
    }
    
    //This methods add the blur to our view and our destinationView
    func blurTransition(_ context : UIViewControllerContextTransitioning,completion: @escaping () -> Void){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.transitionDuration(using: context) / 2,
                                                       delay: 0, options: .curveLinear,
                                                       animations: {
            self.destinationView.alpha = 0.5
            self.blurView.effect = UIBlurEffect(style: .dark)
        }, completion: { (position) in
            completion()
        })
    }
    //This Method remove the blur view with an animation
    func unBlur(_ context : UIViewControllerContextTransitioning,completion: @escaping () -> Void){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.transitionDuration(using: context) / 2,
                                                       delay:0,
                                                       options: .curveLinear, animations: {
            self.destinationView.alpha = 1.0
            self.blurView.effect = nil
        }, completion: { (position) in
            completion()
        })
    }
    
}
