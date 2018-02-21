//
//  TabBarViewController.swift
//  AppleBeta
//
//  Created by Niklas Bülow on 21.02.18.
//  Copyright © 2018 Niklas Bülow. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        checkSelection()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        checkSelection()
    }

    private func checkSelection() {
        guard let item = self.tabBar.selectedItem else { return }
        if item.title == "Apple Releases" {
            Requester.currentSource = .apple
        } else if item.title == "ipsw" {
            Requester.currentSource = .ipsw
        }
    }
}
