//
//  MainMenuTableViewController.swift
//  Wodeo 2
//
//  Created by Gareth Long on 15/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

protocol ViewCanceling {
    func viewDidCancel()
}

class MainMenuTableViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,BallicticStashDelegate,ViewCanceling {

    @IBOutlet weak var tableView:UITableView!
    
    var menuItems = [(String,String,String)]()

    var wodToSend:WOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        //tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        tableView.contentInset = UIEdgeInsetsMake(9.0, 0.0, 0.0, 0.0)
        
        menuItems.append(("Standard","STANDARD","FOR TIME"))
        menuItems.append(("CountDown","COUNTDOWN","AMRAP"))
        menuItems.append(("Interval","INTERVAL",""))
        menuItems.append(("8","TABATA",""))
        
        
                
    }
    
    func ballisticStachDidReturn() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MainMenuCell

        cell.title.text = menuItems[indexPath.row].1
        cell.subTitle.text = menuItems[indexPath.row].2
        cell.cellImage.image = UIImage(named: menuItems[indexPath.row].0)

        return cell
    }
    
       
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK: - Table view delegate
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    switch indexPath.row {
        case 0:
            wodToSend = StandardWOD(with: "STANDARD")
            performSegueWithIdentifier("videoViewcontroller", sender: nil)
            
        case 1:
            wodToSend = CountDownWOD(with:"AMRAP")
            performSegueWithIdentifier("countDownSettings", sender: nil)
            
        case 2:
            wodToSend = IntervalWOD(with:"INTERVAL")
            performSegueWithIdentifier("interval", sender: nil)
            
        case 3:
            wodToSend = TabataWOD(with: "TABATA")
            performSegueWithIdentifier("tabata", sender: nil)
        default:print("No cell selected")
            
        }
    }

    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case "videoViewcontroller":
            if !UserSettings.sharedInstance.getUserVideoMessageOptOut(){
                let infoView = UIAlertController(title: "5 Minute Limit", message: "If you like our app, unlock more minutes and help support future great features, with the 'Unlimited Video' purchase. (It's as cheap as they would allow us!)", preferredStyle: UIAlertControllerStyle.Alert)
                infoView.view.tintColor = UIColor(red: 240/255.0, green: 178/255.0, blue: 71/255.0, alpha: 1.0)
                
                let ok = UIAlertAction(title:"Lets Go!", style: UIAlertActionStyle.Default, handler:{
                    (alert:UIAlertAction!) -> Void in
                    self.performSegueWithIdentifier("wodeoProducts", sender: nil)
                })
                
                let no = UIAlertAction(title: "No thanks..", style: UIAlertActionStyle.Cancel, handler:{ (alert:UIAlertAction!) -> Void in
                    UserSettings.sharedInstance.saveUserVideoMessageOptOut()
                    self.performSegueWithIdentifier("videoViewcontroller", sender: nil)
                })
                
                infoView.addAction(ok)
                infoView.addAction(no)
                
                presentViewController(infoView, animated:true, completion:nil)
                return false
            }else{
                return true 
            }
            
        default:
            return true
        }
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if !shouldPerformSegueWithIdentifier(segue.identifier!, sender: sender){
            return
        }
        
        switch segue.identifier! {
        case "wodeoProducts" :print("Going to products")
            let vc = segue.destinationViewController as! WodeoProductPage
            vc.delegate = self
            
        case "videoViewcontroller":
            
            let vc = segue.destinationViewController as! VideoViewController
            vc.workout = wodToSend
            vc.delegate = self
        
        case "countDownSettings" :
            let vc = segue.destinationViewController as! SettingsViewController
            vc.wod = wodToSend
            vc.delegate = self
        
        case "interval" :
            let vc = segue.destinationViewController as! IntervalSettingsVC
            vc.wod = wodToSend
            vc.delegate = self
            
        case "tabata" :
            let vc = segue.destinationViewController as! TabataSettingsVC
            vc.wod = wodToSend
            vc.delegate = self
            
        default:print("Dont know what was picked")
        }
        

    }
    
    //View cancelling delegate
    func viewDidCancel() {
        dismissViewControllerAnimated(true, completion:nil)
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
}
