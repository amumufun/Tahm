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
    lazy var statusBarWindow: NSWindow = {
        let contentRect = NSRect(x: 0, y: 0, width: 200, height: 200)
        let statusBarWindow = NSWindow(contentRect: contentRect, styleMask: [], backing: .buffered, defer: false)
        statusBarWindow.hasShadow = true
        statusBarWindow.isOpaque = false
        statusBarWindow.level = NSWindow.Level.statusBar
        statusBarWindow.backgroundColor = NSColor.clear
        statusBarWindow.animationBehavior = NSWindow.AnimationBehavior.utilityWindow
        return statusBarWindow
    }()
    @IBOutlet weak var statusBarWindowView: NSView!
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
    @IBOutlet weak var statusBarImage: ImageAspectFillView!
    
    var uploadClient: UploadClient?
    lazy var coreDataManager: CoreDataManager = {
        return CoreDataManager()
    }()
    
    lazy var mainWindowController: MainWindowController? = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let id = NSStoryboard.SceneIdentifier("MainWindowController")
        guard let controller = storyboard.instantiateController(withIdentifier: id) as? MainWindowController else {
            return nil
        }
        return controller
    }()
    
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
        configureStatusBarWindow(button)
        
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
    
    func configureStatusBarWindow(_ button: NSStatusBarButton) {
        statusBarWindowView.wantsLayer = true
        statusBarWindowView.layer?.cornerRadius = 5.0
        statusBarWindowView.layer?.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        statusBarWindowView.layer?.backgroundColor = NSColor.white.cgColor
        statusBarWindow.contentView = statusBarWindowView
        
        statusBarImage.image = NSImage(named: "pic")
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] (event) -> NSEvent? in
            if event.window == button.window && button.isEnabled {
                self?.toggleMainWindow(button)
                return nil
            }
            return event
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.statusBarWindow.isVisible {
                strongSelf.closeMainWindow(event)
            }
        }
    }
    
    func toggleMainWindow(_ sender: NSButton) {
        if statusBarWindow.isVisible && sender.window?.screen == statusBarWindow.screen {
            closeMainWindow(sender)
        } else {
            showMainWindow(sender)
        }
    }
    
    func showMainWindow(_ sender: NSButton) {
        if let frame = sender.window?.frame {
            statusBarWindow.setFrameOrigin(NSMakePoint(frame.minX, frame.minY - statusBarWindow.frame.height))
            statusBarWindow.makeKeyAndOrderFront(sender)
            isOpen = true
            eventMonitor?.start()
        }
    }
    
    func closeMainWindow(_ sender: Any?) {
        statusBarWindow.orderOut(sender)
        isOpen = false
        eventMonitor?.stop()
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func showMainWindow(_ sender: Any) {
        mainWindowController?.window?.makeKeyAndOrderFront(sender)
        NSApp.setActivationPolicy(.regular)
        closeMainWindow(sender)
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
        DispatchQueue.main.async {
            self.statusItemButton!.isEnabled = true
            self.progressbar!.isHidden = true
        }
    }
}

extension StatusMenuController: UploadClientDelegate {
    func uploadSuccess(results: [UploadResult]) {
        var urls: [String] = []
        for item in results {
            let pic = NSEntityDescription.insertNewObject(forEntityName: "Pic", into: self.coreDataManager.managedObjectContext) as! Pic
            pic.originalName = item.originalName
            pic.uploadTime = item.uploadTime
            pic.url = item.url
            pic.storage = item.storage
            
            urls.append(pic.url!)
        }
        self.coreDataManager.saveAction(nil)
        
        // 通知
        Utils.showNotification(message: "\(results.count)条图片地址已复制到剪贴板", title: "上传成功")
        // 复制到剪贴板
        Utils.copyToPasteboard(string: urls.joined(separator: "\n"))
        self.uploadComplete()
    }
    
    func uploadProgress(percentage: Double) {
        DispatchQueue.main.async {
            self.progressbar?.doubleValue = percentage
        }
    }
}
