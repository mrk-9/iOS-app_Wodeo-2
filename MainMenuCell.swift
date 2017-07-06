//
//  MainMenuCell.swift
//  Wodeo 2
//
//  Created by Gareth Long on 15/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {

    @IBOutlet weak var cellImage:UIImageView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var subTitle:UILabel!
    @IBOutlet weak var fadedBackgrondView:UIView!
    
        
    let backGroundView = UIView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fadedBackgrondView.layer.cornerRadius = 15.0
        fadedBackgrondView.layer.masksToBounds = true
        
        
        let bgv = UIView(frame:bounds)
        bgv.layer.cornerRadius = 15.0
        bgv.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.4)
        
        selectedBackgroundView = bgv

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
        
        
    }
    
    
}
