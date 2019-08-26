//
//  MainViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/22.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import SwiftHEXColors

class MainViewController: NSViewController {
    
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var menuTableView: MenuTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leftView.wantsLayer = true
        leftView.layer?.backgroundColor = NSColor(hexString: "#f2f2f2")?.cgColor
    }
    
}
