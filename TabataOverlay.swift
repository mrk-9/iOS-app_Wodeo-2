//
//  TabataOverlay.swift
//  Wodeo 2
//
//  Created by Gareth Long on 27/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class TabataOverlay: OverlayViewController ,WODDelegate,TabataWOD_Delegate,ResultsControllerDelegate {

    var tabataWOD:TabataWOD!
    @IBOutlet weak var mainRotatorView:RotatorView!
    var repCountLabel = TimeTextLabel(fontSize:30.0)
    var roundCountLabel = TimeTextLabel(fontSize: 30.0)
    var restingLabel = TimeTextLabel(fontSize: 100.0)
    //layout vars
    let counterLH:CGFloat = 35.0
    
    var isResting = false
    
    
    
    //View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        print("Interval layout is loading")
        
        tabataWOD = workOut as! TabataWOD
        tabataWOD.delegate = self
        tabataWOD.tabataDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    //Stop watch delegate
    override func stopWatchDidCountDown(t: TimeInterval) {
        super.stopWatchDidCountDown(t)
        tabataWOD.startWorkOut()
        addButtonUI()
        
    }
    
    
    //Create and layout the UI
    override func createUI() {
        super.createUI()
        
    }
    
    func addButtonUI(){
        
        let addRepButton = TiledView()
        addRepButton.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)
        addRepButton.instruction = "Add Rep"
        addRepButton.top = true
        addRepButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(TabataOverlay.addRep(_:))))
        mainRotatorView.addSubview(addRepButton)
        
        restingLabel.string = "WORK"
        
        UIView.animateWithDuration(0.5, animations:{
            self.mainRotatorView.alpha = 1.0
        })
    }
    
    
    override func layOutForPortrait() {
        super.layOutForPortrait()
        repCountLabel.frame = CGRectMake(2.0, 0.0, fw,counterLH)
        roundCountLabel.frame = CGRectMake(2.0, counterLH,fw, counterLH)
        restingLabel.frame = CGRectMake(0.0, fh - 200.0, fw, 200.0)
        restingLabel.alignmentMode = kCAAlignmentCenter
        
        
        view.layer.addSublayer(restingLabel)
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
        
        restingLabel.frame = CGRectMake(0.0,0.0, fw, 200.0)
        restingLabel.position = CGPointMake(fw - 100.0, fh/2)
        restingLabel.alignmentMode = kCAAlignmentCenter
        restingLabel.transform = CATransform3DRotate(restingLabel.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
        
        view.layer.addSublayer(restingLabel)
        
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
        
        restingLabel.frame = CGRectMake(0.0,0.0, fw, 200.0)
        restingLabel.position = CGPointMake(100.0, fh/2)
        restingLabel.alignmentMode = kCAAlignmentCenter
        restingLabel.transform = CATransform3DRotate(restingLabel.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        view.layer.addSublayer(restingLabel)

        
        view.layer.addSublayer(repCountLabel)
        view.layer.addSublayer(roundCountLabel)
        
        
        mainRotatorView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))
        
        
    }
    
    
    
    //Wod delegate
    func wodStopWatchDidUpdateToValue(timeValue: String) {
        countDownLabel.string = timeValue
    }
    
    func workOutDidEnd() {
        tabataWOD.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
        }
    }
    
    //Tabata WOD delegate
    func tabataWODDidMoveToRoundWithName(name: String) {
        repCountLabel.string = ""
        roundCountLabel.string = name
    }
    
    func tabataWODDidMoveToRestPeriod() {
        isResting = true
        restingLabel.string = "REST"
        restingLabel.foregroundColor = UIColor.redColor().CGColor

    }
    
    func tabataWODDidMoveOutOfRestPeriod() {
        isResting = false
        restingLabel.string = "WORK"
        restingLabel.foregroundColor = UIColor.greenColor().CGColor
    }
    
    
    
    
    
    //Buttons
    func addRep(sender:UITapGestureRecognizer){
        
        if !isResting {
            if sender.state == .Ended{
                repCountLabel.string = tabataWOD.addRep()
            }
        }
        
    }
    
    override func cancelButtonPressed(){
        super.cancelButtonPressed()
        tabataWOD.stopWorkOut()
        
    }
    
    override func cameraManagerDidGenerateVideoAsset(url: NSURL) {
        
        super.cameraManagerDidGenerateVideoAsset(url)
        //Add overlay and set it as the video manager
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabataResultsVC") as! TabataResultsVC
        presentViewController(viewController, animated: true, completion: nil)
        viewController.tabataWOD = tabataWOD
        viewController.videoToMakeURL = url
        viewController.delegate = self
    }
    
    func resultsDidCancel() {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    override func saveButtonPressed(){
        countDownStopWatch.stop()
        let cWorkOut = workOut as! TabataWOD
        cWorkOut.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
            
        }
    }

}
