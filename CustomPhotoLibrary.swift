//
//  CustomPhotoLibrary.swift
//  Wodeo 2
//
//  Created by Gareth Long on 20/02/2016.
//  Copyright © 2016 Elliott Brown. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import AVFoundation
import AssetsLibrary
import Photos



class CustomPhotoAlbum: NSObject {
    
    static let albumName = "Wodeo 2"
    
    static let sharedInstance = CustomPhotoAlbum()
    
    
    var assetCollection: PHAssetCollection!
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                status
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(CustomPhotoAlbum.albumName)   // create an asset collection with the album name
            }) { success, error in
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                } else {
                    print("error \(error)")
                }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject as! PHAssetCollection
        }
        return nil
    }
    
    func saveImage(image: UIImage, metadata: NSDictionary) {
        if assetCollection == nil {
            return                          // if there was an error upstream, skip the save
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            assetChangeRequest.creationDate = (metadata["DatePhotoTaken"] as! NSDate)
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
            albumChangeRequest!.addAssets([assetPlaceHolder!])
            }, completionHandler: nil)
    }
    
    func saveVideo(videoURL:NSURL, metadata: NSDictionary){
        if assetCollection == nil {
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(videoURL)
            let assetPlaceHolder = assetChangeRequest!.placeholderForCreatedAsset
           assetChangeRequest!.creationDate = (metadata["DateVideoTaken"] as! NSDate)
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
            albumChangeRequest!.addAssets([assetPlaceHolder!])
            }, completionHandler:{(finished:Bool,error:NSError?) in
                
                if let err = error {
                    print("\(err.localizedDescription)")
                }
                
        })
    }
    
}
