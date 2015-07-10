//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    // MARK: - public API

    var tweet: Tweet? {
        didSet {
             tweetMentionsCount = (tweet?.hashtags.count ?? 0) +
                                  (tweet?.urls.count ?? 0) +
                                  (tweet?.userMentions.count ?? 0) +
                                  (tweet?.media.count ?? 0)
            updateUI()
        }
  }
    var tweetMentionsCount = 0  
    struct Palette {
        static let hashtagColor = UIColor.purpleColor()
        static let urlColor = UIColor.blueColor()
        static let userColor = UIColor.orangeColor()
    }

  
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    

    func updateUI() {
        // переустанавливаем заново любую существующую инфоримацию твита
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // загружаем новую информацию из нашего tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.attributedText  = setTextLabel(tweet)
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            setProfileImageView(tweet) // tweetProfileImageView updated asynchronously
            tweetCreatedLabel?.text = setCreatedLabel(tweet)
        }
    }
    
 
    private func setTextLabel(tweet: Tweet) -> NSMutableAttributedString {
        var tweetText:String = tweet.text
        for _ in tweet.media {tweetText += " 📷"}
        var attribText = NSMutableAttributedString(string: tweetText)
        
        attribText.setKeywordsColor(tweet.hashtags, color: Palette.hashtagColor)
        attribText.setKeywordsColor(tweet.urls, color: Palette.urlColor)
        attribText.setKeywordsColor(tweet.userMentions, color: Palette.userColor)
 
        return attribText
    }
    
    private func setCreatedLabel(tweet: Tweet) -> String {
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        return formatter.stringFromDate(tweet.created)
    }
    
    private func setProfileImageView(tweet: Tweet) {
        if let profileImageURL = tweet.user.profileImageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: profileImageURL)
                dispatch_async(dispatch_get_main_queue()) {
                    if profileImageURL == tweet.user.profileImageURL {
                        if imageData != nil {
                            self.tweetProfileImageView?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetProfileImageView?.image = nil
                        }
                    }
                }
            }
        }
    }

    
}

// MARK: - Расширение

private extension NSMutableAttributedString {
    func setKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}

