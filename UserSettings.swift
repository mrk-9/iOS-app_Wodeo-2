//
//  UserSettings.swift
//  Wodeo 2
//
//  Created by Gareth Long on 27/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import Foundation




class UserSettings:NSObject {
    
    let UD_VideoDelay = "VideoDelay"
    let UD_VideoQuality = "VideoQuality"
    let UD_CameraFlip = "CameraFlip"
    let UD_StandardName = "StandardName"
    let UD_JudgeName = "JudgeName"
    
    //Products
    let UD_PurchasedVideo = "PerchacedVideo"
    let UD_userVideoMessageOptOut = "UserVideoMessageOptOut"
    let UD_lastTimeUserWasInformed = "LastTimeUserWasInformed"
    
    static let sharedInstance = UserSettings()
    let ud = NSUserDefaults.standardUserDefaults()
    
    
    //Video quality
    func saveVideoQuality(quality:VideoQuality){
        ud.setObject(quality.rawValue, forKey: UD_VideoQuality)
    }
    
    func getVideoQuality() -> VideoQuality{
        
        if let r = ud.objectForKey(UD_VideoQuality){
            if let q = VideoQuality(rawValue:r as! String){
                return q
            }else{
                return VideoQuality.High
            }
        }else{
            return VideoQuality.High
        }
        
        
    }
    
    //Delay Settings
    func saveDelay(delay:Int){
        ud.setInteger(delay, forKey: UD_VideoDelay)
    }
    
    func getDelay() -> Int {
        
        let r = ud.integerForKey(UD_VideoDelay)
        if r > 0{
            return r
        }else{
            return 5
        }
    }
    
    //CameraFlip
    func saveCameraFlip(flip:CameraDevice){
        ud.setObject(flip.rawValue, forKey: UD_CameraFlip)
    }
    
    func getCameraFlip() -> CameraDevice {
        if let s = ud.objectForKey(UD_CameraFlip){
            if let r = CameraDevice(rawValue:s as! String) {
                return r
            }else{
                return CameraDevice.Front
            }
        }else{
            return CameraDevice.Front
        }
    }
    
    //Standard Name 
    func saveStandardName(name:String){
        ud.setObject(name, forKey: UD_StandardName)
    }
    
    func getStandardName() -> String {
        if let r = ud.objectForKey(UD_StandardName) {
            return r as! String
        }else{
            return ""
        }
    }
    
    //Judge name
    func saveJudgeName(name:String){
        ud.setObject(name, forKey: UD_JudgeName)
    }
    
    func getJudgeName() -> String {
        if let r = ud.objectForKey(UD_JudgeName){
            return r as! String
        }else{
            return ""
        }
    }
    
    
    //Purchaced Video
    func savePurchasedVideo(){
        ud.setBool(true, forKey: UD_PurchasedVideo)
    }
    
    func getPurchasedVideo() -> Bool {
        return ud.boolForKey(UD_PurchasedVideo)
    }
    
    func saveUserVideoMessageOptOut(){
        ud.setBool(true, forKey:UD_userVideoMessageOptOut)
        let dateValue = NSTimeIntervalSince1970
        ud.setDouble(dateValue, forKey: UD_lastTimeUserWasInformed)
    }
    
    
    func getUserVideoMessageOptOut() -> Bool{
        let now = NSTimeIntervalSince1970
        if now - ud.doubleForKey(UD_lastTimeUserWasInformed) > 2592000{
            return false
        }else{
            return true
        }
    }

    
}


