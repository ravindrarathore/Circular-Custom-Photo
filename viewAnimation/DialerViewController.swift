//
//  DialerViewController.swift
//  viewAnimation
//
//  Created by Apple on 18/12/17.
//  Copyright © 2017 Ravindra. All rights reserved.
//

import UIKit
import Photos

class DialerViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var DialerView: UIView!
    @IBOutlet weak var imsge: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //no of rows
    var noOfRowInCollectionView : Int = 0
    // album Model
    var album:[AlbumModel] = [AlbumModel]()
    var IndexSelected = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.listAlbums()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //       view rotate on touch screen
        let touch = touches.first
        if touch!.view === DialerView {
            let position = touch!.location(in: self.view)
            let target = DialerView.center
            let angle = atan2(target.y-position.y, target.x-position.x)
            DialerView.transform = CGAffineTransform(rotationAngle: angle)
            imsge.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    //    counting no of alaubums in phone
    func listAlbums() {
        
        self.album = []
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: options)
        userAlbums.enumerateObjects{ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
                self.album.append(newAlbum)
                
            }
        }
        //        Reload Collection View
        DispatchQueue.main.async {
            self.noOfRowInCollectionView = self.album.count
            self.collectionView.reloadData()
            if self.album.count == 0{
                self.listAlbums()
            }
        }
        
    }
    
    
    //    CollectionView Delegete
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfRowInCollectionView
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DialerCell", for: indexPath) as! DialerCollectionViewCell
        cell.cellButton.tag = indexPath.row
        return cell
    }
    
    @IBAction func ButtonAction(_ sender: Any) {
        let but = sender as! UIButton
        IndexSelected = but.tag
        self.performSegue(withIdentifier: "dialerToPhotos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dialerToPhotos" {
            let destination = segue.destination as? PhotosViewController
            (destination)?.album = self.album
            (destination)?.index = self.IndexSelected
            
        }
    }
    
    
}

class AlbumModel {
    let name:String
    let count:Int
    let collection:PHAssetCollection
    init(name:String, count:Int, collection:PHAssetCollection) {
        self.name = name
        self.count = count
        self.collection = collection
    }
}

