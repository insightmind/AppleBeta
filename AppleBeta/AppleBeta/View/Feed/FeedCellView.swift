//
//  FeedCellView.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 18.06.20.
//  Copyright © 2020 Niklas Buelow. All rights reserved.
//

import SwiftUI

struct FeedCellView: View {
    @State var feedItem: FeedItem

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundColor(Color(.quaternarySystemFill))

                Image(uiImage: feedItem.type.icon)
                    .resizable()

            }.aspectRatio(1, contentMode: .fit)


            VStack(alignment: .leading) {
                Text(feedItem.title)
                    .font(.system(size: 16, weight: .bold))

                Text(feedItem.dateString)
                    .font(.system(size: 12))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, idealHeight: 60, alignment: .leading)
    }
}

struct FeedCellView_Previews: PreviewProvider {
    static var previews: some View {
        FeedCellView(feedItem: FeedItem(type: .iOS, title: "Xcode 11.6 beta (11N700h)", date: Date()))
    }
}
