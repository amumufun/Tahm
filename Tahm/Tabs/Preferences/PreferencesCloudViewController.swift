//
//  PreferencesCloudViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/29.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

protocol CloudTabViewDelegate {
    func switchTab(at: Int)
}

class PreferencesCloudViewController: NSViewController {

    @IBOutlet weak var popupButton: NSPopUpButton!
    
    var prefs = Preferences()
    var tabDelegate: CloudTabViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        initControls()
    }
    
    func initControls() {
        popupButton.removeAllItems()
        for item in cloudConfigList {
            popupButton.addItem(withTitle: item.name)
        }
        popupButton.selectItem(at: prefs.cloud)
        
        NotificationCenter.default.addObserver(self, selector: #selector(regisSwitchTab), name: NSNotification.Name("regisSwitchTab"), object: nil)
    }
    
    @objc func regisSwitchTab() {
        Utils.fireNotification(name: "switchCloudTab", userInfo: ["tab": prefs.cloud])
    }
    
    @IBAction func backToPreferences(_ sender: NSButton) {
        Utils.fireNotification(name: "switchTab", userInfo: ["tab": TabViews.Preferences.rawValue])
    }
    
    @IBAction func cloudChanged(_ sender: NSPopUpButton) {
        Utils.fireNotification(name: "switchCloudTab", userInfo: ["tab": sender.indexOfSelectedItem])
    }
    
}
