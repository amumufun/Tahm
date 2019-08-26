//
//  ImageAspectFillView.swift
//  Tahm
//
//  Created by Chace on 2019/8/5.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class ImageAspectFillView: NSImageView {

    override var image: NSImage? {
        set {
            self.layer = CALayer()
            self.layer?.contentsGravity = CALayerContentsGravity.resizeAspectFill
            self.layer?.contents = newValue
            self.wantsLayer = true
            
            super.image = newValue
        }
        
        get {
            return super.image
        }
    }
    
}
