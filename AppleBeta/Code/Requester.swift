//
//  Requester.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 10.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import Foundation
import UserNotifications
import FeedKit

class Requester {
    
    static let feedURL = URL(string: "https://ipsw.me/timeline.rss")
    
    static func request() -> RSSFeed? {
        
        guard let feedURL = Requester.feedURL else {
            return nil
        }
        let parser = FeedParser(URL: feedURL)
        
        guard let result = parser?.parse() else { return nil }
        if result.isFailure { return nil }
        if let error = result.error {
            print(error.localizedDescription)
            return nil
        }
        
        if result.isSuccess {
            switch result {
            case let .rss(feed):
                return feed
            default:
                return nil
            }
        }
        
        return nil
    }
    
    static func handle(feed: RSSFeed) -> UIBackgroundFetchResult {
        
        guard let pubDate = feed.pubDate else { return .noData }
        
        let defaults = UserDefaults.standard
        let date = defaults.object(forKey: "LastFetch") as? Date ?? pubDate
        
        guard let items = feed.items?.reversed() else { return .noData }
        
        var badgeCount = 0
        
        for item in items {
            
            guard let itemDate = item.pubDate else { continue }
            
            let comparison = Calendar(identifier: .gregorian).compare(itemDate, to: date, toGranularity: .nanosecond)
            if comparison == .orderedAscending { break }
            
            guard let title = item.title else { continue }
            guard let description = item.description else { continue }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = description
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
            badgeCount += 1
        }
        
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
        
        defaults.set(pubDate, forKey: "LastFetch")
        defaults.synchronize()
        
        return .newData
    }
    
}
