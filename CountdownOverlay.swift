//
//  CountdownOverlay.swift
//  Wodeo 2
//
//  Created by Gareth Long on 21/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class CountdownOverlay: OverlayViewController ,WODDelegate , ResultsControllerDelegate{

    //Downcast the work out to the current workout
    var countDownWorkOut:CountDownWOD!
    
    
    
    @IBOutlet weak var topView:RotatorView!
    @IBOutlet weak var bottomView:RotatorView!
    
    //Views specific to Standard overlay
    var repCountLabel = TimeTextLabel(fontSize: 30.0)
    var roundCountLabel = TimeTextLabel(fontSize: 30.0)
    
    //layout vars
    let counterLH:CGFloat = 35.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDownWorkOut = workOut as! CountDownWOD
        countDownWorkOut.delegate = self
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        view.sendSubviewToBack(testView)
//    }
    
    override func layOutForPortrait() {
        super.layOutForPortrait()
        repCountLabel.frame = CGRectMake(2.0, 0.0, fw,counterLH)
        roundCountLabel.frame = CGRectMake(2.0, counterLH,fw, counterLH)
        
        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)    }
    
    override func layOutForLandscapeLeft() {
        super.layOutForLandscapeLeft()
        
        let labelWidth = (fh/2) - 5.0
        
        repCountLabel.frame = CGRectMake(0.0, 0.0,labelWidth, counterLH)
        repCountLabel.alignmentMode = kCAAlignmentRight
        repCountLabel.position = CGPointMake(counterLH / 2,labelWidth/2)
        repCountLabel.transform = CATransform3DRotate(repCountLabel.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
        
        roundCountLabel.frame = CGRectMake(0.0, 0.0,labelWidth, counterLH)
        roundCountLabel.position = CGPointMake(counterLH / 2,(fh - (labelWidth / 2)) - 5)
        roundCountLabel.transform = CATransform3DRotate(roundCountLabel.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)
        
        
        
    }
    
    override func layOutForLandscapeRight() {
        super.layOutForLandscapeRight()
        
        let labelWidth = (fh/2) - 5.0
        
        repCountLabel.frame = CGRectMake(0.0, 0.0,labelWidth, counterLH)
        repCountLabel.alignmentMode = kCAAlignmentRight
        repCountLabel.position = CGPointMake(fw - (counterLH / 2),(fh - (labelWidth / 2)) - 5)
        repCountLabel.transform = CATransform3DRotate(repCountLabel.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        roundCountLabel.frame = CGRectMake(0.0, 0.0,labelWidth, counterLH)
        roundCountLabel.position = CGPointMake(fw - (counterLH / 2),labelWidth/2)
        roundCountLabel.transform = CATransform3DRotate(roundCountLabel.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)
        
        
        topView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))
        bottomView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))

        
    }
    
    override func cancelButtonPressed(){
        super.cancelButtonPressed()
        countDownWorkOut.stopWorkOut()
    }
    
    
    override func stopWatchDidCountDown(t: TimeInterval) {
        super.stopWatchDidCountDown(t)
        //the count down timer has stopped so add the count up timer
        countDownWorkOut.startWorkOut()
        addButtonUI()
    }
    
    func addButtonUI(){
        
        let buffer:CGFloat = 20.0
        
        let addRepButton = TiledView()
        addRepButton.frame = CGRectMake(0.0, 0.0, topView.frame.size.width - buffer, topView.frame.size.height - buffer)
        addRepButton.center = CGPointMake(topView.frame.size.width / 2, topView.frame.size.height / 2)
        addRepButton.instruction = "Add Rep"
        addRepButton.top = true
        addRepButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(CountdownOverlay.addRep(_:))))
        topView.addSubview(addRepButton)
        
        let addRoundButton = TiledView()
        addRoundButton.frame = CGRectMake(0.0, 0.0, bottomView.frame.size.width - buffer, bottomView.frame.size.height - buffer)
        addRoundButton.center = CGPointMake(bottomView.frame.size.width / 2, bottomView.frame.size.height / 2)
        addRoundButton.instruction = "Add Round"
        addRoundButton.top = false
        addRoundButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(CountdownOverlay.addRound(_:))))
        bottomView.addSubview(addRoundButton)


        
        
        UIView.animateWithDuration(0.5, animations:{
            self.topView.alpha = 1.0
            self.bottomView.alpha = 1.0
        })
    }
    
    
    func addRep(sender:UITapGestureRecognizer){
        countDownWorkOut.addRep()
        repCountLabel.string = "Reps:\(countDownWorkOut.rounds.last!.reps.count)"
    }
    
    func addRound(sender:UITapGestureRecognizer){
        countDownWorkOut.addRound()
        roundCountLabel.string = "Rounds:\(countDownWorkOut.rounds.count)"
        repCountLabel.string = "Reps:\(countDownWorkOut.rounds.last!.reps.count)"
    }
    
    //Wod delegate methods
    func wodStopWatchDidUpdateToValue(timeValue: String) {
        countDownLabel.string = (timeValue)
    }
    
    func workOutDidEnd() {
        countDownStopWatch.stop()
        let cWorkOut = workOut as! CountDownWOD
        cWorkOut.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
            
        }

    }
    
    override func cameraManagerDidGenerateVideoAsset(url: NSURL) {
        
        super.cameraManagerDidGenerateVideoAsset(url)
        //Add overlay and set it as the video manager
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("countDownResults") as! CountDownResultsVC
        presentViewController(viewController, animated: true, completion: nil)
        viewController.countDownWorkout = countDownWorkOut
        viewController.videoToMakeURL = url
        viewController.delegate = self
    }
    
    override func saveButtonPressed(){
        countDownStopWatch.stop()
        let cWorkOut = workOut as! CountDownWOD
        cWorkOut.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
            
        }
    }

    
    func resultsDidCancel() {
        dismissViewControllerAnimated(false, completion: {
            
            self.delegate!.overlayDidCancel()
            
        })
    }
    
    
}

    
    
    
