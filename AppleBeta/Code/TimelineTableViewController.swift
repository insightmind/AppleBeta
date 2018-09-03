//
//  TimelineTableViewController.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 10.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import UIKit
import UserNotifications
import FeedKit

class TimelineTableViewController: UITableViewController {
    var data: [RSSFeedItem] = []
    let reuseIdentifer = "ReleaseCell"
    var source: ReleaseSources?

    override func viewDidLoad() {
        super.viewDidLoad()

        source = source ?? Requester.currentSource

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error { print(error.localizedDescription) }
        }

        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        refresh(self)
    }

    @objc func refresh(_ sender: Any?) {
        guard let url = source?.url else { return }
        Requester.request(
            url: url,
            failure: {
                print($0.localizedDescription)
                self.refreshControl?.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0)
        },
            completion: { feed in
                self.data = feed.items ?? []
                self.tableView.reloadData()
                self.refreshControl?.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0)
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! ReleaseTableViewCell
        cell.setup(data[indexPath.row])
        return cell
    }

}
