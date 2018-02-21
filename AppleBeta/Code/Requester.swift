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


enum ReleaseSources: String {
    case ipsw = "https://ipsw.me/timeline.rss"
    case apple = "https://developer.apple.com/news/releases/rss/releases.rss"

    func url() -> URL? { return URL(string: self.rawValue) }
}

class Requester {

    static let queue = DispatchQueue(label: "AppleBeta", qos: .userInitiated)

    static var currentSource: ReleaseSources = .apple

    static func request(url: URL?, completion: ((RSSFeed?) -> Void)?) {
        queue.async {
            guard let feedURL = url else {
                completion?(nil)
                return
            }
            let parser = FeedParser(URL: feedURL)

            guard let result = parser?.parse() else {
                completion?(nil)
                return
            }
            if result.isFailure {
                completion?(nil)
                return
            }
            if let error = result.error {
                print(error.localizedDescription)
                completion?(nil)
                return
            }

            if result.isSuccess {
                switch result {
                case let .rss(feed):
                    completion?(feed)
                default:
                    completion?(nil)
                }
            }
        }
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
