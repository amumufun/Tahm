//
//  PreferencesViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/26.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import MASShortcut

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var shortcutView: MASShortcutView!
    @IBOutlet weak var cloudButton: NSPopUpButton!
    @IBOutlet weak var filenameRadio: NSButton!
    @IBOutlet weak var dateRadio: NSButton!
    @IBOutlet weak var randomRadio: NSButton!
    @IBOutlet weak var clipboardCheckbox: NSButtonCell!
    @IBOutlet weak var powerBootCheckbox: NSButton!
    @IBOutlet weak var uploadMessageCheckbox: NSButton!
    @IBOutlet weak var compressCheckbox: NSButton!
    var namingValue: Int {
        var type = 0
        if filenameRadio.state == .on {
            type = 0
        } else if dateRadio.state == .on {
            type = 1
        } else if randomRadio.state == .on {
            type = 2
        }
        return type
    }
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        initControls()
    }
    
    func initControls() {
        cloudButton.removeAllItems()
        for item in cloudConfigList {
            cloudButton.addItem(withTitle: item.name)
        }
        cloudButton.selectItem(at: prefs.cloud)
        
        switch prefs.naming {
        case 0:
            filenameRadio.state = .on
        case 1:
            dateRadio.state = .on
        case 2:
            randomRadio.state = .on
        default:
            filenameRadio.state = .on
        }
        
        let shortcut = MASShortcut(keyCode: kVK_Space, modifierFlags: .shift)
        MASShortcutMonitor.shared()?.register(shortcut, withAction: {
            print("触发快捷键")
        })
        
        shortcutView.shortcutValue = shortcut
        
        clipboardCheckbox.state = prefs.clipboard ? .on : .off
        powerBootCheckbox.state = prefs.powerBoot ? .on : .off
        uploadMessageCheckbox.state = prefs.uploadMessage ? .on : .off
        compressCheckbox.state = prefs.compress ? .on : .off
    }
    
    @IBAction func configCloud(_ sender: NSButton) {
        Utils.switchTab(tab: TabViews.PreferencesCloud.rawValue)
    }
    
    @IBAction func radioChanged(_ sender: Any) {
        prefs.naming = namingValue
    }
    
    @IBAction func clipboardCheckboxClick(_ sender: Any) {
        prefs.clipboard = clipboardCheckbox.state == .on ? true : false
    }
    
    @IBAction func powerBootCheckboxClick(_ sender: Any) {
        prefs.powerBoot = powerBootCheckbox.state == .on ? true : false
    }
    
    @IBAction func uploadMessageCheckboxClick(_ sender: Any) {
        prefs.uploadMessage = uploadMessageCheckbox.state == .on ? true : false
    }

    @IBAction func compressCheckboxClick(_ sender: Any) {
        prefs.compress = compressCheckbox.state == .on ? true : false
    }
    
    @IBAction func cloudChanged(_ sender: NSPopUpButton) {
        prefs.cloud = sender.indexOfSelectedItem
    }
    
}
