//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/6/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    // MARK: - Public API

    var tweet: Tweet? {
        
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media  where media.count > 0 {
                    mentionTypes.append(MentionType(type: "Images",
                        mentions: media.map { Mention.Image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls  where urls.count > 0 {
                    mentionTypes.append(MentionType(type: "URLs",
                        mentions: urls.map { Mention.Keyword($0.keyword) }))
            }
            if let hashtags = tweet?.hashtags where hashtags.count > 0 {
                    mentionTypes.append(MentionType(type: "Hashtags",
                        mentions: hashtags.map { Mention.Keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions {
                var userItems = [Mention.Keyword("@" + tweet!.user.screenName)]
                if users.count > 0 {
                    userItems += users.map { Mention.Keyword($0.keyword) }
                }
                mentionTypes.append(MentionType(type: "Users", mentions: userItems))
            }
        }
    }
    
    // MARK: - Внутренняя структура данных
    
   private var mentionTypes: [MentionType] = []
    
    
    private struct MentionType: Printable
    {
        var type: String
        var mentions: [Mention]
        
        var description: String { return "\(type): \(mentions)" }
    }
    
    private enum Mention: Printable
    {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }

    
    // MARK: - UITableViewControllerDataSource
    
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keyword Cell"
        static let ImageCellReuseIdentifier = "Image Cell"
        
        static let KeywordSegueIdentifier = "From Keyword"
        static let ImageSegueIdentifier = "Show Image"
        static let WebSegueIdentifier = "Show URL"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentionTypes.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionTypes[section].mentions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
                                             indexPath: NSIndexPath) -> UITableViewCell {
        
        let mention = mentionTypes[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordCellReuseIdentifier,
                                                            forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = keyword
            return cell
            
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier,
                                                        forIndexPath: indexPath) as! ImageTableViewCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView,
                      heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                            
        let mention = mentionTypes[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView,
                                  titleForHeaderInSection section: Int) -> String? {
        return mentionTypes[section].type
    }
    
    // MARK: - Navitation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.KeywordSegueIdentifier {
            if let cell = sender as? UITableViewCell,
                let url = cell.textLabel?.text where url.hasPrefix("http") {
                    
                    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                    return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.KeywordSegueIdentifier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController,
                    let cell = sender as? UITableViewCell {
                        
                        ttvc.searchText = cell.textLabel?.text
                        
                }
            } else if identifier == Storyboard.ImageSegueIdentifier {
                if let ivc = segue.destinationViewController as? ImageViewController,
                    let cell = sender as? ImageTableViewCell {
                        
                        ivc.imageURL = cell.imageUrl
                        ivc.title = title
                        
                }
            }
        }
    }


}
