//
//  File.swift
//  Tahm
//
//  Created by Chace on 2019/8/14.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation
import SwiftHEXColors

let TextFieldErrorColor = NSColor(hexString: "#d40000", alpha: 0.2)

protocol UploadClientDelegate {
    func uploadStart()
    func uploadProgress(percentage: Double)
    func uploadSuccess(results: [UploadResult])
}

class UploadClient: NSObject {
    
    var delegate: UploadClientDelegate?
    let prefs = Preferences()
    
    static func getClient(className: String) -> UploadClient {
        let namespace = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let client = NSClassFromString(namespace + "." + className) as! UploadClient.Type
        return client.init()
    }
    
    func upload(_ urls: [URL]) {
        // 
    }
    
    func uploadProgress(bytesSent: Int64) {
        //
    }
    
    func getName(lastPathComponent: String) -> String {
        var lastPathArr = lastPathComponent.split(separator: ".")
        let suffix = lastPathArr[lastPathArr.count - 1]
        lastPathArr.removeLast()
        let filename = lastPathArr.joined()
        if prefs.naming == 1 {
            let date = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyyMMddHHmmss"
            return filename + dateFormat.string(from: date) + "." + suffix
        } else if prefs.naming == 2 {
            let uuid = UUID().uuidString
            return uuid.replacingOccurrences(of: "-", with: "").lowercased() + "." + suffix
        }
        return lastPathComponent
    }
    
    required override init() {
        super.init()
    }
}
