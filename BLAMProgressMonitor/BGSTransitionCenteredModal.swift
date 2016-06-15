//
//  BGSTransitionCenteredModal.swift
//  BrightAssetManager
//
//  Created by Peter Todd Air on 02/10/2015.
//  Copyright © 2015 Bright Green Star. All rights reserved.
//

import UIKit

class BGSTransitionCenteredModal: NSObject, UIViewControllerTransitioningDelegate {
    let transitionLogon = BGSTransitionCenteredAnimator()
    var originCallingFrame:CGRect = CGRect.zero
    
    
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
            transitionLogon.presenting = true
            transitionLogon.originFrame = originCallingFrame
            
            return transitionLogon
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
    
    
    
    
}
