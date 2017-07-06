//
//  TimeTextLabel.swift
//  Wodeo 2
//
//  Created by Gareth Long on 19/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class TimeTextLabel: CATextLayer {
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
     init(fontSize:CGFloat) {
        super.init()
        font = "Folio-BoldCondensed"
        self.fontSize = fontSize
        alignmentMode = kCAAlignmentLeft
        foregroundColor = UIColor(red: 243/255.0, green: 80/255.0, blue: 47/255.0, alpha: 1.0).CGColor
        backgroundColor = UIColor.clearColor().CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
