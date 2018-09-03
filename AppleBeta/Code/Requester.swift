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

    var url: URL? { return URL(string: self.rawValue) }
}

class Requester {
    enum RequesterError: Error {
        case invalidURL
        case invalidResult
        case invalidData
    }

    static let queue = DispatchQueue(label: "AppleBeta", qos: .userInitiated)
    static var currentSource: ReleaseSources = .apple

    static func request(
        url: URL,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping (RSSFeed) -> Void
    ) {
        let parser = FeedParser(URL: url)
        queue.async {
            guard let result = parser?.parse() else {
                failure?(RequesterError.invalidResult)
                return
            }

            if result.isFailure, let error = result.error {
                failure?(error)
                return
            }

            if result.isSuccess {
                switch result {
                case let .rss(feed):
                    DispatchQueue.main.async { completion(feed) }

                default:
                    failure?(RequesterError.invalidData)
                }
            }
        }
    }

    @discardableResult
    static func handle(feed: RSSFeed) -> UIBackgroundFetchResult {
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
