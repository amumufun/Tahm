//
//  Utils.swift
//  Tahm
//
//  Created by Chace on 2019/8/26.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class Utils {
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
}
