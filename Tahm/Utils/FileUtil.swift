//
//  FileUtil.swift
//  Tahm
//
//  Created by Chace on 2019/8/14.
//  Copyright © 2019 Chace. All rights reserved.
//

import Cocoa

class FileUtil {
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
}
