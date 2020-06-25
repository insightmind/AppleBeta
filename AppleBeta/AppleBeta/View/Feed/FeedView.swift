//
//  FeedView.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 18.06.20.
//  Copyright © 2020 Niklas Buelow. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    let title: String
    let source: Source

    @State
    private var feed: [FeedItem] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    ForEach(feed, content: FeedCell.init)
                        .padding([.leading, .trailing])
                }
            }
            .onAppear(perform: loadFeed)
            .navigationBarTitle(title)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func loadFeed() {
        Requester().loadFeed(for: source) { feed in
            self.feed = feed
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(title: "Apple Releases", source: .apple)
    }
}
