
protocol IntervalWOD_Delegate {
    func intervalWODDidMoveToRoundWithName(name:String)
}

class IntervalWOD:WOD,StopWatchDelegate {
    
    
    var rounds = [PresetRound]()
    var stopWatch:StopWatch!
    var repStopWatch:StopWatch!
    var roundCounter:Int = 0
    var loopCounter:Int = 1
    var loops:Int = 1
    
    var intervalDelegate:IntervalWOD_Delegate?
    
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
        
        
        if roundCounter < rounds.count {
            
            if let it = intervalDelegate {
                it.intervalWODDidMoveToRoundWithName("Loop \(rounds[roundCounter].loopNumber) Round \(roundCounter + 1) of \(rounds.count)")
            }

            
            stopWatch.countDownFromSeconds = rounds[roundCounter].presetDuration
            roundCounter += 1
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
