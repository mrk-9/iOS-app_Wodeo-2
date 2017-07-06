//
//  WodeoModel.swift
//  timerTesting
//
//  Created by Gareth Long on 13/02/2016.
//  Copyright © 2016 gazlongapps. All rights reserved.
//

/*
To be subclassed for each type of work out.

*/



import Foundation

protocol WODDelegate {
    func wodStopWatchDidUpdateToValue(timeValue:String)
    func workOutDidEnd()
}

class Rep {
    
    var startTime:TimeInterval
    var endTime:TimeInterval?
    let repNumber:Int!
    
    init(startTime:TimeInterval,repNumber:Int){
        self.startTime = startTime
        self.repNumber = repNumber
    }
    
}

class Round {
    
    var startTime:TimeInterval!
    var endTime:TimeInterval?
    var reps = [Rep]()
    var roundNumber:Int = 0
    
    
    init(startTime:TimeInterval,roundNumber:Int){
        self.startTime = startTime
        self.roundNumber = roundNumber
    }
    
    //func title() -> String {
        
   // }
    
    func titleForRepAtIndex(index:Int) -> String {
        let repStartTime = reps[index].startTime
        var repEndTime = TimeInterval(secondsAsDouble:0.0)
        
        if index == reps.count - 1 {
            //Its the last rep so use the round end time
            if let et = endTime{
                repEndTime = et
            }else{
                repEndTime = TimeInterval(secondsAsDouble:0.0)
            }
        }else{
            repEndTime = reps[index + 1].startTime
        }
        
        return "Rep: \(index + 1) (\(repStartTime.intervalString(true)) - \(repEndTime.intervalString(true)))"
        
    }
}

class PresetRound: Round {
    
    var presetDuration:Int!
    var loopNumber:Int!
    
    init(roundNumber:Int,presetDuration:Int,loopNumber:Int){
        super.init(startTime:TimeInterval(secondsAsDouble: 0.0), roundNumber:roundNumber)
        self.presetDuration = presetDuration
        self.loopNumber = loopNumber
    }
}


class WOD {
    
    var totalVideoSecondsAllowed:Double = UserSettings.sharedInstance.getPurchasedVideo() ? 100000.0:300.0
    
    //Public variables
    var name:String
    var startDate:NSDate
    var countDownTime:Int = 0
    var delegate:WODDelegate!
    var workOutTime:Double = 0.0
        
    init(with name:String) {
        self.name = name
        self.startDate = NSDate()
        
    }
    
}







