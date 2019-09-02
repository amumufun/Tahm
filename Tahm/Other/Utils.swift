//
//  Utils.swift
//  Tahm
//
//  Created by Chace on 2019/8/26.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class Utils {
    static func getSizeWithFilePath(_ url: URL) -> Int64 {
        var fileSize: Int64 = 0
        let fm = FileManager.default
        do {
            let attr = try fm.attributesOfItem(atPath: url.path) as NSDictionary
            fileSize = Int64(attr.fileSize())
        } catch {
            print("获取文件大小失败")
        }
        return fileSize
    }
    
    static func showNotification(message: String, title: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.deliveryDate = NSDate(timeIntervalSinceNow: 10) as Date
        // 发送通知
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    static func copyToPasteboard(string: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(string, forType: NSPasteboard.PasteboardType.string)
    }
    
    static func switchTab(tab: Int) {
        NotificationCenter.default.post(name: NSNotification.Name("switchTab"), object: self, userInfo: ["tab": tab])
    }
    
    static var firstBoot: Bool {
        if UserDefaults.standard.bool(forKey: "firstBoot") {
            UserDefaults.standard.set(true, forKey: "firstBoot")
            return false
        }
        return true
    }
}
