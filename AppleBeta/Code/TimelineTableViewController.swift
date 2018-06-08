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

        if source == nil {
            self.source = Requester.currentSource
        }

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        refresh(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        refresh(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func refresh(_ sender: Any?) {
        guard let source = self.source else { return }
        Requester.request(url: source.url()) { feed in
            DispatchQueue.main.async {
                self.data = feed?.items ?? []
                self.tableView.reloadData()
                // End refreshing; if we don't do it this way the refresh
                // animation ends up jerky
                self.refreshControl?.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0)
            }
        }
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
