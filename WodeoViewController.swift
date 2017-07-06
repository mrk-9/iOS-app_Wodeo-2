//
//  WodeoViewController.swift
//  Wodeo 2
//
//  Created by Gareth Long on 16/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit


class WodeoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func orientationChanged() {
        
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
