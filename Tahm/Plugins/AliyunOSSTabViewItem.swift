//
//  AliyunOSSTabViewItem.swift
//  Tahm
//
//  Created by Chace on 2019/9/2.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class AliyunOSSTabViewItem: NSTabViewItem {
    @IBOutlet weak var bucketName: EditTextField!
    @IBOutlet weak var endPoint: EditTextField!
    @IBOutlet weak var accessKeyId: EditTextField!
    @IBOutlet weak var secretKeyId: EditTextField!
    @IBOutlet weak var path: EditTextField!
    @IBOutlet weak var suffix: EditTextField!
    @IBOutlet weak var httpRadio: NSButton!
    @IBOutlet weak var httpsRadio: NSButton!
    var sslValue: Bool {
        if httpsRadio.state == .on {
            return true
        }
        return false
    }
    
    var conf: AliyunOSSConfig!
    
    override func awakeFromNib() {
        if let conf = UserDefaults.standard.retrive(AliyunOSSConfig.self, key: AliyunOSSConfigKey) {
            bucketName.stringValue = conf.bucketName
            if bucketName.stringValue.isEmpty {
                bucketName.backgroundColor = TextFieldErrorColor
            }
            endPoint.stringValue = conf.endPoint
            if bucketName.stringValue.isEmpty {
                endPoint.backgroundColor = TextFieldErrorColor
            }
            accessKeyId.stringValue = conf.accessKeyId
            if bucketName.stringValue.isEmpty {
                accessKeyId.backgroundColor = TextFieldErrorColor
            }
            secretKeyId.stringValue = conf.secretKeyId
            if bucketName.stringValue.isEmpty {
                secretKeyId.backgroundColor = TextFieldErrorColor
            }
            path.stringValue = conf.path
            suffix.stringValue = conf.suffix
            if conf.ssl {
                httpsRadio.state = .on
            } else {
                httpRadio.state = .on
            }
            self.conf = conf
        } else {
            conf = AliyunOSSConfig(endPoint: "", bucketName: "", ssl: true, accessKeyId: "", secretKeyId: "", path: "", suffix: "")
        }
    }
    
    @IBAction func procotolChanged(_ sender: NSButton) {
        conf.ssl = sslValue
        UserDefaults.standard.set(conf, key: AliyunOSSConfigKey)
    }
}

extension AliyunOSSTabViewItem: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
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
            if textField == accessKeyId {
                if accessKeyId.stringValue.isEmpty {
                    accessKeyId.backgroundColor = TextFieldErrorColor
                } else {
                    accessKeyId.backgroundColor = nil
                }
                conf.accessKeyId = accessKeyId.stringValue
            }
            if textField == secretKeyId {
                if secretKeyId.stringValue.isEmpty {
                    secretKeyId.backgroundColor = TextFieldErrorColor
                } else {
                    secretKeyId.backgroundColor = nil
                }
                conf.secretKeyId = secretKeyId.stringValue
            }
            if textField == path {
                conf.path = path.stringValue
            }
            if textField == suffix {
                conf.suffix = suffix.stringValue
            }
            UserDefaults.standard.set(conf, key: AliyunOSSConfigKey)
        }
    }
}
