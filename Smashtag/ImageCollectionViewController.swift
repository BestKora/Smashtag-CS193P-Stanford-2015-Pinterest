//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/12/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

public struct TweetMedia: Printable
{
    var tweet: Tweet
    var media: MediaItem
    
    public var description: String { return "\(tweet): \(media)" }
}

class ImageCollectionViewController: UICollectionViewController,
                                     UICollectionViewDelegateFlowLayout,
                                     CHTCollectionViewDelegateWaterfallLayout
{
    var tweets: [[Tweet]] = [] {
        didSet {
           images = tweets.flatMap({$0})
                .map { tweet in
                    tweet.media.map { TweetMedia(tweet: tweet, media: $0) }}.flatMap({$0})
         }
    }

    private var images = [TweetMedia]()
    private var cache = NSCache()
    
    private struct Constants {
        static let CellReuseIdentifier = "Image Cell"
        static let SegueIdentifier = "Show Tweet"
        static let SizeSetting = CGSize(width: 120.0, height: 120.0)
        
        static let ColumnCountWaterfall = 3
        static let minimumColumnSpacing:CGFloat = 2
        static let minimumInteritemSpacing:CGFloat = 2
    }

    private var scale: CGFloat = 1 {
        didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка Waterfall Layout
        setupWaterfallCollectionViewLayout()

        collectionView?.addGestureRecognizer(
            UIPinchGestureRecognizer(target: self, action: "zoom:"))
    }
    
    //MARK: - Настройка Waterfall layout CollectionView
    private func setupWaterfallCollectionViewLayout(){
        
        // Создаем waterfall layout
        var layout = CHTCollectionViewWaterfallLayout()
        
        // Меняем атрибуты для зазоров между ячейками и строками и
        // количество столбцов - основной параметр настройки        
        layout.columnCount = Constants.ColumnCountWaterfall
        layout.minimumColumnSpacing = Constants.minimumColumnSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        
        // устанавливаем Waterfall layout нашему collection view
        collectionView?.collectionViewLayout = layout
    }

   func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
    }


    override func collectionView(collectionView: UICollectionView,
                                                numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(collectionView: UICollectionView,
                     cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            Constants.CellReuseIdentifier, forIndexPath: indexPath) as!  ImageCollectionViewCell
    
        cell.cache = cache
        cell.tweetMedia = images[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout и CHTCollectionViewWaterfallLayout

    func collectionView(collectionView: UICollectionView,
           layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        if collectionView.collectionViewLayout is CHTCollectionViewWaterfallLayout{
            let newColumnNumber = Int(CGFloat(Constants.ColumnCountWaterfall) / scale)
            (collectionView.collectionViewLayout
                    as! CHTCollectionViewWaterfallLayout).columnCount =
                                              newColumnNumber < 1 ? 1 :newColumnNumber
        }
        let ratio = CGFloat(images[indexPath.row].media.aspectRatio)
        let maxCellWidth = collectionView.bounds.size.width
        var size = CGSize(width: Constants.SizeSetting.width * scale,
                         height: Constants.SizeSetting.height * scale)
        if ratio > 1 {
            size.height /= ratio
        } else {
            size.width *= ratio
        }
        if size.width > maxCellWidth {
            size.width = maxCellWidth
            size.height = size.width / ratio
        }
        return size
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueIdentifier {
            if let ttvc = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? ImageCollectionViewCell,
                   let tweetMedia = cell.tweetMedia {
                    ttvc.tweets = [[tweetMedia.tweet]]
                }
            }
        }
    }

}
