//
//  RotatorView.swift
//  Video Testing
//
//  Created by Gareth Long on 12/02/2016.
//  Copyright © 2016 gazlongapps. All rights reserved.
//

import UIKit

class RotatorView: UIView {

    func rotateViewsToMatchOrientation(orientation:UIDeviceOrientation){
        
        let animationDuration = 0.5
        var rotation:CGFloat = 0.0
        
        switch orientation {
                
        case.LandscapeLeft:rotation = CGFloat(-M_PI_2)
        case.LandscapeRight:rotation = CGFloat(M_PI_2)
        case.Portrait: rotation = 0.0
        case.PortraitUpsideDown:rotation = CGFloat(2 * M_PI_2)
        default: rotation = 0.0
        }
        
        
        for childView in self.subviews {
            
            
            if !childView.isKindOfClass(UILabel) {
                UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping:1.0, initialSpringVelocity: 2.0, options:.TransitionNone, animations:{
                
                        childView.transform = CGAffineTransformMakeRotation(rotation)

                }, completion:nil)
            }
            
                
        }
        
    }

}
