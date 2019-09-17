//
//  TencentCOSConfig.swift
//  Tahm
//
//  Created by Chace on 2019/9/16.
//  Copyright © 2019 Chace. All rights reserved.
//

import Foundation

struct TencentCOSConfig: Codable {
    var endPoint: String // EndPoint（所属地域）
    var bucketName: String // Bucket 空间名称
    var secretId: String // SecretId
    var secretKey: String // SecretKey
    var path: String // 存储路径
    var domain: String // 万象处理域名或自定义域名
    var suffix: String // url后缀
}

let TencentCOSConfigKey = "TencentCOSConfigKey"
