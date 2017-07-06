//
//  SettingsViewController.swift
//  Wodeo 2
//
//  Created by Gareth Long on 21/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,ViewCanceling {

    var wod:WOD!
    var delegate:ViewCanceling!
    
    @IBOutlet weak var minuteLabel:UILabel!
    @IBOutlet weak var secondLabel:UILabel!
    @IBOutlet weak var minuteStepper:UIStepper!
    @IBOutlet weak var secondStepper:UIStepper!
    
    var minStepperPV:Double = 0.0
    var secStepperPV:Double = 0.0
    
    
    @IBAction func minuteStepperChanged(sender:UIStepper){
        
        
        if shouldWarnUser(){
            if sender.value > minStepperPV {
                sender.value -= 1
            }
            warnUser()
        }else{
            minuteLabel.text = "\(Int(minuteStepper.value))"
        }
    }
    
    @IBAction func secondStepperChanged(sender:UIStepper){
        if shouldWarnUser(){
            if sender.value > secStepperPV{
                sender.value -= 1
            }
            warnUser()
        }else{
            secondLabel.text = "\(Int(secondStepper.value))"
        }
    }
    
    func shouldWarnUser() -> Bool{
       
    let total = (minuteStepper.value * 60) + (secondStepper.value)
        
    if !UserSettings.sharedInstance.getPurchasedVideo() && total > wod.totalVideoSecondsAllowed {
            return true
       }else{
        return false
       }
    }
    
    func warnUser(){
        let infoView = UIAlertController(title: "5 Minute Limit", message: "If you like our app, unlock more minutes and help support future great features, with the 'Unlimited Video' purchase. (It's as cheap as they would allow us!)", preferredStyle: UIAlertControllerStyle.Alert)
        infoView.view.tintColor = UIColor(red: 240/255.0, green: 178/255.0, blue: 71/255.0, alpha: 1.0)
        
        let ok = UIAlertAction(title:"Lets Go!", style: UIAlertActionStyle.Default, handler:{
            (alert:UIAlertAction!) -> Void in
            
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WodeoStore") as! WodeoProductPage
            viewController.delegate = self
            self.presentViewController(viewController, animated: true, completion: nil)
           

        })
        
        let no = UIAlertAction(title: "No thanks..", style: UIAlertActionStyle.Cancel, handler:{ (alert:UIAlertAction!) -> Void in
        })
        
        infoView.addAction(ok)
        infoView.addAction(no)
        
        presentViewController(infoView, animated:true, completion:nil)
    }
    
    @IBAction func done(sender:UIButton) {
        performSegueWithIdentifier("goToCamera", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCamera" {
        let vc = segue.destinationViewController as! VideoViewController
        let cWOD = wod as! CountDownWOD
        cWOD.setCountDownTime(countDownTime())
        vc.workout = cWOD
        vc.delegate = self
        }
        
    }
    
    @IBAction func cancel(sender:UIButton) {
        delegate.viewDidCancel()
    }
    
    func countDownTime() -> Int {
        return Int((minuteStepper.value * 60) + (secondStepper.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func viewDidCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
}
