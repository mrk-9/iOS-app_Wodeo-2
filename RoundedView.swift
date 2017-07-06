//
//  RoundedView.swift
//  Wodeo 2
//
//  Created by Gareth Long on 15/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp(){
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
    }
}
