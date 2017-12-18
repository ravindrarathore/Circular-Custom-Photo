//
//  PhotosViewController.swift
//  viewAnimation
//
//  Created by Apple on 18/12/17.
//  Copyright © 2017 Ravindra. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var album:[AlbumModel] = [AlbumModel]()
    var index = 0
    var imageArray : [UIImage] = []
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FetchCustomAlbumPhotos(name: album[index].name)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = imageArray[indexPath.row] as! UIImage
        return cell
    }
    //    Mark : Getting Photos from specify Album
    func FetchCustomAlbumPhotos(name : String)
    {
        self.imageArray = []
        var albumName = name
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets  =  PHFetchResult<AnyObject>()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            assetCollection = collection.firstObject as! PHAssetCollection
            albumFound = true
        }
        else { albumFound = false }
        var i = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        
        photoAssets.enumerateObjects { (object: AnyObject!,  count: Int,  stop: UnsafeMutablePointer<ObjCBool>) in
            if object is PHAsset{
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")
                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset,
                                          targetSize: imageSize,
                                          contentMode: .aspectFill,
                                          options: options,
                                          resultHandler: {
                                            (image, info) -> Void in
                                            
                                            
                                            self.imageArray.append(image!)
                                            
                                            
                })
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
        
    }
    
    
}


