//
//  TiledView.swift
//  Wodeo 2
//
//  Created by Gareth Long on 26/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

@IBDesignable

class TiledView: UIView {

   
    var backgroundLayer:CALayer!
    var topL:CATextLayer!
    var leftL:CATextLayer!
    var rightL:CATextLayer!
    var bottomL:CATextLayer!
    
    var top:Bool = false {
        didSet{
            topL.hidden = top ? false:true
            bottomL.hidden = top ? true:false
        }
    }
    
    var instruction:String = "" {
        didSet{
            topL.string = instruction
            leftL.string = instruction
            rightL.string = instruction
            bottomL.string = instruction
        }
    }
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundLayer = CALayer()
        backgroundLayer.frame = frame
        backgroundLayer.cornerRadius = 20.0
        backgroundLayer.masksToBounds = true
        backgroundLayer.backgroundColor = UIColor(red: 54/255.0, green: 54/255.0, blue: 54/255.0, alpha: 0.2).CGColor
        backgroundLayer.borderWidth = 1.0
        backgroundLayer.borderColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha:0.4).CGColor
        layer.addSublayer(backgroundLayer)
        
        topL = CATextLayer()
        leftL = CATextLayer()
        rightL = CATextLayer()
        bottomL = CATextLayer()
        
        topL.alignmentMode = kCAAlignmentCenter
        leftL.alignmentMode = kCAAlignmentCenter
        rightL.alignmentMode = kCAAlignmentCenter
        bottomL.alignmentMode = kCAAlignmentCenter
        
        let op:Float = 0.5
        topL.opacity = op
        leftL.opacity = op
        rightL.opacity = op
        bottomL.opacity = op
        
        topL.font = "Folio-BoldCondensed"
        leftL.font = "Folio-BoldCondensed"
        rightL.font = "Folio-BoldCondensed"
        bottomL.font = "Folio-BoldCondensed"
        
        let fontSize:CGFloat = 25.0
        topL.fontSize = fontSize
        leftL.fontSize = fontSize
        rightL.fontSize = fontSize
        bottomL.fontSize = fontSize
        
        
        
        topL.foregroundColor = UIColor.yellowColor().CGColor
        leftL.foregroundColor = UIColor.yellowColor().CGColor
        rightL.foregroundColor = UIColor.yellowColor().CGColor
        bottomL.foregroundColor = UIColor.yellowColor().CGColor
        

        leftL.transform = CATransform3DRotate(leftL.transform, CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
        rightL.transform = CATransform3DRotate(rightL.transform, CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        
        topL.backgroundColor = UIColor.clearColor().CGColor
        leftL.backgroundColor = UIColor.clearColor().CGColor
        rightL.backgroundColor = UIColor.clearColor().CGColor
        bottomL.backgroundColor = UIColor.clearColor().CGColor
        
        
        layer.addSublayer(topL)
        layer.addSublayer(bottomL)
        layer.addSublayer(leftL)
        layer.addSublayer(rightL)
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        
        let lh:CGFloat = 50.0
        let vm = bounds.size.width / 2.0
        let lo:CGFloat = lh / 2.0
        
        topL.bounds = CGRectMake(0.0, 0.0, bounds.size.width, lh)
        leftL.bounds = CGRectMake(0.0, 0.0, bounds.size.width, lh)
        rightL.bounds = CGRectMake(0.0, 0.0, bounds.size.width, lh)
        bottomL.bounds = CGRectMake(0.0, 0.0, bounds.size.width, lh)
        
        topL.position = CGPoint(x: vm, y:lo)
        leftL.position = CGPoint(x:lo, y: bounds.size.height / 2.0)
        rightL.position = CGPoint(x: bounds.size.width - lo, y: bounds.size.height / 2.0)
        bottomL.position = CGPoint(x:vm, y:bounds.size.height - lo)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
