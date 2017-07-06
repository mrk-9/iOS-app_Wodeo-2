//
//  InfoViewController.swift
//  Wodeo 2
//
//  Created by Gareth Long on 16/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class InfoViewController: SpotlightViewController {

    @IBOutlet var annotationViews: [UIView]!
    @IBOutlet var rotatorView:RotatorView!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InfoViewController.orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)
        delegate = self
    }
    
    func next(labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.Oval(center: CGPointMake(screenSize.width - 34,30), diameter: 60))
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(32,28), diameter: 60))
        case 2:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(screenSize.width - 45,screenSize.height - 50), diameter: 60))
        case 3:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(animated: Bool) {
        annotationViews.enumerate().forEach { index, view in
            UIView .animateWithDuration(animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
    
    
    func orientationChanged() {
    self.rotatorView.rotateViewsToMatchOrientation(currentOrientation())
}

func currentOrientation() -> UIDeviceOrientation {
    
    switch UIDevice.currentDevice().orientation {
    case .LandscapeLeft:
        return .LandscapeRight
    case .LandscapeRight:
        return .LandscapeLeft
    case .PortraitUpsideDown:
        return .PortraitUpsideDown
    default:
        return .Portrait
    }
}
    
    override func prefersStatusBarHidden() -> Bool {
       return true
    }

}

extension InfoViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}

