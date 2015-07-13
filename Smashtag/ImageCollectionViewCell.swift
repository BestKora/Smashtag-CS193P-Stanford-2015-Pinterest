//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/12/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var cache: NSCache?
    var tweetMedia: TweetMedia? {
        didSet {
            imageURL = tweetMedia?.media.url
            fetchImage()
        }
    }
    
    private var imageURL: NSURL?
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            spinner?.stopAnimating()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            
            var imageData = cache?.objectForKey(imageURL!) as? NSData
            if imageData != nil {
                self.image = UIImage(data: imageData!)
                return
            }
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                            self.cache?.setObject(imageData!, forKey: self.imageURL!,
                                                                cost: imageData!.length / 1024)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
}
