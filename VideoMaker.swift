//
//  VideoMaker.swift
//  Video Testing
//
//  Created by Gareth Long on 06/02/2016.
//  Copyright © 2016 gazlongapps. All rights reserved.
//

import AVFoundation
import AssetsLibrary
import UIKit
import Photos


class VideoMaker: UIViewController {
    
    var videoToMakeURL:NSURL?
    var videoToMake:AVAsset?
    var exporter:AVAssetExportSession!

    func videoOutput() {
        
            videoToMake = AVAsset(URL: videoToMakeURL!)
        
            if (videoToMake == nil) {
            
                return
            }
        
        //This holds the different tracks of the video like audio and the layers
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        do{
           try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero,videoToMake!.duration), ofTrack: videoToMake!.tracksWithMediaType(AVMediaTypeVideo)[0], atTime: kCMTimeZero)
        }catch let error as NSError{
             print("Error inserting time range on video track \(error.localizedDescription)")
             return
        }catch{
            print("An unknown error occured")
        }
        
        
        //Add the audio
        let audioTrack1 = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        do{
            try audioTrack1.insertTimeRange(CMTimeRangeMake(kCMTimeZero,videoToMake!.duration), ofTrack: videoToMake!.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)
        }catch let error as NSError{
            print("Error inserting time range on video track \(error.localizedDescription)")
            return
        }catch{
            print("An unknown error occured")
        }

        
        //Make the instructions for the other layers
        let mainInstrucation = AVMutableVideoCompositionInstruction()
        mainInstrucation.timeRange = CMTimeRangeMake(kCMTimeZero, videoToMake!.duration)
        
        //Create the layer instructions
        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let videoAssetTrack = videoToMake!.tracksWithMediaType(AVMediaTypeVideo)[0]
        
        
        let assetInfo = orientationFromTransform(videoAssetTrack.preferredTransform)
        // sort size it in respect to the video orientation.
        
        videoLayerInstruction.setTransform(videoAssetTrack.preferredTransform, atTime: kCMTimeZero)
        videoLayerInstruction.setOpacity(0.0, atTime:videoToMake!.duration)
        
        //Add the instructions
        mainInstrucation.layerInstructions = [videoLayerInstruction]
        let mainCompositionInst = AVMutableVideoComposition()
        
        var naturalSize:CGSize
        if assetInfo.isPortrait {
            naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
        }else{
            naturalSize = videoAssetTrack.naturalSize
        }
        
        let renderWidth = naturalSize.width
        let renderHeight = naturalSize.height
        
        mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight)
        mainCompositionInst.instructions = [mainInstrucation]
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        
        
        
        
        //So now the main composition has been created add the video affects
        applyVideoEffectsToComposition(mainCompositionInst, size: naturalSize)
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        let documentsDirectory = paths[0]
        let random = Int(arc4random_uniform(1000))
        let url = NSURL(fileURLWithPath:documentsDirectory).URLByAppendingPathComponent("FinalVideo\(random).mov")
       
        //Create the exporter 
        exporter = AVAssetExportSession(asset: mixComposition, presetName:AVAssetExportPresetHighestQuality)
        
        exporter.outputURL = url
        exporter.outputFileType = AVFileTypeMPEG4
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainCompositionInst
        
        
        //Perform the export
        exporter!.exportAsynchronouslyWithCompletionHandler() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               self.exportDidFinish(self.exporter!)
           })
        }
    }
    
    func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImageOrientation, isPortrait: Bool) {
        var assetOrientation = UIImageOrientation.Up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .Right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .Left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .Up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .Down
        }
        return (assetOrientation, isPortrait)
    }
    
    
    func exportDidFinish(session: AVAssetExportSession) {
        switch session.status {
        case AVAssetExportSessionStatus.Failed:
            print("Failed \(session.error)")
        case AVAssetExportSessionStatus.Cancelled:
            print("Cancelled \(session.error)")
        default:
            print("complete")
            print("\(session.outputURL)")
            saveFileAtURLToPhotoLibrary(session.outputURL!)
        }
    
    }
    
    func saveFileAtURLToPhotoLibrary(url:NSURL){
        let lib = CustomPhotoAlbum()
        lib.saveVideo(url,metadata: ["DateVideoTaken":NSDate()])
    }
    
    func applyVideoEffectsToComposition(composition: AVMutableVideoComposition, size: CGSize) {
        
        
        
        
        
    }

    
}