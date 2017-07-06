//
//  TabataSettingsVC.swift
//  Wodeo 2
//
//  Created by Gareth Long on 27/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class TabataSettingsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,ViewCanceling  {

    var wod:WOD!
    var delegate:ViewCanceling?
    
    var rounds = [PresetRound]()
    
    @IBOutlet weak var loopLabel:UILabel!
    @IBOutlet weak var roundLabel:UILabel!
    @IBOutlet weak var loopStepper:UIStepper!
    @IBOutlet weak var roundStepper:UIStepper!
    @IBOutlet weak var restLabel:UILabel!
    @IBOutlet weak var restStepper:UIStepper!
    @IBOutlet weak var tableView:UITableView!
    
    
    var restStepperPV = 0.0
    var loopStepperPV = 0.0
    var roundStepperPV = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var counter = 0
        while counter < 8 {
            let round = PresetRound(roundNumber:counter + 1, presetDuration: 20,loopNumber:1)
            rounds.append(round)
            counter += 1
        }
        
        restStepper.value = 10
        roundStepper.value = 8
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func restStepperChanged(sender:UIStepper){
        
        if sender.value < restStepperPV{
            restLabel.text = "\(Int(sender.value))"
            restStepperPV = sender.value
            return
        }
        
        if shouldWarnUser(){
            if sender.value > restStepperPV {
                sender.value -= 1
                restStepperPV = sender.value
            }
            warnUser()
        }else{
            restLabel.text = "\(Int(sender.value))"
            restStepperPV = sender.value
        }
        
        
    }
    
    
    @IBAction func loopStepperChanged(sender:UIStepper){
        
        if sender.value < loopStepperPV{
            loopLabel.text = Int(sender.value).timesThrough()
            loopStepperPV = sender.value
            return
        }
        
        if shouldWarnUser(){
            if sender.value > loopStepperPV {
                sender.value -= 1
            }
            warnUser()
        }else{
            loopLabel.text = Int(sender.value).timesThrough()
            loopStepperPV = sender.value
        }

    }
    
    @IBAction func roundStepperChanged(sender:UIStepper){
        
        if sender.value < roundStepperPV{
            roundLabel.text = "\(Int(sender.value))"
            
            if Int(sender.value) == rounds.count {
                return
            }
            
            if Int(sender.value) <= rounds.count {
                rounds.removeLast()
            }else{
                let newRound = PresetRound(roundNumber:rounds.count + 1, presetDuration: 20,loopNumber:1)
                rounds.append(newRound)
            }
            
            tableView.reloadData()
            roundStepperPV = sender.value
            return
        }
        
        if shouldWarnUser(){
            if sender.value > roundStepperPV {
                sender.value -= 1
            }
            warnUser()
        }else{
        
        roundLabel.text = "\(Int(sender.value))"
        
        if Int(sender.value) == rounds.count {
            return
        }
        
        if Int(sender.value) <= rounds.count {
            rounds.removeLast()
        }else{
            let newRound = PresetRound(roundNumber:rounds.count + 1, presetDuration: 20,loopNumber:1)
            rounds.append(newRound)
        }
        
        tableView.reloadData()
        roundStepperPV = sender.value
        }
    }
    
    func shouldWarnUser() -> Bool {
        var totalSecondsInRounds = 0
        for r in rounds {
            totalSecondsInRounds += r.presetDuration
        }
        
        let totalRest = restStepper.value * (Double(rounds.count) - 1)
        
        let total = Double(totalRest + Double(totalSecondsInRounds)) * loopStepper.value
        
        return total > wod.totalVideoSecondsAllowed ? true : false
        
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

    
    @IBAction func cancel(sender:AnyObject){
        if let del = delegate {
            del.viewDidCancel()
        }else{
            print("Delegate not set")
        }
    }
    
    @IBAction func go(sender:AnyObject){
        
        
        
        performSegueWithIdentifier("goToVideo", sender: nil)
        
    }
    
    
    //UITableView Delegate
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let stepper = UIStepper(frame:CGRectMake(cell.frame.width - 102,(cell.frame.height / 2) - 14.5,94,29))
        stepper.maximumValue = 10000
        stepper.minimumValue = 1
        stepper.wraps = false
        stepper.addTarget(self, action:#selector(TabataSettingsVC.cellStepperChanged(_:)), forControlEvents:.ValueChanged)
        stepper.tag = indexPath.row
        stepper.tintColor = UIColor(red: 240/255.0, green: 178/255.0, blue: 71/255.0, alpha: 1.0)
        
        
        cell.addSubview(stepper)
        
        cell.textLabel!.text = "Round \(rounds[indexPath.row].roundNumber)"
        
        let roundDuration = rounds[indexPath.row].presetDuration
        
        stepper.value = Double(roundDuration)
        
        if roundDuration <= 59 {
            cell.detailTextLabel!.text = "\(Double(rounds[indexPath.row].presetDuration).stringForTimeInterval(false)) seconds"
        }else{
            cell.detailTextLabel!.text = "\(Double(rounds[indexPath.row].presetDuration).stringForTimeInterval(false))"
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func cellStepperChanged(sender:UIStepper) {
        rounds[sender.tag].presetDuration = Int(sender.value)
        tableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToVideo" {
            let vc = segue.destinationViewController as! VideoViewController
            vc.delegate = self
            let intWOD = wod as! TabataWOD
            
            
            intWOD.rounds = gererateRounds()
            intWOD.loops = Int(loopStepper.value)
            intWOD.restPeriodBetweenRounds = Int(restStepper.value)
            vc.workout = intWOD
            
            
            
            var counter = 1
            for r in intWOD.rounds {
                print("Round \(counter) Loop = \(r.loopNumber)")
                counter += 1
            }
            
        }
    }
    
    func gererateRounds() -> [PresetRound] {
        
        var loopCounter = 0
        var roundCounter = 0
        var proccessedRounds = [PresetRound]()
        
        
        while loopCounter < Int(loopStepper.value) {
            for r in rounds {
                proccessedRounds.append(PresetRound(roundNumber: r.roundNumber, presetDuration:r.presetDuration, loopNumber: loopCounter + 1))
                roundCounter += 1
            }
            loopCounter += 1
        }
        
        return proccessedRounds
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func viewDidCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
