//
//  ReleaseTableViewCell.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 12.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import UIKit
import FeedKit

enum UpdateType: String {
    case iOS = "iOS"
    case watchOS = "watchOS"
    case iTunes = "iTunes"
    case macOS = "macOS"
    case tvOS = "tvOS"
    case other = "other"

    static let all = [iOS, watchOS, iTunes, macOS, tvOS, other]
}

class ReleaseTableViewCell: UITableViewCell {

    var item: RSSFeedItem?
    var updateType: UpdateType = .other

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var releaseTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(_ item: RSSFeedItem) {

        self.item = item

        setupImage()

        var title = item.title
        if let range = title?.range(of: "Released") {
            title?.removeSubrange(range)
        }

        releaseTitle.text = title

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        guard let date = item.pubDate else {
            releaseDate.text = item.description
            return
        }

        releaseDate.text = dateFormatter.string(from: date)

    }

    func setupImage() {
        guard let titleString = self.item?.title else { return }

        for type in UpdateType.all {
            if titleString.contains(type.rawValue) {
                self.updateType = type
                break
            }
        }

        let image = UIImage(named: updateType.rawValue)
        typeImageView.image = image
    }

    override func prepareForReuse() {
        self.updateType = .other
        self.typeImageView.image = nil
    }

}
