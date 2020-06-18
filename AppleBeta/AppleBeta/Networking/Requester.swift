//
//  Requester.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 10.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import UIKit
import UserNotifications
import FeedKit

class Requester {
    enum RequesterError: Error {
        case invalidURL
        case invalidResult
        case invalidData
    }

    static let queue = DispatchQueue(label: "AppleBeta", qos: .userInitiated)

    func loadFeed(for source: Source, failure: ((Error) -> Void)? = nil, completion: @escaping ([FeedItem]) -> Void) {
        guard let url = source.url else {
            failure?(RequesterError.invalidURL)
            return
        }

        request(url: url, failure: failure) { feed in
            guard let items = feed.items else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            let feedItems = items.compactMap { item -> FeedItem? in
                guard let title = item.title, let date = item.pubDate else { return nil }
                return FeedItem(type: .resolve(from: title), title: title, date: date)
            }

            DispatchQueue.main.async { completion(feedItems) }
        }
    }

    private func request(url: URL, failure: ((Error) -> Void)? = nil, completion: @escaping (RSSFeed) -> Void) {
        let parser = FeedParser(URL: url)
        parser.parseAsync { result in
            switch result {
            case let .success(result):
                guard let feed = result.rssFeed else {
                    failure?(RequesterError.invalidData)
                    return
                }

                completion(feed)

            case let .failure(error):
                failure?(error)
            }
        }
    }

    @discardableResult
    private func handle(feed: RSSFeed) -> UIBackgroundFetchResult {
        let currentDate = Date()
        let defaults = UserDefaults.standard
        let date = defaults.object(forKey: "LastFetch") as? Date ?? Date(timeIntervalSince1970: 0)

        guard let items = feed.items?.reversed() else { return .noData }

        var badgeCount = 0

        items.filter { item -> Bool in
            guard let itemDate = item.pubDate else { return false }
            return date < itemDate
        }.forEach { item in
            guard let title = item.title else { return }

            let content = UNMutableNotificationContent()
            content.title = "A new software update is now available."
            content.body = title
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
            let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            badgeCount += 1
        }

        UIApplication.shared.applicationIconBadgeNumber = badgeCount

        defaults.set(currentDate, forKey: "LastFetch")
        defaults.synchronize()

        return .newData
    }
}
