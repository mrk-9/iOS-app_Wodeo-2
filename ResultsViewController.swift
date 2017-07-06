//
//  ResultsViewController.swift
//  Wodeo 2
//
//  Created by Gareth Long on 18/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit
import AVFoundation

protocol ResultsControllerDelegate {
    func resultsDidCancel()
}

class ResultsViewController: VideoMaker,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    
    
    //View outlets
    @IBOutlet weak var workOutDate: UILabel!
    @IBOutlet weak var workOutName: UILabel!
    @IBOutlet weak var carriedOutByTextfield: UITextField!
    @IBOutlet weak var judgedByTextField:UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    var overlayLayer:CALayer!
    var parentLayer:CALayer!
    var videoLayer:CALayer!
    var layerGenerator = VideoOverlayGenerator()
    
    var delegate:ResultsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserSettings.sharedInstance.getStandardName() != "" {
            carriedOutByTextfield.text = UserSettings.sharedInstance.getStandardName()
        }
        
        if UserSettings.sharedInstance.getJudgeName() != "" {
            judgedByTextField.text = UserSettings.sharedInstance.getJudgeName()
        }
    }
    
    
    //Textfield delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()    
        return true
    }
    
    //Table view dataSource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        
        
        return cell
    }
    
    
    
    //Button actions
    @IBAction func cancelButton(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title:"Are you sure, the video will be lost?", message: "", preferredStyle:UIAlertControllerStyle.ActionSheet)
        let harmful = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler:{
            (alert:UIAlertAction!) -> Void in
               self.delegate!.resultsDidCancel()
            })
        let cancel = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        optionMenu.addAction(harmful)
        optionMenu.addAction(cancel)
        
        presentViewController(optionMenu, animated: true, completion: nil)
        
        
    }
    @IBAction func saveVideo(sender: AnyObject) {
        
        if carriedOutByTextfield.text != "" {
            UserSettings.sharedInstance.saveStandardName(carriedOutByTextfield.text!)
        }
        
        if judgedByTextField.text != "" {
            UserSettings.sharedInstance.saveJudgeName(judgedByTextField.text!)
        }
        
        
        let infoView = UIAlertController(title: "Create video", message: "Your video will be saved to your video library in a folder called 'Wodeo 2'. This may take some time depending on video length and quality.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title:"Lets Go!", style: UIAlertActionStyle.Default, handler:{
            
            (alert:UIAlertAction!) -> Void in
            
            self.showWorkingsOut()
            self.videoOutput()
        })
        
        infoView.addAction(ok)
        
        presentViewController(infoView, animated:true, completion:nil)
        
        
    }
    
    func showWorkingsOut(){
        workOutName.hidden = true
        workOutDate.hidden = true
        progressLabel.hidden = false
        progressView.hidden = false
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ResultsViewController.progressTimerUpdated(_:)), userInfo: nil, repeats:true)
        
        
        
    }
    
    func progressTimerUpdated(timer:NSTimer){
        progressView.progress = exporter.progress
        
        let frmt = NSNumberFormatter()
        frmt.numberStyle = NSNumberFormatterStyle.PercentStyle
        let currentPercentage = frmt.stringFromNumber(NSNumber(float:exporter.progress))
        progressLabel.text = "Creating your video: \(currentPercentage!)"
        
        if exporter.progress == 1.0 {
            timer.invalidate()
            progressLabel.text = "Done!"
            delegate!.resultsDidCancel()
        }
        
        
    }
    
    //Admin
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func applyVideoEffectsToComposition(composition: AVMutableVideoComposition, size: CGSize) {
        
        parentLayer = CALayer()
        parentLayer.frame = CGRectMake(0.0, 0.0, size.width, size.height)
        videoLayer = CALayer()
        videoLayer.frame = CGRectMake(0.0, 0.0, size.width, size.height)
        parentLayer.addSublayer(videoLayer)
        overlayLayer = CALayer()
        overlayLayer.frame = CGRectMake(0, 0, size.width, size.height)
        overlayLayer.masksToBounds = true
        
        
        overlayLayer.addSublayer(layerGenerator.logo(size))
        overlayLayer.addSublayer(layerGenerator.workOutAndDate(size, withText:"\(workOutName.text!) \(workOutDate.text!)"))
        
        if carriedOutByTextfield.text != "" {
            overlayLayer.addSublayer(layerGenerator.carriedOutBy(size, withText:"Carried out by: \(carriedOutByTextfield.text!)"))
        }
        
        if judgedByTextField.text != "" {
            overlayLayer.addSublayer(layerGenerator.judgedBy(size, withText:"Judged by: \(judgedByTextField.text!)"))
        }
        
        overlayLayer.addSublayer(layerGenerator.mainBackingLayer(size))

        
    }
    
    func stringForWorkOurDetails() -> String {
        return "OverRide"
    }

    
    
}
