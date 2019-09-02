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
        
        uploadClient = UploadClient.getClient(className: "AliyunOSS")
        uploadClient?.delegate = self
        
        dropView.delegate = self
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
            
            urls.append(pic.url!)
        }
        self.coreDataManager.saveAction(nil)
        
        if prefs.uploadMessage {
            Utils.showNotification(message: "\(results.count)条图片地址已复制到剪贴板", title: "上传成功")
        }
        // 复制到剪贴板
        Utils.copyToPasteboard(string: urls.joined(separator: "\n"))
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
