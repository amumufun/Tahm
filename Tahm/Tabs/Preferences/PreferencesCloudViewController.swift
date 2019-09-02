//
//  PreferencesCloudViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/29.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class PreferencesCloudViewController: NSViewController {

    @IBOutlet weak var popupButton: NSPopUpButton!
    @IBOutlet weak var tabView: NSTabView!
    
    var prefs = Preferences()
    
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
        tabView.selectTabViewItem(at: prefs.cloud)
    }
    
    @IBAction func backToPreferences(_ sender: NSButton) {
        Utils.switchTab(tab: TabViews.Preferences.rawValue)
    }
    
    @IBAction func cloudChanged(_ sender: NSPopUpButton) {
        tabView.selectTabViewItem(at: sender.indexOfSelectedItem)
    }
    
    
    
}
