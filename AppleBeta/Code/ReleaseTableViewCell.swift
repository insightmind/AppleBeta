//
//  ReleaseTableViewCell.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 12.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import UIKit
import FeedKit

class ReleaseTableViewCell: UITableViewCell {

    var item: RSSFeedItem?
    var updateType: UpdateType = .other

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var releaseTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!

    func setup(_ item: RSSFeedItem) {
        self.item = item
        configureIcon()
        configureTitle()
    }

    private func configureTitle() {
        guard let item = self.item else { return }
        var title = item.title
        if let range = title?.range(of: "Released") {
            title?.removeSubrange(range)
        }

        releaseTitle.text = title

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        if let date = item.pubDate {
            releaseDate.text = dateFormatter.string(from: date)
        } else {
            releaseDate.text = item.description
        }
    }

    private func configureIcon() {
        guard let titleString = self.item?.title else { return }
        updateType = .resolve(from: titleString)
        typeImageView.image = updateType.icon
    }

    override func prepareForReuse() {
        updateType = .other
        typeImageView.image = nil
    }
}
