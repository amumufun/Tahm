//
//  PreferencesViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/26.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import MASShortcut
import LaunchAtLogin

protocol PreferencesDelegate {
    func cloudChanged(className: String)
}

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var shortcutView: MASShortcutView!
    @IBOutlet weak var cloudButton: NSPopUpButton!
    @IBOutlet weak var namingFilenameRadio: NSButton!
    @IBOutlet weak var namingDateRadio: NSButton!
    @IBOutlet weak var namingRandomRadio: NSButton!
    @IBOutlet weak var formatURLRadio: NSButton!
    @IBOutlet weak var formatMarkdownRadio: NSButton!
    @IBOutlet weak var formatHTMLRadio: NSButton!
    @IBOutlet weak var clipboardCheckbox: NSButtonCell!
    @IBOutlet weak var startAtLoginCheckbox: NSButton!
    @IBOutlet weak var uploadMessageCheckbox: NSButton!

    var namingValue: Int {
        var type = 0
        if namingFilenameRadio.state == .on {
            type = 0
        } else if namingDateRadio.state == .on {
            type = 1
        } else if namingRandomRadio.state == .on {
            type = 2
        }
        return type
    }
    
    var formatValue: Int {
        var type = 0
        if formatURLRadio.state == .on {
            type = 0
        } else if formatMarkdownRadio.state == .on {
            type = 1
        } else if formatHTMLRadio.state == .on {
            type = 2
        }
        return type
    }
    
    var prefs = Preferences()
    var delegate: PreferencesDelegate?
    
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
            formatURLRadio.state = .on
        case 1:
            namingDateRadio.state = .on
        case 2:
            namingRandomRadio.state = .on
        default:
            namingFilenameRadio.state = .on
        }
        
        switch prefs.format {
        case 0:
            formatURLRadio.state = .on
        case 1:
            formatMarkdownRadio.state = .on
        case 2:
            formatHTMLRadio.state = .on
        default:
            formatURLRadio.state = .on
        }
        
        let shortcut = MASShortcut(keyCode: kVK_Space, modifierFlags: .shift)
        MASShortcutMonitor.shared()?.register(shortcut, withAction: {
            print("触发快捷键")
        })
        
        shortcutView.shortcutValue = shortcut
        
        clipboardCheckbox.state = prefs.clipboard ? .on : .off
        startAtLoginCheckbox.state = prefs.startAtLogin ? .on : .off
        uploadMessageCheckbox.state = prefs.uploadMessage ? .on : .off
    }
    
    @IBAction func configCloud(_ sender: NSButton) {
        Utils.fireNotification(name: "switchTab", userInfo: ["tab": TabViews.PreferencesCloud.rawValue])
    }
    
    @IBAction func radioChanged(_ sender: Any) {
        prefs.naming = namingValue
    }
    
    @IBAction func formatRadioChanged(_ sender: Any) {
        prefs.format = namingValue
    }
    
    @IBAction func clipboardCheckboxClick(_ sender: Any) {
        prefs.clipboard = clipboardCheckbox.state == .on ? true : false
    }
    
    @IBAction func startAtLoginCheckboxClick(_ sender: Any) {
        prefs.startAtLogin = startAtLoginCheckbox.state == .on ? true : false
        // 设置自启动
        LaunchAtLogin.isEnabled = prefs.startAtLogin
    }
    
    @IBAction func uploadMessageCheckboxClick(_ sender: Any) {
        prefs.uploadMessage = uploadMessageCheckbox.state == .on ? true : false
    }
    
    @IBAction func cloudChanged(_ sender: NSPopUpButton) {
        prefs.cloud = sender.indexOfSelectedItem
        delegate?.cloudChanged(className: cloudConfigList[prefs.cloud].className)
    }
    
}
