//
//  AliyunOSSConfig.swift
//  Tahm
//
//  Created by Chace on 2019/9/2.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation

struct AliyunOSSConfig: Codable {
    var endPoint: String // EndPoint（地域节点）
    var bucketName: String // Bucket 名字
    var ssl: Bool // HTTPS
    var accessKeyId: String // AccessKeyID
    var secretKeyId: String // AccessKeySecret
    var path: String // 存储路径
    var suffix: String // url后缀
}

let AliyunOSSConfigKey = "AliyunOSSConfigKey"
