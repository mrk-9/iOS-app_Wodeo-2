//
//  StandardOverlay.swift
//  Wodeo 2
//
//  Created by Gareth Long on 16/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit
import AVFoundation

class StandardOverlay: OverlayViewController,WODDelegate,ResultsControllerDelegate {

    
    //Down cast the work out to the current work out
    var standardWorkOut:StandardWOD!
    
    @IBOutlet weak var topView:RotatorView!
    @IBOutlet weak var bottomView:RotatorView!
    
    //Views specific to Standard overlay
    var repCountLabel = TimeTextLabel(fontSize: 30.0)
    var roundCountLabel = TimeTextLabel(fontSize: 30.0)
    
    //layout vars
    let counterLH:CGFloat = 35.0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        standardWorkOut = workOut as! StandardWOD
        standardWorkOut.delegate = self
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        view.sendSubviewToBack(testView)
//    }
    
    
    override func layOutForPortrait() {
        super.layOutForPortrait()
        repCountLabel.frame = CGRectMake(fw * 0.6, 0.0, fw * 0.4,counterLH)
        roundCountLabel.frame = CGRectMake(fw * 0.6, counterLH, fw * 0.6, counterLH)
        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)
    }
    
    override func layOutForLandscapeLeft() {
        super.layOutForLandscapeLeft()
        
        repCountLabel.frame = CGRectMake(0.0, 0.0, fw * 0.4, counterLH)
        repCountLabel.position = CGPointMake(counterLH / 2,fh / 2)
        repCountLabel.transform = CATransform3DRotate(repCountLabel.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)

        roundCountLabel.frame = CGRectMake(0.0, 0.0, fw * 0.4, counterLH)
        roundCountLabel.position = CGPointMake(counterLH / 2,fw * 0.4)
        roundCountLabel.transform = CATransform3DRotate(roundCountLabel.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)

               
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)
        
               
    }
    
    override func layOutForLandscapeRight() {
        super.layOutForLandscapeRight()
        
        repCountLabel.frame = CGRectMake(0.0, 0.0, fw * 0.4, counterLH)
        repCountLabel.position = CGPointMake(fw - (counterLH / 2),fh / 2)
        repCountLabel.transform = CATransform3DRotate(repCountLabel.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        roundCountLabel.frame = CGRectMake(0.0, 0.0, fw * 0.4, counterLH)
        roundCountLabel.position = CGPointMake(fw - (counterLH / 2),fh * 0.8)
        roundCountLabel.transform = CATransform3DRotate(roundCountLabel.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)

        topView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))
        bottomView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))
        
    }
    
    override func cancelButtonPressed(){
        super.cancelButtonPressed()
        standardWorkOut.stopWorkOut()
    }

    
    override func stopWatchDidCountDown(t: TimeInterval) {
        super.stopWatchDidCountDown(t)
        //the count down timer has stopped so add the count up timer
        standardWorkOut.startWorkOut()
        addButtonUI()
    }

    func addButtonUI(){
        
        let buffer:CGFloat = 20.0
        
        let addRepButton = TiledView(frame: CGRectMake(0.0, 0.0, topView.frame.size.width - buffer, topView.frame.size.height - buffer))
        addRepButton.center = CGPointMake(topView.frame.size.width / 2, topView.frame.size.height / 2)
        addRepButton.instruction = "Add Rep"
        addRepButton.top = true
        addRepButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(StandardOverlay.addRep(_:))))
        topView.addSubview(addRepButton)
        
        let addRoundButton = TiledView(frame:CGRectMake(0.0, 0.0, bottomView.frame.size.width - buffer, bottomView.frame.size.height - buffer))
        addRoundButton.top = false
        addRoundButton.frame = CGRectMake(0.0, 0.0, bottomView.frame.size.width - buffer, bottomView.frame.size.height - buffer)
        addRoundButton.center = CGPointMake(bottomView.frame.size.width / 2, bottomView.frame.size.height / 2)
        addRoundButton.instruction = "Add Round"
        addRoundButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(StandardOverlay.addRound(_:))))
        bottomView.addSubview(addRoundButton)

        
        
        UIView.animateWithDuration(0.5, animations:{
            self.topView.alpha = 1.0
            self.bottomView.alpha = 1.0
        })
    }
    
    
    func addRep(sender:UITapGestureRecognizer){
       standardWorkOut.addRep()
       repCountLabel.string = "Reps:\(standardWorkOut.rounds.last!.reps.count)"
    }
    
    func addRound(sender:UIGestureRecognizer){
        standardWorkOut.addRound()
        roundCountLabel.string = "Rounds:\(standardWorkOut.rounds.count)"
        repCountLabel.string = "Reps:\(standardWorkOut.rounds.last!.reps.count)"
    }
    
    //Wod delegate methods
    func wodStopWatchDidUpdateToValue(timeValue: String) {
        if standardWorkOut.workOutTime > workOut!.totalVideoSecondsAllowed{
            countDownStopWatch.stop()
            let cWorkOut = workOut as! StandardWOD
            cWorkOut.stopWorkOut()
            videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
                
            }
 
        }
       countDownLabel.string = timeValue
    }
    
    override func cameraManagerDidGenerateVideoAsset(url: NSURL) {
        
        super.cameraManagerDidGenerateVideoAsset(url)
        //Add overlay and set it as the video manager
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("resultsScreen") as! StandardResultsVC
        presentViewController(viewController, animated: true, completion: nil)
        viewController.standardWorkout = standardWorkOut
        viewController.videoToMakeURL = url
        viewController.delegate = self
    }
        
    func resultsDidCancel() {
        dismissViewControllerAnimated(false, completion: {
            
            self.delegate!.overlayDidCancel()
        
        })
    }
    
    func workOutDidEnd() {
        print("Work out ended")
    }
    
        
    }

    
    

