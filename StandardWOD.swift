

class StandardWOD: WOD,StopWatchDelegate{
    
    
    //Stop watch to time it
    var stopWatch:StopWatch
    var rounds = [Round]()
    var totalWorkOutSeconds = TimeInterval()
    
    
    override init(with name: String) {
        stopWatch = StopWatch(type: StopWatchType.CountUp)
        super.init(with: name)
    }
    
    
    //Public functions
    func startWorkOut() {
        stopWatch.delegate = self
        stopWatch.start()
        addRound()
    }
    
    func stopWorkOut(){
        totalWorkOutSeconds = stopWatch.currentDuration
        stopWatch.stop()
        
    }
    
    //Work out data
    func addRound(){
        let cDuration = stopWatch.currentDuration
        
        if let round = rounds.last {
            round.endTime = cDuration
        }
        
        rounds.append(Round(startTime:cDuration, roundNumber: rounds.count + 1))
    }
    
    func addRep(){
        //Get last round reps
        let cRound = rounds.last
        let timeStamp = stopWatch.currentDuration
        
        cRound!.reps.append(Rep(startTime:timeStamp, repNumber:cRound!.reps.count + 1))
    }
    
    private func totalReps() -> Int {
        
        var repCount = 0
        for round in rounds {
            repCount += round.reps.count
        }
        return repCount
        
    }
    
    //Stop watch delegate
    func stopWatchDidUpdateWithTimeInterval(t: TimeInterval) {
        workOutTime = t.secondsAsDouble!
        delegate.wodStopWatchDidUpdateToValue(t.intervalString(false))
        
    }
    
    func stopWatchDidCountDown(t: TimeInterval) {
        
    }
    
    func stopWatchInLastThreeSeconds(t: TimeInterval) {
        
    }
    
    
}

