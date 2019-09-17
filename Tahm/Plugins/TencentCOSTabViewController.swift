//
//  TencentCOSTabViewController.swift
//  Tahm
//
//  Created by Chace on 2019/9/17.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class TencentCOSTabViewController: NSViewController {
    
    @IBOutlet weak var bucketName: EditTextField!
    @IBOutlet weak var endPoint: EditTextField!
    @IBOutlet weak var secretId: EditTextField!
    @IBOutlet weak var secretKey: EditTextField!
    @IBOutlet weak var path: EditTextField!
    @IBOutlet weak var domain: EditTextField!
    @IBOutlet weak var suffix: EditTextField!
    
    var conf: TencentCOSConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSControl.textDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear() {
        if let conf = UserDefaults.standard.retrive(TencentCOSConfig.self, key: TencentCOSConfigKey) {
            bucketName.stringValue = conf.bucketName
            if bucketName.stringValue.isEmpty {
                bucketName.backgroundColor = TextFieldErrorColor
            }
            endPoint.stringValue = conf.endPoint
            if bucketName.stringValue.isEmpty {
                endPoint.backgroundColor = TextFieldErrorColor
            }
            secretId.stringValue = conf.secretId
            if bucketName.stringValue.isEmpty {
                secretId.backgroundColor = TextFieldErrorColor
            }
            secretKey.stringValue = conf.secretKey
            if bucketName.stringValue.isEmpty {
                secretKey.backgroundColor = TextFieldErrorColor
            }
            path.stringValue = conf.path
            domain.stringValue = conf.domain
            suffix.stringValue = conf.suffix
            self.conf = conf
        } else {
            conf = TencentCOSConfig(endPoint: "", bucketName: "", secretId: "", secretKey: "", path: "", domain: "", suffix: "")
        }
    }
    
    @objc func textDidChange(_ obj: Notification) {
        if let textField = obj.object as? EditTextField {
            if textField == bucketName {
                if bucketName.stringValue.isEmpty {
                    bucketName.backgroundColor = TextFieldErrorColor
                } else {
                    bucketName.backgroundColor = nil
                }
                conf.bucketName = bucketName.stringValue
            }
            if textField == endPoint {
                if endPoint.stringValue.isEmpty {
                    endPoint.backgroundColor = TextFieldErrorColor
                } else {
                    endPoint.backgroundColor = nil
                }
                conf.endPoint = endPoint.stringValue
            }
            if textField == secretId {
                if secretId.stringValue.isEmpty {
                    secretId.backgroundColor = TextFieldErrorColor
                } else {
                    secretId.backgroundColor = nil
                }
                conf.secretId = secretId.stringValue
            }
            if textField == secretKey {
                if secretKey.stringValue.isEmpty {
                    secretKey.backgroundColor = TextFieldErrorColor
                } else {
                    secretKey.backgroundColor = nil
                }
                conf.secretKey = secretKey.stringValue
            }
            if textField == path {
                conf.path = path.stringValue
            }
            if textField == domain {
                conf.domain = domain.stringValue
            }
            if textField == suffix {
                conf.suffix = suffix.stringValue
            }
            UserDefaults.standard.set(conf, key: TencentCOSConfigKey)
        }
    }
    
}
