//
//  TabViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/23.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

public enum TabViews: Int {
    case Upload
    case History
    case Preferences
    case PreferencesCloud
    case Help
}

class TabViewController: NSTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchTab(nofi:)), name: NSNotification.Name("switchTab"), object: nil)
    }
    
    @objc func switchTab(nofi: Notification) {
        let tab = nofi.userInfo!["tab"] as! Int
        
        // 切换动画执行时，左侧菜单无法点击，怎么破
        self.transition(from: tabView.selectedTabViewItem!.viewController!, to: tabViewItems[tab].viewController!, options: tab > self.selectedTabViewItemIndex ? .slideUp : .slideDown) {
            self.tabView.selectTabViewItem(at: tab)
        }
    }
    
}
