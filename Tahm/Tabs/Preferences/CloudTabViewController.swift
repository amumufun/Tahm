//
//  CloudTabViewController.swift
//  Tahm
//
//  Created by Chace on 2019/9/17.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class CloudTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchTab(nofi:)), name: NSNotification.Name("switchCloudTab"), object: nil)
        // 保证在当前控制器初始化 再切换tab
        Utils.fireNotification(name: "regisSwitchTab")
    }
    
    @objc func switchTab(nofi: Notification) {
        let tab = nofi.userInfo!["tab"] as! Int
        self.tabView.selectTabViewItem(at: tab)
    }
    
}
