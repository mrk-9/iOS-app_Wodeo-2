

class CountDownWOD:WOD , StopWatchDelegate{
    
    var stopWatch:StopWatch
    var rounds = [Round]()
    var totalWorkOutSeconds = TimeInterval()
    var countDownFromTime:Int = 0
    
    
    override init(with name: String) {
        stopWatch = StopWatch(type: StopWatchType.CountDown)
        super.init(with: name)
        
        
    }
    
    func startWorkOut() {
        
        stopWatch.delegate = self
        stopWatch.start()
        addRound()
        
    }
    
    func stopWorkOut(){
        totalWorkOutSeconds = stopWatch.currentDuration
        stopWatch.stop()
        
    }
    
    
    
    func addRound(){
        rounds.append(Round(startTime:stopWatch.currentDuration, roundNumber: rounds.count + 1))
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
    
    func setCountDownTime(time:Int){
        stopWatch.countDownFromSeconds = time
    }
    
    //Stop watch delegate
    func stopWatchDidUpdateWithTimeInterval(t: TimeInterval) {
        delegate.wodStopWatchDidUpdateToValue(t.intervalString(false))
        
    }
    
    func stopWatchDidCountDown(t: TimeInterval) {
        delegate.workOutDidEnd()
    }
    
    func stopWatchInLastThreeSeconds(t: TimeInterval) {
        
    }
    
    
}
