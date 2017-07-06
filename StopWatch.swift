//
//  TimeTest.swift
//  timerTesting
//
//  Created by Gareth Long on 13/02/2016.
//  Copyright © 2016 gazlongapps. All rights reserved.
//

import Foundation
import AVFoundation


extension Int {
    
    func timesThrough() -> String{
        if self == 1 {
            return "1 time through"
        }else{
            return "\(self) times through"
        }
    }
    
}

extension Double {
    
    /// Rounds the double to decimal places value
    func stringForTimeInterval(withMicroSeconds:Bool) -> String {
        
        var retString = ""
        let startTime = self
        let baseTime = NSDate(timeIntervalSince1970: startTime)
        let dateFormatter = NSDateFormatter()
        
        
        if withMicroSeconds {
            
            dateFormatter.dateFormat = "HH:mm:ss.SS"
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:0)
            //Remove the blank components
            let slipDownString = dateFormatter.stringFromDate(baseTime).componentsSeparatedByString(":")
        
            for part in slipDownString {
                if part != "00" {
                    retString += part
                    if part.rangeOfString(".") == nil {
                        retString += ":"
                    }
                }
            }
            
        }else{
            
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:0)
            
            //Remove the blank components
            var slipDownString = dateFormatter.stringFromDate(baseTime).componentsSeparatedByString(":")
            
            //trim out the initial zero's
            
           
            
            
            
            //mark leading zeros for removal
            for i in 0..<slipDownString.count {
                if slipDownString[i] == "00" {
                    slipDownString[i] = "r"
                }else{
                    break
                }

            }
            
            
            
            for i in 0..<slipDownString.count {
                if slipDownString[i] != "r" {
                    retString += slipDownString[i]
                    
                    if i != (slipDownString.count - 1) {
                        retString += ":"
                    }
                }

            }
            
            
        }
        
        return retString
    }

    

}
            

                



struct TimeInterval {
    
    var secondsAsDouble:Double?
    
    func intervalString(withMilliseconds:Bool) -> String {
        if let secs = secondsAsDouble {
            return secs.stringForTimeInterval(withMilliseconds)
        }else {
            return "Time Interval Set"
        }
    }
    
}

enum StopWatchType {
    case CountUp
    case CountDown
}

protocol StopWatchDelegate {
    
    func stopWatchDidUpdateWithTimeInterval(t:TimeInterval)
    func stopWatchDidCountDown(t:TimeInterval)
}


class StopWatch:NSObject {
    
    var startTime:CFAbsoluteTime!
    var timer:NSTimer?
    let type:StopWatchType
    var timerStarted = false
    var countDownFromSeconds:Int?
    var delegate:StopWatchDelegate!
    var inLastThreeSeconds = false
    var speechSynth = AVSpeechSynthesizer()
    //let myUtterence = AVSpeechUtterance(string:"3......2......1")
    
    var currentDuration:TimeInterval {
        if timerStarted {
            let currentTime = CFAbsoluteTimeGetCurrent()
            return TimeInterval(secondsAsDouble:currentTime - startTime!)
        }else{
            return TimeInterval(secondsAsDouble: 0.0)
        }

    }
    
    init(type:StopWatchType){
        self.type = type
    }
    
    func stop(){
        
        if speechSynth.speaking {
            
            speechSynth.stopSpeakingAtBoundary(.Immediate)
        }
        
        if let t = timer {
            t.invalidate()
        }
    }
    
    func start(){
        inLastThreeSeconds = false
        startTime = CFAbsoluteTimeGetCurrent()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector:#selector(StopWatch.update), userInfo: nil, repeats: true)
                timerStarted = true
    }
    
    func update(){
        switch type {
            case .CountUp:updateCurrentDuration()
            case .CountDown:updateTimeRemaining()
        }
    }
    
    
    func delay(seconds seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    var speaking:Bool = false
    func countDown() {
        speaking = true
        let priority = QOS_CLASS_USER_INITIATED
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
           
            let utterence = AVSpeechUtterance(string:"3")
            self.speechSynth.speakUtterance(utterence)
            
            self.delay(seconds: 1, completion: {
                let utterence = AVSpeechUtterance(string:"2")
                self.speechSynth.speakUtterance(utterence)
            })
            
            self.delay(seconds: 2, completion: {
                let utterence = AVSpeechUtterance(string:"1")
                self.speechSynth.speakUtterance(utterence)
                
            })
            
            
        }
    }
    
    func updateTimeRemaining() {
        if timerStarted {
            let currentTime = CFAbsoluteTimeGetCurrent()
            
            if let cdt = countDownFromSeconds {
                let ct = Double(cdt) - (currentTime - startTime!)
                
                if ct <= 0 {
                    self.speaking = false
                    delegate.stopWatchDidCountDown(TimeInterval(secondsAsDouble:0.0))
                }else{
                    
                    if ct <= 4 && !speaking {
                        countDown()
                    }
                    
                    delegate.stopWatchDidUpdateWithTimeInterval(TimeInterval(secondsAsDouble:ct))
                }
                
            }else{
                print("Count down time not set")
            }
        }else{
            print("Timer not started")
        }
        
    }
    func updateCurrentDuration() {
        if timerStarted {
            let currentTime = CFAbsoluteTimeGetCurrent()
            if delegate != nil {
            delegate.stopWatchDidUpdateWithTimeInterval(TimeInterval(secondsAsDouble:currentTime - startTime!))
            }
        }else{
            print("Timer not started")
        }
    }
    
}