//
//  DropView.swift
//  Tahm
//
//  Created by Chace on 2019/8/23.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import SwiftHEXColors

protocol DropViewDelegate {
    func uploadImage(_ urls: [URL])
}

class DropView: NSView {
    
    let shapeLayer = CAShapeLayer()
    var delegate: DropViewDelegate?
    
    let acceptableTypes = [NSPasteboard.PasteboardType.fileURL]
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: NSImage.imageTypes]
    
    var isReceivingDrag = false {
        didSet {
            if isReceivingDrag {
                shapeLayer.strokeColor = NSColor.selectedControlColor.cgColor
            } else {
                shapeLayer.strokeColor = NSColor(hexString: "#000", alpha: 0.4)?.cgColor
            }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func awakeFromNib() {
        self.wantsLayer = true
        self.layer?.cornerRadius = 10

        shapeLayer.strokeColor = NSColor(hexString: "#000", alpha: 0.4)?.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 4
        shapeLayer.lineDashPattern = [8, 5]
        let path = CGMutablePath()
        path.addRoundedRect(in: bounds, cornerWidth: 10, cornerHeight: 10)
        shapeLayer.path = path
        self.layer?.addSublayer(shapeLayer)
        
        registerForDraggedTypes(acceptableTypes)
    }
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            canAccept = true
        }
        return canAccept
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? NSDragOperation.copy : NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = sender.draggingPasteboard
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL], urls.count > 0 {
            delegate?.uploadImage(urls)
            return true
        }
        return false
    }
    
    
}
