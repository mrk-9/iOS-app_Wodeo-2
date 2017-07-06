//
//  StandardResultsVC.swift
//  Wodeo 2
//
//  Created by Gareth Long on 19/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit
import AVFoundation

class StandardResultsVC: ResultsViewController {
    
    var standardWorkout:StandardWOD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        workOutName.text = standardWorkout.name
        
        let formater = NSDateFormatter()
        formater.dateStyle = .FullStyle
        workOutDate.text = formater.stringFromDate(standardWorkout.startDate)
        
    }
    
    //Table view dataSource Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return standardWorkout.rounds.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Round \(section + 1)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standardWorkout.rounds[section].reps.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
            cell.textLabel!.text = standardWorkout.rounds[indexPath.section].titleForRepAtIndex(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame:CGRectMake(0.0,0.0,300.0,70.0))
        titleLabel.font = UIFont(name:"Folio-BoldCondensed", size: 30.0)
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        titleLabel.textColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
                
        let contView = UIView(frame: titleLabel.frame)
        contView.addSubview(titleLabel)
        
        return contView
    }
    
     override func applyVideoEffectsToComposition(composition: AVMutableVideoComposition, size: CGSize) {
        
        super.applyVideoEffectsToComposition(composition, size: size)
        
        overlayLayer.addSublayer(layerGenerator.timerView(size, forSeconds:Int(standardWorkout.totalWorkOutSeconds.secondsAsDouble!), withDelay: standardWorkout.countDownTime,countUp: true))
        
        overlayLayer.addSublayer(layerGenerator.standardWorkOutInfo(size, workOut:standardWorkout,withDelay:standardWorkout.countDownTime))
        
        parentLayer.addSublayer(overlayLayer)
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
        
        
    }
   
}
