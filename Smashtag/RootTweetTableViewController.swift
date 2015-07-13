//
//  RootTweetTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/10/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class RootTweetTableViewController: TweetTableViewController {
    // необходимо для unwind segue
    @IBAction func backToRoot(segue: UIStoryboardSegue) {}
    // MARK: - View Controller Lifecycle
    
    private struct Storyboard {
        static let MentionsIdentifier = "Show Mentions"
        static let ImagesIdentifier = "Show Images"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageButton = UIBarButtonItem(barButtonSystemItem: .Camera,
                                                       target: self,
                                                       action: "showImages:")
        if let existingButton = navigationItem.rightBarButtonItem {
            navigationItem.rightBarButtonItems = [existingButton, imageButton]
        } else {
            navigationItem.rightBarButtonItem = imageButton
        }
    }

    func showImages(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Storyboard.ImagesIdentifier, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.MentionsIdentifier {
                if let mtvc = segue.destinationViewController as? MentionsTableViewController {
                    if let tweetCell = sender as? TweetTableViewCell {
                        mtvc.tweet = tweetCell.tweet
                    }
                }
            } else if identifier == Storyboard.ImagesIdentifier {
                if let icvc = segue.destinationViewController as? ImageCollectionViewController {
                    icvc.tweets = tweets
                    icvc.title = "Images: \(searchText!)"
                }
            }
        }
    }

}
