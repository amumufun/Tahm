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
        
        // TODO transition似乎在主线程执行，整个窗口无法响应点击
        self.transition(from: tabView.selectedTabViewItem!.viewController!, to: tabViewItems[tab].viewController!, options: tab > self.selectedTabViewItemIndex ? .slideUp : .slideDown) {
            self.tabView.selectTabViewItem(at: tab)
        }
    }
    
    // TODO 关闭快捷键cmd + ↑↓ 或实现切换监听事件
    
}
