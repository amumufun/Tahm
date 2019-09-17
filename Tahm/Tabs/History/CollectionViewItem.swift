//
//  CollectionViewItem.swift
//  Tahm
//
//  Created by Chace on 2019/9/12.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import SwiftHEXColors
import Kingfisher

class CollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var imageAspectView: ImageAspectFillView!
    let prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor(hexString: "#ffffff", alpha: 0.5)?.cgColor
        self.view.layer?.borderColor = NSColor.selectedControlColor.cgColor
        self.view.layer?.borderWidth = 0.0
    }
    
    override var isSelected: Bool {
        didSet {
            self.view.layer?.borderWidth = isSelected ? 3.0 : 0.0
        }
    }
    
    override var representedObject: Any? {
        didSet {
            if let data = representedObject as? Pic {
                let url = "\(String(data.url!))\(cloudConfigList[prefs.cloud].suffix)"
                self.imageAspectView?.kf.setImage(with: URL(string: url))
            }
        }
    }
    
}
