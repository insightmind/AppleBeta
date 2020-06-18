//
//  ContentView.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 18.06.20.
//  Copyright © 2020 Niklas Buelow. All rights reserved.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
        TabView {
            FeedView(title: "Apple Releases", source: .apple)
                .tabItem {
                    Image("Apple")
                    Text("Apple Releases")
                }
            FeedView(title: "IPSW", source: .ipsw)
                .tabItem {
                    Image("IPSW")
                    Text("IPSW")
                }
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
