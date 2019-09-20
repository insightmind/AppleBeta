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
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let backgroundTaskIdentifier = "com.niklasbuelow.applebeta.releases.refresh"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { [weak self] task in
            guard let task = task as? BGAppRefreshTask else { return }
            self?.reloadReleases(task)
        }

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleBackgroundReload()
    }

    private func reloadReleases(_ task: BGAppRefreshTask) {
        guard let url = ReleaseSources.apple.url else { return }
        Requester.request(url: url, failure: nil, completion: { Requester.handle(feed: $0) })
    }

    private func scheduleBackgroundReload() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: Date()) ?? Date()
        try? BGTaskScheduler.shared.submit(request)
    }
}

