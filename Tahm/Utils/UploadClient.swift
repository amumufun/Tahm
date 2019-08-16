//
//  File.swift
//  Tahm
//
//  Created by Chace on 2019/8/14.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation

protocol UploadClientDelegate {
    func uploadProgress(percentage: Double)
    func uploadSuccess(result: [UploadResult])
}

class UploadClient: NSObject {
    
    var delegate: UploadClientDelegate?
    
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
    
    required override init() {
        super.init()
    }
}
