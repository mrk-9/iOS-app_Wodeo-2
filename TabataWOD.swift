//
//  TabataWOD.swift
//  Wodeo 2
//
//  Created by Gareth Long on 27/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import Foundation

protocol TabataWOD_Delegate {
    func tabataWODDidMoveToRoundWithName(name:String)
    func tabataWODDidMoveToRestPeriod()
    func tabataWODDidMoveOutOfRestPeriod()
}

class TabataWOD:WOD,StopWatchDelegate {
    
    
    var rounds = [PresetRound]()
    var stopWatch:StopWatch!
    var repStopWatch:StopWatch!
    var roundCounter:Int = 0
    var loopCounter:Int = 1
    var loops:Int = 1
    var restPeriodBetweenRounds:Int = 0
    var isResting = false
    
    var tabataDelegate:TabataWOD_Delegate?
    
    override init(with name: String) {
        stopWatch = StopWatch(type: StopWatchType.CountDown)
        repStopWatch = StopWatch(type: StopWatchType.CountUp)
        super.init(with: name)
    }
    
    func startWorkOut(){
        repStopWatch.start()
        stopWatch.delegate = self
        nextInterval()
    }
    
    func stopWorkOut() {
        repStopWatch.stop()
        stopWatch.stop()
    }
    
    func addRep() -> String {
        //Get current round
        let round = rounds[roundCounter - 1]
        round.reps.append(Rep(startTime: repStopWatch.currentDuration, repNumber: round.reps.count + 1))
        
        return "Rep: \(round.reps.count)"
    }
    
    
    private func nextInterval(){
        
        stopWatch.stop()
        
        if restPeriodBetweenRounds > 0 && !isResting && roundCounter > 0 && roundCounter < rounds.count {
            isResting = true
            stopWatch.countDownFromSeconds = restPeriodBetweenRounds
            stopWatch.start()
            
            if let td = tabataDelegate {
            td.tabataWODDidMoveToRestPeriod()
            }else{
                print("Delagate not set")
            }
            return
        }
        
        if roundCounter < rounds.count {
            
            isResting = false
            
            if let it = tabataDelegate {
                it.tabataWODDidMoveToRoundWithName("Loop \(rounds[roundCounter].loopNumber) Round \(roundCounter + 1) of \(rounds.count)")
            }
            
            
            stopWatch.countDownFromSeconds = rounds[roundCounter].presetDuration
            roundCounter += 1
            
            if let td = tabataDelegate {
                td.tabataWODDidMoveOutOfRestPeriod()
            }else{
                print("Delegate not set")
            }
            
            stopWatch.start()
            
        }else{
            delegate.workOutDidEnd()
        }
    }
    
    func totalWorkOutSeconds() -> Int {
        var retTotal = 0
        for r in rounds {
            retTotal += r.presetDuration
        }
        
        //Add on the rest period
        let restPeriod = (rounds.count - 1) * restPeriodBetweenRounds
        retTotal += restPeriod
        
        return retTotal
    }
    
    //Stop watch delegate
    func stopWatchDidCountDown(t: TimeInterval) {
        
        nextInterval()
    }
    
    func stopWatchDidUpdateWithTimeInterval(t: TimeInterval) {
        delegate.wodStopWatchDidUpdateToValue(t.intervalString(false))
    }
    
    func stringForRound(index:Int,andRep:Int) -> String {
        
        let loopNumber = rounds[index].loopNumber
        let maxNumberOfLoops = rounds.last!.loopNumber
        
        let roundNumber = rounds[index].roundNumber
        let maxNumberOfRounds = rounds.count
        
        let repNumber = andRep + 1
        let maxReps = rounds[index].reps.count
        
        return "Loop \(loopNumber) of \(maxNumberOfLoops) | Round \(roundNumber) of \(maxNumberOfRounds) | Rep \(repNumber) of \(maxReps)"
        
        
        
        
    }
    
    
    

    
    
    
}