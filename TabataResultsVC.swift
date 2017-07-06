//
//  TabataResultsVC.swift
//  Wodeo 2
//
//  Created by Gareth Long on 27/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit
import AVFoundation


class TabataResultsVC: ResultsViewController {

    var tabataWOD:TabataWOD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        workOutName.text = tabataWOD.name
        
        let formater = NSDateFormatter()
        formater.dateStyle = .FullStyle
        workOutDate.text = formater.stringFromDate(tabataWOD.startDate)
        
    }
    
    //Table view dataSource Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tabataWOD.rounds.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Round \(section + 1)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabataWOD.rounds[section].reps.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = tabataWOD.rounds[indexPath.section].titleForRepAtIndex(indexPath.row)
        
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
        
        overlayLayer.addSublayer(layerGenerator.timerView(size, forSeconds:tabataWOD.totalWorkOutSeconds(), withDelay: tabataWOD.countDownTime,countUp: false))
        
        
        overlayLayer.addSublayer(layerGenerator.tabataWorkOutInfo(size, workOut: tabataWOD, withDelay: tabataWOD.countDownTime))
        
        
        
        
        parentLayer.addSublayer(overlayLayer)
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
        
        
    }

}
