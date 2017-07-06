//
//  IntervalOverlay.swift
//  Wodeo 2
//
//  Created by Gareth Long on 22/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class IntervalOverlay: OverlayViewController ,WODDelegate,IntervalWOD_Delegate,ResultsControllerDelegate  {

    var intervalWOD:IntervalWOD!
    @IBOutlet weak var mainRotatorView:RotatorView!
    var repCountLabel = TimeTextLabel(fontSize:30.0)
    var roundCountLabel = TimeTextLabel(fontSize: 30.0)
    //layout vars
    let counterLH:CGFloat = 35.0

    
    
    //View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        print("Interval layout is loading")
        
        intervalWOD = workOut as! IntervalWOD
        intervalWOD.delegate = self
        intervalWOD.intervalDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    //Stop watch delegate
    override func stopWatchDidCountDown(t: TimeInterval) {
        super.stopWatchDidCountDown(t)
        intervalWOD.startWorkOut()
        addButtonUI()
        
    }
    
    
    //Create and layout the UI
    override func createUI() {
        super.createUI()
        
    }
    
    func addButtonUI(){
        
        let addRepButton = TiledView()
        addRepButton.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)
        addRepButton.instruction = "Add Repp"
        addRepButton.top = true
        addRepButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(IntervalOverlay.addRep(_:))))
        mainRotatorView.addSubview(addRepButton)
        
        UIView.animateWithDuration(0.5, animations:{
            self.mainRotatorView.alpha = 1.0
        })
    }

    
    override func layOutForPortrait() {
        super.layOutForPortrait()
        repCountLabel.frame = CGRectMake(2.0, 0.0, fw,counterLH)
        roundCountLabel.frame = CGRectMake(2.0, counterLH,fw, counterLH)
        
        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)
    }
    
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
        
        
        mainRotatorView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))


    }

    
    
    //Wod delegate
    func wodStopWatchDidUpdateToValue(timeValue: String) {
        countDownLabel.string = timeValue
    }
    
    func workOutDidEnd() {
        intervalWOD.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
        }
    }
    
    //Interval WOD delegate
    func intervalWODDidMoveToRoundWithName(name: String) {
        repCountLabel.string = ""
        roundCountLabel.string = name
    }
    
    //Buttons
    func addRep(sender:UITapGestureRecognizer){
        if sender.state == .Ended{
           repCountLabel.string = intervalWOD.addRep()
        }
        
    }
    
    override func cancelButtonPressed(){
        super.cancelButtonPressed()
        intervalWOD.stopWorkOut()
    
    }
    
    override func cameraManagerDidGenerateVideoAsset(url: NSURL) {
        
        super.cameraManagerDidGenerateVideoAsset(url)
        //Add overlay and set it as the video manager
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("IntervalResults") as! IntervalResultsVC
        presentViewController(viewController, animated: true, completion: nil)
        viewController.intervalWOD = intervalWOD
        viewController.videoToMakeURL = url
        viewController.delegate = self
    }

    func resultsDidCancel() {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    override func saveButtonPressed(){
        countDownStopWatch.stop()
        let cWorkOut = workOut as! IntervalWOD
        cWorkOut.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
            
        }
    }

    
}
