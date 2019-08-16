//
//  StatusMenuController.swift
//  Tahm
//
//  Created by Chace on 2019/8/5.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa
import Alamofire

class StatusMenuController: NSObject {

    var statusItem: NSStatusItem?
    var statusItemButton: NSStatusBarButton?
    var progressbar: NSProgressIndicator?
    lazy var mainWindow: NSWindow = {
        let contentRect = NSRect(x: 0, y: 0, width: 200, height: 200)
        let mainWindow = NSWindow(contentRect: contentRect, styleMask: [], backing: .buffered, defer: false)
        mainWindow.hasShadow = true
        mainWindow.isOpaque = false
        mainWindow.level = NSWindow.Level.statusBar
        mainWindow.backgroundColor = NSColor.clear
        return mainWindow
    }()
    @IBOutlet weak var mainView: NSView!
    var isOpen: Bool = false {
        didSet {
            if isOpen {
                statusItem?.button?.highlight(true)
            } else {
                statusItem?.button?.highlight(false)
            }
        }
    }
    var eventMonitor: EventMonitor?
    @IBOutlet weak var mainImageView: ImageAspectFillView!
    
    var uploadClient: UploadClient?
    
    override func awakeFromNib() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = statusItem?.button else {
            print("应用启动失败，请尝试关闭一些菜单栏应用")
            NSApplication.shared.terminate(nil)
            return
        }
        let image = NSImage(named: "status-logo")
        image?.isTemplate = true
        button.image = image
        statusItemButton = button
        
        configureDragView(button)
        configureMainWindow(button)
        
        uploadClient = UploadClient.getClient(className: "AliyunOSS")
        uploadClient?.delegate = self
    }
    
    func configureDragView(_ button: NSStatusBarButton) {
        let buttonWindowFrame = button.window!.frame
        let statusItemFrame = NSRect(x: 0, y: 0, width: buttonWindowFrame.width, height: buttonWindowFrame.height)
        let dropView = StatusMenuDropView(frame: statusItemFrame)
        dropView.statusItemButton = button
        dropView.delegate = self
        button.addSubview(dropView)
        
        let progrwssFrame = NSRect(x: (buttonWindowFrame.width - 20) / 2, y: (buttonWindowFrame.height - 20) / 2, width: 20, height: 20)
        progressbar = NSProgressIndicator(frame: progrwssFrame)
        progressbar!.style = .spinning
        progressbar!.minValue = 0
        progressbar!.maxValue = 1
        progressbar!.isIndeterminate = false
        progressbar!.wantsLayer = true
        progressbar!.layer?.backgroundColor = NSColor.white.cgColor
        progressbar!.isHidden = true
        button.addSubview(progressbar!)
    }
    
    func configureMainWindow(_ button: NSStatusBarButton) {
        mainView.wantsLayer = true
        mainView.layer?.cornerRadius = 5.0
        mainView.layer?.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mainView.layer?.backgroundColor = NSColor.white.cgColor
        mainWindow.contentView = mainView
        
        mainImageView.image = NSImage(named: "pic")
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] (event) -> NSEvent? in
            if event.window == button.window && button.isEnabled {
                self?.toggleMainWindow(button)
                return nil
            }
            return event
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.mainWindow.isVisible {
                strongSelf.closeMainWindow(event)
            }
        }
    }
    
    func toggleMainWindow(_ sender: NSButton) {
        if mainWindow.isVisible && sender.window?.screen == mainWindow.screen {
            closeMainWindow(sender)
        } else {
            showMainWindow(sender)
        }
    }
    
    func showMainWindow(_ sender: NSButton) {
        if let frame = sender.window?.frame {
            mainWindow.setFrameOrigin(NSMakePoint(frame.minX, frame.minY - mainWindow.frame.height))
            mainWindow.makeKeyAndOrderFront(sender)
            isOpen = true
            eventMonitor?.start()
        }
    }
    
    func closeMainWindow(_ sender: Any?) {
        mainWindow.orderOut(sender)
        isOpen = false
        eventMonitor?.stop()
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
}

extension StatusMenuController: StatusMenuDropViewDelegate {
    func uploadImage(_ urls: [URL]) {
        uploadStart()
        uploadClient?.upload(urls)
    }
    
    func uploadStart() {
        statusItemButton!.isEnabled = false
        progressbar!.isHidden = false
    }
    func uploadComplete() {
        statusItemButton!.isEnabled = true
        progressbar!.isHidden = true
    }
}

extension StatusMenuController: UploadClientDelegate {
    func uploadSuccess(result: [UploadResult]) {
    }
    
    func uploadProgress(percentage: Double) {
        DispatchQueue.main.async {
            self.progressbar?.doubleValue = percentage
            if (percentage == 1.0) {
                self.uploadComplete()
            }
        }
    }
}
