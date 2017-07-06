//
//  VideoOverlayGenerator.swift
//  Wodeo 2
//
//  Created by Gareth Long on 20/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import Foundation
import UIKit

class VideoOverlayGenerator: NSObject {
    
    let labelHeight:CGFloat = 50.0
    let edgeBuffer:CGFloat = 10.0
    let overlayFontSize:CGFloat = 30.0
    let mainBackingHeight:CGFloat = 200.0
    
    private func yForLabel(forSize:CGSize,labelOrder:Int) -> CGFloat {
        let totalOffset = labelHeight * CGFloat(labelOrder)
        return forSize.height - totalOffset
    }
    
    func logo(forSize:CGSize) -> CALayer {
        
        
        
        let image = UIImage(named: "overlayLogo")
        let imageLayer = CALayer()
        imageLayer.contents = image!.CGImage
        imageLayer.frame = CGRectMake(edgeBuffer,-edgeBuffer,forSize.width, forSize.height)
        imageLayer.masksToBounds = true
        imageLayer.contentsGravity  = kCAGravityTopLeft
        
        return imageLayer
        
    }
    
    func workOutAndDate(forSize:CGSize, withText:String) -> CATextLayer {
        
        
        let textLayer = TimeTextLabel(fontSize: overlayFontSize)
        textLayer.alignmentMode = kCAAlignmentRight
        textLayer.frame = CGRectMake(0.0,yForLabel(forSize, labelOrder: 1), forSize.width - edgeBuffer,labelHeight)
        textLayer.string = withText
        
        return textLayer
    
    }
    
    func carriedOutBy(forSize:CGSize, withText:String) -> CATextLayer {
        
        let textLayer = TimeTextLabel(fontSize: overlayFontSize)
        textLayer.alignmentMode = kCAAlignmentRight
        textLayer.frame = CGRectMake(0.0,yForLabel(forSize, labelOrder: 2), forSize.width - edgeBuffer,labelHeight)
        textLayer.string = withText
        
        return textLayer
    }
    
    func judgedBy(forSize:CGSize, withText:String) -> CATextLayer {
        
        let textLayer = TimeTextLabel(fontSize: overlayFontSize)
        textLayer.fontSize = overlayFontSize
        textLayer.alignmentMode = kCAAlignmentRight
        textLayer.frame = CGRectMake(0.0,yForLabel(forSize, labelOrder: 3), forSize.width - edgeBuffer,labelHeight)
        textLayer.string = withText
        
        return textLayer
    }
    
    func mainBackingLayer(forSize:CGSize) -> CALayer {
        
        let backLayer = CALayer()
        backLayer.backgroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
        backLayer.frame = CGRectMake(0.0, 0.0, forSize.width, mainBackingHeight)
               
      return backLayer
        
    }
    
    func timerView(forSize:CGSize,forSeconds:Int,withDelay:Int,countUp:Bool) -> CALayer {
       
        
        
        
        let retLayer = CALayer()
        
        //Create layers
        
        for i in 1..<forSeconds {
             let tl = TimeTextLabel(fontSize: 100.0)
            tl.frame = CGRectMake(edgeBuffer, 0.0,forSize.width - edgeBuffer,mainBackingHeight)
            tl.alignmentMode = kCAAlignmentLeft
            tl.string = countUp ? Double(i).stringForTimeInterval(false):Double(forSeconds - i).stringForTimeInterval(false)
            tl.opacity = 0.0
            tl.backgroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
            tl.foregroundColor = UIColor.darkGrayColor().CGColor
            let anima = animation()
            anima.beginTime = Double(i + withDelay)
            tl.addAnimation(anima, forKey:"Anim\(i)")
            retLayer.addSublayer(tl)

        }
        
        return retLayer
    }
    
    private func animation() -> CABasicAnimation{
        
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 0.1
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        
        return anim
    }
    
