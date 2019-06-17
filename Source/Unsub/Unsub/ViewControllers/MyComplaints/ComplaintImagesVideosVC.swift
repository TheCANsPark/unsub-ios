//
//  ComplaintImagesVideosVC.swift
//  Unsub
//
//  Created by codezilla-mac1 on 17/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ComplaintImagesVideosVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var imgArr = [URL]()
    var videoArr = [URL]()
    var imgVideoArr = [URL]()

    @IBOutlet var collectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images/Videos"
        self.imgVideoArr = self.imgArr
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgVideoArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageVideoCollectionCell", for: indexPath)
        let img : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let videoIcon : UIImageView = cell.contentView.viewWithTag(200) as! UIImageView
        let getUrl = imgVideoArr[indexPath.row]
        
        let str = String(describing: getUrl)
        let fileArray = str.components(separatedBy: ".")
        let finalFileName = fileArray.last
        if finalFileName == "mov" {
           /* if let thumbnailImage = getThumbnailImage(forUrl: getUrl) {
                img.image = thumbnailImage
            }*/
            videoIcon.isHidden = false
            
        } else {
             img.setImgFromUrl(url: "\(getUrl)")
            
          /*  let data = try? Data(contentsOf: getUrl)
            if let imageData = data {
                let image = UIImage(data: imageData)
                img.image = image
            }*/
            videoIcon.isHidden = true
        }
        
        return cell
    }
    //MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let getUrl = imgVideoArr[indexPath.row]
        
        let str = String(describing: getUrl)
        let fileArray = str.components(separatedBy: ".")
        let finalFileName = fileArray.last
        if finalFileName == "mov" {
           
            let player = AVPlayer(url: getUrl)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            
        } else {
            
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                vc.imgUrl = getUrl as NSURL
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
     
        }
    }
    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3.08, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
