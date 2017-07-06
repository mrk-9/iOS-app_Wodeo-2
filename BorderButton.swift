//
//  BorderButton.swift
//  Wodeo 2
//
//  Created by Gareth Long on 29/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }


func commonInit(){
    
    layer.borderColor = UIColor(red: 240/255.0, green: 178/255.0, blue: 71/255.0, alpha: 1.0).CGColor
    layer.borderWidth = 1.5
    layer.cornerRadius = 5.0
    layer.masksToBounds = true
}


}