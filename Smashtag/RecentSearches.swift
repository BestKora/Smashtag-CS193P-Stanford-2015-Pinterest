//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/9/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation
class RecentSearches {
    
    private struct Constants {
        static let SearchesKey = "RecentSearches.Values"
        static let MaxSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var searches: [String] {
        get { return defaults.objectForKey(Constants.SearchesKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: Constants.SearchesKey) }
    }
    
    func add(search: String) {
        var currentSearches = searches
        if let index = find(currentSearches, search) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(search, atIndex: 0)
        while currentSearches.count > Constants.MaxSearches {
            currentSearches.removeLast()
        }
        searches = currentSearches
    }
    
    func removeAtIndex(index: Int) {
        var currentSearches = searches
        currentSearches.removeAtIndex(index)
        searches = currentSearches
    }
    
}
