//
//  StatusMenuDropView.swift
//  Tahm
//
//  Created by Chace on 2019/8/9.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

protocol StatusMenuDropViewDelegate {
    func uploadImage(_ urls: [URL])
}

class StatusMenuDropView: NSView {
    
    var delegate: StatusMenuDropViewDelegate?
    
    let acceptableTypes = [NSPasteboard.PasteboardType.fileURL]
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: NSImage.imageTypes]
    var statusItemButton: NSStatusBarButton!
    var isReceivingDrag = false {
        didSet {
            if isReceivingDrag {
                let image = NSImage(named: "upload")
                image?.isTemplate = true
                statusItemButton.image = image
            } else {
                let image = NSImage(named: "status-logo")
                image?.isTemplate = true
                statusItemButton.image = image
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        registerForDraggedTypes(acceptableTypes)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
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