    func countDownWorkOutInfo(forSize:CGSize,workOut:CountDownWOD,withDelay:Int) -> CALayer {
        
        //Create the series of labels that will appear one after the other in the animation layer.
        let nor = workOut.rounds.count
        var aminationCounter = 0
        let retLayer = CALayer()
        
        for round in workOut.rounds {
            for rep in round.reps {
                let noreps = round.reps.count
                let tl = TimeTextLabel(fontSize:30.0)
                tl.frame = CGRectMake(forSize.width * 0.3,0.0,(forSize.width * 0.7) - edgeBuffer,mainBackingHeight * 0.65)
                tl.alignmentMode = kCAAlignmentRight
                tl.string = "Round: \(round.roundNumber) of \(nor) | Rep: \(rep.repNumber!) of \(noreps)"
                tl.opacity = 0.0
                tl.backgroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
                tl.foregroundColor = UIColor.darkGrayColor().CGColor
                let anim = animation()
                anim.beginTime = rep.startTime.secondsAsDouble! + Double(withDelay)
                tl.addAnimation(anim, forKey:"Anim\(aminationCounter)")
                retLayer.addSublayer(tl)
                aminationCounter += 1
                
            }
        }
        
        return retLayer

    }

    
    
    func standardWorkOutInfo(forSize:CGSize,workOut:StandardWOD,withDelay:Int) -> CALayer {
        
        //Create the series of labels that will appear one after the other in the animation layer.
        let nor = workOut.rounds.count
        var aminationCounter = 0
        let retLayer = CALayer()
        
        for round in workOut.rounds {
            for rep in round.reps {
                let noreps = round.reps.count
                let tl = TimeTextLabel(fontSize: 40.0)
                tl.frame = CGRectMake(forSize.width * 0.3,0.0,(forSize.width * 0.7) - edgeBuffer,mainBackingHeight * 0.65)
                tl.alignmentMode = kCAAlignmentRight
                tl.string = "Round: \(round.roundNumber) of \(nor) | Rep: \(rep.repNumber!) of \(noreps)"
                tl.opacity = 0.0
                tl.backgroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
                tl.foregroundColor = UIColor.darkGrayColor().CGColor
                let anim = animation()
                anim.beginTime = rep.startTime.secondsAsDouble! + Double(withDelay)
                tl.addAnimation(anim, forKey:"Anim\(aminationCounter)")
                retLayer.addSublayer(tl)
                aminationCounter += 1

            }
        }
        
        return retLayer
        
    }
    
    func intervalWorkOutInfo(forSize:CGSize,workOut:IntervalWOD,withDelay:Int) -> CALayer {
        
        //Create the series of labels that will appear one after the other in the animation layer.
        var aminationCounter = 0
        let retLayer = CALayer()
        
        var rc = 0
        var repC = 0
       
        
        for round in workOut.rounds {
            repC = 0
            for rep in round.reps {
                let tl = TimeTextLabel(fontSize: 40.0)
                tl.frame = CGRectMake(forSize.width * 0.3,0.0,(forSize.width * 0.7) - edgeBuffer,mainBackingHeight * 0.65)
                tl.alignmentMode = kCAAlignmentRight
                tl.string = workOut.stringForRound(rc, andRep: repC)
                print("\(workOut.stringForRound(rc, andRep: repC))")
                tl.opacity = 0.0
                tl.backgroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
                tl.foregroundColor = UIColor.darkGrayColor().CGColor
                let anim = animation()
                anim.beginTime = rep.startTime.secondsAsDouble! + Double(withDelay)
                tl.addAnimation(anim, forKey:"Anim\(aminationCounter)")
                retLayer.addSublayer(tl)
                aminationCounter += 1
                repC += 1
            }
            rc += 1
        }
        
        return retLayer
        
    }

    func tabataWorkOutInfo(forSize:CGSize,workOut:TabataWOD,withDelay:Int) -> CALayer {
        
        //Create the series of labels that will appear one after the other in the animation layer.
        var aminationCounter = 0
        let retLayer = CALayer()
        
        var rc = 0
        var repC = 0
        
        
        for round in workOut.rounds {
            repC = 0
            for rep in round.reps {
                let tl = TimeTextLabel(fontSize: 40.0)
                tl.frame = CGRectMake(forSize.width * 0.3,0.0,(forSize.width * 0.7) - edgeBuffer,mainBackingHeight * 0.65)
                tl.alignmentMode = kCAAlignmentRight
                tl.string = workOut.stringForRound(rc, andRep: repC)
                print("\(workOut.stringForRound(rc, andRep: repC))")
                tl.opacity = 0.0
                tl.backgroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
                tl.foregroundColor = UIColor.darkGrayColor().CGColor
                let anim = animation()
                anim.beginTime = rep.startTime.secondsAsDouble! + Double(withDelay)
                tl.addAnimation(anim, forKey:"Anim\(aminationCounter)")
                retLayer.addSublayer(tl)
                aminationCounter += 1
                repC += 1
            }
            rc += 1
        }
        
        return retLayer
        
    }


    
}
