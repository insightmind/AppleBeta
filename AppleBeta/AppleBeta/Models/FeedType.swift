//
//  UpdateType.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 19.09.19.
//  Copyright © 2019 Niklas Bülow. All rights reserved.
//

import UIKit

enum FeedType: String, CaseIterable {
    case iOS = "iOS"
    case iPadOS = "iPadOS"
    case watchOS = "watchOS"
    case macOS = "macOS"
    case tvOS = "tvOS"
    case xcode = "Xcode"
    case other = "other"

    var icon: UIImage { UIImage(named: self.rawValue)! }

    static func resolve(from string: String) -> Self {
        return allCases.first { string.contains($0.rawValue) } ?? .other
    }
}
