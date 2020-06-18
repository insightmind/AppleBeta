//
//  Source.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 18.06.20.
//  Copyright © 2020 Niklas Buelow. All rights reserved.
//

import Foundation

enum Source: String {
    case ipsw = "https://ipsw.me/timeline.rss"
    case apple = "https://developer.apple.com/news/releases/rss/releases.rss"

    var url: URL? { return URL(string: self.rawValue) }
}
