//
//  OverlayViewController.swift
//  Wodeo 2
//
//  Created by Gareth Long on 16/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit
import AVFoundation

protocol OverlayDelegate {
   
    func overlayDidCancel()
    func overlayDidSave()
   
}

class OverlayViewController: UIViewController,StopWatchDelegate,CameraManagerDelegate {

    
    var videoManager:CameraManager?
    
    //Layout variables
    let sbw:CGFloat = 60.0
    let sbh:CGFloat = 60.0
    let slh:CGFloat = 70.0
    var fw:CGFloat {
       return view.frame.size.width
    }
    var fh:CGFloat {
        return view.frame.size.height
    }
    
    //Overlay settings
    var delegate:OverlayDelegate?
    var workOut:WOD?
    var videoSettings:VideoSettings!
    var hasCountDown:Bool = false
    
    //Overlay views
    var cancelButton:UIButton!
    var saveButton:UIButton!
    var countDownLabel = TimeTextLabel(fontSize: 30.0)
    //var testView:UIImageView!
    
    var countDownStopWatch = StopWatch(type:StopWatchType.CountDown)
    
    
    
    
    // Lay out functions
    func layOutForPortrait() {
        
       // testView.frame = view.bounds
        
      //  view.addSubview(testView)
        
        
        saveButton.frame = CGRectMake(fw - sbw,fh-sbh,sbw,sbh)
        cancelButton.frame = CGRectMake(0.0, fh-sbh, sbw, sbh)
        
        countDownLabel.frame = CGRectMake(0.0, 0.0, fw,fw * 0.5)
        countDownLabel.position = CGPointMake(fw / 2,fh / 2)
        
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.layer.addSublayer(countDownLabel)
        
        addPulsing()
    }
    
    func layOutForLandscapeLeft(){
        
        saveButton.frame = CGRectMake(fw - sbw,0.0,sbw,sbh)
        cancelButton.frame = CGRectMake(fw - sbw,fh - sbh, sbw, sbh)
        
        countDownLabel.frame = CGRectMake(0.0, 0.0, fw,fw * 0.5)
        countDownLabel.position = CGPointMake(fw / 2,fh / 2)
        countDownLabel.transform = CATransform3DRotate(countDownLabel.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
        
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.layer.addSublayer(countDownLabel)
        
        addPulsing()
    }
    
    func layOutForLandscapeRight(){
        
        saveButton.frame = CGRectMake(0.0,fh - sbh,sbw,sbh)
        cancelButton.frame = CGRectMake(0.0,0.0, sbw, sbh)
        
        countDownLabel.frame = CGRectMake(0.0, 0.0,fw,fw * 0.5)
        countDownLabel.position = CGPointMake(fw / 2,fh / 2)
        countDownLabel.transform = CATransform3DRotate(countDownLabel.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.layer.addSublayer(countDownLabel)
        
        addPulsing()

    }
    
    func createUI(){
        
        
       // testView = UIImageView(image: UIImage(named: "bg2.png"))
        
        saveButton = UIButton(type:.Custom)
        saveButton.setTitle("", forState: .Normal)
        saveButton.setImage(UIImage(named:"Recording")!, forState: .Normal)
        saveButton.addTarget(self, action: #selector(OverlayViewController.saveButtonPressed), forControlEvents:.TouchUpInside)
        
        cancelButton = UIButton(type:.Custom)
        cancelButton.setTitle("", forState: .Normal)
        cancelButton.setImage(UIImage(named:"cancelButton")!, forState: .Normal)
        cancelButton.addTarget(self, action: #selector(OverlayViewController.cancelButtonPressed), forControlEvents:.TouchUpInside)
        
        countDownLabel = TimeTextLabel(fontSize: 30.0)
        countDownLabel.fontSize = fw * 0.25
        countDownLabel.alignmentMode = kCAAlignmentCenter
    
    }

    
    func initiateCountDownTimer(){
        countDownStopWatch.delegate = self
        countDownStopWatch.countDownFromSeconds = videoSettings.videoDelay
        countDownStopWatch.start()
    }
    
    
    //Stop watch timer delegate methods for countdown timer
    func stopWatchDidCountDown(t: TimeInterval) {
        countDownStopWatch.stop()
    }
    
    func stopWatchDidUpdateWithTimeInterval(t: TimeInterval) {
         countDownLabel.string = t.intervalString(false)
    }
    
    
    //Button methods
    
    func saveButtonPressed(){
         countDownStopWatch.stop()
        let cWorkOut = workOut as! StandardWOD
        cWorkOut.stopWorkOut()
        videoManager!.stopRecordingVideo { (videoURL, error) -> Void in
            
        }
    }
    
    func cameraManagerDidGenerateVideoAsset(url: NSURL) {
        print("Got URL of imgae : \(url.absoluteString)")
    }
    
    func cancelButtonPressed(){
        
        countDownStopWatch.stop()
        self.delegate!.overlayDidCancel()
    }
       
    
    //Initialization
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Lay out depending on the orientation of the screen
        switch videoSettings.videoOrientation! {
                case .Portrait:layOutForPortrait()
                case .LandscapeLeft:layOutForLandscapeLeft()
                case .LandscapeRight:layOutForLandscapeRight()
                default: print("Orientation not set when moving from video to over lay")
        }
        
        initiateCountDownTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasCountDown = videoSettings.videoDelay > 0
        //Create all the buttons ready to be layed out later
        createUI()
    }
    override  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        modalPresentationStyle = .OverCurrentContext
    }
    
    
    //View animtions
    func addPulsing() {
        
        let alphaChange = CAKeyframeAnimation(keyPath:"opacity")
        alphaChange.duration = 2.0
        alphaChange.values = [1.0,0.2,1.0]
        alphaChange.keyTimes = [0.0,0.4,0.8]
        alphaChange.removedOnCompletion = false
        alphaChange.repeatCount = HUGE
        alphaChange.calculationMode = kCAAnimationPaced
        
        let pulsing = CAKeyframeAnimation(keyPath: "transform.scale")
        
        pulsing.duration = 2.0
        
        pulsing.values = [1.0,0.8,1.0]
        pulsing.keyTimes = [0.0,0.4,0.8]
        
        pulsing.removedOnCompletion = false
        pulsing.repeatCount = HUGE
        pulsing.calculationMode = kCAAnimationPaced
        
        //set background color
        saveButton.tintColor = UIColor.redColor()
        let layer = saveButton.layer
        layer.addAnimation(pulsing, forKey: "pulsing")
        layer.addAnimation(alphaChange, forKey: "alpha")
    }
    
    
    //Adimin
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
