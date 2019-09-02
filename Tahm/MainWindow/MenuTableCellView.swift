//
//  MenuTableCellView.swift
//  Tahm
//
//  Created by Chace on 2019/8/21.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftHEXColors

class MenuTableCellView: NSTableCellView {
    
    lazy var backgroundView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 13
        view.layer?.backgroundColor = NSColor(hexString: "#ccc", alpha: 0.5)?.cgColor
        view.isHidden = true
        return view
    }()
    
    lazy var iconView: NSImageView = {
        let imageView = NSImageView()
        return imageView
    }()
    
    lazy var menuItemView: NSStackView = {
        let view = NSStackView()
        view.spacing = 12
        return view
    }()
    
    lazy var textLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBezeled = false
        label.drawsBackground = false
        label.font = NSFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    var selected: Bool = false {
        didSet {
            backgroundView.isHidden = !selected
        }
    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func awakeFromNib() {
        menuItemView.addView(iconView, in: .leading)
        menuItemView.addView(textLabel, in: .leading)
        
        self.addSubview(backgroundView)
        self.addSubview(menuItemView)
        
        backgroundView.snp.makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self).inset(NSEdgeInsetsMake(3, 5, 3, 5))
        }
        menuItemView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(NSEdgeInsetsMake(5, 15, 5, 15))
        }
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(18)
        }
    }
    
}
