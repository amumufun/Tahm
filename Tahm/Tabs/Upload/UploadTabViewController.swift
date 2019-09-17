//
//  UploadTabViewController.swift
//  Tahm
//
//  Created by Chace on 2019/8/23.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class UploadTabViewController: NSViewController {
    
    var uploadClient: UploadClient?
    lazy var coreDataManager: CoreDataManager = {
        return CoreDataManager()
    }()
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var dropView: DropView!
    
    let prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        dropView.delegate = self
    }
    
    override func viewWillAppear() {
        uploadClient = UploadClient.getClient(className: cloudConfigList[prefs.cloud].className)
        uploadClient?.delegate = self
    }
    
}

extension UploadTabViewController: DropViewDelegate {
    func uploadImage(_ urls: [URL]) {
        uploadClient?.upload(urls)
    }
}

extension UploadTabViewController: UploadClientDelegate {
    func uploadStart() {
        label.isHidden = true
        progressBar.isHidden = false
        dropView.isHidden = true
    }
    
    func uploadSuccess(results: [UploadResult]) {
        var urls: [String] = []
        for item in results {
            let pic = NSEntityDescription.insertNewObject(forEntityName: "Pic", into: self.coreDataManager.managedObjectContext) as! Pic
            pic.originalName = item.originalName
            pic.uploadTime = item.uploadTime
            pic.url = item.url
            pic.storage = item.storage
            
            urls.append(Utils.generateLinks(url: pic.url!, type: prefs.format))
        }
        self.coreDataManager.saveAction(nil)
        
        // 复制到剪贴板
        Utils.copyToPasteboard(string: urls.joined(separator: "\n"))
        if prefs.uploadMessage {
            Utils.showNotification(message: "\(results.count)条图片地址已复制到剪贴板", title: "上传成功")
        }
        
        DispatchQueue.main.async {
            self.label.isHidden = false
            self.progressBar.isHidden = true
            self.dropView.isHidden = false
        }
    }
    
    func uploadProgress(percentage: Double) {
        DispatchQueue.main.async {
            self.progressBar?.doubleValue = percentage
        }
    }
}
