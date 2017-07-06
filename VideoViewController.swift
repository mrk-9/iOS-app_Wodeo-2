//
//  VideoViewController.swift
//  Video Testing
//
//  Created by Gareth Long on 11/02/2016.
//  Copyright © 2016 gazlongapps. All rights reserved.
//

import UIKit

struct VideoSettings {
    var videoOrientation:UIDeviceOrientation!
    var videoDelay:Int!
}

enum VideoQuality:String {
    case High = "High"
    case Med = "Med"
    case Low = "Low"
}



class VideoViewController: UIViewController,OverlayDelegate {

    let videoManager = CameraManager()
    var infoViewController:InfoViewController?
    var currentVideoQuality = VideoQuality.High
    
    var workout:WOD?
    
    var delegate:ViewCanceling!
    
    @IBOutlet weak var topView: RotatorView!
    @IBOutlet weak var bottomView: RotatorView!
    @IBOutlet weak var recordButtonView: RotatorView!
    
    @IBOutlet weak var topViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var recButtonLayoutConstraint: NSLayoutConstraint!
   // @IBOutlet weak var videoQualityButton:UIButton!
    @IBOutlet weak var videoDelayButton:UIButton!
    
    @IBOutlet weak var videoPreview: UIView!
    
    @IBOutlet weak var titleView:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restoreUserSettings()

        
             NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoViewController.orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)
            videoManager.addPreviewLayerToView(videoPreview)
    }
    
    func restoreUserSettings(){
        //Video quality
        setVideoQuality(UserSettings.sharedInstance.getVideoQuality())
        //Delay Settings
        setDelay(UserSettings.sharedInstance.getDelay())
        //Flip Settings
        setCameraFlip(UserSettings.sharedInstance.getCameraFlip())
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        titleView.text = workout!.name
    }
    
    //MARK: Buttons

    
    @IBAction func startRecording(sender: AnyObject) {
        
            view.layoutIfNeeded()
        
        self.topViewLayoutConstraint.constant = -self.topView.frame.size.height
        self.bottomViewLayoutConstraint.constant = -self.bottomView.frame.size.height
        self.recButtonLayoutConstraint.constant = -self.bottomView.frame.size.height

        
        //Remove top and bottom views
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        
        //Add overlay and set it as the video manager
        switch workout!.name {
            case "STANDARD":
                 let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StandardVideoOverlay") as! StandardOverlay
                  //set the viewcontroller properties
                  viewController.videoSettings = VideoSettings(videoOrientation: currentOrientation(), videoDelay:currentVideoDelay)
                  viewController.delegate = self
                  viewController.videoManager = videoManager
                  workout!.countDownTime = currentVideoDelay
                  viewController.workOut = workout
                  videoManager.delegate = viewController
                  presentViewController(viewController, animated: true, completion: nil)
            
            case "AMRAP":
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CountdownOverlay") as! CountdownOverlay
                //set the viewcontroller properties
                viewController.videoSettings = VideoSettings(videoOrientation: currentOrientation(), videoDelay:currentVideoDelay)
                viewController.delegate = self
                viewController.videoManager = videoManager
                workout!.countDownTime = currentVideoDelay
                viewController.workOut = workout
                videoManager.delegate = viewController
                presentViewController(viewController, animated: true, completion: nil)

            case "INTERVAL":
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("IntervalOverlay") as! IntervalOverlay
                //set the viewcontroller properties
                viewController.videoSettings = VideoSettings(videoOrientation: currentOrientation(), videoDelay:currentVideoDelay)
                viewController.delegate = self
                viewController.videoManager = videoManager
                workout!.countDownTime = currentVideoDelay
                viewController.workOut = workout
                videoManager.delegate = viewController
                presentViewController(viewController, animated: true, completion: nil)
            
            case "TABATA":
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabataOverlay") as! TabataOverlay
                //set the viewcontroller properties
                viewController.videoSettings = VideoSettings(videoOrientation: currentOrientation(), videoDelay:currentVideoDelay)
                viewController.delegate = self
                viewController.videoManager = videoManager
                workout!.countDownTime = currentVideoDelay
                viewController.workOut = workout
                videoManager.delegate = viewController
                presentViewController(viewController, animated: true, completion: nil)

            
            default:
                print("Dont know that workout")
            
        }
        
                 
                
        videoManager.cameraOutputMode = CameraOutputMode.VideoWithMic
        videoManager.startRecordingVideo()
        
        
        
        
    }
    
    
    @IBAction func getIntructions(sender:AnyObject) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Annotation") as! InfoViewController
        viewController.alpha = 0.5
        presentViewController(viewController, animated: true, completion: nil)
        infoViewController = viewController
    }
    
    @IBAction func cancel(sender:UIButton){
        videoManager.stopAndRemoveCaptureSession()
        delegate.viewDidCancel()
    }
    
    
    
    
    //settings handles
    
    
    @IBAction func flipCamera(sender: AnyObject) {
        
        if videoManager.cameraDevice == CameraDevice.Front {
            setCameraFlip(.Back)
        }else{
            setCameraFlip(.Front)
        }
    }
    
    func setCameraFlip(flip:CameraDevice){
        videoManager.cameraDevice = flip
        UserSettings.sharedInstance.saveCameraFlip(flip)
    }

    var currentVideoDelay = 5
    @IBAction func switchVideoDelay(sender:UIButton){
        switch sender.titleLabel!.text! {
            case " 5":setDelay(10)
            currentVideoDelay = 10
            case " 10":setDelay(15)
            currentVideoDelay = 15
            case " 15":setDelay(20)
            currentVideoDelay = 20
            case " 20":setDelay(60)
            currentVideoDelay = 60
            case " 1M":setDelay(300)
            currentVideoDelay = 300
            case " 5M":setDelay(5)
            currentVideoDelay = 5
            default:setDelay(5)
            currentVideoDelay = 5
        }
        
    }
    
    func setDelay(delay:Int){
        switch delay {
        case 5:videoDelayButton.setTitle(" 5", forState:.Normal)
        case 10:videoDelayButton.setTitle(" 10", forState:.Normal)
        case 15:videoDelayButton.setTitle(" 15", forState:.Normal)
        case 20:videoDelayButton.setTitle(" 20", forState:.Normal)
        case 60:videoDelayButton.setTitle(" 1M", forState:.Normal)
        case 300:videoDelayButton.setTitle(" 5M", forState:.Normal)
        default:videoDelayButton.setTitle(" 5", forState:.Normal)
        }
        
        UserSettings.sharedInstance.saveDelay(delay)

    }
    
    @IBAction func switchQuality(sender:UIButton){
        
        switch currentVideoQuality {
        case .High :
            setVideoQuality(VideoQuality.Med)
        case .Med  :
            setVideoQuality(VideoQuality.Low)
        case .Low  :
            setVideoQuality(VideoQuality.High)
        }
    }

    func setVideoQuality(quality:VideoQuality){
        switch quality {
        case .High :
                    currentVideoQuality = .High
                    videoManager.cameraOutputQuality = CameraOutputQuality.High
                    //videoQualityButton.setImage(UIImage(named: "HighVideoQuality"), forState: .Normal)
                    UserSettings.sharedInstance.saveVideoQuality(.High)
        case .Med  :
                    currentVideoQuality = .Med
                    videoManager.cameraOutputQuality = CameraOutputQuality.Medium
                    //videoQualityButton.setImage(UIImage(named: "MedVideoQuality"), forState:.Normal)
                    UserSettings.sharedInstance.saveVideoQuality(.Med)
        case .Low :
                    currentVideoQuality = .Low
                    videoManager.cameraOutputQuality = CameraOutputQuality.Low
                    //videoQualityButton.setImage(UIImage(named: "LowVideoQuality"), forState: .Normal)
                    UserSettings.sharedInstance.saveVideoQuality(.Low)
        }

        
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

    
     func orientationChanged() {
        self.topView.rotateViewsToMatchOrientation(currentOrientation())
        self.bottomView.rotateViewsToMatchOrientation(currentOrientation())
        self.recordButtonView.rotateViewsToMatchOrientation(currentOrientation())
    }
    
    
    
    
    
    //Overlay delagate
    func overlayDidSave() {
        print("stop recording")
        videoManager.stopRecordingVideo { (videoURL, error) -> Void in
            print("\(videoURL!.absoluteString)")
        }
    }
        
                
    
    
    func overlayDidCancel() {
        dismissViewControllerAnimated(true, completion:{
            
            self.view.layoutIfNeeded()
            
            self.topViewLayoutConstraint.constant = 0
            self.bottomViewLayoutConstraint.constant = 0
            self.recButtonLayoutConstraint.constant = 0
            
            
            //Remove top and bottom views
            UIView.animateWithDuration(0.1, animations: {
                
                
                self.view.layoutIfNeeded()
                
            })

        
        })
    }
    
}
