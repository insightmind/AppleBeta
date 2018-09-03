//
//  AppDelegate.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 09.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import UIKit
import FeedKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        return true
    }
    
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        guard let url = ReleaseSources.apple.url else { return }
        Requester.request(
            url: url,
            failure: { _ in
                completionHandler(.failed)
        },
            completion: {
                let result = Requester.handle(feed: $0)
                completionHandler(result)
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

